import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/core/storage/local_storage.dart';
import 'package:coflanet/routes/app_pages.dart';

/// Controller for profile setup screen (name input after social login)
class ProfileSetupController extends GetxController {
  final LocalStorage _storage = Get.find<LocalStorage>();

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
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }

  /// Save name and continue to survey reason screen
  Future<void> saveAndContinue() async {
    if (!isValid) return;

    // Save name to local storage
    await _storage.saveUserName(_name.value.trim());

    // Navigate to survey reason (커플래닛을 찾게 된 이유)
    Get.toNamed(Routes.surveyReason);
  }
}
