import 'package:flutter/material.dart';

/// Spacing 토큰 — Figma 디자인 시스템 기준.
///
/// 2-layer 구조:
/// - **Palette** (`AppSpacing.s{N}`) — `docs/spacing-migration/02-tokens/palette.json` 의 원시 px 값.
/// - **Semantic** (`AppSpacingSemantic.{category}{Size}`) — `semantic.json` 의 사용 의도 별칭.
///
/// 신규 코드는 항상 위의 두 API만 사용. 레거시 `AppSpacing.space{N}` 와 시맨틱
/// 단축 상수(`containerVerticalPadding`, `itemSpacing`, …)는 `@Deprecated` 로
/// 표시되어 있으며 Phase 5 에서 호출처를 새 API 로 마이그레이션한 뒤 제거 예정.
class AppSpacing {
  AppSpacing._();

  // ═══════════════════════════════════════════════════════════════
  // PALETTE — palette.json
  // ═══════════════════════════════════════════════════════════════

  /// 0px — explicit zero gap
  static const double s0 = 0.0;

  /// 1px — hairline / 1px border-adjacent padding
  static const double s1 = 1.0;

  /// 2px — sub-pixel grid offset
  static const double s2 = 2.0;

  /// 3px — micro gap
  static const double s3 = 3.0;

  /// 4px — minimum gap (icon-text)
  static const double s4 = 4.0;

  /// 6px — sub-step between 4 and 8
  static const double s6 = 6.0;

  /// 7px — Button small vertical padding
  static const double s7 = 7.0;

  /// 8px — standard small gap (icon-text, chip group)
  static const double s8 = 8.0;

  /// 9px — Button medium vertical padding
  static const double s9 = 9.0;

  /// 10px — sub-step between 8 and 12
  static const double s10 = 10.0;

  /// 12px — Button large vertical / Icon Button standard / list item gap
  static const double s12 = 12.0;

  /// 14px — Button small horizontal padding
  static const double s14 = 14.0;

  /// 16px — card padding, heading-body gap
  static const double s16 = 16.0;

  /// 20px — Button medium horizontal padding / page horizontal padding
  static const double s20 = 20.0;

  /// 24px — section gap, modal padding
  static const double s24 = 24.0;

  /// 28px — Button large horizontal padding
  static const double s28 = 28.0;

  /// 32px — large section gap
  static const double s32 = 32.0;

  /// 40px — layout-level gap
  static const double s40 = 40.0;

  /// 44px — layout-level gap (large)
  static const double s44 = 44.0;

  /// 48px — maximum layout gap
  static const double s48 = 48.0;

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

  // ═══════════════════════════════════════════════════════════════
  // LEGACY PALETTE ALIASES — Phase 5 에서 호출처 마이그레이션 후 제거
  // ═══════════════════════════════════════════════════════════════

  @Deprecated('Use AppSpacing.s0')
  static const double space0 = s0;
  @Deprecated('Use AppSpacing.s4')
  static const double space4 = s4;
  @Deprecated('Use AppSpacing.s8')
  static const double space8 = s8;
  @Deprecated('Use AppSpacing.s12')
  static const double space12 = s12;
  @Deprecated('Use AppSpacing.s14')
  static const double space14 = s14;
  @Deprecated('Use AppSpacing.s16')
  static const double space16 = s16;
  @Deprecated('Use AppSpacing.s20')
  static const double space20 = s20;
  @Deprecated('Use AppSpacing.s24')
  static const double space24 = s24;
  @Deprecated('Use AppSpacing.s28')
  static const double space28 = s28;
  @Deprecated('Use AppSpacing.s32')
  static const double space32 = s32;
  @Deprecated('Off-scale 34px — Phase 5 에서 제거 또는 platform safe-area 모듈로 이동')
  static const double space34 = 34.0;
  @Deprecated('Off-scale 36px — Phase 5 에서 제거 또는 platform safe-area 모듈로 이동')
  static const double space36 = 36.0;
  @Deprecated('Use AppSpacing.s40')
  static const double space40 = s40;
  @Deprecated('Use AppSpacing.s44')
  static const double space44 = s44;
  @Deprecated('Use AppSpacing.s48')
  static const double space48 = s48;
  @Deprecated('Off-scale 56px — Phase 5 에서 제거')
  static const double space56 = 56.0;

