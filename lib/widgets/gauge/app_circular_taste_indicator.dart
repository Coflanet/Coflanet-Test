import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';

/// Circular taste indicator showing emoji, progress circle, and label.
/// Used in survey result and taste profile views.
class AppCircularTasteIndicator extends StatelessWidget {
  /// Emoji displayed above the circle
  final String emoji;

  /// Label text displayed below the circle
  final String label;

  /// Value (0-100) shown in center and used for progress
  final int value;

  /// Size of the circular indicator
  final double size;

  /// Progress bar color
  final Color? progressColor;

  /// Background color of the progress bar
  final Color? backgroundColor;

  const AppCircularTasteIndicator({
    super.key,
    required this.emoji,
    required this.label,
    required this.value,
    this.size = 56,
    this.progressColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveProgressColor = progressColor ?? AppColor.primaryNormal;
    final effectiveBackgroundColor =
        backgroundColor ?? AppColor.lineNormalAlternative;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Emoji
        Text(emoji, style: AppTextStyles.emojiNormal),
        const SizedBox(height: 10),

        // Circular indicator
        SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: size,
                height: size,
                child: CircularProgressIndicator(
                  value: value / 100,
                  strokeWidth: 5,
                  strokeCap: StrokeCap.round,
                  backgroundColor: effectiveBackgroundColor,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    effectiveProgressColor,
                  ),
                ),
              ),
              Text(
                '$value',
                style: AppTextStyles.label1NormalBold.copyWith(
                  color: AppColor.labelNormal,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // Label
        Text(
          label,
          style: AppTextStyles.caption1Medium.copyWith(
            color: AppColor.labelAlternative,
          ),
        ),
      ],
    );
  }
}

/// Data model for taste indicator items
class TasteIndicatorItem {
  final String emoji;
  final String label;
  final int value;

  const TasteIndicatorItem({
    required this.emoji,
    required this.label,
    required this.value,
  });
}
