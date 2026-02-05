import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';
import 'package:coflanet/widgets/buttons/primary_button.dart';

/// Text button without background (Text type in Figma)
///
/// Usage:
/// ```dart
/// AppTextButton(
///   text: '자세히 보기',
///   onPressed: () {},
/// )
///
/// // With underline
/// AppTextButton(
///   text: '링크',
///   onPressed: () {},
///   underline: true,
/// )
/// ```
class AppTextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final ButtonSize size;
  final IconData? icon;
  final bool iconAfterText;
  final bool underline;
  final Color? color;

  const AppTextButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.size = ButtonSize.lg,
    this.icon,
    this.iconAfterText = false,
    this.underline = false,
    this.color,
  });

  TextStyle get _textStyle {
    switch (size) {
      case ButtonSize.xl:
      case ButtonSize.lg:
        return AppTextStyles.headline1Bold;
      case ButtonSize.md:
        return AppTextStyles.headline2Bold;
      case ButtonSize.sm:
        return AppTextStyles.label1NormalBold;
      case ButtonSize.xs:
        return AppTextStyles.label2Bold;
    }
  }

  double get _iconSize {
    switch (size) {
      case ButtonSize.xl:
      case ButtonSize.lg:
        return 20;
      case ButtonSize.md:
        return 18;
      case ButtonSize.sm:
        return 16;
      case ButtonSize.xs:
        return 14;
    }
  }

  double get _loadingSize {
    switch (size) {
      case ButtonSize.xl:
      case ButtonSize.lg:
        return 24;
      case ButtonSize.md:
        return 22;
      case ButtonSize.sm:
        return 18;
      case ButtonSize.xs:
        return 14;
    }
  }

  EdgeInsets get _padding {
    switch (size) {
      case ButtonSize.xl:
        return EdgeInsets.symmetric(
          horizontal: AppSpacing.space12,
          vertical: AppSpacing.space8,
        );
      case ButtonSize.lg:
        return EdgeInsets.symmetric(
          horizontal: AppSpacing.space10,
          vertical: AppSpacing.space6,
        );
      case ButtonSize.md:
        return EdgeInsets.symmetric(
          horizontal: AppSpacing.space8,
          vertical: AppSpacing.space4,
        );
      case ButtonSize.sm:
        return EdgeInsets.symmetric(
          horizontal: AppSpacing.space6,
          vertical: AppSpacing.space2,
        );
      case ButtonSize.xs:
        return EdgeInsets.symmetric(
          horizontal: AppSpacing.space4,
          vertical: AppSpacing.space2,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final enabled = isEnabled && !isLoading && onPressed != null;
    final textColor = enabled
        ? (color ?? AppColor.primaryNormal)
        : AppColor.labelDisable;

    return TextButton(
      onPressed: enabled ? onPressed : null,
      style: TextButton.styleFrom(
        foregroundColor: textColor,
        padding: _padding,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: isLoading
          ? SizedBox(
              width: _loadingSize,
              height: _loadingSize,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(textColor),
              ),
            )
          : _buildContent(textColor),
    );
  }

  Widget _buildContent(Color textColor) {
    final style = _textStyle.copyWith(
      color: textColor,
      decoration: underline ? TextDecoration.underline : null,
      decorationColor: textColor,
    );

    if (icon == null) {
      return Text(text, style: style);
    }

    final iconWidget = Icon(icon, size: _iconSize, color: textColor);
    final textWidget = Text(text, style: style);
    final gap = SizedBox(width: AppSpacing.space4);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: iconAfterText
          ? [textWidget, gap, iconWidget]
          : [iconWidget, gap, textWidget],
    );
  }
}
