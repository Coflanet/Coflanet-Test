import 'package:flutter/material.dart';

import '../../foundation/app_color.dart';

/// Play Icon Badge 사이즈 — Figma `Contents/Play Icon Badge` size.
enum AppPlayIconBadgeSize {
  /// 24px
  small(24, 10),

  /// 32px (default)
  medium(32, 14),

  /// 48px
  large(48, 18);

  const AppPlayIconBadgeSize(this.diameter, this.iconSize);
  final double diameter;
  final double iconSize;
}

/// Play Icon Badge 변형 — Figma `Contents/Play Icon Badge` alternative.
enum AppPlayIconBadgeVariant {
  /// false (default) — 옅은 회색 배경
  normal,

  /// true — 짙은 회색 배경
  alternative,
}

/// Play Icon Badge — Figma `Contents/Play Icon Badge`.
///
/// 미디어 콘텐츠 위에 얹어 재생 가능함을 알리는 원형 배지.
/// Figma variant: size (small/medium/large) × alternative (false/true).
class AppPlayIconBadge extends StatelessWidget {
  const AppPlayIconBadge({
    super.key,
    this.size = AppPlayIconBadgeSize.medium,
    this.variant = AppPlayIconBadgeVariant.normal,
    this.onTap,
  });

  final AppPlayIconBadgeSize size;
  final AppPlayIconBadgeVariant variant;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isAlt = variant == AppPlayIconBadgeVariant.alternative;
    final bg = isAlt
        ? AppColor.colorGlobalCoolNeutral60
        : AppColor.colorGlobalCoolNeutral90;
    final fg = isAlt
        ? AppColor.colorGlobalCoolNeutral99
        : AppColor.colorGlobalCoolNeutral40;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: size.diameter,
        height: size.diameter,
        decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.only(left: 2),
          child: Icon(Icons.play_arrow_rounded, size: size.iconSize, color: fg),
        ),
      ),
    );
  }
}
