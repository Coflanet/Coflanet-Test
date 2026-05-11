import 'dart:ui';

import 'package:flutter/material.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_color_theme.dart';
import '../../foundation/app_radius.dart';

/// Icon 버튼 톤 — Figma `Button/Icon/*` 9종.
enum AppIconButtonTone {
  /// 24×24 순수 아이콘 (배경 없음, Badge 옵션 가능)
  normal,

  /// 40×40 pill, Primary 채움 (Disable 시 fill `Component/fill/normal` 12% + BG Blur 64)
  primary,

  /// 40×40 pill, blur — 흰색 강조용 (어두운 배경에서 빛남)
  liquidGlassPrimary,

  /// 40×40 pill, 거의 투명 (단순 hover 영역)
  liquidGlass,

  /// 40×40 pill, 흰색 강조 + BG Blur
  backgroundBlurPrimary,

  /// 40×40 pill, `Component/fill/alternative` 8% + BG Blur 30
  backgroundBlur,

  /// 40×40 pill, `Component/fill/alternative` 8% + Primary 아이콘
  liquidGlassGrayPrimary,

  /// 40×40 pill, fill 없음 (단순 탭 영역)
  gray,

  /// 40×40 pill, stroke 1px `line/normal/normal`
  outlined,
}

/// Icon 버튼 사이즈 (`tone == normal` 외 적용).
///
/// Figma 측정:
/// - Normal: 40×40, padding 10
/// - Small: 32×32, padding 7
/// - Custom: 36×36, padding 6 (사용자가 customSize로 변경 가능)
enum AppIconButtonSize { normal, small, custom }

