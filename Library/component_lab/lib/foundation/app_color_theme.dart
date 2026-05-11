import 'package:flutter/material.dart';

import 'app_color.dart';

/// 다크/라이트 시맨틱 컬러 토큰을 한 곳에서 노출하는 [ThemeExtension].
///
/// 위젯에서:
/// ```dart
/// final c = Theme.of(context).extension<AppColorTheme>()!;
/// Container(color: c.labelNormal);
/// ```
///
/// 이 방식은 위젯 코드의 다음 패턴을 제거한다:
/// ```dart
/// final isDark = Theme.of(context).brightness == Brightness.dark;
/// final fg = isDark ? AppColor.darkLabelNormal : AppColor.labelNormal;
/// ```
class AppColorTheme extends ThemeExtension<AppColorTheme> {
  const AppColorTheme({
    required this.labelNormal,
    required this.labelStrong,
    required this.labelNeutral,
    required this.labelAlternative,
    required this.labelAssistive,
    required this.labelDisable,
    required this.backgroundNormalNormal,
    required this.backgroundElevatedNormal,
    required this.componentFillNormal,
    required this.componentFillStrong,
    required this.componentFillAlternative,
    required this.componentMaterialDimmer,
    required this.interactionDisable,
    required this.inverseBackground,
    required this.inverseLabelNormal,
    required this.lineNormalNormal,
    required this.lineNormalNeutral,
    required this.lineNormalAlternative,
    required this.lineSolidNormal,
    required this.primaryNormal,
    required this.primaryLight,
    required this.statusNegative,
    required this.accentBackgroundBrown,
    required this.accentForegroundRed,
    required this.accentForegroundOrange,
    required this.accentForegroundYellow,
    required this.accentForegroundLime,
    required this.accentForegroundGreen,
    required this.accentForegroundCyan,
    required this.accentForegroundLightBlue,
    required this.accentForegroundBlue,
    required this.accentForegroundViolet,
    required this.accentForegroundPink,
  });

  // ── Label
  final Color labelNormal;
  final Color labelStrong;
  final Color labelNeutral;
  final Color labelAlternative;
  final Color labelAssistive;
  final Color labelDisable;

  // ── Background
  final Color backgroundNormalNormal;
  final Color backgroundElevatedNormal;

  // ── Component fill
  final Color componentFillNormal;
  final Color componentFillStrong;
  final Color componentFillAlternative;
  final Color componentMaterialDimmer;

  // ── Interaction
  final Color interactionDisable;

  // ── Inverse
  final Color inverseBackground;
  final Color inverseLabelNormal;

  // ── Line
  final Color lineNormalNormal;
  final Color lineNormalNeutral;
  final Color lineNormalAlternative;
  final Color lineSolidNormal;

  // ── Primary
  final Color primaryNormal;
  final Color primaryLight;

  // ── Status
  final Color statusNegative;

  // ── Accent (foreground 위주 + brown background)
  final Color accentBackgroundBrown;
  final Color accentForegroundRed;
  final Color accentForegroundOrange;
  final Color accentForegroundYellow;
  final Color accentForegroundLime;
  final Color accentForegroundGreen;
  final Color accentForegroundCyan;
  final Color accentForegroundLightBlue;
  final Color accentForegroundBlue;
  final Color accentForegroundViolet;
  final Color accentForegroundPink;

