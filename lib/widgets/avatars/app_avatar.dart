import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';

/// Avatar size variants
enum AvatarSize {
  /// Extra small: 24px
  xs,

  /// Small: 32px
  sm,

  /// Medium: 40px
  md,

  /// Large: 48px
  lg,

  /// Extra large: 56px
  xl,

  /// Extra extra large: 80px
  xxl,
}

/// A versatile avatar component following design system.
///
/// Usage:
/// ```dart
/// // Basic avatar with initials
/// AppAvatar(
///   name: 'John Doe',
/// )
///
/// // Avatar with network image
/// AppAvatar(
///   name: 'Jane Smith',
///   imageUrl: 'https://example.com/avatar.jpg',
///   size: AvatarSize.lg,
/// )
///
/// // Avatar with custom background
/// AppAvatar(
///   name: 'Coffee Lover',
///   backgroundColor: AppColor.primaryLight,
///   textColor: AppColor.primaryNormal,
/// )
///
/// // Avatar with custom widget
/// AppAvatar.custom(
///   child: Icon(Icons.coffee),
///   size: AvatarSize.md,
/// )
/// ```
class AppAvatar extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final AvatarSize size;
  final Color? backgroundColor;
  final Color? textColor;
  final VoidCallback? onTap;
  final Widget? customChild;
  final bool showBorder;
  final Color? borderColor;

  const AppAvatar({
    super.key,
    required this.name,
    this.imageUrl,
    this.size = AvatarSize.md,
    this.backgroundColor,
    this.textColor,
    this.onTap,
    this.customChild,
    this.showBorder = false,
    this.borderColor,
  });

  const AppAvatar.custom({
    super.key,
    required Widget child,
    this.size = AvatarSize.md,
    this.backgroundColor,
    this.onTap,
    this.showBorder = false,
    this.borderColor,
  }) : name = '',
       imageUrl = null,
       textColor = null,
       customChild = child;

  double get _size {
    switch (size) {
      case AvatarSize.xs:
        return 24;
      case AvatarSize.sm:
        return 32;
      case AvatarSize.md:
        return 40;
      case AvatarSize.lg:
        return 48;
      case AvatarSize.xl:
        return 56;
      case AvatarSize.xxl:
        return 80;
    }
  }

  double get _fontSize {
    switch (size) {
      case AvatarSize.xs:
        return 10;
      case AvatarSize.sm:
        return 12;
      case AvatarSize.md:
        return 14;
      case AvatarSize.lg:
        return 16;
      case AvatarSize.xl:
        return 18;
      case AvatarSize.xxl:
        return 24;
    }
  }

  String get _initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty) {
      return parts[0].substring(0, 1).toUpperCase();
    }
    return '?';
  }

  Color get _backgroundColor {
    if (backgroundColor != null) return backgroundColor!;

    // Generate consistent background color based on name
    if (name.isNotEmpty) {
      final hash = name.hashCode;
      final colors = [
        AppColor.primaryLight,
        AppColor.statusPositive,
        AppColor.statusCautionary,
        AppColor.accentBackgroundBlue,
        AppColor.accentBackgroundPink,
        AppColor.accentBackgroundCyan,
      ];
      return colors[hash.abs() % colors.length];
    }

    return AppColor.componentFillNormal;
  }

  Color get _textColor {
    if (textColor != null) return textColor!;
    return AppColor.staticLabelWhiteStrong;
  }

  Color get _borderColor {
    return borderColor ?? AppColor.backgroundElevatedNormal;
  }

  @override
  Widget build(BuildContext context) {
    Widget avatarChild;

    if (customChild != null) {
      avatarChild = customChild!;
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      avatarChild = CachedNetworkImage(
        imageUrl: imageUrl!,
        width: _size,
        height: _size,
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildPlaceholder(),
        errorWidget: (context, url, error) => _buildPlaceholder(),
        imageBuilder: (context, imageProvider) => CircleAvatar(
          radius: _size / 2,
          backgroundImage: imageProvider,
          backgroundColor: Colors.transparent,
        ),
      );
    } else {
      avatarChild = _buildInitials();
    }

    Widget avatar = CircleAvatar(
      radius: _size / 2,
      backgroundColor: imageUrl != null ? Colors.transparent : _backgroundColor,
      child: imageUrl != null ? null : avatarChild,
    );

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      avatar = ClipOval(child: avatarChild);
    }

    if (showBorder) {
      avatar = Container(
        width: _size + 4,
        height: _size + 4,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: _borderColor, width: 2),
        ),
        child: avatar,
      );
    }

    if (onTap != null) {
      avatar = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(_size / 2),
          child: avatar,
        ),
      );
    }

    return Container(
      width: _size + (showBorder ? 4 : 0),
      height: _size + (showBorder ? 4 : 0),
      child: avatar,
    );
  }

  Widget _buildInitials() {
    return Text(
      _initials,
      style: TextStyle(
        fontSize: _fontSize,
        fontWeight: FontWeight.w600,
        color: _textColor,
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(
        color: AppColor.componentFillNormal,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.person_outline,
        size: _size * 0.5,
        color: AppColor.labelAlternative,
      ),
    );
  }
}

