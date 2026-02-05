import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';
import 'package:coflanet/widgets/buttons/primary_button.dart';

/// Tonal button with light background (Tonal type in Figma)
///
/// Usage:
/// ```dart
/// TonalButton(
///   text: '더보기',
///   onPressed: () {},
/// )
/// ```
class TonalButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final double? width;
  final ButtonSize size;
  final IconData? icon;
  final bool iconAfterText;

  const TonalButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.width,
    this.size = ButtonSize.lg,
    this.icon,
    this.iconAfterText = false,
  });

  double get _height {
    switch (size) {
      case ButtonSize.xl:
        return 56;
      case ButtonSize.lg:
        return 52;
      case ButtonSize.md:
        return 48;
      case ButtonSize.sm:
        return 40;
      case ButtonSize.xs:
        return 32;
    }
  }

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
          horizontal: AppSpacing.space20,
          vertical: AppSpacing.space16,
        );
      case ButtonSize.lg:
        return EdgeInsets.symmetric(
          horizontal: AppSpacing.space16,
          vertical: AppSpacing.space14,
        );
      case ButtonSize.md:
        return EdgeInsets.symmetric(
          horizontal: AppSpacing.space16,
          vertical: AppSpacing.space12,
        );
      case ButtonSize.sm:
        return EdgeInsets.symmetric(
          horizontal: AppSpacing.space12,
          vertical: AppSpacing.space8,
        );
      case ButtonSize.xs:
        return EdgeInsets.symmetric(
          horizontal: AppSpacing.space10,
          vertical: AppSpacing.space6,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final enabled = isEnabled && !isLoading && onPressed != null;

    return SizedBox(
      width: width ?? double.infinity,
      height: _height,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: enabled
              ? AppColor.primaryLight
              : AppColor.interactionDisable,
          foregroundColor: enabled
              ? AppColor.primaryNormal
              : AppColor.labelDisable,
          elevation: 0,
          padding: _padding,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.buttonBorder),
          disabledBackgroundColor: AppColor.interactionDisable,
          disabledForegroundColor: AppColor.labelDisable,
        ),
        child: isLoading
            ? SizedBox(
                width: _loadingSize,
                height: _loadingSize,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColor.primaryNormal,
                  ),
                ),
              )
            : _buildContent(enabled),
      ),
    );
  }

  Widget _buildContent(bool enabled) {
    final color = enabled ? AppColor.primaryNormal : AppColor.labelDisable;

    if (icon == null) {
      return Text(text, style: _textStyle.copyWith(color: color));
    }

    final iconWidget = Icon(icon, size: _iconSize, color: color);
    final textWidget = Text(text, style: _textStyle.copyWith(color: color));
    final gap = SizedBox(width: AppSpacing.space8);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: iconAfterText
          ? [textWidget, gap, iconWidget]
          : [iconWidget, gap, textWidget],
    );
  }
}
