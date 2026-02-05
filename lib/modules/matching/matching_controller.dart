import 'package:get/get.dart';
import 'package:coflanet/core/base/base_controller.dart';
import 'package:coflanet/core/storage/local_storage.dart';
import 'package:coflanet/data/models/survey_result_model.dart';
import 'package:coflanet/routes/app_pages.dart';

class MatchingController extends BaseController {
  final LocalStorage _storage = Get.find<LocalStorage>();

  // Survey result
  final Rxn<SurveyResultModel> _surveyResult = Rxn<SurveyResultModel>();
  SurveyResultModel? get surveyResult => _surveyResult.value;

  // User name
  String get userName => _storage.getUserName() ?? '사용자';

  // Has result
  bool get hasResult => _surveyResult.value != null;

  @override
  void onInit() {
    super.onInit();
    _loadSurveyResult();
  }

  /// Load survey result from local storage
  Future<void> _loadSurveyResult() async {
    await executeWithLoading(() async {
      final resultJson = _storage.getSurveyResult();
      if (resultJson != null) {
        _surveyResult.value = SurveyResultModel.fromJson(resultJson);
      }
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
