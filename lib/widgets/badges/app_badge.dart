import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';

/// Badge variants for different styles
enum BadgeVariant {
  /// Standard badge with background color
  standard,

  /// Outlined badge with border only
  outlined,

  /// Dot badge (circular, no text)
  dot,
}

/// Badge size variants
enum BadgeSize {
  /// Small: height 20px, text caption2Medium
  sm,

  /// Medium: height 24px, text caption1Medium (default)
  md,

  /// Large: height 28px, text label1NormalMedium
  lg,
}

/// Badge color schemes
enum BadgeColor {
  /// Primary color scheme
  primary,

  /// Success/green color scheme
  success,

  /// Warning/orange color scheme
  warning,

  /// Error/red color scheme
  error,

  /// Neutral/gray color scheme
  neutral,
}

/// A versatile badge component following design system.
///
/// Usage:
/// ```dart
/// // Basic badge
/// AppBadge(
///   label: 'New',
/// )
///
/// // Success badge with large size
/// AppBadge(
///   label: 'Verified',
///   color: BadgeColor.success,
///   size: BadgeSize.lg,
/// )
///
/// // Outlined badge
/// AppBadge(
///   label: 'Beta',
///   variant: BadgeVariant.outlined,
///   color: BadgeColor.warning,
/// )
///
/// // Dot badge for notifications
/// AppBadge(
///   variant: BadgeVariant.dot,
///   color: BadgeColor.error,
/// )
/// ```
class AppBadge extends StatelessWidget {
  final String? label;
  final BadgeVariant variant;
  final BadgeSize size;
  final BadgeColor color;
  final bool showLabel;

  const AppBadge({
    super.key,
    this.label,
    this.variant = BadgeVariant.standard,
    this.size = BadgeSize.md,
    this.color = BadgeColor.primary,
    this.showLabel = true,
  }) : assert(
         variant != BadgeVariant.dot || label == null,
         'Dot badge should not have a label',
       );

  double get _height {
    switch (size) {
      case BadgeSize.sm:
        return 20;
      case BadgeSize.md:
        return 24;
      case BadgeSize.lg:
        return 28;
    }
  }

  double get _dotSize {
    switch (size) {
      case BadgeSize.sm:
        return 6;
      case BadgeSize.md:
        return 8;
      case BadgeSize.lg:
        return 10;
    }
  }

  TextStyle get _textStyle {
    switch (size) {
      case BadgeSize.sm:
        return AppTextStyles.caption2Medium;
      case BadgeSize.md:
        return AppTextStyles.caption1Medium;
      case BadgeSize.lg:
        return AppTextStyles.label1NormalMedium;
    }
  }

  EdgeInsets get _padding {
    if (variant == BadgeVariant.dot) {
      return EdgeInsets.zero;
    }

    switch (size) {
      case BadgeSize.sm:
        return EdgeInsets.symmetric(
          horizontal: AppSpacing.space6,
          vertical: AppSpacing.space2,
        );
      case BadgeSize.md:
        return EdgeInsets.symmetric(
          horizontal: AppSpacing.space8,
          vertical: AppSpacing.space4,
        );
      case BadgeSize.lg:
        return EdgeInsets.symmetric(
          horizontal: AppSpacing.space10,
          vertical: AppSpacing.space6,
        );
    }
  }

  Color get _backgroundColor {
    if (variant == BadgeVariant.outlined) {
      return Colors.transparent;
    }

    switch (color) {
      case BadgeColor.primary:
        return AppColor.primaryNormal;
      case BadgeColor.success:
        return AppColor.statusPositive;
      case BadgeColor.warning:
        return AppColor.statusCautionary;
      case BadgeColor.error:
        return AppColor.statusNegative;
      case BadgeColor.neutral:
        return AppColor.labelAlternative;
    }
  }

  Color get _textColor {
    if (variant == BadgeVariant.outlined) {
      switch (color) {
        case BadgeColor.primary:
          return AppColor.primaryNormal;
        case BadgeColor.success:
          return AppColor.statusPositive;
        case BadgeColor.warning:
          return AppColor.statusCautionary;
        case BadgeColor.error:
          return AppColor.statusNegative;
        case BadgeColor.neutral:
          return AppColor.labelAlternative;
      }
    }

    return AppColor.staticLabelWhiteStrong;
  }

  Color get _borderColor {
    switch (color) {
      case BadgeColor.primary:
        return AppColor.primaryNormal;
      case BadgeColor.success:
        return AppColor.statusPositive;
      case BadgeColor.warning:
        return AppColor.statusCautionary;
      case BadgeColor.error:
        return AppColor.statusNegative;
      case BadgeColor.neutral:
        return AppColor.labelAlternative;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (variant == BadgeVariant.dot) {
      return Container(
        width: _dotSize,
        height: _dotSize,
        decoration: BoxDecoration(
          color: _backgroundColor,
          borderRadius: BorderRadius.circular(_dotSize / 2),
        ),
      );
    }

    if (!showLabel || (label?.isEmpty ?? true)) {
      return const SizedBox.shrink();
    }

    return Container(
      height: _height,
      padding: _padding,
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: AppRadius.fullBorder,
        border: variant == BadgeVariant.outlined
            ? Border.all(color: _borderColor, width: 1)
            : null,
      ),
      child: Center(
        child: Text(label ?? '', style: _textStyle.copyWith(color: _textColor)),
      ),
    );
  }
}

/// A positioned badge that can be overlaid on other widgets.
///
/// Usage:
/// ```dart
/// Stack(
///   children: [
///     Icon(Icons.notifications),
///     Positioned(
///       top: 0,
///       right: 0,
///       child: AppPositionedBadge(
///         count: 3,
///         showLabel: false,
///       ),
///     ),
///   ],
/// )
/// ```
class AppPositionedBadge extends StatelessWidget {
  final int? count;
  final String? label;
  final BadgeVariant variant;
  final BadgeSize size;
  final BadgeColor color;
  final bool showLabel;
  final bool showZero;

  const AppPositionedBadge({
    super.key,
    this.count,
    this.label,
    this.variant = BadgeVariant.standard,
    this.size = BadgeSize.sm,
    this.color = BadgeColor.error,
    this.showLabel = true,
    this.showZero = false,
  }) : assert(
         count != null || label != null,
         'Either count or label must be provided',
       );

  String get _displayText {
    if (label != null) return label!;

    if (count == null) return '';

    if (count! > 99) return '99+';
    if (count! == 0 && !showZero) return '';
    return count.toString();
  }

  @override
  Widget build(BuildContext context) {
    if (_displayText.isEmpty && variant != BadgeVariant.dot) {
      return const SizedBox.shrink();
    }

    return AppBadge(
      label: _displayText.isEmpty ? null : _displayText,
      variant: variant,
      size: size,
      color: color,
      showLabel: showLabel,
    );
  }
}

/// A status badge for displaying various states.
///
/// Usage:
/// ```dart
/// AppStatusBadge(
///   status: 'Active',
///   color: BadgeColor.success,
/// )
/// ```
class AppStatusBadge extends StatelessWidget {
  final String status;
  final BadgeColor color;
  final BadgeSize size;

  const AppStatusBadge({
    super.key,
    required this.status,
    this.color = BadgeColor.neutral,
    this.size = BadgeSize.md,
  });

  @override
  Widget build(BuildContext context) {
    return AppBadge(
      label: status,
      variant: BadgeVariant.outlined,
      size: size,
      color: color,
    );
  }
}
