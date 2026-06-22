import 'package:flutter/material.dart';

import 'package:coflanet/constants/color_constant.dart';

/// 라이트/다크 테마별 시맨틱 컬러 스킴.
///
/// 화면/위젯에서는 정적 `AppColor.시맨틱토큰` 대신 반드시 이 스킴을 통해
/// 색을 읽는다. `Theme.of(context)` 의존성이 생기므로 테마 전환 시
/// 자동으로 리빌드된다.
///
/// 사용:
/// ```dart
/// final colors = AppColorScheme.of(context);
/// Container(color: colors.backgroundNormalNormal);
/// ```
///
/// 값 출처:
/// - 라이트: 기존 `AppColor` 라이트 시맨틱 토큰과 동일
/// - 다크: Figma 다크 시안(홈 탭, 원두 상세/편집, 커피 설정)에서 실제
///   사용된 색 기준으로 보정 (배경 = 순검정, 카드 = coolNeutral15 등)
class AppColorScheme {
  // ===== Primary =====
  final Color primaryNormal;
  final Color primarySecondary;
  final Color primaryStrong;
  final Color primaryHeavy;
  final Color primaryLight;

  // ===== Label =====
  final Color labelNormal;
  final Color labelStrong;
  final Color labelNeutral;
  final Color labelAlternative;
  final Color labelAssistive;
  final Color labelDisable;

  // ===== Background =====
  final Color backgroundNormalNormal;
  final Color backgroundNormalAlternative;
  final Color backgroundElevatedNormal;
  final Color backgroundElevatedAlternative;
  final Color backgroundOpacity75;

  // ===== Surface (카드/섹션 — Figma 다크 시안의 coolNeutral15 카드 대응) =====
  final Color surfaceCard;
  final Color surfaceCardStrong;

  // ===== Interaction =====
  final Color interactionInactive;
  final Color interactionDisable;

  // ===== Line =====
  final Color lineNormalNormal;
  final Color lineNormalNeutral;
  final Color lineNormalAlternative;
  final Color lineSolidNormal;
  final Color lineSolidNeutral;
  final Color lineSolidAlternative;

  // ===== Status =====
  final Color statusPositive;
  final Color statusPositiveBlue;
  final Color statusCautionary;
  final Color statusNegative;

  // ===== Component =====
  final Color componentFillNormal;
  final Color componentFillStrong;
  final Color componentFillAlternative;
  final Color componentFillScroll;
  final Color componentMaterialDimmer;

  // ===== Inverse (현재 테마의 반대 톤) =====
  final Color inversePrimary;
  final Color inverseBackground;
  final Color inverseLabelNormal;
  final Color inverseLabelStrong;
  final Color inverseLabelNeutral;
  final Color inverseLabelAlternative;
  final Color inverseLabelAssistive;
  final Color inverseLabelDisable;

  const AppColorScheme({
    required this.primaryNormal,
    required this.primarySecondary,
    required this.primaryStrong,
    required this.primaryHeavy,
    required this.primaryLight,
    required this.labelNormal,
    required this.labelStrong,
    required this.labelNeutral,
    required this.labelAlternative,
    required this.labelAssistive,
    required this.labelDisable,
    required this.backgroundNormalNormal,
    required this.backgroundNormalAlternative,
    required this.backgroundElevatedNormal,
    required this.backgroundElevatedAlternative,
    required this.backgroundOpacity75,
    required this.surfaceCard,
    required this.surfaceCardStrong,
    required this.interactionInactive,
    required this.interactionDisable,
    required this.lineNormalNormal,
    required this.lineNormalNeutral,
    required this.lineNormalAlternative,
    required this.lineSolidNormal,
    required this.lineSolidNeutral,
    required this.lineSolidAlternative,
    required this.statusPositive,
    required this.statusPositiveBlue,
    required this.statusCautionary,
    required this.statusNegative,
    required this.componentFillNormal,
    required this.componentFillStrong,
    required this.componentFillAlternative,
    required this.componentFillScroll,
    required this.componentMaterialDimmer,
    required this.inversePrimary,
    required this.inverseBackground,
    required this.inverseLabelNormal,
    required this.inverseLabelStrong,
    required this.inverseLabelNeutral,
    required this.inverseLabelAlternative,
    required this.inverseLabelAssistive,
    required this.inverseLabelDisable,
  });

