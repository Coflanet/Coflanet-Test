import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/color_constant.dart';

/// Round checkbox widget with animated selection state.
/// Used in survey result, select coffee, and onboarding views.
class AppRoundCheckbox extends StatelessWidget {
  /// Whether the checkbox is selected
  final bool isSelected;

  /// Size of the checkbox
  final double size;

  /// Callback when tapped
  final VoidCallback? onTap;

  /// Selected fill color
  final Color? selectedColor;

  /// Unselected border color
  final Color? unselectedBorderColor;

  /// Check icon color
  final Color? checkColor;

  /// Animation duration
  final Duration animationDuration;

  const AppRoundCheckbox({
    super.key,
    required this.isSelected,
    this.size = 24,
    this.onTap,
    this.selectedColor,
    this.unselectedBorderColor,
    this.checkColor,
    this.animationDuration = const Duration(milliseconds: 160),
  });

  @override
  Widget build(BuildContext context) {
    final effectiveSelectedColor = selectedColor ?? AppColor.primaryNormal;
    final effectiveUnselectedBorderColor =
        unselectedBorderColor ?? AppColor.lineNormalNormal;
    final effectiveCheckColor = checkColor ?? AppColor.staticLabelWhiteStrong;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: animationDuration,
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: isSelected ? effectiveSelectedColor : AppColor.transparent,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected
                ? effectiveSelectedColor
                : effectiveUnselectedBorderColor,
            width: 2,
          ),
        ),
        child: isSelected
            ? Center(
                child: SvgPicture.asset(
                  AssetPath.iconCheck,
                  width: size * 0.58,
                  height: size * 0.58,
                  colorFilter: ColorFilter.mode(
                    effectiveCheckColor,
                    BlendMode.srcIn,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
