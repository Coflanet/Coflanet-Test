import 'package:get/get.dart';
import 'package:coflanet/core/storage/local_storage.dart';
import 'package:coflanet/routes/app_pages.dart';

/// Model for survey reason option
class SurveyReasonOption {
  final String id;
  final String label;

  const SurveyReasonOption({required this.id, required this.label});
}

/// Controller for Survey Reason Screen
/// Handles multiple selection of reasons for joining Coflanet
class SurveyReasonController extends GetxController {
  final LocalStorage _storage = Get.find<LocalStorage>();

  /// Available options from Figma (937:45569)
  final List<SurveyReasonOption> options = const [
    SurveyReasonOption(id: 'taste', label: '커피 취향을 찾고 싶어요.'),
    SurveyReasonOption(id: 'beginner', label: '커피는 좋아하지만 추출은 처음이에요'),
    SurveyReasonOption(id: 'subscribe', label: '원두를 편하게 구독하고 싶어요.'),
    SurveyReasonOption(id: 'variety', label: '다양한 원두를 시도해보고 싶어요.'),
    SurveyReasonOption(id: 'community', label: '사람들과 커피에 대해 소통하고 싶어요.'),
    SurveyReasonOption(id: 'info', label: '커피에 대한 정보를 알고싶어요.'),
  ];

  /// Selected option IDs
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

    // Save selected reasons to storage
    await _storage.write('survey_reasons', _selectedIds.toList());

    // Navigate to signup complete screen (완료페이지)
    Get.offAllNamed(Routes.signUpComplete);
  }
}