  /// Light brightness용 인스턴스.
  static final AppColorTheme light = AppColorTheme(
    labelNormal: AppColor.labelNormal,
    labelStrong: AppColor.labelStrong,
    labelNeutral: AppColor.labelNeutral,
    labelAlternative: AppColor.labelAlternative,
    labelAssistive: AppColor.labelAssistive,
    labelDisable: AppColor.labelDisable,
    backgroundNormalNormal: AppColor.backgroundNormalNormal,
    backgroundElevatedNormal: AppColor.backgroundElevatedNormal,
    componentFillNormal: AppColor.componentFillNormal,
    componentFillStrong: AppColor.componentFillStrong,
    componentFillAlternative: AppColor.componentFillAlternative,
    componentMaterialDimmer: AppColor.componentMaterialDimmer,
    interactionDisable: AppColor.interactionDisable,
    inverseBackground: AppColor.inverseBackground,
    inverseLabelNormal: AppColor.inverseLabelNormal,
    lineNormalNormal: AppColor.lineNormalNormal,
    lineNormalNeutral: AppColor.lineNormalNeutral,
    lineNormalAlternative: AppColor.lineNormalAlternative,
    lineSolidNormal: AppColor.lineSolidNormal,
    primaryNormal: AppColor.primaryNormal,
    primaryLight: AppColor.primaryLight,
    statusNegative: AppColor.statusNegative,
    accentBackgroundBrown: AppColor.accentBackgroundBrown,
    accentForegroundRed: AppColor.accentForegroundRed,
    accentForegroundOrange: AppColor.accentForegroundOrange,
    accentForegroundYellow: AppColor.accentForegroundYellow,
    accentForegroundLime: AppColor.accentForegroundLime,
    accentForegroundGreen: AppColor.accentForegroundGreen,
    accentForegroundCyan: AppColor.accentForegroundCyan,
    accentForegroundLightBlue: AppColor.accentForegroundLightBlue,
    accentForegroundBlue: AppColor.accentForegroundBlue,
    accentForegroundViolet: AppColor.accentForegroundViolet,
    accentForegroundPink: AppColor.accentForegroundPink,
  );

  /// Dark brightness용 인스턴스.
  static final AppColorTheme dark = AppColorTheme(
    labelNormal: AppColor.darkLabelNormal,
    labelStrong: AppColor.darkLabelStrong,
    labelNeutral: AppColor.darkLabelNeutral,
    labelAlternative: AppColor.darkLabelAlternative,
    labelAssistive: AppColor.darkLabelAssistive,
    labelDisable: AppColor.darkLabelDisable,
    backgroundNormalNormal: AppColor.darkBackgroundNormalNormal,
    backgroundElevatedNormal: AppColor.darkBackgroundElevatedNormal,
    componentFillNormal: AppColor.darkComponentFillNormal,
    componentFillStrong: AppColor.darkComponentFillStrong,
    componentFillAlternative: AppColor.darkComponentFillAlternative,
    componentMaterialDimmer: AppColor.darkComponentMaterialDimmer,
    interactionDisable: AppColor.darkInteractionDisable,
    inverseBackground: AppColor.darkInverseBackground,
    inverseLabelNormal: AppColor.darkInverseLabelNormal,
    lineNormalNormal: AppColor.darkLineNormalNormal,
    lineNormalNeutral: AppColor.darkLineNormalNeutral,
    lineNormalAlternative: AppColor.darkLineNormalAlternative,
    lineSolidNormal: AppColor.darkLineSolidNormal,
    primaryNormal: AppColor.darkPrimaryNormal,
    primaryLight: AppColor.darkPrimaryLight,
    statusNegative: AppColor.darkStatusNegative,
    accentBackgroundBrown: AppColor.darkAccentBackgroundBrown,
    accentForegroundRed: AppColor.darkAccentForegroundRed,
    accentForegroundOrange: AppColor.darkAccentForegroundOrange,
    accentForegroundYellow: AppColor.darkAccentForegroundYellow,
    accentForegroundLime: AppColor.darkAccentForegroundLime,
    accentForegroundGreen: AppColor.darkAccentForegroundGreen,
    accentForegroundCyan: AppColor.darkAccentForegroundCyan,
    accentForegroundLightBlue: AppColor.darkAccentForegroundLightBlue,
    accentForegroundBlue: AppColor.darkAccentForegroundBlue,
    accentForegroundViolet: AppColor.darkAccentForegroundViolet,
    accentForegroundPink: AppColor.darkAccentForegroundPink,
  );

