import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/widgets/buttons/primary_button.dart';

/// Reusable bottom bar container with consistent styling.
///
/// Provides the common bottom bar wrapper with shadow and SafeArea.
/// Use [child] for custom content or convenience constructors for common patterns.
///
/// Usage:
/// ```dart
/// // Custom child
/// AppBottomBar(
///   child: Row(children: [...]),
/// )
///
/// // Single primary button
/// AppBottomBar.primaryButton(
///   text: '저장',
///   onPressed: () => Get.back(),
/// )
///
/// // Two buttons (secondary + primary)
/// AppBottomBar.twoButtons(
///   secondaryText: '다시 테스트하기',
///   onSecondary: controller.retakeSurvey,
///   primaryText: '홈으로',
///   onPrimary: controller.goBack,
/// )
/// ```
class AppBottomBar extends StatelessWidget {
  /// The child widget to display inside the bottom bar
  final Widget child;

  /// Padding around the content (default: EdgeInsets.all(20))
  final EdgeInsets padding;

  /// Whether to include top border radius
  final bool hasTopRadius;

  /// Background color (default: AppColor.backgroundNormalNormal)
  final Color? backgroundColor;

  const AppBottomBar({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.hasTopRadius = false,
    this.backgroundColor,
  });

  /// Creates a bottom bar with a single primary button
  factory AppBottomBar.primaryButton({
    Key? key,
    required String text,
    required VoidCallback? onPressed,
    bool isEnabled = true,
    EdgeInsets padding = const EdgeInsets.all(20),
    bool hasTopRadius = false,
  }) {
    return AppBottomBar(
      key: key,
      padding: padding,
      hasTopRadius: hasTopRadius,
      child: PrimaryButton(
        text: text,
        onPressed: onPressed,
        isEnabled: isEnabled,
      ),
    );
  }

  /// Creates a bottom bar with two buttons (secondary on left, primary on right)
  factory AppBottomBar.twoButtons({
    Key? key,
    required String secondaryText,
    required VoidCallback? onSecondary,
    required String primaryText,
    required VoidCallback? onPrimary,
    bool primaryEnabled = true,
    EdgeInsets padding = const EdgeInsets.fromLTRB(20, 16, 20, 32),
    bool hasTopRadius = true,
  }) {
    return AppBottomBar(
      key: key,
      padding: padding,
      hasTopRadius: hasTopRadius,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onSecondary,
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: AppColor.componentFillNormal,
                  borderRadius: AppRadius.lgBorder,
                ),
                child: Center(
                  child: Text(
                    secondaryText,
                    style: AppTextStyles.headline2Medium.copyWith(
                      color: AppColor.labelNormal,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: PrimaryButton(
              text: primaryText,
              onPressed: onPrimary,
              isEnabled: primaryEnabled,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColor.backgroundNormalNormal,
        boxShadow: AppShadows.shadowBlackHeavyBottom,
        borderRadius: hasTopRadius ? AppRadius.top(AppRadius.xxxl) : null,
      ),
      child: SafeArea(child: child),
    );
  }
}
