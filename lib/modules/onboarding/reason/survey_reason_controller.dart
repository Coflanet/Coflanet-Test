import 'package:get/get.dart';
import 'package:coflanet/core/services/app_config_service.dart';
import 'package:coflanet/data/models/onboarding_option_model.dart';
import 'package:coflanet/data/repositories/repository_interfaces.dart';
import 'package:coflanet/data/repositories/repository_provider.dart';
import 'package:coflanet/routes/app_pages.dart';

/// Controller for Survey Reason Screen
/// Handles multiple selection of reasons for joining Coflanet
class SurveyReasonController extends GetxController {
  final SurveyRepository _surveyRepository =
      RepositoryProvider.surveyRepository;
  final AppConfigService _config = Get.find<AppConfigService>();

  /// 가입 이유 옵션 — 앱 시작 시 스플래시에서 프리로드된 서버 데이터
  List<OnboardingOption> get options => _config.onboardingOptions;

  /// Selected option keys
  final _selectedIds = <String>{}.obs;
  Set<String> get selectedIds => _selectedIds;

  /// Check if at least one option is selected
  bool get hasSelection => _selectedIds.isNotEmpty;

  /// Check if a specific option is selected
  bool isSelected(String id) => _selectedIds.contains(id);

  /// Toggle option selection
  void toggleOption(String id) {
    if (_selectedIds.contains(id)) {
      _selectedIds.remove(id);
    } else {
      _selectedIds.add(id);
    }
  }

  /// Complete and navigate to signup complete screen (완료페이지)
  Future<void> complete() async {
    if (!hasSelection) return;

    // Save to server via repository
    await _surveyRepository.saveSurveyReasons(_selectedIds.toList());

    // Navigate to signup complete screen (완료페이지)
    Get.offAllNamed(Routes.signUpComplete);
  }
}