  @override
  AppColorTheme copyWith({
    Color? labelNormal,
    Color? labelStrong,
    Color? labelNeutral,
    Color? labelAlternative,
    Color? labelAssistive,
    Color? labelDisable,
    Color? backgroundNormalNormal,
    Color? backgroundElevatedNormal,
    Color? componentFillNormal,
    Color? componentFillStrong,
    Color? componentFillAlternative,
    Color? componentMaterialDimmer,
    Color? interactionDisable,
    Color? inverseBackground,
    Color? inverseLabelNormal,
    Color? lineNormalNormal,
    Color? lineNormalNeutral,
    Color? lineNormalAlternative,
    Color? lineSolidNormal,
    Color? primaryNormal,
    Color? primaryLight,
    Color? statusNegative,
    Color? accentBackgroundBrown,
    Color? accentForegroundRed,
    Color? accentForegroundOrange,
    Color? accentForegroundYellow,
    Color? accentForegroundLime,
    Color? accentForegroundGreen,
    Color? accentForegroundCyan,
    Color? accentForegroundLightBlue,
    Color? accentForegroundBlue,
    Color? accentForegroundViolet,
    Color? accentForegroundPink,
  }) {
    return AppColorTheme(
      labelNormal: labelNormal ?? this.labelNormal,
      labelStrong: labelStrong ?? this.labelStrong,
      labelNeutral: labelNeutral ?? this.labelNeutral,
      labelAlternative: labelAlternative ?? this.labelAlternative,
      labelAssistive: labelAssistive ?? this.labelAssistive,
      labelDisable: labelDisable ?? this.labelDisable,
      backgroundNormalNormal:
          backgroundNormalNormal ?? this.backgroundNormalNormal,
      backgroundElevatedNormal:
          backgroundElevatedNormal ?? this.backgroundElevatedNormal,
      componentFillNormal: componentFillNormal ?? this.componentFillNormal,
      componentFillStrong: componentFillStrong ?? this.componentFillStrong,
      componentFillAlternative:
          componentFillAlternative ?? this.componentFillAlternative,
      componentMaterialDimmer:
          componentMaterialDimmer ?? this.componentMaterialDimmer,
      interactionDisable: interactionDisable ?? this.interactionDisable,
      inverseBackground: inverseBackground ?? this.inverseBackground,
      inverseLabelNormal: inverseLabelNormal ?? this.inverseLabelNormal,
      lineNormalNormal: lineNormalNormal ?? this.lineNormalNormal,
      lineNormalNeutral: lineNormalNeutral ?? this.lineNormalNeutral,
      lineNormalAlternative:
          lineNormalAlternative ?? this.lineNormalAlternative,
      lineSolidNormal: lineSolidNormal ?? this.lineSolidNormal,
      primaryNormal: primaryNormal ?? this.primaryNormal,
      primaryLight: primaryLight ?? this.primaryLight,
      statusNegative: statusNegative ?? this.statusNegative,
      accentBackgroundBrown:
          accentBackgroundBrown ?? this.accentBackgroundBrown,
      accentForegroundRed: accentForegroundRed ?? this.accentForegroundRed,
      accentForegroundOrange:
          accentForegroundOrange ?? this.accentForegroundOrange,
      accentForegroundYellow:
          accentForegroundYellow ?? this.accentForegroundYellow,
      accentForegroundLime: accentForegroundLime ?? this.accentForegroundLime,
      accentForegroundGreen:
          accentForegroundGreen ?? this.accentForegroundGreen,
      accentForegroundCyan: accentForegroundCyan ?? this.accentForegroundCyan,
      accentForegroundLightBlue:
          accentForegroundLightBlue ?? this.accentForegroundLightBlue,
      accentForegroundBlue: accentForegroundBlue ?? this.accentForegroundBlue,
      accentForegroundViolet:
          accentForegroundViolet ?? this.accentForegroundViolet,
      accentForegroundPink: accentForegroundPink ?? this.accentForegroundPink,
    );
  }

