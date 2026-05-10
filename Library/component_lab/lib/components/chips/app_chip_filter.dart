import 'package:flutter/material.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_text_style.dart';
import 'app_chip_action.dart' show AppChipSize;

export 'app_chip_action.dart' show AppChipSize;

/// Filter Chip variant — Figma `Chip/Filter` 2종.
enum AppChipFilterVariant { solid, outlined }

/// Filter Chip 상태(chevron 방향).
enum AppChipFilterState { normal, expand }

/// Filter Chip — Figma `Chip/Filter`.
///
/// 항상 trailing chevron 아이콘을 가짐.
/// `count`가 null이 아니고 `isActive`일 때 라벨 우측에 SemiBold 카운트 표시.
///
/// Figma boundVariables 기반 정확한 매핑:
///
/// 사이즈별 수치:
/// - XSmall: cornerRadius=6, padL=7 padR=5, padV=4, contentGap=1, wrapperGap=3, wrapperPadH=1, icon=12, font=caption1 (12px)
/// - Small : cornerRadius=8, padL=8 padR=6, padV=6, contentGap=1, wrapperGap=4, wrapperPadH=2, icon=16, font=label1Normal (14px)
/// - Medium: cornerRadius=10, padL=11 padR=9, padV=7, contentGap=2, wrapperGap=4, wrapperPadH=2, icon=16, font=body2Normal (15px)
/// - Large : cornerRadius=10, padL=12 padR=10, padV=9, contentGap=2, wrapperGap=4, wrapperPadH=2, icon=16, font=body2Normal (15px)
///
/// 색상 매핑 (Solid):
/// - Default: bg `Component/fill/alternative`, text `Label/normal`
/// - Active : bg `Inverse/backgruond`, text `Inverse/label/normal`
/// - Disable: bg `interaction/disable`, text `Label/disable`
///
/// 색상 매핑 (Outline):
/// - Default: stroke `line/normal/neutral`, text `Label/normal`
/// - Active : fill `Primary/normal` @ `Opacity/5`, stroke `Primary/normal` @ `Opacity/43`, text `Primary/normal`
/// - Disable: stroke `line/normal/neutral`, text `Label/disable`
class AppChipFilter extends StatelessWidget {
  final String label;
  final AppChipSize size;
  final AppChipFilterVariant variant;
  final AppChipFilterState state;
  final bool isActive;
  final int? count;
  final VoidCallback? onPressed;

  const AppChipFilter({
    super.key,
    required this.label,
    this.size = AppChipSize.xsmall,
    this.variant = AppChipFilterVariant.solid,
    this.state = AppChipFilterState.normal,
    this.isActive = false,
    this.count,
    this.onPressed,
  });

  bool get _enabled => onPressed != null;

  ({
    double padL,
    double padR,
    double padV,
    double contentGap,
    double wrapperGap,
    double wrapperPadH,
    double iconSize,
    double cornerRadius,
    TextStyle textStyle,
    TextStyle countStyle,
  }) get _metrics {
    switch (size) {
      case AppChipSize.xsmall:
        return (
          padL: 7,
          padR: 5,
          padV: 4,
          contentGap: 1,
          wrapperGap: 3,
          wrapperPadH: 1,
          iconSize: 12,
          cornerRadius: 6,
          textStyle: AppTextStyles.caption1Medium,
          countStyle: AppTextStyles.caption1Bold,
        );
      case AppChipSize.small:
        return (
          padL: 8,
          padR: 6,
          padV: 6,
          contentGap: 1,
          wrapperGap: 4,
          wrapperPadH: 2,
          iconSize: 16,
          cornerRadius: 8,
          textStyle: AppTextStyles.label1NormalMedium,
          countStyle: AppTextStyles.label1NormalBold,
        );
      case AppChipSize.medium:
        return (
          padL: 11,
          padR: 9,
          padV: 7,
          contentGap: 2,
          wrapperGap: 4,
          wrapperPadH: 2,
          iconSize: 16,
          cornerRadius: 10,
          textStyle: AppTextStyles.body2NormalMedium,
          countStyle: AppTextStyles.body2NormalBold,
        );
      case AppChipSize.large:
        return (
          padL: 12,
          padR: 10,
          padV: 9,
          contentGap: 2,
          wrapperGap: 4,
          wrapperPadH: 2,
          iconSize: 16,
          cornerRadius: 10,
          textStyle: AppTextStyles.body2NormalMedium,
          countStyle: AppTextStyles.body2NormalBold,
        );
    }
  }

