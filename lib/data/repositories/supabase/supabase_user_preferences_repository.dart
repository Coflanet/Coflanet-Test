import 'package:flutter/foundation.dart';
import 'package:coflanet/core/storage/local_storage.dart';
import 'package:coflanet/data/repositories/repository_interfaces.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide LocalStorage;

/// Supabase implementation of UserPreferencesRepository
/// Uses RPC functions for server-synced preferences,
/// local storage for device-local settings.
class SupabaseUserPreferencesRepository implements UserPreferencesRepository {
  final LocalStorage _storage = Get.find<LocalStorage>();

  SupabaseClient get _db => Supabase.instance.client;

  @override
  Future<bool> isOnboardingComplete() async {
    try {
      final result = await _db.rpc('get_onboarding_status');
      debugPrint('[UserPrefsRepo] get_onboarding_status: $result');

      if (result == null) return _storage.isOnboardingComplete;

      // Result could be a bool, a Map with status, or a string
      if (result is bool) return result;
      if (result is Map<String, dynamic>) {
        // Server returns: {has_completed_survey: bool, next_screen: string, ...}
        return result['has_completed_survey'] as bool? ??
            result['onboarding_complete'] as bool? ??
            result['is_complete'] as bool? ??
            _storage.isOnboardingComplete;
      }

      return _storage.isOnboardingComplete;
    } catch (e) {
      debugPrint('[UserPrefsRepo] isOnboardingComplete error: $e');
      return _storage.isOnboardingComplete;
    }
  }

  @override
  Future<void> setOnboardingComplete(bool complete) async {
    // Cache locally — server handles this automatically during survey flow
    await _storage.setOnboardingComplete(complete);
  }

  @override
  Future<bool> isDarkMode() async {
    // Dark mode is device-local only
    return _storage.isDarkMode;
  }

  @override
  Future<void> setDarkMode(bool isDark) async {
    await _storage.setDarkMode(isDark);

    // Sync to server via RPC
    try {
      if (_db.auth.currentUser != null) {
        await _db.rpc(
          'update_profile',
          params: {
            'p_values': {'is_dark_mode': isDark},
          },
        );
      }
    } catch (e) {
      debugPrint('[UserPrefsRepo] setDarkMode sync error: $e');
    }
  }

  @override
  Future<String?> getUserName() async {
    // Try Supabase Auth user metadata first
    // Kakao OAuth may use 'name', 'full_name', or 'preferred_username'
    final user = _db.auth.currentUser;
    final meta = user?.userMetadata;
    final name =
        meta?['display_name'] as String? ??
        meta?['full_name'] as String? ??
        meta?['name'] as String? ??
        meta?['preferred_username'] as String?;
    if (name != null && name.isNotEmpty) return name;

    // Fallback to local
    return _storage.getUserName();
  }

  @override
  Future<void> saveUserName(String name) async {
    await _storage.saveUserName(name);

    try {
      await _db.rpc('save_display_name', params: {'display_name': name});
    } catch (e) {
      debugPrint('[UserPrefsRepo] saveUserName error: $e');
    }
  }

  @override
  Future<String?> getUserId() async {
    // Supabase Auth is the source of truth
    return _db.auth.currentUser?.id ?? _storage.getUserId();
  }

  @override
  Future<void> saveUserId(String id) async {
    // No-op: Supabase Auth manages user_id
    // Keep local cache for compatibility
    await _storage.saveUserId(id);
  }

  @override
  Future<void> clearAll() async {
    await _storage.clearAll();
  }
}
