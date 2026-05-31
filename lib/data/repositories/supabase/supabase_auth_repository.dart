import 'package:flutter/foundation.dart';
import 'package:coflanet/core/storage/local_storage.dart';
import 'package:coflanet/data/models/user_model.dart';
import 'package:coflanet/data/providers/auth_provider.dart';
import 'package:coflanet/data/repositories/repository_interfaces.dart';
import 'package:coflanet/data/repositories/supabase/supabase_repository_base.dart';
import 'package:get/get.dart';

/// Supabase implementation of AuthRepository
/// Uses Supabase Auth — authentication handled by AuthService.
/// This repository handles user profile management and account operations.
class SupabaseAuthRepository extends SupabaseRepositoryBase
    implements AuthRepository {
  final LocalStorage _storage = Get.find<LocalStorage>();

  @override
  Future<UserModel> exchangeToken({
    required String socialToken,
    required SocialLoginType provider,
    UserModel? socialUser,
  }) async {
    // No-op: AuthService handles Supabase Auth directly
    // Return current user from session
    final user = db.auth.currentUser;
    final session = db.auth.currentSession;
    return UserModel(
      id: user?.id ?? socialUser?.id ?? '',
      email: user?.email ?? socialUser?.email,
      name: user?.userMetadata?['display_name'] as String? ?? socialUser?.name,
      profileImageUrl:
          user?.userMetadata?['avatar_url'] as String? ??
          socialUser?.profileImageUrl,
      provider: provider.name,
      accessToken: session?.accessToken ?? socialToken,
      refreshToken: session?.refreshToken,
    );
  }

  @override
  Future<UserModel?> refreshToken(String refreshToken) async {
    // No-op: Supabase auto-refreshes tokens
    return null;
  }

  @override
  Future<void> logout() async {
    // 인증 메서드는 재인증 루프 위험으로 guard 로 감싸지 않는다.
    await db.auth.signOut();
  }

  @override
  Future<void> deleteAccount() async {
    try {
      // supabase_flutter automatically includes auth headers
      await guard(() => db.functions.invoke('delete-account'));
    } catch (e) {
      debugPrint(
        '[SupabaseAuthRepository] delete-account Edge Function failed: $e',
      );
      // Fallback: RPC 직접 호출 (인증 메서드인 currentUser 는 감싸지 않음)
      final userId = db.auth.currentUser?.id;
      if (userId != null) {
        await guard(
          () => db.rpc('delete_user_data', params: {'p_user_id': userId}),
        );
      }
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = db.auth.currentUser;
    if (user == null) return null;

    final session = db.auth.currentSession;
    return UserModel(
      id: user.id,
      email: user.email,
      name:
          user.userMetadata?['display_name'] as String? ??
          user.userMetadata?['full_name'] as String?,
      profileImageUrl: user.userMetadata?['avatar_url'] as String?,
      provider: user.appMetadata['provider'] as String? ?? 'unknown',
      accessToken: session?.accessToken ?? '',
      refreshToken: session?.refreshToken,
    );
  }

  @override
  Future<UserModel> updateProfile({
    String? name,
    String? profileImageUrl,
  }) async {
    if (name != null) {
      await guard(
        () => db.rpc('save_display_name', params: {'display_name': name}),
      );
    }

    // Refresh user data
    final current = await getCurrentUser();
    if (current == null) throw Exception('No authenticated user');

    final updated = current.copyWith(
      name: name ?? current.name,
      profileImageUrl: profileImageUrl ?? current.profileImageUrl,
    );
    await _storage.saveUserData(updated.toJson());
    return updated;
  }
}