/// An avatar with online status indicator.
///
/// Usage:
/// ```dart
/// AppAvatarWithStatus(
///   name: 'John Doe',
///   imageUrl: 'https://example.com/avatar.jpg',
///   isOnline: true,
///   onTap: () => _viewProfile(),
/// )
/// ```
class AppAvatarWithStatus extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final AvatarSize size;
  final bool isOnline;
  final VoidCallback? onTap;
  final bool showBorder;

  const AppAvatarWithStatus({
    super.key,
    required this.name,
    this.imageUrl,
    this.size = AvatarSize.md,
    this.isOnline = false,
    this.onTap,
    this.showBorder = false,
  });

  double get _statusDotSize {
    switch (size) {
      case AvatarSize.xs:
      case AvatarSize.sm:
        return 8;
      case AvatarSize.md:
      case AvatarSize.lg:
        return 10;
      case AvatarSize.xl:
      case AvatarSize.xxl:
        return 12;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AppAvatar(
          name: name,
          imageUrl: imageUrl,
          size: size,
          onTap: onTap,
          showBorder: showBorder,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: _statusDotSize,
            height: _statusDotSize,
            decoration: BoxDecoration(
              color: isOnline ? AppColor.statusPositive : AppColor.labelNeutral,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColor.backgroundElevatedNormal,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// A group of avatars for showing multiple users.
///
/// Usage:
/// ```dart
/// AppAvatarGroup(
///   avatars: [
///     AppAvatarData(name: 'John Doe', imageUrl: '...'),
///     AppAvatarData(name: 'Jane Smith', imageUrl: '...'),
///     AppAvatarData(name: 'Bob Johnson'),
///   ],
///   maxAvatars: 3,
///   size: AvatarSize.sm,
///   totalCount: 5,
/// )
/// ```
class AppAvatarData {
  final String name;
  final String? imageUrl;
  final VoidCallback? onTap;

  const AppAvatarData({required this.name, this.imageUrl, this.onTap});
}

class AppAvatarGroup extends StatelessWidget {
  final List<AppAvatarData> avatars;
  final AvatarSize size;
  final int maxAvatars;
  final int? totalCount;
  final double spacing;

  const AppAvatarGroup({
    super.key,
    required this.avatars,
    this.size = AvatarSize.sm,
    this.maxAvatars = 3,
    this.totalCount,
    this.spacing = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    final displayedAvatars = avatars.take(maxAvatars).toList();
    final totalItems = totalCount ?? avatars.length;
    final hasMore = totalItems > maxAvatars;

    return Row(
      children: [
        ...displayedAvatars.asMap().entries.map((entry) {
          final index = entry.key;
          final avatarData = entry.value;

          return Padding(
            padding: EdgeInsets.only(left: index > 0 ? spacing : 0),
            child: AppAvatar(
              name: avatarData.name,
              imageUrl: avatarData.imageUrl,
              size: size,
              onTap: avatarData.onTap,
              showBorder: true,
            ),
          );
        }).toList(),
        if (hasMore) ...[SizedBox(width: spacing), _buildMoreIndicator()],
      ],
    );
  }

  Widget _buildMoreIndicator() {
    final totalItems = totalCount ?? avatars.length;
    final moreCount = totalItems - maxAvatars;

    return Container(
      width: _getAvatarSize(),
      height: _getAvatarSize(),
      decoration: BoxDecoration(
        color: AppColor.componentFillNormal,
        shape: BoxShape.circle,
        border: Border.all(color: AppColor.backgroundElevatedNormal, width: 2),
      ),
      child: Center(
        child: Text(
          '+$moreCount',
          style: AppTextStyles.caption2Medium.copyWith(
            color: AppColor.labelAlternative,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  double _getAvatarSize() {
    switch (size) {
      case AvatarSize.xs:
        return 24;
      case AvatarSize.sm:
        return 32;
      case AvatarSize.md:
        return 40;
      case AvatarSize.lg:
        return 48;
      case AvatarSize.xl:
        return 56;
      case AvatarSize.xxl:
        return 80;
    }
  }
}
