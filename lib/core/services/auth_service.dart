import 'package:get/get.dart';
import 'package:coflanet/core/storage/local_storage.dart';
import 'package:coflanet/data/models/user_model.dart';
import 'package:coflanet/data/providers/auth_provider.dart';
import 'package:coflanet/data/providers/dummy_auth_provider.dart';
import 'package:coflanet/data/providers/kakao_auth_provider.dart';
import 'package:coflanet/data/providers/naver_auth_provider.dart';
import 'package:coflanet/data/providers/apple_auth_provider.dart';

/// Authentication service configuration
class AuthServiceConfig {
  /// Use dummy providers for development
  /// Set to false in production to use real social login SDKs
  final bool useDummyProviders;

  const AuthServiceConfig({this.useDummyProviders = true});
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
class AuthService extends GetxService {
  final AuthServiceConfig config;
  final LocalStorage _storage = Get.find<LocalStorage>();

  // Providers
  late final Map<SocialLoginType, AuthProvider> _providers;

  // Current user state
  final Rxn<UserModel> _currentUser = Rxn<UserModel>();
  UserModel? get currentUser => _currentUser.value;
  bool get isLoggedIn => _currentUser.value != null;

  // Loading state
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  AuthService({this.config = const AuthServiceConfig()});

  @override
  void onInit() {
    super.onInit();
    _initProviders();
    _loadUserFromStorage();
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
  ///
  /// Returns [UserModel] on success
  /// Throws [AuthException] on failure
  Future<UserModel> signIn(SocialLoginType type) async {
    final provider = _providers[type];
    if (provider == null) {
      throw AuthException('Provider not found: $type');
    }

    _isLoading.value = true;

    try {
      final user = await provider.signIn();

      // Save to storage
      await _saveUserToStorage(user);

      // Update state
      _currentUser.value = user;

      return user;
    } finally {
      _isLoading.value = false;
    }
  }

  /// Sign out current user
  Future<void> signOut() async {
    final user = _currentUser.value;
    if (user == null) return;

    _isLoading.value = true;

    try {
      // Get provider for current user
      final providerType = SocialLoginType.values.firstWhere(
        (t) => t.name == user.provider,
        orElse: () => SocialLoginType.guest,
      );

      final provider = _providers[providerType];

      // Try to sign out from provider
      try {
        await provider?.signOut();
      } catch (e) {
        // Ignore provider sign out errors, still clear local session
      }

      // Clear storage
      await _clearUserFromStorage();

      // Update state
      _currentUser.value = null;
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

    final providerType = SocialLoginType.values.firstWhere(
      (t) => t.name == user.provider,
      orElse: () => SocialLoginType.guest,
    );

    final provider = _providers[providerType];
    if (provider == null) return;

    try {
      final refreshedUser = await provider.refreshToken(user);
      if (refreshedUser != null) {
        await _saveUserToStorage(refreshedUser);
        _currentUser.value = refreshedUser;
      }
    } catch (e) {
      // Token refresh failed, may need to re-authenticate
      rethrow;
    }
  }

  /// Update user name (after profile setup)
  Future<void> updateUserName(String name) async {
    final user = _currentUser.value;
    if (user == null) return;

    final updatedUser = user.copyWith(name: name);
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
