import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';

/// Chip variants for different styles
enum ChipVariant {
  /// Outlined chip with border
  outlined,

  /// Filled chip with background color
  filled,

  /// Minimal chip with no background or border
  minimal,
}

/// Chip size variants
enum ChipSize {
  /// Small: height 28px, text caption1Medium
  sm,

  /// Medium: height 32px, text label1NormalMedium (default)
  md,

  /// Large: height 36px, text label1NormalBold
  lg,
}

/// A versatile chip component following design system.
///
/// Usage:
/// ```dart
/// // Basic outlined chip
/// AppChip(
///   label: 'Hand Drip',
/// )
///
/// // Filled chip with icon
/// AppChip(
///   label: 'Espresso',
///   variant: ChipVariant.filled,
///   avatar: Icon(Icons.coffee, size: 16),
///   onDeleted: () => _removeChip(),
/// )
///
/// // Clickable chip
/// AppChip(
///   label: 'Cold Brew',
///   onTap: () => _selectChip(),
///   isSelected: true,
/// )
/// ```
class AppChip extends StatelessWidget {
  final String label;
  final ChipVariant variant;
  final ChipSize size;
  final Widget? avatar;
  final VoidCallback? onTap;
  final VoidCallback? onDeleted;
  final bool isSelected;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isEnabled;

  const AppChip({
    super.key,
    required this.label,
    this.variant = ChipVariant.outlined,
    this.size = ChipSize.md,
    this.avatar,
    this.onTap,
    this.onDeleted,
    this.isSelected = false,
    this.backgroundColor,
    this.textColor,
    this.isEnabled = true,
  });

  double get _height {
    switch (size) {
      case ChipSize.sm:
        return 28;
      case ChipSize.md:
        return 32;
      case ChipSize.lg:
        return 36;
    }
  }

  TextStyle get _textStyle {
    switch (size) {
      case ChipSize.sm:
        return AppTextStyles.caption1Medium;
      case ChipSize.md:
        return AppTextStyles.label1NormalMedium;
      case ChipSize.lg:
        return AppTextStyles.label1NormalBold;
    }
  }

  double get _avatarSize {
    switch (size) {
      case ChipSize.sm:
        return 16;
      case ChipSize.md:
        return 18;
      case ChipSize.lg:
        return 20;
    }
  }

  EdgeInsets get _padding {
    switch (size) {
      case ChipSize.sm:
        return EdgeInsets.symmetric(
          horizontal: AppSpacing.space8,
          vertical: AppSpacing.space4,
        );
      case ChipSize.md:
        return EdgeInsets.symmetric(
          horizontal: AppSpacing.space10,
          vertical: AppSpacing.space6,
        );
      case ChipSize.lg:
        return EdgeInsets.symmetric(
          horizontal: AppSpacing.space12,
          vertical: AppSpacing.space8,
        );
    }
  }

  Color get _backgroundColor {
    if (backgroundColor != null) return backgroundColor!;

    switch (variant) {
      case ChipVariant.outlined:
        return isSelected && isEnabled
            ? AppColor.primaryNormal
            : Colors.transparent;
      case ChipVariant.filled:
        return isSelected && isEnabled
            ? AppColor.primaryNormal
            : AppColor.componentFillNormal;
      case ChipVariant.minimal:
        return Colors.transparent;
    }
  }

  Color get _textColor {
    if (textColor != null) return textColor!;

    switch (variant) {
      case ChipVariant.outlined:
        return isSelected && isEnabled
            ? AppColor.staticLabelWhiteStrong
            : isEnabled
            ? AppColor.labelNormal
            : AppColor.labelDisable;
      case ChipVariant.filled:
        return isSelected && isEnabled
            ? AppColor.staticLabelWhiteStrong
            : isEnabled
            ? AppColor.labelNormal
            : AppColor.labelDisable;
      case ChipVariant.minimal:
        return isEnabled ? AppColor.labelAlternative : AppColor.labelDisable;
    }
  }

