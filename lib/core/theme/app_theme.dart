import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';

/// App-wide theme configuration
class AppTheme {
  AppTheme._();

  /// Light theme
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primaryColor: AppColor.primaryNormal,
        scaffoldBackgroundColor: AppColor.backgroundNormalNormal,
        colorScheme: ColorScheme.light(
          primary: AppColor.primaryNormal,
          secondary: AppColor.primarySecondary,
          surface: AppColor.backgroundNormalNormal,
          error: AppColor.statusNegative,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: AppColor.labelNormal,
          onError: Colors.white,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColor.backgroundNormalNormal,
          foregroundColor: AppColor.labelNormal,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: AppTextStyles.headline1Bold.copyWith(
            color: AppColor.labelNormal,
          ),
        ),
        textTheme: const TextTheme(
          displayLarge: AppTextStyles.display1Bold,
          displayMedium: AppTextStyles.display2Bold,
          headlineLarge: AppTextStyles.heading1Bold,
          headlineMedium: AppTextStyles.heading2Bold,
          titleLarge: AppTextStyles.title1Bold,
          titleMedium: AppTextStyles.title2Bold,
          titleSmall: AppTextStyles.title3Bold,
          bodyLarge: AppTextStyles.body1NormalRegular,
          bodyMedium: AppTextStyles.body2NormalRegular,
          labelLarge: AppTextStyles.label1NormalMedium,
          labelMedium: AppTextStyles.label2Medium,
          labelSmall: AppTextStyles.caption1Regular,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.primaryNormal,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: AppTextStyles.headline1Bold,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColor.labelNormal,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            side: BorderSide(color: AppColor.lineNormalNormal),
            textStyle: AppTextStyles.headline1Bold,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColor.primaryNormal,
            textStyle: AppTextStyles.label1NormalMedium,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColor.componentFillNormal,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColor.primaryNormal, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColor.statusNegative, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColor.primaryNormal;
            }
            return Colors.transparent;
          }),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        dividerTheme: DividerThemeData(
          color: AppColor.lineNormalNeutral,
          thickness: 1,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppColor.backgroundNormalNormal,
          selectedItemColor: AppColor.primaryNormal,
          unselectedItemColor: AppColor.labelAssistive,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: AppTextStyles.caption1Medium,
          unselectedLabelStyle: AppTextStyles.caption1Regular,
        ),
      );

  /// Dark theme
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: AppColor.darkPrimaryNormal,
        scaffoldBackgroundColor: AppColor.darkBackgroundNormalNormal,
        colorScheme: ColorScheme.dark(
          primary: AppColor.darkPrimaryNormal,
          secondary: AppColor.darkPrimarySecondary,
          surface: AppColor.darkBackgroundNormalNormal,
          error: AppColor.darkStatusNegative,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: AppColor.darkLabelNormal,
          onError: Colors.white,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColor.darkBackgroundNormalNormal,
          foregroundColor: AppColor.darkLabelNormal,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: AppTextStyles.headline1Bold.copyWith(
            color: AppColor.darkLabelNormal,
          ),
        ),
        textTheme: TextTheme(
          displayLarge: AppTextStyles.display1Bold.copyWith(
            color: AppColor.darkLabelNormal,
          ),
          displayMedium: AppTextStyles.display2Bold.copyWith(
            color: AppColor.darkLabelNormal,
          ),
          headlineLarge: AppTextStyles.heading1Bold.copyWith(
            color: AppColor.darkLabelNormal,
          ),
          headlineMedium: AppTextStyles.heading2Bold.copyWith(
            color: AppColor.darkLabelNormal,
          ),
          titleLarge: AppTextStyles.title1Bold.copyWith(
            color: AppColor.darkLabelNormal,
          ),
          titleMedium: AppTextStyles.title2Bold.copyWith(
            color: AppColor.darkLabelNormal,
          ),
          titleSmall: AppTextStyles.title3Bold.copyWith(
            color: AppColor.darkLabelNormal,
          ),
          bodyLarge: AppTextStyles.body1NormalRegular.copyWith(
            color: AppColor.darkLabelNormal,
          ),
          bodyMedium: AppTextStyles.body2NormalRegular.copyWith(
            color: AppColor.darkLabelNormal,
          ),
          labelLarge: AppTextStyles.label1NormalMedium.copyWith(
            color: AppColor.darkLabelNormal,
          ),
          labelMedium: AppTextStyles.label2Medium.copyWith(
            color: AppColor.darkLabelNormal,
          ),
          labelSmall: AppTextStyles.caption1Regular.copyWith(
            color: AppColor.darkLabelNormal,
          ),
        ),
      );
}
