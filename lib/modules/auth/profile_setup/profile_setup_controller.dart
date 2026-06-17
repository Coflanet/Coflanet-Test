import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/util_constant.dart';
import 'package:coflanet/core/storage/local_storage.dart';
import 'package:coflanet/core/services/auth_service.dart';
import 'package:coflanet/core/services/survey_service.dart';
import 'package:coflanet/routes/app_pages.dart';

/// Controller for profile setup screen (name input after social login)
class ProfileSetupController extends GetxController {
  final LocalStorage _storage = Get.find<LocalStorage>();
  final AuthService _authService = Get.find<AuthService>();
  final SurveyService _surveyService = Get.find<SurveyService>();

  /// Text controller for name input
  final TextEditingController nameController = TextEditingController();

  /// Observable name value
  final _name = ''.obs;
  String get name => _name.value;

  /// 저장(서버 반영) 진행 상태 — 중복 탭 방지 + 버튼 로딩 표시
  final _isSaving = false.obs;
  bool get isSaving => _isSaving.value;

  /// Check if name is valid (minimum 2 characters)
  bool get isValid => _name.value.trim().length >= 2;

  @override
  void onInit() {
    super.onInit();
    // Sync text controller with observable
    nameController.addListener(() {
      _name.value = nameController.text;
    });

    // Pre-fill name from social login if available
    _prefillNameFromSocialLogin();
  }

  /// Pre-fill name field with name from social login
  void _prefillNameFromSocialLogin() {
    final user = _authService.currentUser;
    if (user?.name != null && user!.name!.isNotEmpty) {
      nameController.text = user.name!;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }

  /// Save name and continue to survey reason screen
  ///
  /// 서버 저장(save_display_name)이 실패하면 다음 단계로 넘어가지 않고 에러를
  /// 노출한다. 이전에는 try-catch 가 없어 서버 저장 예외 시 navigation 에
  /// 도달하지 못하고 화면이 조용히 멈췄다.
  Future<void> saveAndContinue() async {
    if (!isValid || _isSaving.value) return;

    final trimmedName = _name.value.trim();
    _isSaving.value = true;

    try {
      // 로컬/캐시 우선 반영 (다른 화면에서 이름 즉시 사용)
      await _storage.saveUserName(trimmedName);
      await _surveyService.updateUserName(trimmedName);

      // 서버(profiles.display_name)에 저장 — 실패 시 예외 → 이동하지 않음
      await _authService.updateUserName(trimmedName);

      // 성공한 경우에만 다음 단계로 이동 (커플래닛을 찾게 된 이유)
      Get.toNamed(Routes.surveyReason);
    } catch (e) {
      if (kDebugMode) debugPrint('[ProfileSetup] 이름 저장 실패: $e');
      AppUtil.showErrorSnackbar('저장 실패', '이름을 저장하지 못했어요. 잠시 후 다시 시도해주세요.');
    } finally {
      _isSaving.value = false;
    }
  }
}
