import 'package:flutter/material.dart';

/// Spacing 토큰 — Figma 디자인 시스템 기준.
///
/// 2계층 구조:
/// - **Palette** (`space{N}`): 원시 값. Figma JSON `Spacing` 13단계 + Phase 1-C 갭 분석 신규 3단계 (`space0`, `space28`, `space56`).
/// - **Semantic**: 의미 토큰. Palette를 참조해 사용 의도 명시.
class AppSpacing {
  AppSpacing._();

  // ═══════════════════════════════════════════════════════════════
  // PALETTE
  // ═══════════════════════════════════════════════════════════════

  /// 0px — zero padding 명시 (Phase 1-C 신규)
  static const double space0 = 0.0;

  /// 4px
  static const double space4 = 4.0;

  /// 8px — Figma `Spacing.Button.hor`
  static const double space8 = 8.0;

  /// 12px — Figma `Spacing.12 (Item Space)` / `Spacing.Button.ver`
  static const double space12 = 12.0;

  /// 14px — Safe Area Bottom (Android)
  static const double space14 = 14.0;

  /// 16px — Figma `Spacing.16 (Text Contents space)` / `Padding.Box in Box`
  static const double space16 = 16.0;

  /// 20px
  static const double space20 = 20.0;

  /// 24px — Figma `Padding.Contents in Box`
  static const double space24 = 24.0;

  /// 28px — Phase 1-C 신규 (button bottom / GNB logo off-scale 통합)
  static const double space28 = 28.0;

  /// 32px
  static const double space32 = 32.0;

  /// 34px — Safe Area Bottom (iOS)
  static const double space34 = 34.0;

  /// 36px — Safe Area Status (Android)
  static const double space36 = 36.0;

  /// 40px
  static const double space40 = 40.0;

  /// 44px — Safe Area Status (iOS)
  static const double space44 = 44.0;

  /// 48px
  static const double space48 = 48.0;

  /// 56px — Phase 1-C 신규 (banner off-scale 통합)
  static const double space56 = 56.0;

  // ═══════════════════════════════════════════════════════════════
  // SEMANTIC
  // ═══════════════════════════════════════════════════════════════

  // ── Container / Box Padding ────────────────────────────────────
  static const double containerVerticalPadding = space32;
  static const double containerHorizontalPadding = space24;
  static const double inBoxTopPadding = space16;
  static const double bottomAfterBox = space16;
  static const double bottomAfterText = space32;

  // ── 요소 간 간격 ──────────────────────────────────────────────
  static const double itemSpacing = space12;
  static const double textContentsSpacing = space16;
  static const double textToBoxSpacing = space16;
  static const double betweenBoxesSpacing = space20;

  // ── Padding 카테고리 ──────────────────────────────────────────
  static const double paddingContentsInBox = space24;
  static const double paddingBoxInBox = space16;
  static const double paddingContentsInBoxSmall = space8;

  // ── Button ─────────────────────────────────────────────────────
  static const double buttonPaddingHorizontal = space8;
  static const double buttonPaddingVertical = space12;

  // ── Safe Area (디자이너 시안 기준값) ────────────────────────────
  static const double safeAreaStatusIos = space44;
  static const double safeAreaStatusAndroid = space36;
  static const double safeAreaStatusWeb = 0;
  static const double safeAreaBottomIos = space34;
  static const double safeAreaBottomAndroid = space14;
  static const double safeAreaBottomWeb = 0;

  // ═══════════════════════════════════════════════════════════════
  // EDGE INSETS HELPERS
  // ═══════════════════════════════════════════════════════════════

  static EdgeInsets all(double value) => EdgeInsets.all(value);
  static EdgeInsets horizontal(double value) =>
      EdgeInsets.symmetric(horizontal: value);
  static EdgeInsets vertical(double value) =>
      EdgeInsets.symmetric(vertical: value);
  static EdgeInsets symmetric({double h = 0, double v = 0}) =>
      EdgeInsets.symmetric(horizontal: h, vertical: v);

  static const EdgeInsets containerPadding = EdgeInsets.symmetric(
    horizontal: space24,
    vertical: space32,
  );

  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: space8,
    vertical: space12,
  );
}
