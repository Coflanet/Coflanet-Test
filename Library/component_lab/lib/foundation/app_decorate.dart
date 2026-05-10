import 'package:flutter/material.dart';

/// Decorate 토큰 — Figma 💅 Decorate 페이지 기준.
///
/// 포함 항목:
/// - **Interaction**: 터치/호버 상태 오버레이 (Normal · Light · Strong)
/// - **Dimmer**: 모달 배경 딤 처리
///
/// Shadow, Opacity는 별도 파일(app_shadow.dart, AppColor)에 정의.
class AppDecorate {
  AppDecorate._();

  // ═══════════════════════════════════════════════════════════════
  // BASE COLOR — 인터랙션 오버레이 기본 컬러
  // CoolNeutral10: rgba(23, 23, 25, 1)
  // ═══════════════════════════════════════════════════════════════
  static const Color _interactionBase = Color(0xFF171719);

  // ═══════════════════════════════════════════════════════════════
  // INTERACTION / NORMAL — 기본 강도
  // ═══════════════════════════════════════════════════════════════

  /// Normal - Normal 상태 (투명)
  static const Color interactionNormalNormal = Color(0x00171719);

  /// Normal - Hovered 상태 (5%)
  static const Color interactionNormalHovered = Color(0x0D171719);

  /// Normal - Focused 상태 (8%)
  static const Color interactionNormalFocused = Color(0x14171719);

  /// Normal - Pressed 상태 (12%)
  static const Color interactionNormalPressed = Color(0x1F171719);

  /// Normal 강도의 상태별 opacity 값
  static const double interactionNormalHoveredOpacity = 0.05;
  static const double interactionNormalFocusedOpacity = 0.08;
  static const double interactionNormalPressedOpacity = 0.12;

  // ═══════════════════════════════════════════════════════════════
  // INTERACTION / LIGHT — 약한 강도
  // ═══════════════════════════════════════════════════════════════

  /// Light - Normal 상태 (투명)
  static const Color interactionLightNormal = Color(0x00171719);

  /// Light - Hovered 상태 (3.75%)
  static const Color interactionLightHovered = Color(0x0A171719);

  /// Light - Focused 상태 (6%)
  static const Color interactionLightFocused = Color(0x0F171719);

  /// Light - Pressed 상태 (9%)
  static const Color interactionLightPressed = Color(0x17171719);

  /// Light 강도의 상태별 opacity 값
  static const double interactionLightHoveredOpacity = 0.0375;
  static const double interactionLightFocusedOpacity = 0.06;
  static const double interactionLightPressedOpacity = 0.09;

  // ═══════════════════════════════════════════════════════════════
  // INTERACTION / STRONG — 강한 강도
  // ═══════════════════════════════════════════════════════════════

  /// Strong - Normal 상태 (투명)
  static const Color interactionStrongNormal = Color(0x00171719);

  /// Strong - Hovered 상태 (7.5%)
  static const Color interactionStrongHovered = Color(0x13171719);

  /// Strong - Focused 상태 (12%)
  static const Color interactionStrongFocused = Color(0x1F171719);

  /// Strong - Pressed 상태 (18%)
  static const Color interactionStrongPressed = Color(0x2E171719);

  /// Strong 강도의 상태별 opacity 값
  static const double interactionStrongHoveredOpacity = 0.075;
  static const double interactionStrongFocusedOpacity = 0.12;
  static const double interactionStrongPressedOpacity = 0.18;

  // ═══════════════════════════════════════════════════════════════
  // INTERACTION — 편의 메서드
  // ═══════════════════════════════════════════════════════════════

  /// 인터랙션 오버레이 색상을 반환합니다.
  ///
  /// [intensity]: `normal`, `light`, `strong`
  /// [state]: `normal`, `hovered`, `focused`, `pressed`
  static Color interactionColor({
    InteractionIntensity intensity = InteractionIntensity.normal,
    InteractionState state = InteractionState.normal,
  }) {
    final opacity = _interactionOpacityMap[intensity]![state]!;
    return _interactionBase.withValues(alpha: opacity);
  }

  static const Map<InteractionIntensity, Map<InteractionState, double>>
      _interactionOpacityMap = {
    InteractionIntensity.normal: {
      InteractionState.normal: 0.0,
      InteractionState.hovered: 0.05,
      InteractionState.focused: 0.08,
      InteractionState.pressed: 0.12,
    },
    InteractionIntensity.light: {
      InteractionState.normal: 0.0,
      InteractionState.hovered: 0.0375,
      InteractionState.focused: 0.06,
      InteractionState.pressed: 0.09,
    },
    InteractionIntensity.strong: {
      InteractionState.normal: 0.0,
      InteractionState.hovered: 0.075,
      InteractionState.focused: 0.12,
      InteractionState.pressed: 0.18,
    },
  };

  // ═══════════════════════════════════════════════════════════════
  // DIMMER — 모달/바텀시트 배경 딤 처리
  // CoolNeutral10 @ 52% opacity
  // ═══════════════════════════════════════════════════════════════

  /// Dimmer 색상 — rgba(23, 23, 25, 0.52)
  static const Color dimmer = Color(0x85171719);

  /// Dimmer opacity 값
  static const double dimmerOpacity = 0.52;

  /// Dimmer 색상을 커스텀 opacity로 생성합니다.
  static Color dimmerWithOpacity(double opacity) =>
      _interactionBase.withValues(alpha: opacity);
}

/// 인터랙션 강도
enum InteractionIntensity {
  /// 기본 강도 (5% / 8% / 12%)
  normal,

  /// 약한 강도 (3.75% / 6% / 9%)
  light,

  /// 강한 강도 (7.5% / 12% / 18%)
  strong,
}

/// 인터랙션 상태
enum InteractionState {
  /// 기본 상태 (투명)
  normal,

  /// 마우스 호버 상태
  hovered,

  /// 포커스 상태
  focused,

  /// 눌린 상태
  pressed,
}
