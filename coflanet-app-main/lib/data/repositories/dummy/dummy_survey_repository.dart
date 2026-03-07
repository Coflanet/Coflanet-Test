import 'package:coflanet/core/storage/local_storage.dart';
import 'package:coflanet/data/dummy/dummy_lifestyle_survey_data.dart';
import 'package:coflanet/data/dummy/dummy_survey_data.dart';
import 'package:coflanet/data/models/survey_question_model.dart';
import 'package:coflanet/data/models/survey_result_model.dart';
import 'package:coflanet/data/repositories/repository_interfaces.dart';
import 'package:get/get.dart';

/// Dummy implementation of SurveyRepository
/// Uses local storage and static dummy data
class DummySurveyRepository implements SurveyRepository {
  final LocalStorage _storage = Get.find<LocalStorage>();

  @override
  Future<List<SurveyQuestionModel>> getQuestions({
    String type = 'standard',
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return type == 'lifestyle'
        ? DummyLifestyleSurveyData.questions
        : DummySurveyData.questions;
  }

  @override
  Future<SurveyResultModel?> getSurveyResult() async {
    final resultJson = _storage.getSurveyResult();
    if (resultJson != null) {
      return SurveyResultModel.fromJson(resultJson);
    }
    return null;
  }

  @override
  Future<void> saveSurveyResult(SurveyResultModel result) async {
    await _storage.saveSurveyResult(result.toJson());
  }

  @override
  Future<void> clearSurveyResult() async {
    await _storage.clearSurveyResult();
  }

  @override
  Future<SurveyResultModel> generateResult(
    Map<int, List<String>> answers,
  ) async {
    // Simulate analysis delay
    await Future.delayed(const Duration(seconds: 2));
    return DummySurveyData.generateResult(answers);
  }

  @override
  Future<void> saveSurveyAnswers(Map<String, dynamic> answers) async {
    await _storage.saveSurveyAnswers(answers);
  }

  @override
  Future<Map<String, dynamic>?> getSurveyAnswers() async {
    return _storage.getSurveyAnswers();
  }

  @override
  Future<void> saveSelectedBeanIds(List<String> ids) async {
    await _storage.write('selected_bean_ids', ids);
  }

  @override
  Future<List<String>?> getSelectedBeanIds() async {
    final data = _storage.read<List<dynamic>>('selected_bean_ids');
    return data?.cast<String>();
  }

  @override
  Future<void> saveSurveyReasons(List<String> reasons) async {
    await _storage.write('survey_reasons', reasons);
  }

  @override
  Future<Map<String, dynamic>> startSurvey({
    String surveyType = 'standard',
  }) async {
    return {'session_id': 'dummy_session', 'status': 'ok'};
  }

  @override
  Future<Map<String, dynamic>> saveSurveyStepAnswers(
    String sessionId,
    List<Map<String, dynamic>> answers,
  ) async {
    return {'status': 'ok'};
  }

  @override
  Future<Map<String, dynamic>> completeSurvey(String sessionId) async {
    return {'status': 'ok'};
  }
}