  /// 현재 테마 brightness 에 맞는 스킴 반환.
  /// Theme 의존성이 생기므로 테마 전환 시 호출 위젯이 자동 리빌드된다.
  static AppColorScheme of(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? dark : light;
  }

  /// 검정 캔버스(카드 밖: 헤더·섹션타이틀·캔버스 위 텍스트/아이콘)용 스킴.
  /// task 4 방향 B — 캔버스는 라이트/다크 모두 검정이므로 어두운 표면용으로
  /// 설계된 다크 스킴을 그대로 쓴다. 카드 안은 `of(context)`(활성 스킴).
  static AppColorScheme get canvas => dark;

  /// 라이트 스킴 — 기존 AppColor 라이트 시맨틱 토큰과 동일 값
  static final AppColorScheme light = AppColorScheme(
    primaryNormal: AppColor.colorGlobalViolet50,
    primarySecondary: AppColor.colorGlobalViolet70,
    primaryStrong: AppColor.colorGlobalViolet45,
    primaryHeavy: AppColor.colorGlobalViolet40,
    primaryLight: AppColor.colorGlobalViolet95,
    labelNormal: AppColor.colorGlobalCoolNeutral10,
    labelStrong: AppColor.colorGlobalCommon0,
    labelNeutral: const Color(0xFF2E2F33).withValues(alpha: 0.88),
    labelAlternative: const Color(0xFF37383C).withValues(alpha: 0.61),
    labelAssistive: const Color(0xFF37383C).withValues(alpha: 0.35),
    labelDisable: const Color(0xFF37383C).withValues(alpha: 0.16),
    backgroundNormalNormal: AppColor.colorGlobalCommon100,
    backgroundNormalAlternative: AppColor.colorGlobalCoolNeutral99,
    backgroundElevatedNormal: AppColor.colorGlobalCommon100,
    backgroundElevatedAlternative: AppColor.colorGlobalCoolNeutral99,
    backgroundOpacity75: const Color(0xFFFFFFFF).withValues(alpha: 0.75),
    surfaceCard: AppColor.colorGlobalCommon100,
    surfaceCardStrong: AppColor.colorGlobalCoolNeutral98,
    interactionInactive: AppColor.colorGlobalCoolNeutral70,
    interactionDisable: const Color(0xFFF4F4F5).withValues(alpha: 0.5),
    lineNormalNormal: const Color(0xFF70737C).withValues(alpha: 0.22),
    lineNormalNeutral: const Color(0xFF70737C).withValues(alpha: 0.16),
    lineNormalAlternative: const Color(0xFF70737C).withValues(alpha: 0.08),
    lineSolidNormal: AppColor.colorGlobalCoolNeutral96,
    lineSolidNeutral: AppColor.colorGlobalCoolNeutral97,
    lineSolidAlternative: AppColor.colorGlobalCoolNeutral98,
    statusPositive: AppColor.colorGlobalGreen50,
    statusPositiveBlue: AppColor.colorGlobalBlue50,
    statusCautionary: AppColor.colorGlobalOrange50,
    statusNegative: AppColor.colorGlobalRed50,
    componentFillNormal: const Color(0xFF70737C).withValues(alpha: 0.08),
    componentFillStrong: const Color(0xFF70737C).withValues(alpha: 0.16),
    componentFillAlternative: const Color(0xFF70737C).withValues(alpha: 0.05),
    componentFillScroll: const Color(0xFF4D4D4D).withValues(alpha: 0.6),
    componentMaterialDimmer: const Color(0xFF171719).withValues(alpha: 0.52),
    inversePrimary: AppColor.colorGlobalViolet60,
    inverseBackground: AppColor.colorGlobalCoolNeutral15,
    inverseLabelNormal: AppColor.colorGlobalCoolNeutral99,
    inverseLabelStrong: AppColor.colorGlobalCommon100,
    inverseLabelNeutral: const Color(0xFFC2C4C8).withValues(alpha: 0.88),
    inverseLabelAlternative: const Color(0xFFAEB0B6).withValues(alpha: 0.61),
    inverseLabelAssistive: const Color(0xFFAEB0B6).withValues(alpha: 0.35),
    inverseLabelDisable: const Color(0xFF989BA2).withValues(alpha: 0.16),
  );

