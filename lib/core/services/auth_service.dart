import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    hide LocalStorage, AuthException;
import 'package:coflanet/core/storage/local_storage.dart';
import 'package:coflanet/data/models/user_model.dart';
import 'package:coflanet/data/providers/auth_provider.dart';
import 'package:coflanet/data/providers/dummy_auth_provider.dart';
import 'package:coflanet/data/providers/kakao_auth_provider.dart';
import 'package:coflanet/data/providers/naver_auth_provider.dart';
import 'package:coflanet/data/providers/apple_auth_provider.dart';
import 'package:coflanet/data/repositories/repository_interfaces.dart';
import 'package:coflanet/data/repositories/repository_provider.dart';
import 'package:coflanet/data/repositories/repository_config.dart';
import 'package:coflanet/routes/app_pages.dart';

/// Authentication service configuration
class AuthServiceConfig {
  /// Use dummy providers for development
  /// Set to false in production to use real social login SDKs
  final bool useDummyProviders;

  /// Use server token exchange
  /// When true, social tokens are exchanged for server JWT via AuthRepository
  /// When false (default), social tokens are used directly (for development)
  final bool useServerAuth;

  const AuthServiceConfig({
    this.useDummyProviders = true,
    this.useServerAuth = false,
  });
}

/// Central authentication service
///
/// Manages social login providers and user session.
///
/// ## Usage
///
/// ### Initialize in main.dart or app_binding.dart:
/// ```dart
/// Get.put(AuthService(
///   config: AuthServiceConfig(
///     useDummyProviders: kDebugMode, // Use dummy in debug, real in release
///   ),
/// ));
/// ```
///
/// ### Sign in:
/// ```dart
/// final authService = Get.find<AuthService>();
/// final user = await authService.signIn(SocialLoginType.kakao);
/// ```
///
/// ### Check session:
/// ```dart
/// if (authService.isLoggedIn) {
///   final user = authService.currentUser;
/// }
/// ```
class AuthService extends GetxService with WidgetsBindingObserver {
  final AuthServiceConfig config;
  final LocalStorage _storage = Get.find<LocalStorage>();

  // Repository for server auth (token exchange)
  final AuthRepository _authRepository = RepositoryProvider.authRepository;

  // Providers
  late final Map<SocialLoginType, AuthProvider> _providers;

  // Current user state
  final Rxn<UserModel> _currentUser = Rxn<UserModel>();
  UserModel? get currentUser => _currentUser.value;
  bool get isLoggedIn => _currentUser.value != null;

  // Loading state
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  // OAuth cancellation
  Completer<UserModel>? _oauthCompleter;
  StreamSubscription<AuthState>? _oauthSub;
  Timer? _oauthResumeTimer;

  // 앱 전역 인증 상태 구독 (OAuth 임시 구독과 별개로 세션 종료를 감시)
  StreamSubscription<AuthState>? _authStateSub;

  // 세션 만료 처리 중복 실행 방지 플래그
  bool _handlingSessionExpiry = false;

  AuthService({this.config = const AuthServiceConfig()});

  bool get _isSupabase => RepositoryConfig.dataSource == DataSource.supabase;

