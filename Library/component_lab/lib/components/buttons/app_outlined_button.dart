import 'package:flutter/material.dart';

import '../../foundation/_button_metrics.dart';
import '../../foundation/app_color.dart';
import '../../foundation/app_radius.dart';
import '../../foundation/app_text_style.dart';

enum AppOutlinedButtonSize { large, medium, small, xsmall }

/// Outlined 버튼 톤 — Figma `Button/Outlined/*` 3종.
enum AppOutlinedButtonTone {
  /// Stroke + Text 모두 Primary 색
  primary,

  /// Stroke 회색, Text Primary
  secondary,

  /// Stroke 회색, Text 일반
  assistive,
}

/// Outlined 버튼 — Pill, 1px stroke.
class AppOutlinedButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppOutlinedButtonTone tone;
  final AppOutlinedButtonSize size;
  final IconData? leftIcon;
  final IconData? rightIcon;
  final double? width;

  const AppOutlinedButton({
    super.key,
    required this.label,
    this.onPressed,
    this.tone = AppOutlinedButtonTone.primary,
    this.size = AppOutlinedButtonSize.large,
    this.leftIcon,
    this.rightIcon,
    this.width,
  });

  bool get _enabled => onPressed != null;

  // ── Size geometry — `AppButtonMetrics` 단일 룩업.
  AppButtonMetrics get _m => switch (size) {
        AppOutlinedButtonSize.large => AppButtonMetrics.large,
        AppOutlinedButtonSize.medium => AppButtonMetrics.medium,
        AppOutlinedButtonSize.small => AppButtonMetrics.small,
        AppOutlinedButtonSize.xsmall => AppButtonMetrics.xsmall,
      };

  double get _height => _m.height;
  EdgeInsets get _padding => _m.padding;
  double get _gap => _m.gap;
  double get _iconSize => _m.iconSize;
  TextStyle get _textStyle => _m.textStyle;

  ({Color stroke, Color fg}) _colors() {
    if (!_enabled) {
      // Figma: stroke = `line/normal/normal`, text = `Label/disable`
      return (stroke: AppColor.lineNormalNormal, fg: AppColor.labelDisable);
    }
    switch (tone) {
      case AppOutlinedButtonTone.primary:
        return (stroke: AppColor.primaryNormal, fg: AppColor.primaryNormal);
      case AppOutlinedButtonTone.secondary:
        return (stroke: AppColor.lineNormalNormal, fg: AppColor.primaryNormal);
      case AppOutlinedButtonTone.assistive:
        return (stroke: AppColor.lineNormalNormal, fg: AppColor.labelNormal);
    }
  }

  /// Outlined Secondary/Assistive는 stroke 1px 보정으로 padding이 다름.
  /// Primary는 28/12 그대로, Secondary/Assistive는 28/11 (수직 -1).
  EdgeInsets _adjustedPadding() {
    if (tone == AppOutlinedButtonTone.primary) return _padding;
    // Secondary/Assistive — 수직 padding -1 (Figma 측정)
    final base = _padding;
    return EdgeInsets.symmetric(
      horizontal: base.left,
      vertical: base.top - 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = _colors();
    final radius = AppRadius.radiusButtonBorder;

    return SizedBox(
      width: width,
      height: _height,
      child: Material(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(color: c.stroke, width: 1),
        ),
        child: InkWell(
          onTap: onPressed,
          borderRadius: radius,
          child: Padding(
            padding: _adjustedPadding(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: width == double.infinity
                  ? MainAxisSize.max
                  : MainAxisSize.min,
              children: [
                if (leftIcon != null) ...[
                  Icon(leftIcon, size: _iconSize, color: c.fg),
                  SizedBox(width: _gap),
                ],
                Text(label, style: _textStyle.copyWith(color: c.fg)),
                if (rightIcon != null) ...[
                  SizedBox(width: _gap),
                  Icon(rightIcon, size: _iconSize, color: c.fg),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
