import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:coflanet/core/storage/local_storage.dart';

/// 앱 테마 모드 — 시스템 추종 / 라이트 고정 / 다크 고정 3상태
enum AppThemeMode {
  system('system', '시스템 설정'),
  light('light', '라이트'),
  dark('dark', '다크');

  /// LocalStorage 영속용 문자열
  final String storageValue;

  /// 설정 UI 표시용 한국어 라벨
  final String label;

  const AppThemeMode(this.storageValue, this.label);

  static AppThemeMode fromStorage(String? value) {
    return AppThemeMode.values.firstWhere(
      (mode) => mode.storageValue == value,
      orElse: () => AppThemeMode.system,
    );
  }

  /// Flutter ThemeMode 변환
  ThemeMode get themeMode => switch (this) {
    AppThemeMode.system => ThemeMode.system,
    AppThemeMode.light => ThemeMode.light,
    AppThemeMode.dark => ThemeMode.dark,
  };
}

/// 앱 전역 테마 상태 관리.
///
/// - 3상태(시스템/라이트/다크) 모드 전환 + LocalStorage 영속
/// - `Get.changeThemeMode` 로 GetMaterialApp 의 themeMode 갱신
/// - 색 참조는 위젯에서 `AppColorScheme.of(context)` 사용 (이 컨트롤러 경유 금지)
///
/// 사용:
/// ```dart
/// final themeController = Get.find<ThemeController>();
/// themeController.setMode(AppThemeMode.dark);
/// Obx(() => Text(themeController.mode.label));
/// ```
class ThemeController extends GetxController {
  final LocalStorage _localStorage = LocalStorage();

  final Rx<AppThemeMode> _mode = AppThemeMode.system.obs;

  /// 현재 선택된 테마 모드 (Obx 안에서 읽으면 반응형)
  AppThemeMode get mode => _mode.value;

  /// GetMaterialApp 에 전달할 ThemeMode
  ThemeMode get themeMode => _mode.value.themeMode;

  /// 현재 실제로 다크 테마인지 (system 모드면 OS 설정 기준).
  /// 위젯 색 분기에는 사용 금지 — `AppColorScheme.of(context)` 를 쓸 것.
  bool get isDarkMode => switch (_mode.value) {
    AppThemeMode.dark => true,
    AppThemeMode.light => false,
    AppThemeMode.system =>
      WidgetsBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark,
  };

  @override
  void onInit() {
    super.onInit();
    _mode.value = AppThemeMode.fromStorage(_localStorage.themeMode);
  }

  /// 테마 모드 변경 + 영속화
  void setMode(AppThemeMode newMode) {
    if (_mode.value == newMode) return;
    _mode.value = newMode;
    _localStorage.setThemeMode(newMode.storageValue);
    Get.changeThemeMode(newMode.themeMode);
  }
}
