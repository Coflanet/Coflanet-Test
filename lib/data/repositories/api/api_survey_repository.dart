import 'package:coflanet/core/api/api_client.dart';
import 'package:coflanet/data/models/survey_question_model.dart';
import 'package:coflanet/data/models/survey_result_model.dart';
import 'package:coflanet/data/repositories/repository_interfaces.dart';
import 'package:get/get.dart';

/// API implementation of SurveyRepository
/// Connects to backend API for survey data
class ApiSurveyRepository implements SurveyRepository {
  final ApiClient _apiClient = Get.find<ApiClient>();

  // API endpoints
  static const String _questionsEndpoint = '/survey/questions';
  static const String _resultEndpoint = '/survey/result';
  static const String _submitEndpoint = '/survey/submit';
  static const String _answersEndpoint = '/survey/answers';
  static const String _beansEndpoint = '/survey/selected-beans';
  static const String _reasonsEndpoint = '/survey/reasons';

  @override
  Future<List<SurveyQuestionModel>> getQuestions({
    String type = 'standard',
  }) async {
    try {
      final response = await _apiClient.get('$_questionsEndpoint?type=$type');
      final List<dynamic> data = response.data['questions'];
      return data.map((e) => SurveyQuestionModel.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<SurveyResultModel?> getSurveyResult() async {
    try {
      final response = await _apiClient.get(_resultEndpoint);
      if (response.data != null && response.data['result'] != null) {
        return SurveyResultModel.fromJson(response.data['result']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveSurveyResult(SurveyResultModel result) async {
    try {
      await _apiClient.post(_resultEndpoint, data: result.toJson());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> clearSurveyResult() async {
    try {
      await _apiClient.delete(_resultEndpoint);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<SurveyResultModel> generateResult(
    Map<int, List<String>> answers,
  ) async {
    try {
      // Convert answers map to API format
      final answersJson = answers.map(
        (key, value) => MapEntry(key.toString(), value),
      );

      final response = await _apiClient.post(
        _submitEndpoint,
        data: {'answers': answersJson},
      );

      return SurveyResultModel.fromJson(response.data['result']);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> saveSurveyAnswers(Map<String, dynamic> answers) async {
    try {
      await _apiClient.post(_answersEndpoint, data: answers);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>?> getSurveyAnswers() async {
    try {
      final response = await _apiClient.get(_answersEndpoint);
      return response.data['answers'] as Map<String, dynamic>?;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveSelectedBeanIds(List<String> ids) async {
    try {
      await _apiClient.post(_beansEndpoint, data: {'bean_ids': ids});
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<String>?> getSelectedBeanIds() async {
    try {
      final response = await _apiClient.get(_beansEndpoint);
      final List<dynamic>? data = response.data['bean_ids'];
      return data?.cast<String>();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveSurveyReasons(List<String> reasons) async {
    try {
      await _apiClient.post(_reasonsEndpoint, data: {'reasons': reasons});
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> startSurvey({
    String surveyType = 'standard',
  }) async {
    throw UnimplementedError('API startSurvey not implemented');
  }

  @override
  Future<Map<String, dynamic>> saveSurveyStepAnswers(
    String sessionId,
    List<Map<String, dynamic>> answers,
  ) async {
    throw UnimplementedError('API saveSurveyStepAnswers not implemented');
  }

  @override
  Future<Map<String, dynamic>> completeSurvey(String sessionId) async {
    throw UnimplementedError('API completeSurvey not implemented');
  }
}
