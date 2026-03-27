import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:coflanet/constants/color_constant.dart';

/// Reusable SVG icon widget wrapping flutter_svg
///
/// Usage:
/// ```dart
/// AppIcon(AssetPath.iconHeart, size: 24, color: AppColor.primaryNormal)
/// AppIcon(AssetPath.iconCoffee) // default: 24px, labelNormal color
/// AppIcon.button(AssetPath.iconClose, onTap: () => Get.back())
/// ```
class AppIcon extends StatelessWidget {
  /// SVG asset path (use AssetPath.icon* constants)
  final String assetPath;

  /// Icon size (width = height). Default: 24
  final double size;

  /// Icon color. Applied as colorFilter. Default: labelNormal
  final Color? color;

  /// Optional semantic label for accessibility
  final String? semanticLabel;

  const AppIcon(
    this.assetPath, {
    super.key,
    this.size = 24,
    this.color,
    this.semanticLabel,
  });

  /// Convenience constructor for tappable icon with hit area
  /// Wraps icon in a 40x40 touch target (minimum recommended by Apple/Google)
  static Widget button(
    String assetPath, {
    Key? key,
    double size = 24,
    double hitSize = 40,
    Color? color,
    required VoidCallback? onTap,
    String? semanticLabel,
  }) {
    return GestureDetector(
      key: key,
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: hitSize,
        height: hitSize,
        child: Center(
          child: AppIcon(
            assetPath,
            size: size,
            color: color,
            semanticLabel: semanticLabel,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = color ?? AppColor.labelNormal;

    return SvgPicture.asset(
      assetPath,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
      semanticsLabel: semanticLabel,
    );
  }
}