class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final AppIconButtonTone tone;
  final AppIconButtonSize size;
  final double? customSize;

  /// `tone == normal`일 때 Badge 표시
  final bool showBadge;

  final String? tooltip;

  /// 아이콘 색상 직접 지정 (null이면 tone 기본)
  final Color? iconColor;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tone = AppIconButtonTone.gray,
    this.size = AppIconButtonSize.normal,
    this.customSize,
    this.showBadge = false,
    this.tooltip,
    this.iconColor,
  });

  bool get _enabled => onPressed != null;

  double get _box {
    if (tone == AppIconButtonTone.normal) return 24;
    switch (size) {
      case AppIconButtonSize.normal:
        return 40;
      case AppIconButtonSize.small:
        return 32;
      case AppIconButtonSize.custom:
        return customSize ?? 36;
    }
  }

  double get _iconSize {
    if (tone == AppIconButtonTone.normal) return 24;
    switch (size) {
      case AppIconButtonSize.normal:
        return 20;
      case AppIconButtonSize.small:
        return 16;
      case AppIconButtonSize.custom:
        return ((customSize ?? 36) - 12).clamp(12, 32).toDouble();
    }
  }

  /// Figma padding by size+tone:
  /// - normal/small: padding 10/7 (Primary, LG Primary, BG Blur Primary, LG/Gray Primary, Outlined)
  /// - normal/small: padding 6/_ (LG, BG Blur, Gray) — 단일 사이즈 (40×40, padding 6)
  double get _padding {
    if (tone == AppIconButtonTone.normal) return 0;
    final isPrimaryStyle = tone == AppIconButtonTone.primary ||
        tone == AppIconButtonTone.liquidGlassPrimary ||
        tone == AppIconButtonTone.backgroundBlurPrimary ||
        tone == AppIconButtonTone.liquidGlassGrayPrimary ||
        tone == AppIconButtonTone.outlined;
    if (!isPrimaryStyle) return 6;
    switch (size) {
      case AppIconButtonSize.normal:
        return 10;
      case AppIconButtonSize.small:
        return 7;
      case AppIconButtonSize.custom:
        return 6;
    }
  }

  ({Color fill, Color fg, BorderSide? stroke, double? blurSigma}) _colors(
      BuildContext context) {
    final c = context.appColors;
    final disabled = !_enabled;
    final defaultFg = c.labelNormal;

    if (tone == AppIconButtonTone.normal) {
      return (
        fill: const Color(0x00000000),
        fg: disabled ? AppColor.labelDisable : defaultFg,
        stroke: null,
        blurSigma: null,
      );
    }

    switch (tone) {
      case AppIconButtonTone.primary:
        return disabled
            ? (
                // Figma: Component/fill/normal 12% + BG Blur 64
                fill: AppColor.componentFillStrong, // 12%에 가깝게
                fg: AppColor.staticLabelWhiteStrong.withValues(alpha: 0.5),
                stroke: null,
                blurSigma: 32, // backdrop blur 64를 시각 근사
              )
            : (
                fill: AppColor.primaryNormal,
                fg: AppColor.staticLabelWhiteStrong,
                stroke: null,
                blurSigma: null,
              );
      case AppIconButtonTone.liquidGlassPrimary:
      case AppIconButtonTone.backgroundBlurPrimary:
        return (
          fill: AppColor.colorGlobalCommon100.withValues(alpha: 0.16),
          fg: AppColor.staticLabelWhiteNormal,
          stroke: null,
          blurSigma: 24,
        );
      case AppIconButtonTone.liquidGlass:
        return (
          fill: AppColor.colorGlobalCommon0.withValues(alpha: 0.04),
          fg: defaultFg,
          stroke: null,
          blurSigma: 24,
        );
      case AppIconButtonTone.backgroundBlur:
        // Figma: fill Component/fill/alternative 8% + BG Blur 30
        return (
          fill: AppColor.componentFillNormal, // 8%
          fg: defaultFg,
          stroke: null,
          blurSigma: 30,
        );
      case AppIconButtonTone.liquidGlassGrayPrimary:
        return (
          fill: AppColor.componentFillNormal,
          fg: AppColor.primaryNormal,
          stroke: null,
          blurSigma: null,
        );
      case AppIconButtonTone.gray:
        return (
          fill: const Color(0x00000000),
          fg: defaultFg,
          stroke: null,
          blurSigma: null,
        );
      case AppIconButtonTone.outlined:
        return (
          fill: const Color(0x00000000),
          fg: defaultFg,
          stroke:
              BorderSide(color: AppColor.lineNormalNormal, width: 1),
          blurSigma: null,
        );
      case AppIconButtonTone.normal:
        return (
          fill: const Color(0x00000000),
          fg: defaultFg,
          stroke: null,
          blurSigma: null,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = _colors(context);
    final box = _box;
    final radius = AppRadius.radiusButtonBorder;

    Widget surface = Material(
      color: c.fill,
      shape: c.stroke != null
          ? RoundedRectangleBorder(borderRadius: radius, side: c.stroke!)
          : RoundedRectangleBorder(borderRadius: radius),
      child: InkWell(
        onTap: onPressed,
        borderRadius: radius,
        child: SizedBox(
          width: box,
          height: box,
          child: Padding(
            padding: EdgeInsets.all(_padding),
            child: Center(
              child: Icon(
                icon,
                size: _iconSize,
                color: iconColor ?? c.fg,
              ),
            ),
          ),
        ),
      ),
    );

    if (c.blurSigma != null) {
      surface = ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter:
              ImageFilter.blur(sigmaX: c.blurSigma!, sigmaY: c.blurSigma!),
          child: surface,
        ),
      );
    }

    if (showBadge && tone == AppIconButtonTone.normal) {
      surface = Stack(
        clipBehavior: Clip.none,
        children: [
          surface,
          Positioned(
            top: 2,
            right: 2,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: AppColor.statusNegative,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      );
    }

    final tappable = SizedBox(width: box, height: box, child: surface);

    return tooltip != null
        ? Tooltip(message: tooltip!, child: tappable)
        : tappable;
  }
}
