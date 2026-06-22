import 'package:flutter/material.dart';

/// Spacing constants based on Figma Design System
///
/// Usage:
/// ```dart
/// Padding(padding: EdgeInsets.all(AppSpacing.md))
/// SizedBox(height: AppSpacing.lg)
/// ```
class AppSpacing {
  AppSpacing._();

  // ===== BASE SPACING VALUES =====

  /// 2px - Minimal spacing
  static const double space2 = 2.0;

  /// 4px - Extra small spacing
  static const double space4 = 4.0;

  /// 6px - Small spacing
  static const double space6 = 6.0;

  /// 8px - Base small spacing
  static const double space8 = 8.0;

  /// 10px
  static const double space10 = 10.0;

  /// 12px - Medium spacing
  static const double space12 = 12.0;

  /// 14px
  static const double space14 = 14.0;

  /// 16px - Base medium spacing
  static const double space16 = 16.0;

  /// 20px - Large spacing
  static const double space20 = 20.0;

  /// 24px - Base large spacing
  static const double space24 = 24.0;

  /// 28px
  static const double space28 = 28.0;

  /// 32px - Extra large spacing
  static const double space32 = 32.0;

  /// 40px
  static const double space40 = 40.0;

  /// 48px
  static const double space48 = 48.0;

  /// 56px
  static const double space56 = 56.0;

  /// 64px
  static const double space64 = 64.0;

  /// 80px
  static const double space80 = 80.0;

  // ===== SEMANTIC ALIASES =====

  /// 4px - Extra extra small
  static const double xxs = space4;

  /// 8px - Extra small
  static const double xs = space8;

  /// 12px - Small
  static const double sm = space12;

  /// 16px - Medium (default)
  static const double md = space16;

  /// 20px - Large
  static const double lg = space20;

  /// 24px - Extra large
  static const double xl = space24;

  /// 32px - Extra extra large
  static const double xxl = space32;

  /// 48px - Extra extra extra large
  static const double xxxl = space48;

  // ===== COMPONENT-SPECIFIC SPACING =====

  /// Button horizontal padding (16px)
  static const double buttonPaddingH = space16;

  /// Button vertical padding (14px)
  static const double buttonPaddingV = space14;

  /// Card padding (16px)
  static const double cardPadding = space16;

  /// Modal padding (24px)
  static const double modalPadding = space24;

  /// Screen horizontal padding (20px)
  static const double screenPaddingH = space20;

  /// Screen vertical padding (16px)
  static const double screenPaddingV = space16;

  /// List item spacing (12px)
  static const double listItemSpacing = space12;

  /// Icon and text gap (8px)
  static const double iconTextGap = space8;

  /// Section spacing (24px)
  static const double sectionSpacing = space24;

  // ===== CARD PATTERN (iyumi 카드 패턴, task 4) =====

  /// 화면 최상단 텍스트 위 마진 (32) — 전 화면 통일
  static const double screenTopMargin = space32;

  /// 헤더(카드 밖) 좌우 패딩 (20)
  static const double headerHorizontalPadding = space20;

  /// 큰 카드(CardSection) 좌우/상하 패딩
  static const double sectionPaddingHorizontal = space24;
  static const double sectionPaddingVertical = space32;
  static const EdgeInsets sectionPadding = EdgeInsets.symmetric(
    horizontal: space24,
    vertical: space32,
  );

  /// 작은 카드(CardItem) 패딩 (24)
  static const EdgeInsets itemPadding = EdgeInsets.all(space24);

  /// 카드 사이 간격 (4) — section/item 공통
  static const double cardGap = space4;
  static const double sectionGap = space4;
  static const double itemGap = space4;

  /// OS 독바(홈 인디케이터) 여유 (96) + 그 위 호흡 (16)
  static const double bottomDockAllowance = space80 + space16;
  static const double bottomBreathingRoom = space16;

  /// 스크롤 최하단 패딩 — safe area + 독바 여유 + 호흡.
  /// 자체 스크롤 화면(scrollable:false)의 리스트 하단에 직접 적용한다.
  static double bottomScrollInset(BuildContext context) =>
      MediaQuery.of(context).padding.bottom +
      bottomDockAllowance +
      bottomBreathingRoom;

  // ===== EDGE INSETS HELPERS =====

  /// All sides padding
  static EdgeInsets all(double value) => EdgeInsets.all(value);

  /// Horizontal padding
  static EdgeInsets horizontal(double value) =>
      EdgeInsets.symmetric(horizontal: value);

  /// Vertical padding
  static EdgeInsets vertical(double value) =>
      EdgeInsets.symmetric(vertical: value);

  /// Symmetric padding
  static EdgeInsets symmetric({double h = 0, double v = 0}) =>
      EdgeInsets.symmetric(horizontal: h, vertical: v);

  // ===== COMMON EDGE INSETS =====

  /// Screen padding (horizontal: 20, vertical: 16)
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: space20,
    vertical: space16,
  );

  /// Card padding (all: 16)
  static const EdgeInsets cardPaddingAll = EdgeInsets.all(space16);

  /// Modal content padding (horizontal: 24, vertical: 20)
  static const EdgeInsets modalContentPadding = EdgeInsets.symmetric(
    horizontal: space24,
    vertical: space20,
  );

  /// Button padding (horizontal: 16, vertical: 14)
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: space16,
    vertical: space14,
  );

  /// List item padding (horizontal: 16, vertical: 12)
  static const EdgeInsets listItemPadding = EdgeInsets.symmetric(
    horizontal: space16,
    vertical: space12,
  );
}
