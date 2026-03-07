import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:coflanet/core/base/base_controller.dart';
import 'package:coflanet/core/services/auth_service.dart';
import 'package:coflanet/core/services/survey_service.dart';
import 'package:coflanet/data/models/survey_result_model.dart';
import 'package:coflanet/routes/app_pages.dart';

/// Taste preference item (e.g. 산미 / 좋음)
class TastePreference {
  final String category;
  final String level;
  final TasteGradientType gradientType;

  const TastePreference({
    required this.category,
    required this.level,
    required this.gradientType,
  });
}

enum TasteGradientType { blue, yellow, pink }

/// Flavor description item
class FlavorDescription {
  final String title;
  final String description;

  const FlavorDescription({required this.title, required this.description});
}

/// Recipe model for saved recipes (kept for API compatibility)
class SavedRecipe {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String coffeeType;
  final DateTime savedAt;

  SavedRecipe({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.coffeeType,
    required this.savedAt,
  });
}

class MyPlanetController extends BaseController {
  final AuthService _authService = Get.find<AuthService>();
  final SurveyService _surveyService = Get.find<SurveyService>();

  // Saved recipes list (kept for backward compatibility)
  final RxList<SavedRecipe> _savedRecipes = <SavedRecipe>[].obs;
  List<SavedRecipe> get savedRecipes => _savedRecipes;

  // Delegate to SurveyService
  SurveyResultModel? get surveyResult => _surveyService.surveyResult;
  bool get hasTasteProfile => _surveyService.hasResult;
  String get userName => _surveyService.userName;

  // 게스트 여부
  bool get isAnonymous => _authService.isAnonymous;

  // Has saved recipes (backward compat)
  bool get hasRecipes => _savedRecipes.isNotEmpty;

  // Recipe count (backward compat)
  int get recipeCount => _savedRecipes.length;

  // Taste preferences derived from survey result
  List<TastePreference> get tastePreferences {
    final profile = surveyResult?.tasteProfile;
    if (profile == null) return [];

    return [
      TastePreference(
        category: '산미',
        level: _levelText(profile.acidity),
        gradientType: _gradientForValue(profile.acidity),
      ),
      TastePreference(
        category: '바디감',
        level: _levelText(profile.body),
        gradientType: _gradientForValue(profile.body),
      ),
      TastePreference(
        category: '단맛',
        level: _levelText(profile.sweetness),
        gradientType: _gradientForValue(profile.sweetness),
      ),
      TastePreference(
        category: '쓴맛',
        level: _levelText(profile.bitterness),
        gradientType: _gradientForValue(profile.bitterness),
      ),
    ];
  }

  // Flavor descriptions
  List<FlavorDescription> get flavorDescriptions => const [
    FlavorDescription(title: '과일 향', description: '베리, 사과, 감귤 같은 상큼한 향'),
    FlavorDescription(title: '꽃 향', description: '자스민처럼 은은하고 화사한 향'),
    FlavorDescription(title: '견과류/초콜릿 향', description: '고소한 견과나 다크초콜릿 같은 향'),
    FlavorDescription(title: '로스팅 향', description: '구운 곡물, 시리얼 같은 구수한 향'),
  ];

  @override
  void onInit() {
    super.onInit();
    _loadTasteProfile();
  }

  /// Load taste profile via SurveyService
  Future<void> _loadTasteProfile() async {
    await executeWithLoading(() async {
      await _surveyService.loadSurveyResult();
    });
  }

  /// Toggle demo data for testing
  Future<void> toggleDemoData() async {
    if (hasTasteProfile) {
      await _surveyService.clearSurveyResult();
    } else {
      await _surveyService.saveSurveyResult(
        const SurveyResultModel(
          coffeeType: '과일향 애호가',
          coffeeTypeDescription: '산미와 과일향을 즐기는 타입',
          tasteProfile: TasteProfileModel(
            acidity: 80,
            sweetness: 50,
            bitterness: 30,
            body: 50,
            aroma: 70,
          ),
          recommendations: [],
        ),
      );
    }
  }

  /// 계정 연동 화면으로 이동
  void goToAccountLink() {
    Get.toNamed(Routes.accountLink);
  }

  /// Navigate to survey
  void goToSurvey() {
    Get.toNamed(Routes.surveyIntro);
  }

  /// Retake survey
  void retakeSurvey() {
    Get.toNamed(Routes.surveyIntro);
  }

  /// Logout
  Future<void> logout() async {
    try {
      await _authService.signOut();
    } catch (e) {
      debugPrint('[MyPlanet] logout error: $e');
    }
    Get.offAllNamed(Routes.signIn);
  }

  /// Withdraw account (회원탈퇴)
  void withdrawAccount() {
    Get.dialog(
      AlertDialog(
        title: const Text('회원탈퇴'),
        content: const Text('정말 탈퇴하시겠습니까?\n모든 데이터가 삭제됩니다.'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('취소')),
          TextButton(
            onPressed: () async {
              Get.back(); // close dialog
              await _executeWithdrawal();
            },
            child: const Text('탈퇴', style: TextStyle(color: Color(0xFFFF4242))),
          ),
        ],
      ),
    );
  }

  Future<void> _executeWithdrawal() async {
    try {
      isLoading = true;
      await _authService.deleteAccount();
      await _surveyService.clearSurveyResult();
      Get.offAllNamed(Routes.signIn);
    } catch (e) {
      Get.snackbar(
        '오류',
        '회원탈퇴 중 오류가 발생했습니다: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading = false;
    }
  }

  /// Open privacy policy
  void openPrivacyPolicy() {
    launchUrl(
      Uri.parse('https://coflanet.github.io/coflanet/privacy'),
      mode: LaunchMode.externalApplication,
    );
  }

  /// Open terms of service
  void openTermsOfService() {
    launchUrl(
      Uri.parse('https://coflanet.github.io/coflanet/terms'),
      mode: LaunchMode.externalApplication,
    );
  }

  // Kept for backward compatibility
  void addRecipe() {}
  void removeRecipe(String id) {
    _savedRecipes.removeWhere((recipe) => recipe.id == id);
  }

  void viewRecipeDetail(SavedRecipe recipe) {
    Get.snackbar(
      recipe.name,
      recipe.description,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void goBack() {
    Get.back();
  }

  // === Private helpers ===

  String _levelText(int value) {
    if (value >= 70) return '좋음';
    if (value >= 40) return '보통';
    return '싫음';
  }

  TasteGradientType _gradientForValue(int value) {
    if (value >= 70) return TasteGradientType.blue;
    if (value >= 40) return TasteGradientType.yellow;
    return TasteGradientType.pink;
  }
}
