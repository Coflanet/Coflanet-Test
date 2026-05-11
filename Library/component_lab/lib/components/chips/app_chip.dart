import 'package:flutter/material.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_color_theme.dart';
import '../../foundation/app_radius.dart';
import '../../foundation/app_text_style.dart';
import '../../foundation/app_spacing.dart';

/// Chip color — Figma Accent Background 9개 + neutral.
enum AppChipColor {
  neutral,
  primary,
  red,
  orange,
  yellow,
  lime,
  green,
  cyan,
  lightBlue,
  blue,
  pink,
  violet,
  brown,
}

/// Chip size.
enum AppChipTagSize { sm, md }

/// 디자인 시스템 Chip / Tag.
///
/// Accent 컬러군을 의미적 라벨링에 활용 (예: 카테고리, 상태, 태그).
class AppChip extends StatelessWidget {
  final String label;
  final AppChipColor color;
  final AppChipTagSize size;
  final IconData? leadingIcon;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const AppChip({
    super.key,
    required this.label,
    this.color = AppChipColor.neutral,
    this.size = AppChipTagSize.md,
    this.leadingIcon,
    this.onTap,
    this.onDelete,
  });

  ({Color bg, Color fg}) _colors(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final c = context.appColors;

    Color bgFor(Color light, Color dark) => isDark ? dark : light;

    switch (color) {
      case AppChipColor.neutral:
        return (bg: c.componentFillNormal, fg: c.labelNormal);
      case AppChipColor.primary:
        return (bg: c.primaryLight, fg: c.primaryNormal);
      case AppChipColor.red:
        return (
          bg: bgFor(AppColor.colorGlobalRed95, AppColor.colorGlobalRed20),
          fg: c.accentForegroundRed,
        );
      case AppChipColor.orange:
        return (
          bg: bgFor(
              AppColor.colorGlobalOrange95, AppColor.colorGlobalOrange20),
          fg: c.accentForegroundOrange,
        );
      case AppChipColor.yellow:
        return (
          bg: bgFor(
              AppColor.colorGlobalYellow95, AppColor.colorGlobalYellow20),
          fg: c.accentForegroundYellow,
        );
      case AppChipColor.lime:
        return (
          bg: bgFor(AppColor.colorGlobalLime95, AppColor.colorGlobalLime20),
          fg: c.accentForegroundLime,
        );
      case AppChipColor.green:
        return (
          bg: bgFor(
              AppColor.colorGlobalGreen95, AppColor.colorGlobalGreen20),
          fg: c.accentForegroundGreen,
        );
      case AppChipColor.cyan:
        return (
          bg: bgFor(AppColor.colorGlobalCyan95, AppColor.colorGlobalCyan20),
          fg: c.accentForegroundCyan,
        );
      case AppChipColor.lightBlue:
        return (
          bg: bgFor(AppColor.colorGlobalLightBlue95,
              AppColor.colorGlobalLightBlue20),
          fg: c.accentForegroundLightBlue,
        );
      case AppChipColor.blue:
        return (
          bg: bgFor(AppColor.colorGlobalBlue95, AppColor.colorGlobalBlue20),
          fg: c.accentForegroundBlue,
        );
      case AppChipColor.pink:
        return (
          bg: bgFor(AppColor.colorGlobalPink95, AppColor.colorGlobalPink20),
          fg: c.accentForegroundPink,
        );
      case AppChipColor.violet:
        return (
          bg: bgFor(
              AppColor.colorGlobalViolet95, AppColor.colorGlobalViolet20),
          fg: c.accentForegroundViolet,
        );
      case AppChipColor.brown:
        return (
          bg: AppColor.accentBackgroundBrownLight,
          fg: c.accentBackgroundBrown,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = _colors(context);
    final isSm = size == AppChipTagSize.sm;
    final padding = isSm
        ? const EdgeInsets.symmetric(
            horizontal: AppSpacing.space8, vertical: AppSpacing.space4)
        : const EdgeInsets.symmetric(
            horizontal: AppSpacing.space12, vertical: 6);
    final textStyle =
        isSm ? AppTextStyles.caption2Medium : AppTextStyles.label2Medium;
    final iconSize = isSm ? 12.0 : 14.0;

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (leadingIcon != null) ...[
          Icon(leadingIcon, size: iconSize, color: colors.fg),
          SizedBox(width: isSm ? 4 : AppSpacing.space4),
        ],
        Text(label, style: textStyle.copyWith(color: colors.fg)),
        if (onDelete != null) ...[
          SizedBox(width: isSm ? 4 : AppSpacing.space4),
          // Tap target 보강 — 시각 아이콘은 작지만 hit-test 영역은 24×24 이상.
          Semantics(
            label: '$label 삭제',
            button: true,
            onTap: onDelete,
            excludeSemantics: true,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onDelete,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.space4),
                child: Icon(Icons.close_rounded,
                    size: iconSize, color: colors.fg),
              ),
            ),
          ),
        ],
      ],
    );

    // Figma cornerRadius: sm=8, md=10
    final chipRadius = isSm ? AppRadius.radius8Border : AppRadius.radius10Border;

    final body = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: colors.bg,
        borderRadius: chipRadius,
      ),
      child: content,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: chipRadius,
          child: body,
        ),
      );
    }
    return body;
  }
}