  SupabaseClient get _supabase => Supabase.instance.client;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _initProviders();
    _loadUserFromStorage();
    // 캐시된 로그인 상태와 실제 Supabase 세션의 정합성을 맞춘다.
    _reconcileSession();
    // 세션 종료(로그아웃/만료)를 전역으로 감시한다.
    _listenToAuthChanges();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _oauthResumeTimer?.cancel();
    _oauthSub?.cancel();
    _authStateSub?.cancel();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _oauthCompleter != null) {
      // 사용자가 브라우저에서 앱으로 복귀 — 짧은 유예 후 취소
      _oauthResumeTimer?.cancel();
      _oauthResumeTimer = Timer(const Duration(seconds: 3), () {
        _cancelOAuthIfPending();
      });
    }
  }

  /// Cancel pending OAuth flow if user returned without completing
  void _cancelOAuthIfPending() {
    final completer = _oauthCompleter;
    if (completer != null && !completer.isCompleted) {
      debugPrint('[AuthService] OAuth cancelled — user returned to app');
      _oauthSub?.cancel();
      _oauthSub = null;
      _oauthCompleter = null;
      completer.completeError(AuthException('로그인이 취소되었습니다.'));
    }
  }

  /// Initialize providers based on configuration
  void _initProviders() {
    if (config.useDummyProviders) {
      // Development mode: use dummy providers
      _providers = {
        SocialLoginType.kakao: DummyAuthProvider(SocialLoginType.kakao),
        SocialLoginType.naver: DummyAuthProvider(SocialLoginType.naver),
        SocialLoginType.apple: DummyAuthProvider(SocialLoginType.apple),
        SocialLoginType.guest: DummyAuthProvider(SocialLoginType.guest),
      };
    } else {
      // Production mode: use real providers
      _providers = {
        SocialLoginType.kakao: KakaoAuthProvider(),
        SocialLoginType.naver: NaverAuthProvider(),
        SocialLoginType.apple: AppleAuthProvider(),
        SocialLoginType.guest: DummyAuthProvider(SocialLoginType.guest),
      };
    }
  }

  /// Load user session from storage
  void _loadUserFromStorage() {
    final userData = _storage.getUserData();
    if (userData != null) {
      try {
        _currentUser.value = UserModel.fromJson(userData);
      } catch (e) {
        // Invalid stored data, clear it
        _storage.clearUserData();
      }
    }
  }

  /// 캐시된 로그인 상태와 실제 Supabase 세션의 정합성을 맞춘다.
  ///
  /// 로컬에 캐시된 UserModel 은 있는데 Supabase 세션이 없으면(만료/소실),
  /// 앱이 "로그인됨"으로 오인해 인증 RPC 가 UNAUTHORIZED 로 실패하는 문제가
  /// 생긴다. 이때 캐시를 비워 isLoggedIn 이 실제 세션과 어긋나지 않게 한다.
  /// 더미/로컬 모드는 Supabase 세션 개념이 없으므로 캐시를 그대로 둔다.
  void _reconcileSession() {
    if (!_isSupabase) return;
    if (_currentUser.value == null) return;
    if (_supabase.auth.currentSession != null) return;

    debugPrint('[AuthService] 캐시 사용자 존재하나 Supabase 세션 없음 — 캐시 정리');
    _currentUser.value = null;
    _storage.clearUserData();
  }

  /// 앱 전역 Supabase 인증 상태 구독.
  ///
  /// 토큰 갱신 실패나 로그아웃으로 세션이 사라지면(signedOut), 어느 화면이든
  /// 캐시 UserModel 을 정리하고 로그인 화면으로 이동시킨다. 화면별 처리 없이
  /// 세션 종료 이벤트에 전역으로 반응하는 단일 지점이다.
  void _listenToAuthChanges() {
    if (!_isSupabase) return;
    _authStateSub?.cancel();
    _authStateSub = _supabase.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.signedOut && data.session == null) {
        if (_currentUser.value != null) {
          debugPrint('[AuthService] 세션 종료(signedOut) — 캐시 정리');
          _currentUser.value = null;
          _storage.clearUserData();
        }
        // 세션이 사라졌으면 어느 화면에 있든 로그인 화면으로 이동
        if (Get.currentRoute != Routes.signIn) {
          Get.offAllNamed(Routes.signIn);
        }
      }
    });
  }

  /// 서버 RPC/함수의 인증 만료성 에러인지 판별한다.
  ///
  /// - PostgrestException P0001 + 메시지에 'UNAUTHORIZED' (RPC 내부 RAISE)
  /// - PostgrestException 42501 (permission denied — 미인증 role 로 함수 호출)
  static bool isAuthExpiredError(Object error) {
    if (error is PostgrestException) {
      final code = error.code;
      if (code == '42501') return true;
      if (code == 'P0001' &&
          error.message.toUpperCase().contains('UNAUTHORIZED')) {
        return true;
      }
    }
    return false;
  }

  /// 세션 만료 처리 — 세션/캐시를 정리하고 로그인 화면으로 유도한다.
  ///
  /// 인증 RPC 가 UNAUTHORIZED 로 실패했을 때 일반 에러 대신 호출한다.
  /// 짧은 시간에 여러 RPC 가 동시에 실패해도 한 번만 처리한다.
  Future<void> handleSessionExpired() async {
    if (_handlingSessionExpiry) return;
    if (Get.currentRoute == Routes.signIn) return;
    _handlingSessionExpiry = true;

    try {
      debugPrint('[AuthService] 세션 만료 감지 — 로그인 화면으로 이동');
      if (_isSupabase) {
        try {
          await _supabase.auth.signOut();
        } catch (_) {
          // 이미 세션이 없을 수 있음 — 무시하고 로컬 정리 진행
        }
      }
      _storage.clearUserData();
      _currentUser.value = null;

      Get.offAllNamed(Routes.signIn);
      Get.snackbar('세션 만료', '세션이 만료되었습니다. 다시 로그인해주세요.');
    } finally {
      _handlingSessionExpiry = false;
    }
  }

  /// Sign in with the specified provider
  Future<UserModel> signIn(SocialLoginType type) async {
    _isLoading.value = true;

    try {
      UserModel user;

      if (_isSupabase) {
        user = await _signInWithSupabase(type);
      } else {
        // Original flow: social SDK + optional server token exchange
        final provider = _providers[type];
        if (provider == null) {
          throw AuthException('Provider not found: $type');
        }
        final socialUser = await provider.signIn();
        if (config.useServerAuth) {
          user = await _authRepository.exchangeToken(
            socialToken: socialUser.accessToken,
            provider: type,
            socialUser: socialUser,
          );
        } else {
          user = socialUser;
        }
      }

      await _saveUserToStorage(user);
      _currentUser.value = user;
      return user;
    } finally {
      _isLoading.value = false;
    }
  }

  /// Supabase-specific sign-in
  Future<UserModel> _signInWithSupabase(SocialLoginType type) async {
    switch (type) {
      case SocialLoginType.guest:
        final response = await _supabase.auth.signInAnonymously();
        return _userFromAuthResponse(response, 'guest');

      case SocialLoginType.kakao:
        return _signInWithOAuth(OAuthProvider.kakao, 'kakao');

      case SocialLoginType.apple:
        return _signInWithOAuth(OAuthProvider.apple, 'apple');

      case SocialLoginType.naver:
        return _signInWithNaverEdgeFunction();
    }
  }

  /// OAuth sign-in using Completer + onAuthStateChange listener
  Future<UserModel> _signInWithOAuth(
    OAuthProvider oauthProvider,
    String providerName,
  ) async {
    // Clean up any previous OAuth attempt
    _oauthResumeTimer?.cancel();
    _oauthSub?.cancel();

    final completer = Completer<UserModel>();
    _oauthCompleter = completer;

    _oauthSub = _supabase.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.signedIn && data.session != null) {
        // 성공 — resume timer 취소
        _oauthResumeTimer?.cancel();
        _oauthSub?.cancel();
        _oauthSub = null;
        _oauthCompleter = null;
        if (!completer.isCompleted) {
          completer.complete(_userFromSession(data.session!, providerName));
        }
      }
    });

    await _supabase.auth.signInWithOAuth(
      oauthProvider,
      redirectTo: 'com.coflanet.tech.app://callback',
      authScreenLaunchMode: LaunchMode.externalApplication,
    );

    try {
      return await completer.future.timeout(
        const Duration(minutes: 2),
        onTimeout: () {
          _oauthSub?.cancel();
          _oauthSub = null;
          _oauthCompleter = null;
          throw AuthException('OAuth 로그인 시간 초과');
        },
      );
    } catch (e) {
      _oauthSub?.cancel();
      _oauthSub = null;
      _oauthCompleter = null;
      rethrow;
    }
  }

  /// Naver sign-in via native SDK + Edge Function
  Future<UserModel> _signInWithNaverEdgeFunction() async {
    final naverProvider = _providers[SocialLoginType.naver];
    if (naverProvider == null) {
      throw AuthException('Naver provider not configured');
    }
    final naverUser = await naverProvider.signIn();

    final response = await _supabase.functions.invoke(
      'naver-auth',
      body: {'code': naverUser.accessToken},
    );

    final data = response.data as Map<String, dynamic>;
    if (data['success'] != true) {
      final error = data['error'] as Map<String, dynamic>?;
      throw AuthException(
        'Naver auth failed: ${error?['message'] ?? 'unknown'}',
      );
    }

    final sessionData =
        (data['data'] as Map<String, dynamic>?)?['session']
            as Map<String, dynamic>?;
    final refreshToken = sessionData?['refresh_token'] as String?;
    if (refreshToken == null || refreshToken.isEmpty) {
      throw AuthException('Naver auth: refresh_token 없음');
    }

    // setSession()은 refresh_token으로 새 세션 생성
    final authResponse = await _supabase.auth.setSession(refreshToken);
    return _userFromAuthResponse(authResponse, 'naver');
  }

  UserModel _userFromAuthResponse(AuthResponse response, String provider) {
    final session = response.session;
    final user = response.user;
    final meta = user?.userMetadata;
    return UserModel(
      id: user?.id ?? '',
      email: user?.email,
      name:
          meta?['display_name'] as String? ??
          meta?['full_name'] as String? ??
          meta?['name'] as String? ??
          meta?['preferred_username'] as String?,
      profileImageUrl: meta?['avatar_url'] as String?,
      provider: provider,
      accessToken: session?.accessToken ?? '',
      refreshToken: session?.refreshToken,
    );
  }

  UserModel _userFromSession(Session session, String provider) {
    final user = session.user;
    final meta = user.userMetadata;
    return UserModel(
      id: user.id,
      email: user.email,
      name:
          meta?['display_name'] as String? ??
          meta?['full_name'] as String? ??
          meta?['name'] as String? ??
          meta?['preferred_username'] as String?,
      profileImageUrl: meta?['avatar_url'] as String?,
      provider: provider,
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
    );
  }

  /// Sign out current user
  Future<void> signOut() async {
    final user = _currentUser.value;
    if (user == null) return;

    _isLoading.value = true;

    try {
      if (_isSupabase) {
        try {
          await _supabase.auth.signOut();
        } catch (e) {
          debugPrint('[AuthService] Supabase signOut error: $e');
        }
      } else {
        final providerType = SocialLoginType.values.firstWhere(
          (t) => t.name == user.provider,
          orElse: () => SocialLoginType.guest,
        );
        final provider = _providers[providerType];

        if (config.useServerAuth) {
          try {
            await _authRepository.logout();
          } catch (e) {
            // Ignore server logout errors, still clear local session
          }
        }

        try {
          await provider?.signOut();
        } catch (e) {
          // Ignore provider sign out errors, still clear local session
        }
      }

      await _clearUserFromStorage();
      _currentUser.value = null;
    } finally {
      _isLoading.value = false;
    }
  }

  /// Delete account (회원탈퇴)
  Future<void> deleteAccount() async {
    final user = _currentUser.value;
    if (user == null) return;

    _isLoading.value = true;

    try {
      if (_isSupabase) {
        // Call delete-account Edge Function (server-side cascade delete)
        final token = _supabase.auth.currentSession?.accessToken;
        try {
          await _supabase.functions.invoke(
            'delete-account',
            headers: {if (token != null) 'Authorization': 'Bearer $token'},
          );
        } catch (e) {
          debugPrint('[AuthService] delete-account Edge Function failed: $e');
          // Fallback: RPC 직접 호출
          final userId = _supabase.auth.currentUser?.id;
          if (userId != null) {
            await _supabase.rpc(
              'delete_user_data',
              params: {'p_user_id': userId},
            );
          }
        }
        try {
          await _supabase.auth.signOut();
        } catch (_) {}
      } else {
        final providerType = SocialLoginType.values.firstWhere(
          (t) => t.name == user.provider,
          orElse: () => SocialLoginType.guest,
        );
        final provider = _providers[providerType];

        if (config.useServerAuth) {
          await _authRepository.deleteAccount();
        }

        await provider?.unlink();
      }

      await _clearUserFromStorage();
      _currentUser.value = null;
    } finally {
      _isLoading.value = false;
    }
  }

  /// Sign in with email and password (Supabase)
  Future<UserModel> signInWithEmail(String email, String password) async {
    _isLoading.value = true;
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final user = _userFromAuthResponse(response, 'email');
      await _saveUserToStorage(user);
      _currentUser.value = user;
      return user;
    } finally {
      _isLoading.value = false;
    }
  }

  /// Sign up with email and password (Supabase)
  Future<UserModel> signUpWithEmail(String email, String password) async {
    _isLoading.value = true;
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );
      final user = _userFromAuthResponse(response, 'email');
      await _saveUserToStorage(user);
      _currentUser.value = user;
      return user;
    } finally {
      _isLoading.value = false;
    }
  }

  /// Continue as guest
  Future<UserModel> continueAsGuest() async {
    return signIn(SocialLoginType.guest);
  }

  /// 현재 유저가 게스트(익명)인지 확인
  bool get isAnonymous {
    if (!_isSupabase) return currentUser?.provider == 'guest';
    return _supabase.auth.currentUser?.isAnonymous ?? false;
  }

  /// 게스트 계정을 소셜 계정으로 연동 (linkIdentity)
  /// user_id 유지 → 기존 데이터 자동 보존
  Future<UserModel> linkWithSocial(SocialLoginType type) async {
    _isLoading.value = true;
    try {
      if (!_isSupabase) throw AuthException('Supabase 모드에서만 지원');
      if (!isAnonymous) throw AuthException('게스트 계정만 연동 가능');

      switch (type) {
        case SocialLoginType.kakao:
          return await _linkWithOAuth(OAuthProvider.kakao, 'kakao');
        case SocialLoginType.apple:
          return await _linkWithOAuth(OAuthProvider.apple, 'apple');
        case SocialLoginType.naver:
          return await _linkWithNaverEdgeFunction();
        case SocialLoginType.guest:
          throw AuthException('이미 게스트 계정입니다');
      }
    } finally {
      _isLoading.value = false;
    }
  }

  /// 게스트 계정을 이메일 계정으로 연동
  Future<UserModel> linkWithEmail(String email, String password) async {
    _isLoading.value = true;
    try {
      if (!_isSupabase) throw AuthException('Supabase 모드에서만 지원');
      if (!isAnonymous) throw AuthException('게스트 계정만 연동 가능');

      final response = await _supabase.auth.updateUser(
        UserAttributes(email: email, password: password),
      );
      final supaUser = response.user;
      final user = UserModel(
        id: supaUser?.id ?? '',
        email: supaUser?.email,
        name: supaUser?.userMetadata?['display_name'] as String?,
        provider: 'email',
        accessToken: _supabase.auth.currentSession?.accessToken ?? '',
        refreshToken: _supabase.auth.currentSession?.refreshToken,
      );
      await _saveUserToStorage(user);
      _currentUser.value = user;
      return user;
    } finally {
      _isLoading.value = false;
    }
  }

  /// OAuth 연동 (linkIdentity) — user_id 유지, 기존 데이터 보존
  Future<UserModel> _linkWithOAuth(
    OAuthProvider provider,
    String providerName,
  ) async {
    _oauthResumeTimer?.cancel();
    _oauthSub?.cancel();

    final completer = Completer<UserModel>();
    _oauthCompleter = completer;

    _oauthSub = _supabase.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.signedIn && data.session != null) {
        _oauthResumeTimer?.cancel();
        _oauthSub?.cancel();
        _oauthSub = null;
        _oauthCompleter = null;
        if (!completer.isCompleted) {
          completer.complete(_userFromSession(data.session!, providerName));
        }
      }
    });

    await _supabase.auth.linkIdentity(
      provider,
      redirectTo: 'com.coflanet.tech.app://callback',
      authScreenLaunchMode: LaunchMode.externalApplication,
    );

    try {
      final user = await completer.future.timeout(
        const Duration(minutes: 2),
        onTimeout: () {
          _oauthSub?.cancel();
          _oauthSub = null;
          _oauthCompleter = null;
          throw AuthException('계정 연동 시간 초과');
        },
      );
      await _saveUserToStorage(user);
      _currentUser.value = user;
      return user;
    } catch (e) {
      _oauthSub?.cancel();
      _oauthSub = null;
      _oauthCompleter = null;
      rethrow;
    }
  }

  /// 네이버 계정 연동 (Edge Function mode: 'link')
  Future<UserModel> _linkWithNaverEdgeFunction() async {
    final naverProvider = _providers[SocialLoginType.naver];
    if (naverProvider == null) {
      throw AuthException('Naver provider not configured');
    }
    final naverUser = await naverProvider.signIn();

    final currentSession = _supabase.auth.currentSession;
    if (currentSession == null) {
      throw AuthException('현재 세션이 없습니다');
    }

    final response = await _supabase.functions.invoke(
      'naver-auth',
      body: {'code': naverUser.accessToken, 'mode': 'link'},
      headers: {'Authorization': 'Bearer ${currentSession.accessToken}'},
    );

    final data = response.data as Map<String, dynamic>;
    if (data['success'] != true) {
      final error = data['error'] as Map<String, dynamic>?;
      throw AuthException(error?['message'] ?? '네이버 계정 연동 실패');
    }

    final refreshed = await _supabase.auth.refreshSession();
    final user = _userFromAuthResponse(refreshed, 'naver');
    await _saveUserToStorage(user);
    _currentUser.value = user;
    return user;
  }

  /// Refresh current user's token
  Future<void> refreshToken() async {
    final user = _currentUser.value;
    if (user == null) return;

    try {
      if (_isSupabase) {
        // Supabase handles token refresh automatically
        return;
      }

      UserModel? refreshedUser;

      if (config.useServerAuth) {
        final token = user.refreshToken;
        if (token != null) {
          refreshedUser = await _authRepository.refreshToken(token);
        }
      } else {
        final providerType = SocialLoginType.values.firstWhere(
          (t) => t.name == user.provider,
          orElse: () => SocialLoginType.guest,
        );
        final provider = _providers[providerType];
        if (provider != null) {
          refreshedUser = await provider.refreshToken(user);
        }
      }

      if (refreshedUser != null) {
        await _saveUserToStorage(refreshedUser);
        _currentUser.value = refreshedUser;
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Update user name (after profile setup)
  Future<void> updateUserName(String name) async {
    final user = _currentUser.value;
    if (user == null) return;

    UserModel updatedUser;

    if (_isSupabase) {
      await _supabase.auth.updateUser(
        UserAttributes(data: {'display_name': name}),
      );
      await _supabase.rpc('save_display_name', params: {'display_name': name});
      updatedUser = user.copyWith(name: name);
    } else if (config.useServerAuth) {
      updatedUser = await _authRepository.updateProfile(name: name);
    } else {
      updatedUser = user.copyWith(name: name);
    }

    await _saveUserToStorage(updatedUser);
    _currentUser.value = updatedUser;
  }

  // === Storage Helpers ===

  Future<void> _saveUserToStorage(UserModel user) async {
    await _storage.saveUserData(user.toJson());
    await _storage.saveAccessToken(user.accessToken);
    if (user.refreshToken != null) {
      await _storage.saveRefreshToken(user.refreshToken!);
    }
    if (user.name != null) {
      await _storage.saveUserName(user.name!);
    }
    await _storage.saveUserId(user.id);
  }

  Future<void> _clearUserFromStorage() async {
    await _storage.clearUserData();
    await _storage.clearTokens();
    await _storage.remove(LocalStorage.keyUserId);
    await _storage.remove(LocalStorage.keyUserName);
  }
}