  ({Color bg, Color fg, BorderSide? side}) _colors(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (!_enabled) {
      if (variant == AppChipFilterVariant.solid) {
        return (
          bg: isDark
              ? AppColor.darkInteractionDisable
              : AppColor.interactionDisable,
          fg: isDark ? AppColor.darkLabelDisable : AppColor.labelDisable,
          side: null,
        );
      }
      return (
        bg: const Color(0x00000000),
        fg: isDark ? AppColor.darkLabelDisable : AppColor.labelDisable,
        side: BorderSide(
          color: isDark
              ? AppColor.darkLineNormalNeutral
              : AppColor.lineNormalNeutral,
          width: 1,
        ),
      );
    }

    if (isActive) {
      if (variant == AppChipFilterVariant.solid) {
        return (
          bg: isDark
              ? AppColor.darkInverseBackground
              : AppColor.inverseBackground,
          fg: isDark
              ? AppColor.darkInverseLabelNormal
              : AppColor.inverseLabelNormal,
          side: null,
        );
      }
      // Outline Active: fill Primary/normal @ Opacity/5, stroke Primary/normal @ Opacity/43
      final primary =
          isDark ? AppColor.darkPrimaryNormal : AppColor.primaryNormal;
      return (
        bg: primary.withValues(alpha: 0.05),
        fg: primary,
        side: BorderSide(
          color: primary.withValues(alpha: 0.43),
          width: 1,
        ),
      );
    }

    // Default
    if (variant == AppChipFilterVariant.solid) {
      return (
        bg: isDark
            ? AppColor.darkComponentFillAlternative
            : AppColor.componentFillAlternative,
        fg: isDark ? AppColor.darkLabelNormal : AppColor.labelNormal,
        side: null,
      );
    }
    return (
      bg: const Color(0x00000000),
      fg: isDark ? AppColor.darkLabelNormal : AppColor.labelNormal,
      side: BorderSide(
        color: isDark
            ? AppColor.darkLineNormalNeutral
            : AppColor.lineNormalNeutral,
        width: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final m = _metrics;
    final c = _colors(context);
    final borderRadius = BorderRadius.circular(m.cornerRadius);
    final shape = RoundedRectangleBorder(
      borderRadius: borderRadius,
      side: c.side ?? BorderSide.none,
    );

    final wrapperChildren = <Widget>[
      Padding(
        padding: EdgeInsets.symmetric(horizontal: m.wrapperPadH),
        child: Text(label, style: m.textStyle.copyWith(color: c.fg)),
      ),
      if (count != null && isActive) ...[
        SizedBox(width: m.wrapperGap),
        Text('$count', style: m.countStyle.copyWith(color: c.fg)),
      ],
    ];

    final chevron = Icon(
      state == AppChipFilterState.expand
          ? Icons.keyboard_arrow_up_rounded
          : Icons.keyboard_arrow_down_rounded,
      size: m.iconSize,
      color: c.fg,
    );

    return Material(
      color: c.bg,
      shape: shape,
      child: InkWell(
        onTap: onPressed,
        customBorder: shape,
        child: Padding(
          padding: EdgeInsets.only(
            left: m.padL,
            right: m.padR,
            top: m.padV,
            bottom: m.padV,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(mainAxisSize: MainAxisSize.min, children: wrapperChildren),
              SizedBox(width: m.contentGap),
              chevron,
            ],
          ),
        ),
      ),
    );
  }
}
