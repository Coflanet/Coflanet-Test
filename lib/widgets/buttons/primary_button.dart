import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final double? width;
  final double height;
  final IconData? icon;
  final bool iconAfterText;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.width,
    this.height = 52,
    this.icon,
    this.iconAfterText = false,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = isEnabled && !isLoading && onPressed != null;

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: enabled
              ? AppColor.primaryNormal
              : AppColor.interactionDisable,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          disabledBackgroundColor: AppColor.interactionDisable,
          disabledForegroundColor: AppColor.labelDisable,
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (icon == null) {
      return Text(
        text,
        style: AppTextStyles.headline1Bold,
      );
    }

    final iconWidget = Icon(icon, size: 20);
    final textWidget = Text(
      text,
      style: AppTextStyles.headline1Bold,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: iconAfterText
          ? [textWidget, const SizedBox(width: 8), iconWidget]
          : [iconWidget, const SizedBox(width: 8), textWidget],
    );
  }
}
