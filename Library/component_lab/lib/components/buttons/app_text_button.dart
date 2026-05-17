import 'package:flutter/material.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_spacing.dart';
import '../../foundation/app_text_style.dart';

/// Text 버튼 사이즈 — Figma는 Medium/Small 2개만.
enum AppTextButtonSize { medium, small }

/// Text 버튼 톤 — Figma `Button/Text/*` 3종.
enum AppTextButtonTone {
  /// Primary 컬러
  primary,

  /// labelNormal
  normal,

  /// labelAlternative
  assistive,
}

/// Text 버튼 — radius 0, 가로 padding 0, 위·아래 4px (Figma 기준).
class AppTextButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppTextButtonTone tone;
  final AppTextButtonSize size;
  final IconData? leftIcon;
  final IconData? rightIcon;

  const AppTextButton({
    super.key,
    required this.label,
    this.onPressed,
    this.tone = AppTextButtonTone.primary,
    this.size = AppTextButtonSize.medium,
    this.leftIcon,
    this.rightIcon,
  });

  bool get _enabled => onPressed != null;

  EdgeInsets get _padding => const EdgeInsets.symmetric(vertical: AppSpacing.s4);
  double get _gap => 10;

  double get _iconSize =>
      size == AppTextButtonSize.medium ? 18 : 16;

  /// Figma 측정:
  /// - Medium: 16px → body1NormalBold
  /// - Small: 14px → label1NormalBold
  TextStyle get _textStyle => size == AppTextButtonSize.medium
      ? AppTextStyles.body1NormalBold
      : AppTextStyles.label1NormalBold;

  Color _foreground() {
    if (!_enabled) return AppColor.labelDisable;
    switch (tone) {
      case AppTextButtonTone.primary:
        return AppColor.primaryNormal;
      case AppTextButtonTone.normal:
        return AppColor.labelNormal;
      case AppTextButtonTone.assistive:
        return AppColor.labelAlternative;
    }
  }

  @override
  Widget build(BuildContext context) {
    final fg = _foreground();
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: _padding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leftIcon != null) ...[
                Icon(leftIcon, size: _iconSize, color: fg),
                SizedBox(width: _gap),
              ],
              Text(label, style: _textStyle.copyWith(color: fg)),
              if (rightIcon != null) ...[
                SizedBox(width: _gap),
                Icon(rightIcon, size: _iconSize, color: fg),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
