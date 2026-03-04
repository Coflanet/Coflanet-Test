import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';

/// Animated horizontal taste bar with label and value badge.
/// Used in matching result and taste profile views.
class AppAnimatedTasteBar extends StatelessWidget {
  /// Label text (e.g., "산미", "단맛")
  final String label;

  /// Value (0-100)
  final int value;

  /// Color for the progress bar and value badge
  final Color color;

  /// Animation duration
  final Duration animationDuration;

  /// Whether this is the last item (removes bottom padding)
  final bool isLast;

  /// Height of the progress bar
  final double barHeight;

  const AppAnimatedTasteBar({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    this.animationDuration = const Duration(milliseconds: 800),
    this.isLast = false,
    this.barHeight = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: AppTextStyles.label1NormalMedium.copyWith(
                  color: AppColor.labelNormal,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColor.staticLabelWhiteStrong.withValues(alpha: 0.2),
                  borderRadius: AppRadius.xxlBorder,
                ),
                child: Text(
                  '$value',
                  style: AppTextStyles.label1NormalBold.copyWith(color: color),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Stack(
            children: [
              // Background bar
              Container(
                height: barHeight,
                decoration: BoxDecoration(
                  color: AppColor.lineNormalAlternative,
                  borderRadius: AppRadius.smBorder,
                ),
              ),
              // Animated value bar with gradient
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: value / 100),
                duration: animationDuration,
                curve: Curves.easeOutCubic,
                builder: (context, animValue, child) {
                  return FractionallySizedBox(
                    widthFactor: animValue,
                    child: Container(
                      height: barHeight,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [color.withValues(alpha: 0.7), color],
                        ),
                        borderRadius: AppRadius.smBorder,
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Mini taste bar for compact displays (e.g., in recommendation cards)
class AppMiniTasteBar extends StatelessWidget {
  /// Label text (e.g., "산미")
  final String label;

  /// Value (0-100)
  final int value;

  /// Label width
  final double labelWidth;

  /// Bar height
  final double barHeight;

  const AppMiniTasteBar({
    super.key,
    required this.label,
    required this.value,
    this.labelWidth = 28,
    this.barHeight = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(
            width: labelWidth,
            child: Text(
              label,
              style: AppTextStyles.caption2Medium.copyWith(
                color: AppColor.labelAssistive,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: SizedBox(
              height: barHeight,
              child: ClipRRect(
                borderRadius: AppRadius.xxsBorder,
                child: LinearProgressIndicator(
                  value: value / 100,
                  backgroundColor: AppColor.lineNormalAlternative,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColor.primaryNormal,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
