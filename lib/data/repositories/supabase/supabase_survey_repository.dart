import 'package:flutter/foundation.dart';
import 'package:coflanet/core/storage/local_storage.dart';
import 'package:coflanet/data/dummy/dummy_lifestyle_survey_data.dart';
import 'package:coflanet/data/dummy/dummy_survey_data.dart';
import 'package:coflanet/data/models/survey_question_model.dart';
import 'package:coflanet/data/models/survey_result_model.dart';
import 'package:coflanet/data/repositories/repository_interfaces.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide LocalStorage;

/// Supabase implementation of SurveyRepository
/// Uses RPC functions + Edge Functions for survey flow.
class SupabaseSurveyRepository implements SurveyRepository {
  final LocalStorage _storage = Get.find<LocalStorage>();

  SupabaseClient get _db => Supabase.instance.client;

  @override
  Future<List<SurveyQuestionModel>> getQuestions({
    String type = 'standard',
  }) async {
    // Survey questions are static — served from local data
    // TODO: 추후 서버에서 질문 관리 시 RPC로 교체
    return type == 'lifestyle'
        ? DummyLifestyleSurveyData.questions
        : DummySurveyData.questions;
  }

  @override
  Future<SurveyResultModel?> getSurveyResult() async {
    try {
      // Get taste profile
      final profileData = await _db.rpc('get_my_taste_profile');
      debugPrint('[SurveyRepo] get_my_taste_profile: $profileData');

      if (profileData == null) {
        // Fall back to local cache
        return _getLocalResult();
      }

      // Get recommendations
      final recsData = await _db.rpc('get_my_recommendations');
      debugPrint('[SurveyRepo] get_my_recommendations: $recsData');

      return _parseServerResult(profileData, recsData);
    } catch (e) {
      debugPrint('[SurveyRepo] getSurveyResult error: $e');
      return _getLocalResult();
    }
  }

  SurveyResultModel? _getLocalResult() {
    final cached = _storage.getSurveyResult();
    if (cached != null) {
      try {
        return SurveyResultModel.fromJson(cached);
      } catch (_) {}
    }
    return null;
  }

  /// Parse server RPC responses into SurveyResultModel
  /// Defensive parsing — structure may vary
  SurveyResultModel _parseServerResult(dynamic profileData, dynamic recsData) {
    // profileData could be a Map or a List with one element
    final profile = profileData is List
        ? (profileData.isNotEmpty
              ? profileData.first as Map<String, dynamic>
              : <String, dynamic>{})
        : profileData as Map<String, dynamic>? ?? <String, dynamic>{};

    // Parse taste profile
    final tasteProfile = TasteProfileModel(
      acidity: _toInt(profile['acidity']),
      sweetness: _toInt(profile['sweetness']),
      bitterness: _toInt(profile['bitterness']),
      body: _toInt(profile['body']),
      aroma: _toInt(profile['aroma']),
      balance: _toInt(profile['balance'], defaultValue: 50),
    );

    // Parse flavor descriptions
    final flavors = <FlavorDescriptionModel>[];
    final flavorList = profile['flavor_descriptions'] ?? profile['flavors'];
    if (flavorList is List) {
      for (final f in flavorList) {
        if (f is Map<String, dynamic>) {
          flavors.add(
            FlavorDescriptionModel(
              name: f['name'] as String? ?? '',
              emoji: f['emoji'] as String? ?? '',
              description: f['description'] as String? ?? '',
            ),
          );
        }
      }
    }

    // Parse recommendations
    final recommendations = <CoffeeRecommendationModel>[];
    final recsList = recsData is List ? recsData : [];
    for (final r in recsList) {
      if (r is Map<String, dynamic>) {
        recommendations.add(_parseRecommendation(r));
      }
    }

    final result = SurveyResultModel(
      coffeeType:
          profile['coffee_type'] as String? ??
          profile['coffeeType'] as String? ??
          '밸런스형',
      coffeeTypeDescription:
          profile['coffee_type_description'] as String? ??
          profile['coffeeTypeDescription'] as String? ??
          '',
      tasteProfile: tasteProfile,
      flavorDescriptions: flavors,
      recommendations: recommendations,
    );

    // Cache locally
    _storage.saveSurveyResult(result.toJson());

    return result;
  }

