import 'package:coflanet/core/storage/local_storage.dart';
import 'package:coflanet/data/models/user_model.dart';
import 'package:coflanet/data/providers/auth_provider.dart';
import 'package:coflanet/data/repositories/repository_interfaces.dart';
import 'package:get/get.dart';

/// Dummy implementation of AuthRepository
/// For development - passes through social tokens without server exchange
class DummyAuthRepository implements AuthRepository {
  final LocalStorage _storage = Get.find<LocalStorage>();

  @override
  Future<UserModel> exchangeToken({
    required String socialToken,
    required SocialLoginType provider,
    UserModel? socialUser,
  }) async {
    // In dummy mode, just pass through the social user
    // No server exchange needed
    if (socialUser != null) {
      return socialUser;
    }

    // If no social user provided, create a dummy one
    return UserModel(
      id: 'dummy_${provider.name}_${DateTime.now().millisecondsSinceEpoch}',
      provider: provider.name,
      accessToken: socialToken,
    );
  }

  @override
  Future<UserModel?> refreshToken(String refreshToken) async {
    // In dummy mode, token refresh is not needed
    // Just return current user data if exists
    final userData = _storage.getUserData();
    if (userData != null) {
      return UserModel.fromJson(userData);
    }
    return null;
  }

  @override
  Future<void> logout() async {
    // No server call needed in dummy mode
    // Local cleanup is handled by AuthService
  }

  @override
  Future<void> deleteAccount() async {
    // No server call needed in dummy mode
    // Local cleanup is handled by AuthService
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final userData = _storage.getUserData();
    if (userData != null) {
      return UserModel.fromJson(userData);
    }
    return null;
  }

  @override
  Future<UserModel> updateProfile({
    String? name,
    String? profileImageUrl,
  }) async {
    final userData = _storage.getUserData();
    if (userData == null) {
      throw Exception('No user data found');
    }

    final currentUser = UserModel.fromJson(userData);
    final updatedUser = currentUser.copyWith(
      name: name ?? currentUser.name,
      profileImageUrl: profileImageUrl ?? currentUser.profileImageUrl,
    );

    await _storage.saveUserData(updatedUser.toJson());
    return updatedUser;
  }
}
