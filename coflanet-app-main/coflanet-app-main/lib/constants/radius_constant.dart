import 'package:flutter/material.dart';

/// Border radius constants based on Figma Design System
///
/// Usage:
/// ```dart
/// Container(
///   decoration: BoxDecoration(
///     borderRadius: AppRadius.lgBorder, // BorderRadius.circular(12)
///   ),
/// )
///
/// // Or use raw values
/// BorderRadius.circular(AppRadius.lg) // 12.0
/// ```
class AppRadius {
  AppRadius._();

  // ===== RAW VALUES =====

  /// 0px - No radius
  static const double none = 0.0;

  /// 2px - Minimal radius (progress bars, thin elements)
  static const double xxs = 2.0;

  /// 4px - Extra small radius (small badges, tags)
  static const double xs = 4.0;

  /// 6px - Small radius (checkboxes)
  static const double sm = 6.0;

  /// 8px - Medium small radius (small cards, chips)
  static const double md = 8.0;

  /// 12px - Medium radius (buttons, inputs, cards) - MOST COMMON
  static const double lg = 12.0;

  /// 14px
  static const double lgPlus = 14.0;

  /// 16px - Large radius (cards, containers)
  static const double xl = 16.0;

  /// 20px - Extra large radius (modals, large cards)
  static const double xxl = 20.0;

  /// 24px - Extra extra large radius (large containers)
  static const double xxxl = 24.0;

  /// 32px - Rounded containers
  static const double round = 32.0;

  /// 100px - Fully rounded / pill shape
  static const double full = 100.0;

  // ===== BORDER RADIUS OBJECTS =====

  /// No radius
  static BorderRadius get noneBorder => BorderRadius.zero;

  /// 2px radius
  static BorderRadius get xxsBorder => BorderRadius.circular(xxs);

  /// 4px radius
  static BorderRadius get xsBorder => BorderRadius.circular(xs);

  /// 6px radius
  static BorderRadius get smBorder => BorderRadius.circular(sm);

  /// 8px radius
  static BorderRadius get mdBorder => BorderRadius.circular(md);

  /// 12px radius - Buttons, Inputs
  static BorderRadius get lgBorder => BorderRadius.circular(lg);

  /// 14px radius
  static BorderRadius get lgPlusBorder => BorderRadius.circular(lgPlus);

  /// 16px radius - Cards
  static BorderRadius get xlBorder => BorderRadius.circular(xl);

  /// 20px radius - Modals
  static BorderRadius get xxlBorder => BorderRadius.circular(xxl);

  /// 24px radius - Large containers
  static BorderRadius get xxxlBorder => BorderRadius.circular(xxxl);

  /// 32px radius - Rounded elements
  static BorderRadius get roundBorder => BorderRadius.circular(round);

  /// 100px radius - Pill shape
  static BorderRadius get fullBorder => BorderRadius.circular(full);

  // ===== COMPONENT-SPECIFIC RADIUS =====

  /// Button radius (12px)
  static const double button = lg;
  static BorderRadius get buttonBorder => lgBorder;

  /// Input field radius (12px)
  static const double input = lg;
  static BorderRadius get inputBorder => lgBorder;

  /// Card radius (16px)
  static const double card = xl;
  static BorderRadius get cardBorder => xlBorder;

  /// Modal radius (20px)
  static const double modal = xxl;
  static BorderRadius get modalBorder => xxlBorder;

  /// Chip radius (8px)
  static const double chip = md;
  static BorderRadius get chipBorder => mdBorder;

  /// Checkbox radius (6px)
  static const double checkbox = sm;
  static BorderRadius get checkboxBorder => smBorder;

  /// Avatar radius (full)
  static const double avatar = full;
  static BorderRadius get avatarBorder => fullBorder;

  // ===== DIRECTIONAL RADIUS =====

  /// Top only radius
  static BorderRadius top(double radius) => BorderRadius.only(
    topLeft: Radius.circular(radius),
    topRight: Radius.circular(radius),
  );

  /// Bottom only radius
  static BorderRadius bottom(double radius) => BorderRadius.only(
    bottomLeft: Radius.circular(radius),
    bottomRight: Radius.circular(radius),
  );

  /// Left only radius
  static BorderRadius left(double radius) => BorderRadius.only(
    topLeft: Radius.circular(radius),
    bottomLeft: Radius.circular(radius),
  );

  /// Right only radius
  static BorderRadius right(double radius) => BorderRadius.only(
    topRight: Radius.circular(radius),
    bottomRight: Radius.circular(radius),
  );
}
