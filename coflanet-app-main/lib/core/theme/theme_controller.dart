import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/core/storage/local_storage.dart';
import 'package:coflanet/constants/color_constant.dart';

/// Simple theme controller for managing app-wide theme state.
///
/// This controller handles:
/// - Light/Dark mode switching
/// - Theme persistence using existing LocalStorage
///
/// Usage:
/// ```dart
/// final themeController = Get.find<ThemeController>();
///
/// // Toggle theme
/// themeController.toggleTheme();
///
/// // Set specific theme
/// themeController.setDarkMode(true);
///
/// // Listen to theme changes
/// Obx(() => Text(
///   'Current theme: ${themeController.isDarkMode.value ? 'Dark' : 'Light'}'
/// ))
/// ```
class ThemeController extends GetxController {
  final LocalStorage _localStorage = LocalStorage();

  late RxBool _isDarkMode;

  /// Observable dark mode status
  RxBool get isDarkMode => _isDarkMode;

  /// Whether dark mode is currently active (non-observable)
  bool get isDarkModeValue => _isDarkMode.value;

  @override
  void onInit() {
    super.onInit();
    _initializeTheme();
  }

  /// Initialize theme from storage or system settings
  void _initializeTheme() {
    // Use existing dark mode setting from LocalStorage
    final savedDarkMode = _localStorage.isDarkMode;
    _isDarkMode = savedDarkMode.obs;

    // Apply initial theme
    Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  /// Toggle between light and dark theme
  void toggleTheme() {
    final newDarkMode = !_isDarkMode.value;
    setDarkMode(newDarkMode);
  }

  /// Set dark mode directly
  void setDarkMode(bool isDark) {
    if (_isDarkMode.value != isDark) {
      _isDarkMode.value = isDark;

      // Save to storage using existing method
      _localStorage.setDarkMode(isDark);

      // Apply theme
      Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);

      // Trigger update
      update();
    }
  }

  /// Get theme-appropriate color
  Color getThemeColor({required Color lightColor, required Color darkColor}) {
    return _isDarkMode.value ? darkColor : lightColor;
  }

  /// Get appropriate app color based on theme
  AppColorTheme getAppColors() {
    return _isDarkMode.value ? DarkAppColors() : LightAppColors();
  }
}

/// Light theme colors
class LightAppColors implements AppColorTheme {
  @override
  Color get primaryNormal => AppColor.primaryNormal;

  @override
  Color get labelNormal => AppColor.labelNormal;

  @override
  Color get backgroundNormal => AppColor.backgroundNormalNormal;

  @override
  Color get backgroundElevated => AppColor.backgroundElevatedNormal;

  @override
  Color get componentFill => AppColor.componentFillNormal;

  @override
  Color get lineColor => AppColor.lineNormalNormal;
}

/// Dark theme colors
class DarkAppColors implements AppColorTheme {
  @override
  Color get primaryNormal => AppColor.darkPrimaryNormal;

  @override
  Color get labelNormal => AppColor.darkLabelNormal;

  @override
  Color get backgroundNormal => AppColor.darkBackgroundNormalNormal;

  @override
  Color get backgroundElevated => AppColor.darkBackgroundElevatedNormal;

  @override
  Color get componentFill => AppColor.darkComponentFillNormal;

  @override
  Color get lineColor => AppColor.darkLineNormalNormal;
}

/// Abstract theme color interface
abstract class AppColorTheme {
  Color get primaryNormal;
  Color get labelNormal;
  Color get backgroundNormal;
  Color get backgroundElevated;
  Color get componentFill;
  Color get lineColor;
}
