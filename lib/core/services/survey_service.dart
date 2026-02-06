import 'package:get/get.dart';
import 'package:coflanet/core/storage/local_storage.dart';
import 'package:coflanet/data/models/survey_result_model.dart';

/// Service for survey-related operations
/// Centralizes survey result loading and management to avoid code duplication
class SurveyService extends GetxService {
  final LocalStorage _storage = Get.find<LocalStorage>();

  // ─── Survey Result ───
  final Rxn<SurveyResultModel> _surveyResult = Rxn<SurveyResultModel>();
  SurveyResultModel? get surveyResult => _surveyResult.value;

  /// Whether a survey result exists
  bool get hasResult => _surveyResult.value != null;

  // ─── User Info ───
  String get userName => _storage.getUserName() ?? '사용자';

  // ─── Initialization ───

  /// Initialize the service and load cached survey result
  Future<SurveyService> init() async {
    await loadSurveyResult();
    return this;
  }

  // ─── Survey Result Management ───

  /// Load survey result from local storage
  Future<void> loadSurveyResult() async {
    final resultJson = _storage.getSurveyResult();
    if (resultJson != null) {
      _surveyResult.value = SurveyResultModel.fromJson(resultJson);
    }
  }

  /// Save survey result to local storage
  Future<void> saveSurveyResult(SurveyResultModel result) async {
    await _storage.saveSurveyResult(result.toJson());
    _surveyResult.value = result;
  }

  /// Clear survey result
  Future<void> clearSurveyResult() async {
    await _storage.clearSurveyResult();
    _surveyResult.value = null;
  }

  /// Refresh survey result from storage
  Future<void> refresh() async {
    await loadSurveyResult();
  }
}