  CoffeeRecommendationModel _parseRecommendation(Map<String, dynamic> r) {
    // Defensive: handle both camelCase and snake_case keys
    final tp = r['taste_profile'] ?? r['tasteProfile'];
    final tasteProfile = tp is Map<String, dynamic>
        ? TasteProfileModel.fromJson(tp)
        : TasteProfileModel(
            acidity: _toInt(r['acidity']),
            sweetness: _toInt(r['sweetness']),
            bitterness: _toInt(r['bitterness']),
            body: _toInt(r['body']),
            aroma: _toInt(r['aroma']),
            balance: _toInt(r['balance'], defaultValue: 50),
          );

    final flavorTags = <String>[];
    final tags = r['flavor_tags'] ?? r['flavorTags'];
    if (tags is List) {
      flavorTags.addAll(tags.map((t) => t.toString()));
    }

    return CoffeeRecommendationModel(
      id: (r['id'] ?? r['bean_id'] ?? '').toString(),
      name: r['name'] as String? ?? '',
      manufacturer: r['manufacturer'] as String?,
      origin: r['origin'] as String? ?? '',
      roastLevel:
          r['roast_level'] as String? ?? r['roastLevel'] as String? ?? '',
      description: r['description'] as String? ?? '',
      imageUrl: r['image_url'] as String? ?? r['imageUrl'] as String?,
      originalPrice: r['original_price'] as int? ?? r['originalPrice'] as int?,
      discountPrice: r['discount_price'] as int? ?? r['discountPrice'] as int?,
      discountPercent:
          r['discount_percent'] as int? ?? r['discountPercent'] as int?,
      weight: r['weight'] as String?,
      tasteProfile: tasteProfile,
      matchPercent:
          r['match_percent'] as int? ?? r['matchPercent'] as int? ?? 50,
      flavorTags: flavorTags,
      purchaseUrl: r['purchase_url'] as String? ?? r['purchaseUrl'] as String?,
    );
  }

  int _toInt(dynamic value, {int defaultValue = 0}) {
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) return int.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  @override
  Future<void> saveSurveyResult(SurveyResultModel result) async {
    // Cache locally only — server generates results via submit-survey
    await _storage.saveSurveyResult(result.toJson());
  }

  @override
  Future<void> clearSurveyResult() async {
    try {
      await _db.rpc('retake_survey');
    } catch (e) {
      debugPrint('[SurveyRepo] retake_survey error: $e');
    }
    await _storage.clearSurveyResult();
  }

  @override
  Future<SurveyResultModel> generateResult(
    Map<int, List<String>> answers,
  ) async {
    // Step 1: retake_survey → get new session_id
    final retakeResult = await _db.rpc('retake_survey');
    debugPrint('[SurveyRepo] retake_survey result: $retakeResult');

    String? sessionId;
    if (retakeResult is Map<String, dynamic>) {
      sessionId =
          retakeResult['new_session_id'] as String? ??
          retakeResult['session_id'] as String?;
    } else if (retakeResult is String) {
      sessionId = retakeResult;
    }
    if (sessionId == null || sessionId.isEmpty) {
      throw Exception('[SurveyRepo] retake_survey did not return session_id');
    }

    // Step 2: submit-survey Edge Function (답변 포함)
    final accessToken = _db.auth.currentSession?.accessToken;
    final answersJson = answers.map((k, v) => MapEntry(k.toString(), v));

    final response = await _db.functions.invoke(
      'submit-survey',
      body: {'session_id': sessionId, 'answers': answersJson},
      headers: {
        if (accessToken != null) 'Authorization': 'Bearer $accessToken',
      },
    );

    final data = response.data;
    debugPrint('[SurveyRepo] submit-survey response: $data');
    if (data == null) {
      throw Exception('[SurveyRepo] submit-survey returned null');
    }

    // Parse the response
    final responseMap = data is Map<String, dynamic>
        ? data
        : <String, dynamic>{};
    final profileData =
        responseMap['taste_profile'] ?? responseMap['profile'] ?? responseMap;
    final recsData = responseMap['recommendations'] ?? [];

    return _parseServerResult(profileData, recsData);
  }

  @override
  Future<void> saveSurveyAnswers(Map<String, dynamic> answers) async {
    // Cache locally — answers are submitted with session via Edge Function
    await _storage.saveSurveyAnswers(answers);
  }

  @override
  Future<Map<String, dynamic>?> getSurveyAnswers() async {
    return _storage.getSurveyAnswers();
  }

  @override
  Future<void> saveSelectedBeanIds(List<String> ids) async {
    // Cache locally
    await _storage.write('selected_bean_ids', ids);
  }

  @override
  Future<List<String>?> getSelectedBeanIds() async {
    final data = _storage.read<List<dynamic>>('selected_bean_ids');
    return data?.cast<String>();
  }

  @override
  Future<void> saveSurveyReasons(List<String> reasons) async {
    try {
      await _db.rpc('save_onboarding_reasons', params: {'reasons': reasons});
    } catch (e) {
      debugPrint('[SurveyRepo] save_onboarding_reasons error: $e');
    }
    // Cache locally as well
    await _storage.write('survey_reasons', reasons);
  }
}
