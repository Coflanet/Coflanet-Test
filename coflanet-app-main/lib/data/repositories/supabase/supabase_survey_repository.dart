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

  /// Current survey session ID (tracked across start → save → complete)
  String? _currentSessionId;

  /// Current survey type for question ID lookups
  String? _currentSurveyType;

  /// Cached question_key → question UUID map (loaded from survey_questions table)
  Map<String, String>? _questionKeyToIdCache;

  /// Static mapping: dummy question index → server question_key (preference)
  static const _preferenceQuestionKeys = <int, String>{
    0: 'brew_method',
    1: 'experience_level',
    2: 'pref_acidity',
    3: 'pref_body',
    4: 'pref_sweetness',
    5: 'pref_bitterness',
    6: 'pref_aroma_fruity',
    7: 'pref_aroma_floral',
    8: 'pref_aroma_nutty_cocoa',
    9: 'pref_aroma_roasted',
  };

  /// Static mapping: dummy question index → server question_key (lifestyle)
  static const _lifestyleQuestionKeys = <int, String>{
    0: 'brew_method',
    1: 'experience_level',
    2: 'life_morning',
    3: 'life_weekend',
    4: 'life_stress',
    5: 'life_new_experience',
    6: 'life_taste',
    7: 'life_dessert',
    8: 'life_drink_temp',
    9: 'life_scent',
    10: 'life_personality',
    11: 'life_decision',
  };

  @override
  Future<List<SurveyQuestionModel>> getQuestions({
    String type = 'standard',
  }) async {
    // Questions are static — served from local data
    // Server session is started separately via startSurvey()
    return type == 'lifestyle'
        ? DummyLifestyleSurveyData.questions
        : DummySurveyData.questions;
  }

  @override
  Future<SurveyResultModel?> getSurveyResult() async {
    // Skip server call if not authenticated
    if (_db.auth.currentUser == null) {
      return _getLocalResult();
    }

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
    // Step 1: Ensure session exists
    String? sessionId = _currentSessionId;
    if (sessionId == null || sessionId.isEmpty) {
      final retakeResult = await _db.rpc('retake_survey');
      debugPrint('[SurveyRepo] retake_survey result: $retakeResult');

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
      _currentSessionId = sessionId;

      // Load question IDs for the new session
      final surveyType = _currentSurveyType ?? 'preference';
      await _loadQuestionIds(surveyType);
    }

    // Step 2: Save ALL answers at once (ensures completeness)
    final allAnswerMaps = <Map<String, dynamic>>[];
    for (final entry in answers.entries) {
      allAnswerMaps.add({'step': entry.key, 'selected_options': entry.value});
    }
    if (allAnswerMaps.isNotEmpty) {
      await saveSurveyStepAnswers(sessionId, allAnswerMaps);
    }

    // Step 3: complete_survey RPC
    try {
      await completeSurvey(sessionId);
    } catch (e) {
      debugPrint('[SurveyRepo] complete_survey error (continuing): $e');
    }

    // Step 4: submit-survey Edge Function (supabase_flutter handles auth)
    final response = await _db.functions.invoke(
      'submit-survey',
      body: {'session_id': sessionId},
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

    // Clear session after successful completion
    _currentSessionId = null;
    _currentSurveyType = null;
    _questionKeyToIdCache = null;

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

  @override
  Future<Map<String, dynamic>> startSurvey({
    String surveyType = 'standard',
  }) async {
    final result = await _db.rpc(
      'start_survey',
      params: {'p_survey_type': surveyType},
    );
    debugPrint('[SurveyRepo] start_survey result: $result');
    final data = result is Map<String, dynamic> ? result : <String, dynamic>{};
    _currentSessionId =
        data['session_id'] as String? ?? data['new_session_id'] as String?;
    _currentSurveyType = surveyType;

    // Pre-load question UUIDs for this survey type
    _questionKeyToIdCache = null; // invalidate old cache
    await _loadQuestionIds(surveyType);

    return data;
  }

  /// Load question_key → question UUID mapping from survey_questions table.
  Future<void> _loadQuestionIds(String surveyType) async {
    try {
      final rows = await _db
          .from('survey_questions')
          .select('id, question_key, survey_type')
          .or('survey_type.eq.common,survey_type.eq.$surveyType')
          .order('step')
          .order('question_order');

      final map = <String, String>{};
      for (final r in rows) {
        final key = r['question_key'] as String?;
        if (key != null) {
          map[key] = r['id'] as String;
        }
      }
      _questionKeyToIdCache = map;
      debugPrint('[SurveyRepo] loaded ${map.length} question IDs by key: $map');
    } catch (e) {
      debugPrint('[SurveyRepo] _loadQuestionIds error: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> saveSurveyStepAnswers(
    String sessionId,
    List<Map<String, dynamic>> answers,
  ) async {
    // Resolve dummy step → question_key → question UUID before sending
    // RPC expects: [{question_id: UUID, selected_options: [...], score_value: int?}]
    if (_questionKeyToIdCache == null && _currentSurveyType != null) {
      await _loadQuestionIds(_currentSurveyType!);
    }

    final questionKeys = _currentSurveyType == 'lifestyle'
        ? _lifestyleQuestionKeys
        : _preferenceQuestionKeys;

    final resolvedAnswers = <Map<String, dynamic>>[];
    for (final answer in answers) {
      final step = answer['step'] as int?;
      if (step == null) continue;

      final questionKey = questionKeys[step];
      if (questionKey == null) {
        debugPrint('[SurveyRepo] no question_key for step $step, skipping');
        continue;
      }

      final questionId = _questionKeyToIdCache?[questionKey];
      if (questionId == null) {
        debugPrint(
          '[SurveyRepo] no UUID for question_key=$questionKey, skipping',
        );
        continue;
      }

      final selectedOptions = answer['selected_options'] as List? ?? [];
      final resolved = <String, dynamic>{
        'question_id': questionId,
        'selected_options': selectedOptions,
      };

      // Add score_value for preference taste/aroma questions
      final score = _computeScoreValue(step, selectedOptions);
      if (score != null) {
        resolved['score_value'] = score;
      }

      resolvedAnswers.add(resolved);
    }

    if (resolvedAnswers.isEmpty) {
      debugPrint('[SurveyRepo] no resolved answers to save');
      return {};
    }

    final result = await _db.rpc(
      'save_survey_answers',
      params: {'p_session_id': sessionId, 'p_answers': resolvedAnswers},
    );
    debugPrint('[SurveyRepo] save_survey_answers result: $result');
    return result is Map<String, dynamic> ? result : <String, dynamic>{};
  }

  /// Exposed for unit testing: preference question key mapping.
  @visibleForTesting
  static Map<int, String> get preferenceQuestionKeys => _preferenceQuestionKeys;

  /// Exposed for unit testing: lifestyle question key mapping.
  @visibleForTesting
  static Map<int, String> get lifestyleQuestionKeys => _lifestyleQuestionKeys;

  /// Exposed for unit testing: score_value computation.
  @visibleForTesting
  static int? computeScoreValue(int dummyStep, List<dynamic> selectedOptions) {
    return _computeScoreValueStatic(dummyStep, selectedOptions);
  }

  /// Compute score_value for preference survey taste/aroma questions.
  /// Taste (steps 2-5): dislike=1, neutral=2, like=3
  /// Aroma (steps 6-9): dislike=0, like=1
  int? _computeScoreValue(int dummyStep, List<dynamic> selectedOptions) {
    if (_currentSurveyType != 'preference') return null;
    return _computeScoreValueStatic(dummyStep, selectedOptions);
  }

  static int? _computeScoreValueStatic(
    int dummyStep,
    List<dynamic> selectedOptions,
  ) {
    if (selectedOptions.isEmpty) return null;
    final option = selectedOptions.first.toString();

    if (dummyStep >= 2 && dummyStep <= 5) {
      switch (option) {
        case 'dislike':
          return 1;
        case 'neutral':
          return 2;
        case 'like':
          return 3;
      }
    } else if (dummyStep >= 6 && dummyStep <= 9) {
      switch (option) {
        case 'dislike':
          return 0;
        case 'like':
          return 1;
      }
    }
    return null;
  }

  @override
  Future<Map<String, dynamic>> completeSurvey(String sessionId) async {
    final result = await _db.rpc(
      'complete_survey',
      params: {'p_session_id': sessionId},
    );
    debugPrint('[SurveyRepo] complete_survey result: $result');
    return result is Map<String, dynamic> ? result : <String, dynamic>{};
  }
}
