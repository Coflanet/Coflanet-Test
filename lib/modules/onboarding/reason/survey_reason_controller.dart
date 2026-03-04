import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:coflanet/core/storage/local_storage.dart';
import 'package:coflanet/data/repositories/repository_interfaces.dart';
import 'package:coflanet/data/repositories/repository_provider.dart';
import 'package:coflanet/routes/app_pages.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide LocalStorage;

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
  final SurveyRepository _surveyRepository =
      RepositoryProvider.surveyRepository;

  /// Hardcoded fallback options from Figma (937:45569)
  static const _fallbackOptions = [
    SurveyReasonOption(id: 'taste', label: '커피 취향을 찾고 싶어요.'),
    SurveyReasonOption(id: 'beginner', label: '커피는 좋아하지만 추출은 처음이에요'),
    SurveyReasonOption(id: 'subscribe', label: '원두를 편하게 구독하고 싶어요.'),
    SurveyReasonOption(id: 'variety', label: '다양한 원두를 시도해보고 싶어요.'),
    SurveyReasonOption(id: 'community', label: '사람들과 커피에 대해 소통하고 싶어요.'),
    SurveyReasonOption(id: 'info', label: '커피에 대한 정보를 알고싶어요.'),
  ];

  /// Available options (loaded from server or fallback)
  final _options = <SurveyReasonOption>[..._fallbackOptions].obs;
  List<SurveyReasonOption> get options => _options;

  /// Selected option IDs
  final _selectedIds = <String>{}.obs;
  Set<String> get selectedIds => _selectedIds;

  /// Check if at least one option is selected
  bool get hasSelection => _selectedIds.isNotEmpty;

  /// Check if a specific option is selected
  bool isSelected(String id) => _selectedIds.contains(id);

  @override
  void onInit() {
    super.onInit();
    _loadOptions();
  }

  /// Load options from get_onboarding_options RPC
  Future<void> _loadOptions() async {
    try {
      final result = await Supabase.instance.client.rpc(
        'get_onboarding_options',
      );
      if (result is List && result.isNotEmpty) {
        final parsed = <SurveyReasonOption>[];
        for (var i = 0; i < result.length; i++) {
          final map = result[i] as Map<String, dynamic>;
          final id = (map['id'] ?? map['slug'] ?? '').toString();
          final label = map['label'] as String? ?? map['name'] as String? ?? '';
          if (label.isEmpty) continue;
          parsed.add(
            SurveyReasonOption(id: id.isEmpty ? 'option_$i' : id, label: label),
          );
        }
        if (parsed.isNotEmpty) {
          _options.value = parsed;
          return;
        }
      }
    } catch (e) {
      debugPrint('[SurveyReasonController] get_onboarding_options error: $e');
    }
    // Fallback: keep hardcoded options (already set as default)
  }

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
