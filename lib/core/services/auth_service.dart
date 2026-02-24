import 'dart:async';
import 'package:flutter/foundation.dart';
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

  AuthService({this.config = const AuthServiceConfig()});

  bool get _isSupabase => RepositoryConfig.dataSource == DataSource.supabase;

  SupabaseClient get _supabase => Supabase.instance.client;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _initProviders();
    _loadUserFromStorage();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _oauthResumeTimer?.cancel();
    _oauthSub?.cancel();
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
    // Get access token from native Naver SDK
    final naverProvider = _providers[SocialLoginType.naver];
    if (naverProvider == null) {
      throw AuthException('Naver provider not configured');
    }
    final naverUser = await naverProvider.signIn();

    // Exchange with Edge Function (server expects authorization_code)
    final response = await _supabase.functions.invoke(
      'naver-auth',
      body: {'authorization_code': naverUser.accessToken},
    );

    final data = response.data as Map<String, dynamic>;
    if (data['access_token'] == null) {
      throw AuthException('Naver auth Edge Function 실패');
    }

    // Set the session from the returned tokens
    final authResponse = await _supabase.auth.setSession(
      data['access_token'] as String,
    );
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