  /// 다크 스킴 — Figma 다크 시안(홈/원두 상세) 기준
  /// 배경: 순검정(common0), 카드/섹션: coolNeutral15, 강조 카드: coolNeutral20
  static final AppColorScheme dark = AppColorScheme(
    primaryNormal: AppColor.colorGlobalViolet60,
    primarySecondary: AppColor.colorGlobalViolet70,
    primaryStrong: AppColor.colorGlobalViolet55,
    primaryHeavy: AppColor.colorGlobalViolet50,
    // 연보라 틴트 배경 — violet20 솔리드는 위의 보라/회색 텍스트가 묻혀서
    // 반투명 틴트로 사용 (어두운 배경 위에서 은은한 보라 + 텍스트 대비 확보)
    primaryLight: AppColor.colorGlobalViolet60.withValues(alpha: 0.2),
    labelNormal: AppColor.colorGlobalCoolNeutral99,
    labelStrong: AppColor.colorGlobalCommon100,
    labelNeutral: const Color(0xFFC2C4C8).withValues(alpha: 0.88),
    labelAlternative: const Color(0xFFAEB0B6).withValues(alpha: 0.61),
    labelAssistive: const Color(0xFFAEB0B6).withValues(alpha: 0.35),
    labelDisable: const Color(0xFF989BA2).withValues(alpha: 0.16),
    backgroundNormalNormal: AppColor.colorGlobalCommon0,
    // Figma 다크 시안(홈/셸)의 페이지 배경이 순검정이므로 alternative 도 검정
    backgroundNormalAlternative: AppColor.colorGlobalCommon0,
    // 모달/다이얼로그 표면 — 순검정 페이지 + 딤 위에서 카드 윤곽이 보이도록
    // cn15/17 보다 한 단계 밝은 값 사용 (다크 다이얼로그 대비 확보)
    backgroundElevatedNormal: AppColor.colorGlobalCoolNeutral22,
    backgroundElevatedAlternative: AppColor.colorGlobalCoolNeutral20,
    backgroundOpacity75: const Color(0xFF000000).withValues(alpha: 0.75),
    surfaceCard: AppColor.colorGlobalCoolNeutral15,
    surfaceCardStrong: AppColor.colorGlobalCoolNeutral20,
    interactionInactive: AppColor.colorGlobalCoolNeutral40,
    interactionDisable: const Color(0xFF2E2F33).withValues(alpha: 0.5),
    lineNormalNormal: const Color(0xFF70737C).withValues(alpha: 0.32),
    lineNormalNeutral: const Color(0xFF70737C).withValues(alpha: 0.28),
    lineNormalAlternative: const Color(0xFF70737C).withValues(alpha: 0.22),
    lineSolidNormal: AppColor.colorGlobalCoolNeutral25,
    lineSolidNeutral: AppColor.colorGlobalCoolNeutral23,
    lineSolidAlternative: AppColor.colorGlobalCoolNeutral22,
    statusPositive: AppColor.colorGlobalGreen60,
    statusPositiveBlue: AppColor.colorGlobalBlue60,
    statusCautionary: AppColor.colorGlobalOrange60,
    statusNegative: AppColor.colorGlobalRed60,
    componentFillNormal: const Color(0xFF70737C).withValues(alpha: 0.22),
    componentFillStrong: const Color(0xFF70737C).withValues(alpha: 0.28),
    componentFillAlternative: const Color(0xFF70737C).withValues(alpha: 0.12),
    componentFillScroll: const Color(0xFF3E3E3E).withValues(alpha: 0.6),
    componentMaterialDimmer: const Color(0xFF171719).withValues(alpha: 0.74),
    inversePrimary: AppColor.colorGlobalViolet50,
    inverseBackground: AppColor.colorGlobalCoolNeutral99,
    inverseLabelNormal: AppColor.colorGlobalCoolNeutral10,
    inverseLabelStrong: AppColor.colorGlobalCommon0,
    inverseLabelNeutral: const Color(0xFF2E2F33).withValues(alpha: 0.88),
    inverseLabelAlternative: const Color(0xFF37383C).withValues(alpha: 0.61),
    inverseLabelAssistive: const Color(0xFF37383C).withValues(alpha: 0.35),
    inverseLabelDisable: const Color(0xFF37383C).withValues(alpha: 0.16),
  );
}