  // ═══════════════════════════════════════════════════════════════
  // LEGACY SEMANTIC SHORTCUTS — Phase 5 에서 AppSpacingSemantic 로 교체
  // ═══════════════════════════════════════════════════════════════

  @Deprecated('Use AppSpacingSemantic.layoutMd (s32)')
  static const double containerVerticalPadding = s32;
  @Deprecated('Use AppSpacingSemantic.insetXl (s24)')
  static const double containerHorizontalPadding = s24;
  @Deprecated('Use AppSpacingSemantic.stackLg (s16)')
  static const double inBoxTopPadding = s16;
  @Deprecated('Use AppSpacingSemantic.stackLg (s16)')
  static const double bottomAfterBox = s16;
  @Deprecated('Use AppSpacingSemantic.layoutMd (s32)')
  static const double bottomAfterText = s32;
  @Deprecated('Use AppSpacingSemantic.inlineLg (s12) or stackMd (s8)')
  static const double itemSpacing = s12;
  @Deprecated('Use AppSpacingSemantic.stackLg (s16)')
  static const double textContentsSpacing = s16;
  @Deprecated('Use AppSpacingSemantic.stackLg (s16)')
  static const double textToBoxSpacing = s16;
  @Deprecated('Off-scale 20px — Phase 5 에서 palette s20 또는 semantic 로 마이그레이션')
  static const double betweenBoxesSpacing = s20;
  @Deprecated('Use AppSpacingSemantic.insetXl (s24)')
  static const double paddingContentsInBox = s24;
  @Deprecated('Use AppSpacingSemantic.stackLg (s16)')
  static const double paddingBoxInBox = s16;
  @Deprecated('Use AppSpacingSemantic.insetSm (s8)')
  static const double paddingContentsInBoxSmall = s8;
  @Deprecated('Use AppSpacingSemantic.stackMd (s8)')
  static const double buttonPaddingHorizontal = s8;
  @Deprecated('Use AppSpacingSemantic.stackLg (s12) or insetSquishLgVertical')
  static const double buttonPaddingVertical = s12;

  // Safe area (platform 시안 기준값) — palette 와 별개 platform 상수.
  // Phase 5 에서 platform safe-area 헬퍼로 이동 검토.
  @Deprecated('Move to platform safe-area module in Phase 5')
  static const double safeAreaStatusIos = 44.0;
  @Deprecated('Move to platform safe-area module in Phase 5')
  static const double safeAreaStatusAndroid = 36.0;
  @Deprecated('Move to platform safe-area module in Phase 5')
  static const double safeAreaStatusWeb = 0;
  @Deprecated('Move to platform safe-area module in Phase 5')
  static const double safeAreaBottomIos = 34.0;
  @Deprecated('Move to platform safe-area module in Phase 5')
  static const double safeAreaBottomAndroid = 14.0;
  @Deprecated('Move to platform safe-area module in Phase 5')
  static const double safeAreaBottomWeb = 0;

  @Deprecated('Use EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s32)')
  static const EdgeInsets containerPadding = EdgeInsets.symmetric(
    horizontal: s24,
    vertical: s32,
  );

  @Deprecated('Use EdgeInsets.symmetric(horizontal: AppSpacing.s8, vertical: AppSpacing.s12)')
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: s8,
    vertical: s12,
  );
}

/// Semantic spacing tokens — `semantic.json` 기준.
///
/// Palette 값을 참조하여 사용 의도를 명시. 카테고리:
/// - **stack** — 수직 간격 (위/아래 elements)
/// - **inline** — 수평 간격 (좌/우 elements)
/// - **inset** — 4방향 등간격 패딩
/// - **insetSquish** — 비대칭 패딩 (가로 ≠ 세로). `…Vertical` / `…Horizontal` 쌍.
/// - **layout** — 레이아웃 레벨 큰 간격 (section, page)
class AppSpacingSemantic {
  AppSpacingSemantic._();

  // ── stack — 수직 간격 ────────────────────────────────────────────

  /// Label-Value 미세 세로 간격 (= s2)
  static const double stackXs = AppSpacing.s2;

  /// Heading-Description 세로 간격 (= s4)
  static const double stackSm = AppSpacing.s4;

  /// List item 사이 세로 간격 (= s8)
  static const double stackMd = AppSpacing.s8;

