import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';

/// Flavor tag style variants.
enum FlavorTagStyle {
  /// Primary style with purple background
  primary,

  /// Secondary style with gray background
  secondary,

  /// Outlined style with border
  outlined,

  /// Compact style for smaller spaces
  compact,
}

/// A reusable flavor tag chip widget.
///
/// Usage:
/// ```dart
/// FlavorTag(label: '과일 향')
/// FlavorTag(label: '다크초콜릿', style: FlavorTagStyle.secondary)
/// FlavorTag(label: '자스민', onTap: () => print('tapped'))
/// ```
class FlavorTag extends StatelessWidget {
  /// The tag label text
  final String label;

  /// Tag style variant
  final FlavorTagStyle style;

  /// Whether the tag is selected (for selectable tags)
  final bool isSelected;

  /// Optional tap callback
  final VoidCallback? onTap;

  /// Optional delete callback (shows delete icon when provided)
  final VoidCallback? onDelete;

  /// Optional leading icon
  final IconData? icon;

  const FlavorTag({
    super.key,
    required this.label,
    this.style = FlavorTagStyle.primary,
    this.isSelected = false,
    this.onTap,
    this.onDelete,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: _getPadding(),
        decoration: BoxDecoration(
          color: _getBackgroundColor(),
          borderRadius: _getBorderRadius(),
          border: _getBorder(),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: _getIconSize(), color: _getTextColor()),
              SizedBox(width: style == FlavorTagStyle.compact ? 4 : 6),
            ],
            Text(label, style: _getTextStyle()),
            if (onDelete != null) ...[
              SizedBox(width: style == FlavorTagStyle.compact ? 4 : 6),
              GestureDetector(
                onTap: onDelete,
                child: Icon(
                  Icons.close,
                  size: _getIconSize(),
                  color: _getTextColor().withOpacity(0.7),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  EdgeInsets _getPadding() {
    switch (style) {
      case FlavorTagStyle.compact:
        return const EdgeInsets.symmetric(horizontal: 10, vertical: 5);
      case FlavorTagStyle.primary:
      case FlavorTagStyle.secondary:
      case FlavorTagStyle.outlined:
        return const EdgeInsets.symmetric(horizontal: 14, vertical: 8);
    }
  }

  BorderRadius _getBorderRadius() {
    return AppRadius.xxxlBorder;
  }

  Color _getBackgroundColor() {
    if (isSelected) {
      return AppColor.primaryNormal;
    }

    switch (style) {
      case FlavorTagStyle.primary:
        return AppColor.primaryNormal.withOpacity(0.12);
      case FlavorTagStyle.secondary:
        return AppColor.componentFillNormal;
      case FlavorTagStyle.outlined:
        return Colors.transparent;
      case FlavorTagStyle.compact:
        return AppColor.primaryNormal.withOpacity(0.08);
    }
  }

  Border? _getBorder() {
    if (isSelected) {
      return Border.all(color: AppColor.primaryNormal, width: 2);
    }

    switch (style) {
      case FlavorTagStyle.primary:
        return Border.all(
          color: AppColor.primaryNormal.withOpacity(0.3),
          width: 1,
        );
      case FlavorTagStyle.secondary:
        return Border.all(color: AppColor.lineNormalNormal, width: 1);
      case FlavorTagStyle.outlined:
        return Border.all(color: AppColor.lineNormalNormal, width: 1);
      case FlavorTagStyle.compact:
        return null;
    }
  }

  Color _getTextColor() {
    if (isSelected) {
      return AppColor.staticLabelWhiteStrong;
    }

    switch (style) {
      case FlavorTagStyle.primary:
      case FlavorTagStyle.compact:
        return AppColor.primaryNormal;
      case FlavorTagStyle.secondary:
      case FlavorTagStyle.outlined:
        return AppColor.labelNormal;
    }
  }

  TextStyle _getTextStyle() {
    final color = _getTextColor();

    switch (style) {
      case FlavorTagStyle.compact:
        return AppTextStyles.caption1Medium.copyWith(color: color);
      case FlavorTagStyle.primary:
      case FlavorTagStyle.secondary:
      case FlavorTagStyle.outlined:
        return AppTextStyles.label1NormalMedium.copyWith(color: color);
    }
  }

  double _getIconSize() {
    switch (style) {
      case FlavorTagStyle.compact:
        return 12;
      case FlavorTagStyle.primary:
      case FlavorTagStyle.secondary:
      case FlavorTagStyle.outlined:
        return 14;
    }
  }
}

/// A group of flavor tags with optional selection support.
class FlavorTagGroup extends StatelessWidget {
  /// List of tag labels
  final List<String> tags;

  /// Currently selected tag labels (for multi-select)
  final Set<String>? selectedTags;

  /// Currently selected tag label (for single-select)
  final String? selectedTag;

  /// Tag style variant
  final FlavorTagStyle style;

  /// Callback when a tag is tapped
  final ValueChanged<String>? onTagTap;

  /// Horizontal spacing between tags
  final double spacing;

  /// Vertical spacing between rows
  final double runSpacing;

  /// Whether tags can be deleted
  final bool showDelete;

  /// Callback when delete is tapped
  final ValueChanged<String>? onDelete;

  const FlavorTagGroup({
    super.key,
    required this.tags,
    this.selectedTags,
    this.selectedTag,
    this.style = FlavorTagStyle.primary,
    this.onTagTap,
    this.spacing = 8,
    this.runSpacing = 8,
    this.showDelete = false,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      children: tags.map((tag) {
        final isSelected =
            selectedTags?.contains(tag) == true || selectedTag == tag;

        return FlavorTag(
          label: tag,
          style: style,
          isSelected: isSelected,
          onTap: onTagTap != null ? () => onTagTap!(tag) : null,
          onDelete: showDelete && onDelete != null
              ? () => onDelete!(tag)
              : null,
        );
      }).toList(),
    );
  }
}

/// Predefined flavor tag categories for coffee.
class FlavorCategories {
  FlavorCategories._();

  /// Common flavor descriptors (공통 향미)
  static const List<String> common = [
    '과일 향',
    '꽃 향',
    '견과류',
    '초콜릿',
    '캐러멜',
    '허브',
    '스파이스',
    '와인',
  ];

  /// Characteristic flavor descriptors (특성 향미)
  static const List<String> characteristic = [
    '자스민',
    '베리',
    '시트러스',
    '복숭아',
    '사과',
    '자몽',
    '레몬',
    '오렌지',
    '블루베리',
    '라즈베리',
    '체리',
    '자두',
    '다크초콜릿',
    '밀크초콜릿',
    '코코아',
    '헤이즐넛',
    '아몬드',
    '캐러멜',
    '바닐라',
    '꿀',
    '브라운슈거',
    '로스팅 향',
    '스모키',
    '흙 향',
    '시더우드',
  ];

  /// All flavor descriptors combined
  static List<String> get all => [...common, ...characteristic];
}
