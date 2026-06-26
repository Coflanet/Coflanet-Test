import 'package:get_storage/get_storage.dart';
import 'package:coflanet/data/models/tasting_note_model.dart';
import 'package:coflanet/data/dummy/dummy_tasting_data.dart';

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
  static const String keyThemeMode = 'theme_mode';
  static const String keyTastingNotes = 'tasting_notes';
  static const String keyTastingSeeded = 'tasting_seeded';

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

  /// 테마 모드 저장 ('system' | 'light' | 'dark')
  /// 기기별 설정이므로 서버 동기화 없이 로컬에만 영속한다.
  Future<void> setThemeMode(String mode) async {
    await write(keyThemeMode, mode);
  }

  /// 저장된 테마 모드. 미설정 시 null (→ 시스템 추종)
  String? get themeMode {
    return read<String>(keyThemeMode);
  }

  // === Tasting Notes (커피 저널) ===

  /// 저장된 시음 노트 전체를 최신순으로 반환.
  /// 첫 실행(시드 전)이면 더미 시드를 채워 넣은 뒤 반환한다.
  List<TastingNoteModel> getTastingNotes() {
    _seedTastingNotesIfNeeded();
    final raw = read<List<dynamic>>(keyTastingNotes) ?? const [];
    final notes = raw
        .whereType<Map>()
        .map((e) => TastingNoteModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    notes.sort((a, b) => b.date.compareTo(a.date));
    return notes;
  }

  /// 시음 노트 추가 (최신순 정렬은 조회 시 보장).
  Future<void> addTastingNote(TastingNoteModel note) async {
    final notes = getTastingNotes()..insert(0, note);
    await _writeTastingNotes(notes);
  }

  /// id 로 시음 노트 삭제.
  Future<void> deleteTastingNote(String id) async {
    final notes = getTastingNotes()..removeWhere((n) => n.id == id);
    await _writeTastingNotes(notes);
  }

  Future<void> _writeTastingNotes(List<TastingNoteModel> notes) async {
    await write(keyTastingNotes, notes.map((n) => n.toJson()).toList());
  }

  /// 첫 실행 시 더미 시드 1회. 이미 시드했거나 데이터가 있으면 스킵.
  void _seedTastingNotesIfNeeded() {
    final seeded = read<bool>(keyTastingSeeded) ?? false;
    if (seeded) return;
    final existing = read<List<dynamic>>(keyTastingNotes);
    if (existing == null || existing.isEmpty) {
      write(
        keyTastingNotes,
        DummyTastingData.seedNotes().map((n) => n.toJson()).toList(),
      );
    }
    write(keyTastingSeeded, true);
  }
}
