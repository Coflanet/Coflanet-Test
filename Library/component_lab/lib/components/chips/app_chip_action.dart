import 'package:flutter/material.dart';

import '../../foundation/app_color_theme.dart';
import '../../foundation/app_text_style.dart';

/// Chip 사이즈 — Figma `Chip/*` 4종 (Action/Filter 공통).
enum AppChipSize { xsmall, small, medium, large }

/// Action Chip variant — Figma `Chip/Action` 2종.
enum AppChipActionVariant { solid, outlined }

/// Action Chip — Figma `Chip/Action`.
///
/// Figma boundVariables 기반 정확한 매핑:
///
/// 사이즈별 수치:
/// - XSmall: cornerRadius=6, padH=7, padV=4, gap=2, wrapperPadH=1, icon=12, font=caption1 (12px Medium)
/// - Small : cornerRadius=8, padH=8, padV=6, gap=2, wrapperPadH=2, icon=14, font=label1Normal (14px Medium)
/// - Medium: cornerRadius=10, padH=11, padV=7, gap=3, wrapperPadH=2, icon=14, font=body2Normal (15px Medium)
/// - Large : cornerRadius=10, padH=12, padV=9, gap=3, wrapperPadH=2, icon=16, font=body2Normal (15px Medium)
///
/// 색상 매핑 (boundVariables):
/// - Solid Default: bg `Component/fill/alternative`, text `Label/alternative`
/// - Solid Active : bg `Label/strong`, text `Inverse/label/normal`
/// - Solid Disable: bg `interaction/disable`, text `Label/disable`
/// - Outlined Default: stroke `line/normal/neutral`, text `Label/alternative`
/// - Outlined Active : fill `Primary/normal` @ `Opacity/5`, stroke `Primary/normal` @ `Opacity/43`, text `Primary/normal`
/// - Outlined Disable: stroke `line/normal/neutral`, text `Label/disable`
class AppChipAction extends StatelessWidget {
  final String label;
  final AppChipSize size;
  final AppChipActionVariant variant;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final bool isActive;
  final VoidCallback? onPressed;

  const AppChipAction({
    super.key,
    required this.label,
    this.size = AppChipSize.xsmall,
    this.variant = AppChipActionVariant.solid,
    this.leadingIcon,
    this.trailingIcon,
    this.isActive = false,
    this.onPressed,
  });

  bool get _enabled => onPressed != null;

  ({
    double padH,
    double padV,
    double gap,
    double wrapperPadH,
    double iconSize,
    double cornerRadius,
    TextStyle textStyle,
  }) get _metrics {
    switch (size) {
      case AppChipSize.xsmall:
        return (
          padH: 7,
          padV: 4,
          gap: 2,
          wrapperPadH: 1,
          iconSize: 12,
          cornerRadius: 6,
          textStyle: AppTextStyles.caption1Medium,
        );
      case AppChipSize.small:
        return (
          padH: 8,
          padV: 6,
          gap: 2,
          wrapperPadH: 2,
          iconSize: 14,
          cornerRadius: 8,
          textStyle: AppTextStyles.label1NormalMedium,
        );
      case AppChipSize.medium:
        return (
          padH: 11,
          padV: 7,
          gap: 3,
          wrapperPadH: 2,
          iconSize: 14,
          cornerRadius: 10,
          textStyle: AppTextStyles.body2NormalMedium,
        );
      case AppChipSize.large:
        return (
          padH: 12,
          padV: 9,
          gap: 3,
          wrapperPadH: 2,
          iconSize: 16,
          cornerRadius: 10,
          textStyle: AppTextStyles.body2NormalMedium,
        );
    }
  }

  ({Color bg, Color fg, BorderSide? side}) _colors(BuildContext context) {
    final c = context.appColors;

    if (!_enabled) {
      // Disable
      if (variant == AppChipActionVariant.solid) {
        return (
          bg: c.interactionDisable,
          fg: c.labelDisable,
          side: null,
        );
      }
      return (
        bg: const Color(0x00000000),
        fg: c.labelDisable,
        side: BorderSide(
          color: c.lineNormalNeutral,
          width: 1,
        ),
      );
    }

    if (isActive) {
      if (variant == AppChipActionVariant.solid) {
        return (
          bg: c.labelStrong,
          fg: c.inverseLabelNormal,
          side: null,
        );
      }
      // Outlined Active: fill Primary/normal @ Opacity/5, stroke Primary/normal @ Opacity/43
      final primary =
          c.primaryNormal;
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
    if (variant == AppChipActionVariant.solid) {
      return (
        bg: c.componentFillAlternative,
        fg: c.labelAlternative,
        side: null,
      );
    }
    return (
      bg: const Color(0x00000000),
      fg: c.labelAlternative,
      side: BorderSide(
        color: c.lineNormalNeutral,
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

    final children = <Widget>[
      if (leadingIcon != null)
        Icon(leadingIcon, size: m.iconSize, color: c.fg),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: m.wrapperPadH),
        child: Text(label, style: m.textStyle.copyWith(color: c.fg)),
      ),
      if (trailingIcon != null)
        Icon(trailingIcon, size: m.iconSize, color: c.fg),
    ];

    final material = Material(
      color: c.bg,
      shape: shape,
      child: InkWell(
        onTap: onPressed,
        customBorder: shape,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: m.padH,
            vertical: m.padV,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < children.length; i++) ...[
                if (i > 0) SizedBox(width: m.gap),
                children[i],
              ],
            ],
          ),
        ),
      ),
    );

    // 접근성 — Tap target 48dp WCAG 보강. xsmall은 시각 사이즈가 24px 수준이라
    // 외곽에 투명 padding으로 hit area를 키운다. 시각은 유지.
    final tapBoost = size == AppChipSize.xsmall ? 6.0 : 0.0;
    final wrapped = tapBoost > 0
        ? Padding(padding: EdgeInsets.all(tapBoost), child: material)
        : material;

    return Semantics(
      label: label,
      button: true,
      enabled: onPressed != null,
      selected: isActive,
      excludeSemantics: true,
      onTap: onPressed,
      child: wrapped,
    );
  }
}
