import 'package:coflanet/core/api/api_client.dart';
import 'package:coflanet/core/storage/local_storage.dart';
import 'package:coflanet/data/models/user_model.dart';
import 'package:coflanet/data/providers/auth_provider.dart';
import 'package:coflanet/data/repositories/repository_interfaces.dart';
import 'package:get/get.dart';

/// API implementation of AuthRepository
/// Connects to backend API for authentication
class ApiAuthRepository implements AuthRepository {
  final ApiClient _apiClient = Get.find<ApiClient>();
  final LocalStorage _storage = Get.find<LocalStorage>();

  // API endpoints
  static const String _socialLoginEndpoint = '/auth/social-login';
  static const String _refreshEndpoint = '/auth/refresh';
  static const String _logoutEndpoint = '/auth/logout';
  static const String _deleteAccountEndpoint = '/auth/delete-account';
  static const String _userEndpoint = '/users/me';

  @override
  Future<UserModel> exchangeToken({
    required String socialToken,
    required SocialLoginType provider,
    UserModel? socialUser,
  }) async {
    try {
      final response = await _apiClient.post(
        _socialLoginEndpoint,
        data: {
          'provider': provider.name,
          'social_token': socialToken,
          // Include social user info for registration
          if (socialUser != null) ...{
            'social_id': socialUser.id,
            'email': socialUser.email,
            'name': socialUser.name,
            'profile_image_url': socialUser.profileImageUrl,
          },
        },
      );

      final data = response.data;

      // Server returns our JWT tokens and user info
      final user = UserModel(
        id: data['user']['id'] as String,
        email: data['user']['email'] as String?,
        name: data['user']['name'] as String?,
        profileImageUrl: data['user']['profile_image_url'] as String?,
        provider: provider.name,
        accessToken: data['access_token'] as String,
        refreshToken: data['refresh_token'] as String?,
      );

      // Save tokens to local storage
      await _storage.saveAccessToken(user.accessToken);
      if (user.refreshToken != null) {
        await _storage.saveRefreshToken(user.refreshToken!);
      }
      await _storage.saveUserData(user.toJson());

      return user;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel?> refreshToken(String refreshToken) async {
    try {
      final response = await _apiClient.post(
        _refreshEndpoint,
        data: {'refresh_token': refreshToken},
      );

      final data = response.data;

      final newAccessToken = data['access_token'] as String?;
      final newRefreshToken = data['refresh_token'] as String?;

      if (newAccessToken != null) {
        await _storage.saveAccessToken(newAccessToken);
        if (newRefreshToken != null) {
          await _storage.saveRefreshToken(newRefreshToken);
        }

        // Return updated user model
        final userData = _storage.getUserData();
        if (userData != null) {
          final user = UserModel.fromJson(userData);
          return user.copyWith(
            accessToken: newAccessToken,
            refreshToken: newRefreshToken ?? user.refreshToken,
          );
        }
      }

      return null;
    } catch (e) {
      // Token refresh failed
      return null;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _apiClient.post(_logoutEndpoint);
    } catch (e) {
      // Ignore logout errors, still clear local session
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      await _apiClient.delete(_deleteAccountEndpoint);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final response = await _apiClient.get(_userEndpoint);
      final data = response.data['user'];

      if (data != null) {
        // Merge with local token data
        final localData = _storage.getUserData();
        return UserModel(
          id: data['id'] as String,
          email: data['email'] as String?,
          name: data['name'] as String?,
          profileImageUrl: data['profile_image_url'] as String?,
          provider:
              data['provider'] as String? ??
              localData?['provider'] as String? ??
              'unknown',
          accessToken: _storage.getAccessToken() ?? '',
          refreshToken: _storage.getRefreshToken(),
        );
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<UserModel> updateProfile({
    String? name,
    String? profileImageUrl,
  }) async {
    try {
      final response = await _apiClient.patch(
        _userEndpoint,
        data: {
          if (name != null) 'name': name,
          if (profileImageUrl != null) 'profile_image_url': profileImageUrl,
        },
      );

      final data = response.data['user'];

      final updatedUser = UserModel(
        id: data['id'] as String,
        email: data['email'] as String?,
        name: data['name'] as String?,
        profileImageUrl: data['profile_image_url'] as String?,
        provider: data['provider'] as String? ?? 'unknown',
        accessToken: _storage.getAccessToken() ?? '',
        refreshToken: _storage.getRefreshToken(),
      );

      await _storage.saveUserData(updatedUser.toJson());
      return updatedUser;
    } catch (e) {
      rethrow;
    }
  }
}
