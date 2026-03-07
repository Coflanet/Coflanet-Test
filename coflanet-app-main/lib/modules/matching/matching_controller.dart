import 'package:get/get.dart';
import 'package:coflanet/core/base/base_controller.dart';
import 'package:coflanet/core/services/survey_service.dart';
import 'package:coflanet/data/models/survey_result_model.dart';
import 'package:coflanet/routes/app_pages.dart';

class MatchingController extends BaseController {
  final SurveyService _surveyService = Get.find<SurveyService>();

  // Delegate to SurveyService
  SurveyResultModel? get surveyResult => _surveyService.surveyResult;
  String get userName => _surveyService.userName;
  bool get hasResult => _surveyService.hasResult;

  @override
  void onInit() {
    super.onInit();
    _loadSurveyResult();
  }

  /// Load survey result via service
  Future<void> _loadSurveyResult() async {
    await executeWithLoading(() async {
      await _surveyService.loadSurveyResult();
    });
  }

  /// Navigate to retake survey
  void retakeSurvey() {
    Get.offAllNamed(Routes.surveyIntro);
  }

  /// Go back to previous screen
  void goBack() {
    Get.back();
  }
}
