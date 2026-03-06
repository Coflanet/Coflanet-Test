import 'package:get_storage/get_storage.dart';

/// Local storage service for persisting data
class LocalStorage {
  static final LocalStorage _instance = LocalStorage._internal();
  factory LocalStorage() => _instance;
  LocalStorage._internal();

  late final GetStorage _box;

  /// Storage keys
  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserId = 'user_id';
  static const String keyUserName = 'user_name';
  static const String keyUserData = 'user_data';
  static const String keyOnboardingComplete = 'onboarding_complete';
  static const String keySurveyAnswers = 'survey_answers';
  static const String keySurveyResult = 'survey_result';
  static const String keyDarkMode = 'dark_mode';

  /// Initialize storage
  Future<void> init() async {
    await GetStorage.init();
    _box = GetStorage();
  }

  /// Write value
  Future<void> write(String key, dynamic value) async {
    await _box.write(key, value);
  }

  /// Read value
  T? read<T>(String key) {
    return _box.read<T>(key);
  }

  /// Remove value
  Future<void> remove(String key) async {
    await _box.remove(key);
  }

  /// Clear all data
  Future<void> clearAll() async {
    await _box.erase();
  }

  // === Token Management ===

  Future<void> saveAccessToken(String token) async {
    await write(keyAccessToken, token);
  }

  String? getAccessToken() {
    return read<String>(keyAccessToken);
  }

  Future<void> saveRefreshToken(String token) async {
    await write(keyRefreshToken, token);
  }

  String? getRefreshToken() {
    return read<String>(keyRefreshToken);
  }

  Future<void> clearTokens() async {
    await remove(keyAccessToken);
    await remove(keyRefreshToken);
  }

  bool get isLoggedIn => getAccessToken() != null;

  // === User Info ===

  Future<void> saveUserId(String userId) async {
    await write(keyUserId, userId);
  }

  String? getUserId() {
    return read<String>(keyUserId);
  }

  Future<void> saveUserName(String name) async {
    await write(keyUserName, name);
  }

  String? getUserName() {
    return read<String>(keyUserName);
  }

  // === User Data (Full Model) ===

  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await write(keyUserData, userData);
  }

  Map<String, dynamic>? getUserData() {
    return read<Map<String, dynamic>>(keyUserData);
  }

  Future<void> clearUserData() async {
    await remove(keyUserData);
  }

  // === Onboarding ===

  Future<void> setOnboardingComplete(bool complete) async {
    await write(keyOnboardingComplete, complete);
  }

  bool get isOnboardingComplete {
    return read<bool>(keyOnboardingComplete) ?? false;
  }

  // === Survey ===

  Future<void> saveSurveyAnswers(Map<String, dynamic> answers) async {
    await write(keySurveyAnswers, answers);
  }

  Map<String, dynamic>? getSurveyAnswers() {
    final data = read<Map<String, dynamic>>(keySurveyAnswers);
    return data;
  }

  Future<void> saveSurveyResult(Map<String, dynamic> result) async {
    await write(keySurveyResult, result);
  }

  Map<String, dynamic>? getSurveyResult() {
    return read<Map<String, dynamic>>(keySurveyResult);
  }

  Future<void> clearSurveyResult() async {
    await remove(keySurveyResult);
  }

  // === Theme ===

  Future<void> setDarkMode(bool isDark) async {
    await write(keyDarkMode, isDark);
  }

  bool get isDarkMode {
    return read<bool>(keyDarkMode) ?? false;
  }
}
