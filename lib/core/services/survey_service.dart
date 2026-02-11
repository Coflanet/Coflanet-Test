import 'package:get/get.dart';
import 'package:coflanet/data/models/survey_result_model.dart';
import 'package:coflanet/data/repositories/repository_interfaces.dart';
import 'package:coflanet/data/repositories/repository_provider.dart';

/// Service for survey-related operations
/// Centralizes survey result loading and management to avoid code duplication
/// Uses Repository pattern for data access
class SurveyService extends GetxService {
  final SurveyRepository _surveyRepository =
      RepositoryProvider.surveyRepository;
  final UserPreferencesRepository _prefsRepository =
      RepositoryProvider.userPreferencesRepository;

  // ─── Survey Result ───
  final Rxn<SurveyResultModel> _surveyResult = Rxn<SurveyResultModel>();
  SurveyResultModel? get surveyResult => _surveyResult.value;

  /// Whether a survey result exists
  bool get hasResult => _surveyResult.value != null;

  // ─── User Info ───
  String _cachedUserName = '사용자';
  String get userName => _cachedUserName;

  // ─── Initialization ───

  /// Initialize the service and load cached survey result
  Future<SurveyService> init() async {
    await loadSurveyResult();
    await _loadUserName();
    return this;
  }

  Future<void> _loadUserName() async {
    _cachedUserName = await _prefsRepository.getUserName() ?? '사용자';
  }

  // ─── Survey Result Management ───

  /// Load survey result from repository
  Future<void> loadSurveyResult() async {
    _surveyResult.value = await _surveyRepository.getSurveyResult();
  }

  /// Save survey result to repository
  Future<void> saveSurveyResult(SurveyResultModel result) async {
    await _surveyRepository.saveSurveyResult(result);
    _surveyResult.value = result;
  }

  /// Clear survey result
  Future<void> clearSurveyResult() async {
    await _surveyRepository.clearSurveyResult();
    _surveyResult.value = null;
  }

  /// Refresh survey result from repository
  Future<void> refresh() async {
    await loadSurveyResult();
    await _loadUserName();
  }
}