  /// Card 사이 / Heading-Body 세로 간격 (= s16)
  static const double stackLg = AppSpacing.s16;

  /// Section 사이 세로 간격 (= s24)
  static const double stackXl = AppSpacing.s24;

  // ── inline — 수평 간격 ──────────────────────────────────────────

  /// 수평 미세 간격 (= s2)
  static const double inlineXs = AppSpacing.s2;

  /// Icon-text 표준 수평 간격 (= s4)
  static const double inlineSm = AppSpacing.s4;

  /// Button/Chip group 수평 간격 (= s8)
  static const double inlineMd = AppSpacing.s8;

  /// 수평 강조 간격 (= s12)
  static const double inlineLg = AppSpacing.s12;

  // ── inset — 4방향 등간격 패딩 ───────────────────────────────────

  /// Tag/Badge 4방향 패딩 (= s4)
  static const double insetXs = AppSpacing.s4;

  /// 작은 컨테이너 4방향 패딩 (= s8)
  static const double insetSm = AppSpacing.s8;

  /// Icon Button 표준 4방향 패딩 (= s12)
  static const double insetMd = AppSpacing.s12;

  /// FAB / Card 표준 4방향 패딩 (= s16)
  static const double insetLg = AppSpacing.s16;

  /// Modal 4방향 패딩 (= s24)
  static const double insetXl = AppSpacing.s24;

  // ── insetSquish — 비대칭 패딩 (vertical ≠ horizontal) ───────────

  /// Badge 세로 (= s2)
  static const double insetSquishXsVertical = AppSpacing.s2;

  /// Badge 가로 (= s6)
  static const double insetSquishXsHorizontal = AppSpacing.s6;

  /// Button Small 세로 (= s7)
  static const double insetSquishSmVertical = AppSpacing.s7;

  /// Button Small 가로 (= s14)
  static const double insetSquishSmHorizontal = AppSpacing.s14;

  /// Button Medium 세로 (= s9)
  static const double insetSquishMdVertical = AppSpacing.s9;

  /// Button Medium 가로 (= s20)
  static const double insetSquishMdHorizontal = AppSpacing.s20;

  /// Button Large 세로 (= s12)
  static const double insetSquishLgVertical = AppSpacing.s12;

  /// Button Large 가로 (= s28)
  static const double insetSquishLgHorizontal = AppSpacing.s28;

  // ── layout — 레이아웃 레벨 ──────────────────────────────────────

  /// Section 간격 (= s24)
  static const double layoutSm = AppSpacing.s24;

  /// Section 큰 간격 (= s32)
  static const double layoutMd = AppSpacing.s32;

  /// Layout 큰 간격 (= s40)
  static const double layoutLg = AppSpacing.s40;

  /// Layout 최대 간격 (= s48)
  static const double layoutXl = AppSpacing.s48;

  // ═══════════════════════════════════════════════════════════════
  // EdgeInsets 헬퍼 (자주 쓰이는 inset / insetSquish 조합)
  // ═══════════════════════════════════════════════════════════════

  /// Tag/Badge 등 4방향 등간격 EdgeInsets.
  static EdgeInsets inset(double value) => EdgeInsets.all(value);

  /// insetSquish 헬퍼 — vertical/horizontal 한 쌍을 EdgeInsets 으로.
  static EdgeInsets insetSquish({
    required double vertical,
    required double horizontal,
  }) =>
      EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal);

  /// Button Small 패딩 (`insetSquishSm*`)
  static const EdgeInsets buttonSmallPadding = EdgeInsets.symmetric(
    vertical: insetSquishSmVertical,
    horizontal: insetSquishSmHorizontal,
  );

  /// Button Medium 패딩 (`insetSquishMd*`)
  static const EdgeInsets buttonMediumPadding = EdgeInsets.symmetric(
    vertical: insetSquishMdVertical,
    horizontal: insetSquishMdHorizontal,
  );

  /// Button Large 패딩 (`insetSquishLg*`)
  static const EdgeInsets buttonLargePadding = EdgeInsets.symmetric(
    vertical: insetSquishLgVertical,
    horizontal: insetSquishLgHorizontal,
  );

  /// Badge 패딩 (`insetSquishXs*`)
  static const EdgeInsets badgePadding = EdgeInsets.symmetric(
    vertical: insetSquishXsVertical,
    horizontal: insetSquishXsHorizontal,
  );
}