  @override
  AppColorTheme lerp(ThemeExtension<AppColorTheme>? other, double t) {
    if (other is! AppColorTheme) return this;
    return AppColorTheme(
      labelNormal: Color.lerp(labelNormal, other.labelNormal, t)!,
      labelStrong: Color.lerp(labelStrong, other.labelStrong, t)!,
      labelNeutral: Color.lerp(labelNeutral, other.labelNeutral, t)!,
      labelAlternative:
          Color.lerp(labelAlternative, other.labelAlternative, t)!,
      labelAssistive: Color.lerp(labelAssistive, other.labelAssistive, t)!,
      labelDisable: Color.lerp(labelDisable, other.labelDisable, t)!,
      backgroundNormalNormal: Color.lerp(
          backgroundNormalNormal, other.backgroundNormalNormal, t)!,
      backgroundElevatedNormal: Color.lerp(
          backgroundElevatedNormal, other.backgroundElevatedNormal, t)!,
      componentFillNormal:
          Color.lerp(componentFillNormal, other.componentFillNormal, t)!,
      componentFillStrong:
          Color.lerp(componentFillStrong, other.componentFillStrong, t)!,
      componentFillAlternative: Color.lerp(
          componentFillAlternative, other.componentFillAlternative, t)!,
      componentMaterialDimmer: Color.lerp(
          componentMaterialDimmer, other.componentMaterialDimmer, t)!,
      interactionDisable:
          Color.lerp(interactionDisable, other.interactionDisable, t)!,
      inverseBackground:
          Color.lerp(inverseBackground, other.inverseBackground, t)!,
      inverseLabelNormal:
          Color.lerp(inverseLabelNormal, other.inverseLabelNormal, t)!,
      lineNormalNormal:
          Color.lerp(lineNormalNormal, other.lineNormalNormal, t)!,
      lineNormalNeutral:
          Color.lerp(lineNormalNeutral, other.lineNormalNeutral, t)!,
      lineNormalAlternative:
          Color.lerp(lineNormalAlternative, other.lineNormalAlternative, t)!,
      lineSolidNormal: Color.lerp(lineSolidNormal, other.lineSolidNormal, t)!,
      primaryNormal: Color.lerp(primaryNormal, other.primaryNormal, t)!,
      primaryLight: Color.lerp(primaryLight, other.primaryLight, t)!,
      statusNegative: Color.lerp(statusNegative, other.statusNegative, t)!,
      accentBackgroundBrown:
          Color.lerp(accentBackgroundBrown, other.accentBackgroundBrown, t)!,
      accentForegroundRed:
          Color.lerp(accentForegroundRed, other.accentForegroundRed, t)!,
      accentForegroundOrange: Color.lerp(
          accentForegroundOrange, other.accentForegroundOrange, t)!,
      accentForegroundYellow: Color.lerp(
          accentForegroundYellow, other.accentForegroundYellow, t)!,
      accentForegroundLime:
          Color.lerp(accentForegroundLime, other.accentForegroundLime, t)!,
      accentForegroundGreen:
          Color.lerp(accentForegroundGreen, other.accentForegroundGreen, t)!,
      accentForegroundCyan:
          Color.lerp(accentForegroundCyan, other.accentForegroundCyan, t)!,
      accentForegroundLightBlue: Color.lerp(
          accentForegroundLightBlue, other.accentForegroundLightBlue, t)!,
      accentForegroundBlue:
          Color.lerp(accentForegroundBlue, other.accentForegroundBlue, t)!,
      accentForegroundViolet: Color.lerp(
          accentForegroundViolet, other.accentForegroundViolet, t)!,
      accentForegroundPink:
          Color.lerp(accentForegroundPink, other.accentForegroundPink, t)!,
    );
  }
}

/// `Theme.of(context).extension<AppColorTheme>()!` 의 syntactic sugar.
extension AppColorThemeContextExt on BuildContext {
  /// 시맨틱 컬러 토큰 (브라이트니스 자동 분기).
  AppColorTheme get appColors => Theme.of(this).extension<AppColorTheme>()!;
}
