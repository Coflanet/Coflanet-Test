import 'package:coflanet/core/api/api_client.dart';
import 'package:coflanet/core/storage/local_storage.dart';
import 'package:coflanet/data/repositories/repository_interfaces.dart';
import 'package:get/get.dart';

/// API implementation of UserPreferencesRepository
/// Uses local storage for some preferences (like dark mode)
/// and API for others (like user profile data)
class ApiUserPreferencesRepository implements UserPreferencesRepository {
  final ApiClient _apiClient = Get.find<ApiClient>();
  final LocalStorage _storage = Get.find<LocalStorage>();

  // API endpoints
  static const String _userEndpoint = '/users/me';
  static const String _preferencesEndpoint = '/users/me/preferences';

  @override
  Future<bool> isOnboardingComplete() async {
    // Onboarding status is stored locally for quick access
    return _storage.isOnboardingComplete;
  }

  @override
  Future<void> setOnboardingComplete(bool complete) async {
    // Save locally for quick access
    await _storage.setOnboardingComplete(complete);

    // Also sync to server
    try {
      await _apiClient.patch(
        _preferencesEndpoint,
        data: {'onboarding_complete': complete},
      );
    } catch (e) {
      // Fail silently - local storage is the source of truth for this
    }
  }

  @override
  Future<bool> isDarkMode() async {
    // Theme preference is stored locally only
    return _storage.isDarkMode;
  }

  @override
  Future<void> setDarkMode(bool isDark) async {
    // Theme preference is stored locally only
    await _storage.setDarkMode(isDark);
  }

  @override
  Future<String?> getUserName() async {
    // Try local cache first
    final localName = _storage.getUserName();
    if (localName != null) {
      return localName;
    }

    // Fetch from API
    try {
      final response = await _apiClient.get(_userEndpoint);
      final name = response.data['name'] as String?;
      if (name != null) {
        await _storage.saveUserName(name);
      }
      return name;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveUserName(String name) async {
    // Save locally for quick access
    await _storage.saveUserName(name);

    // Sync to server
    try {
      await _apiClient.patch(_userEndpoint, data: {'name': name});
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String?> getUserId() async {
    return _storage.getUserId();
  }

  @override
  Future<void> saveUserId(String id) async {
    await _storage.saveUserId(id);
  }

  @override
  Future<void> clearAll() async {
    await _storage.clearAll();
    // Note: We don't clear server-side data here
    // That should be handled by a separate account deletion flow
  }
}
