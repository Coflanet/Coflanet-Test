import 'package:flutter/material.dart';

import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';

/// 앱 전역 테마 설정.
///
/// 라이트/다크 모두 [AppColorScheme] 시맨틱 스킴에서 색을 가져오는
/// 단일 빌더(_build)로 생성한다 — 서브테마 누락/비대칭 방지.
class AppTheme {
  AppTheme._();

  /// Light theme
  static ThemeData get light => _build(AppColorScheme.light, Brightness.light);

  /// Dark theme
  static ThemeData get dark => _build(AppColorScheme.dark, Brightness.dark);

  static ThemeData _build(AppColorScheme colors, Brightness brightness) {
    final bool isDark = brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      primaryColor: colors.primaryNormal,
      scaffoldBackgroundColor: colors.backgroundNormalNormal,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: colors.primaryNormal,
        onPrimary: AppColor.staticLabelWhiteStrong,
        secondary: colors.primarySecondary,
        onSecondary: AppColor.staticLabelWhiteStrong,
        surface: colors.backgroundNormalNormal,
        onSurface: colors.labelNormal,
        error: colors.statusNegative,
        onError: AppColor.staticLabelWhiteStrong,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.backgroundNormalNormal,
        foregroundColor: colors.labelNormal,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.headline1Bold.copyWith(
          color: colors.labelNormal,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.display1Bold.copyWith(
          color: colors.labelNormal,
        ),
        displayMedium: AppTextStyles.display2Bold.copyWith(
          color: colors.labelNormal,
        ),
        headlineLarge: AppTextStyles.heading1Bold.copyWith(
          color: colors.labelNormal,
        ),
        headlineMedium: AppTextStyles.heading2Bold.copyWith(
          color: colors.labelNormal,
        ),
        titleLarge: AppTextStyles.title1Bold.copyWith(
          color: colors.labelNormal,
        ),
        titleMedium: AppTextStyles.title2Bold.copyWith(
          color: colors.labelNormal,
        ),
        titleSmall: AppTextStyles.title3Bold.copyWith(
          color: colors.labelNormal,
        ),
        bodyLarge: AppTextStyles.body1NormalRegular.copyWith(
          color: colors.labelNormal,
        ),
        bodyMedium: AppTextStyles.body2NormalRegular.copyWith(
          color: colors.labelNormal,
        ),
        labelLarge: AppTextStyles.label1NormalMedium.copyWith(
          color: colors.labelNormal,
        ),
        labelMedium: AppTextStyles.label2Medium.copyWith(
          color: colors.labelNormal,
        ),
        labelSmall: AppTextStyles.caption1Regular.copyWith(
          color: colors.labelNormal,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primaryNormal,
          foregroundColor: AppColor.staticLabelWhiteStrong,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.lgBorder),
          textStyle: AppTextStyles.headline1Bold,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.labelNormal,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.lgBorder),
          side: BorderSide(color: colors.lineNormalNormal),
          textStyle: AppTextStyles.headline1Bold,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.primaryNormal,
          textStyle: AppTextStyles.label1NormalMedium,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.componentFillNormal,
        border: OutlineInputBorder(
          borderRadius: AppRadius.lgBorder,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.lgBorder,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.lgBorder,
          borderSide: BorderSide(color: colors.primaryNormal, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.lgBorder,
          borderSide: BorderSide(color: colors.statusNegative, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.primaryNormal;
          }
          return AppColor.transparent;
        }),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.xsBorder),
      ),
      dividerTheme: DividerThemeData(
        color: colors.lineNormalNeutral,
        thickness: 1,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.backgroundElevatedNormal,
        modalBackgroundColor: colors.backgroundElevatedNormal,
        surfaceTintColor: AppColor.transparent,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colors.backgroundElevatedNormal,
        surfaceTintColor: AppColor.transparent,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colors.backgroundNormalNormal,
        selectedItemColor: colors.primaryNormal,
        unselectedItemColor: colors.labelAssistive,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: AppTextStyles.caption1Medium,
        unselectedLabelStyle: AppTextStyles.caption1Regular,
      ),
      // 다크에서 splash/highlight 가 라이트 기본값으로 남지 않도록 명시
      splashColor: isDark
          ? AppColor.colorGlobalCommon100.withValues(alpha: 0.06)
          : null,
      highlightColor: isDark
          ? AppColor.colorGlobalCommon100.withValues(alpha: 0.04)
          : null,
    );
  }
}