  Color get _borderColor {
    switch (variant) {
      case ChipVariant.outlined:
        return isSelected && isEnabled
            ? AppColor.primaryNormal
            : AppColor.lineNormalNormal;
      case ChipVariant.filled:
      case ChipVariant.minimal:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveAvatar = avatar;

    Widget chipContent = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (effectiveAvatar != null) ...[
          effectiveAvatar,
          SizedBox(width: AppSpacing.space4),
        ],
        Flexible(
          child: Text(
            label,
            style: _textStyle.copyWith(color: _textColor),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (onDeleted != null) ...[
          SizedBox(width: AppSpacing.space4),
          _buildDeleteButton(),
        ],
      ],
    );

    Widget chip = Container(
      height: _height,
      padding: _padding,
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: AppRadius.chipBorder,
        border: Border.all(color: _borderColor, width: 1),
      ),
      child: chipContent,
    );

    if (onTap != null && isEnabled) {
      chip = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.chipBorder,
          child: chip,
        ),
      );
    }

    return chip;
  }

  Widget _buildDeleteButton() {
    return GestureDetector(
      onTap: onDeleted,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.space2),
        child: Icon(
          Icons.close_rounded,
          size: _avatarSize * 0.8,
          color: _textColor,
        ),
      ),
    );
  }
}

/// A chip that uses a circle avatar with initials or image.
///
/// Usage:
/// ```dart
/// AppAvatarChip(
///   name: 'John Doe',
///   imageUrl: 'https://example.com/avatar.jpg',
///   onTap: () => _viewProfile(),
/// )
/// ```
class AppAvatarChip extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final VoidCallback? onTap;
  final VoidCallback? onDeleted;
  final ChipSize size;
  final bool isSelected;

  const AppAvatarChip({
    super.key,
    required this.name,
    this.imageUrl,
    this.onTap,
    this.onDeleted,
    this.size = ChipSize.md,
    this.isSelected = false,
  });

  String get _initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty) {
      return parts[0].substring(0, 1).toUpperCase();
    }
    return '?';
  }

  double get _avatarSize {
    switch (size) {
      case ChipSize.sm:
        return 20;
      case ChipSize.md:
        return 24;
      case ChipSize.lg:
        return 28;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget avatar;

    if (imageUrl != null) {
      avatar = CircleAvatar(
        radius: _avatarSize / 2,
        backgroundImage: NetworkImage(imageUrl!),
        backgroundColor: AppColor.componentFillNormal,
        child: imageUrl == null
            ? Text(
                _initials,
                style: AppTextStyles.caption1Medium.copyWith(
                  color: AppColor.labelAlternative,
                ),
              )
            : null,
      );
    } else {
      avatar = CircleAvatar(
        radius: _avatarSize / 2,
        backgroundColor: AppColor.primaryLight,
        child: Text(
          _initials,
          style: AppTextStyles.caption1Medium.copyWith(
            color: AppColor.primaryNormal,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return AppChip(
      label: name,
      variant: ChipVariant.outlined,
      size: size,
      avatar: avatar,
      onTap: onTap,
      onDeleted: onDeleted,
      isSelected: isSelected,
    );
  }
}

/// A filter chip for selection states.
///
/// Usage:
/// ```dart
/// AppFilterChip(
///   label: 'Arabica',
///   onTap: () => _toggleFilter('Arabica'),
///   isSelected: _selectedFilters.contains('Arabica'),
/// )
/// ```
class AppFilterChip extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isSelected;
  final ChipSize size;

  const AppFilterChip({
    super.key,
    required this.label,
    this.onTap,
    this.isSelected = false,
    this.size = ChipSize.md,
  });

  @override
  Widget build(BuildContext context) {
    return AppChip(
      label: label,
      variant: isSelected ? ChipVariant.filled : ChipVariant.outlined,
      size: size,
      onTap: onTap,
      isSelected: isSelected,
    );
  }
}
