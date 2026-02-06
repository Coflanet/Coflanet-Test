import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';

/// Card elevation variants
enum CardElevation {
  /// No shadow, flat design
  flat,

  /// Subtle shadow (default)
  normal,

  /// Medium shadow for emphasis
  medium,

  /// Strong shadow for floating effect
  strong,
}

/// A versatile card component following design system.
///
/// Usage:
/// ```dart
/// // Basic card
/// AppCard(
///   child: Text('Card content'),
/// )
///
/// // Elevated card with custom padding
/// AppCard(
///   elevation: CardElevation.medium,
///   padding: EdgeInsets.all(16),
///   child: Column(
///     children: [
///       Text('Title'),
///       Text('Description'),
///     ],
///   ),
/// )
///
/// // Tappable card
/// AppCard(
///   onTap: () => print('Card tapped'),
///   child: ListTile(
///     title: Text('Tappable Card'),
///   ),
/// )
/// ```
class AppCard extends StatelessWidget {
  final Widget child;
  final CardElevation elevation;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final Color? borderColor;
  final VoidCallback? onTap;
  final bool isSelectable;
  final bool isSelected;
  final double? width;
  final double? height;

  const AppCard({
    super.key,
    required this.child,
    this.elevation = CardElevation.normal,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderColor,
    this.onTap,
    this.isSelectable = false,
    this.isSelected = false,
    this.width,
    this.height,
  });

  List<BoxShadow> get _shadows {
    switch (elevation) {
      case CardElevation.flat:
        return [];
      case CardElevation.normal:
        return AppShadows.shadowBlackNormal;
      case CardElevation.medium:
        return AppShadows.shadowBlackEmphasize;
      case CardElevation.strong:
        return AppShadows.shadowBlackStrong;
    }
  }

  Color get _backgroundColor {
    if (backgroundColor != null) return backgroundColor!;

    if (isSelectable) {
      return isSelected
          ? AppColor.primaryLight
          : AppColor.backgroundElevatedNormal;
    }

    return AppColor.backgroundElevatedNormal;
  }

  Color get _borderColor {
    if (borderColor != null) return borderColor!;

    if (isSelectable && isSelected) {
      return AppColor.primaryNormal;
    }

    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    final effectivePadding = padding ?? AppSpacing.cardPaddingAll;

    Widget cardChild = Padding(padding: effectivePadding, child: child);

    // If tappable, wrap with GestureDetector or InkWell
    if (onTap != null) {
      cardChild = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.cardBorder,
          child: cardChild,
        ),
      );
    }

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: AppRadius.cardBorder,
        border: Border.all(
          color: _borderColor,
          width: isSelectable && isSelected ? 2.0 : 1.0,
        ),
        boxShadow: _shadows,
      ),
      child: cardChild,
    );
  }
}

/// A specialized card for list items with consistent layout.
///
/// Usage:
/// ```dart
/// AppListCard(
///   leading: Icon(Icons.coffee),
///   title: 'Hand Drip Coffee',
///   subtitle: 'Medium roast, balanced flavor',
///   trailing: Icon(Icons.chevron_right),
///   onTap: () => _navigateToDetail(),
/// )
/// ```
class AppListCard extends StatelessWidget {
  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final bool isSelectable;
  final bool isSelected;

  const AppListCard({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.padding,
    this.isSelectable = false,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      elevation: CardElevation.flat,
      padding:
          padding ??
          EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
      onTap: onTap,
      isSelectable: isSelectable,
      isSelected: isSelected,
      child: Row(
        children: [
          if (leading != null) ...[leading!, SizedBox(width: AppSpacing.md)],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                title,
                if (subtitle != null) ...[
                  SizedBox(height: AppSpacing.xs),
                  subtitle!,
                ],
              ],
            ),
          ),
          if (trailing != null) ...[SizedBox(width: AppSpacing.md), trailing!],
        ],
      ),
    );
  }
}

/// A card with image at the top and content below.
///
/// Usage:
/// ```dart
/// AppImageCard(
///   imageUrl: 'https://example.com/image.jpg',
///   title: 'Coffee Recipe',
///   subtitle: 'Perfect hand drip method',
///   onTap: () => _viewRecipe(),
/// )
/// ```
class AppImageCard extends StatelessWidget {
  final String? imageUrl;
  final Widget? imageWidget;
  final Widget title;
  final Widget? subtitle;
  final VoidCallback? onTap;
  final double? imageHeight;
  final BoxFit imageFit;

  const AppImageCard({
    super.key,
    this.imageUrl,
    this.imageWidget,
    required this.title,
    this.subtitle,
    this.onTap,
    this.imageHeight = 120,
    this.imageFit = BoxFit.cover,
  }) : assert(
         imageUrl != null || imageWidget != null,
         'Either imageUrl or imageWidget must be provided',
       );

  @override
  Widget build(BuildContext context) {
    Widget imageContent;

    if (imageWidget != null) {
      imageContent = SizedBox(
        height: imageHeight,
        width: double.infinity,
        child: imageWidget,
      );
    } else if (imageUrl != null) {
      imageContent = ClipRRect(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.card),
        ),
        child: CachedNetworkImage(
          imageUrl: imageUrl!,
          height: imageHeight,
          width: double.infinity,
          fit: imageFit,
          placeholder: (context, url) => Container(
            height: imageHeight,
            width: double.infinity,
            color: AppColor.componentFillNormal,
            child: const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            height: imageHeight,
            width: double.infinity,
            color: AppColor.componentFillNormal,
            child: Icon(
              Icons.broken_image_outlined,
              color: AppColor.labelAlternative,
              size: 32,
            ),
          ),
        ),
      );
    } else {
      imageContent = Container(
        height: imageHeight,
        width: double.infinity,
        color: AppColor.componentFillNormal,
      );
    }

    return AppCard(
      elevation: CardElevation.normal,
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          imageContent,
          Padding(
            padding: AppSpacing.cardPaddingAll,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title,
                if (subtitle != null) ...[
                  SizedBox(height: AppSpacing.xs),
                  subtitle!,
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
