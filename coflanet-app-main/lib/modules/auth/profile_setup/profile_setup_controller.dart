import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  Future<void> saveAndContinue() async {
    if (!isValid) return;

    final trimmedName = _name.value.trim();

    // Save name to local storage
    await _storage.saveUserName(trimmedName);

    // Update SurveyService cache so other screens can access the name
    await _surveyService.updateUserName(trimmedName);

    // Update AuthService user model
    await _authService.updateUserName(trimmedName);

    // Navigate to survey reason (커플래닛을 찾게 된 이유)
    Get.toNamed(Routes.surveyReason);
  }
}
