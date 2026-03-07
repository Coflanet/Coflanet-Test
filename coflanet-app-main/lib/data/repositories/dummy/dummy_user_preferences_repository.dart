import 'package:coflanet/core/storage/local_storage.dart';
import 'package:coflanet/data/repositories/repository_interfaces.dart';
import 'package:get/get.dart';

/// Dummy implementation of UserPreferencesRepository
/// Uses local storage for persistence
class DummyUserPreferencesRepository implements UserPreferencesRepository {
  final LocalStorage _storage = Get.find<LocalStorage>();

  @override
  Future<bool> isOnboardingComplete() async {
    return _storage.isOnboardingComplete;
  }

  @override
  Future<void> setOnboardingComplete(bool complete) async {
    await _storage.setOnboardingComplete(complete);
  }

  @override
  Future<bool> isDarkMode() async {
    return _storage.isDarkMode;
  }

  @override
  Future<void> setDarkMode(bool isDark) async {
    await _storage.setDarkMode(isDark);
  }

  @override
  Future<String?> getUserName() async {
    return _storage.getUserName();
  }

  @override
  Future<void> saveUserName(String name) async {
    await _storage.saveUserName(name);
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
  }
}
