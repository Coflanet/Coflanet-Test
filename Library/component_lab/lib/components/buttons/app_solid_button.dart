import 'dart:ui';

import 'package:flutter/material.dart';

import '../../foundation/_button_metrics.dart';
import '../../foundation/app_color.dart';
import '../../foundation/app_radius.dart';
import '../../foundation/app_text_style.dart';

/// Solid 버튼 사이즈 (Figma `Button/Solid/*` Size variant).
enum AppSolidButtonSize { large, medium, small, xsmall }

/// Solid 버튼 톤 — Figma 7종.
enum AppSolidButtonTone {
  /// `Button/Solid/Primary` — Violet 채움, 흰 텍스트
  primary,

  /// `Button/Solid/Gray Primary` — 회색 채움, Primary 텍스트
  grayPrimary,

  /// `Button/Solid/Gray` — 회색 채움, 일반 텍스트
  gray,

  /// `Button/Solid/LiquidGlass Primary` — 유리 효과, 흰 텍스트
  liquidGlassPrimary,

  /// `Button/Solid/LiquidGlass` — 유리 효과, 일반 텍스트
  liquidGlass,

  /// `Button/Solid/Background Blur Primary` — blur, 흰 텍스트
  backgroundBlurPrimary,

  /// `Button/Solid/Background Blur` — blur + 회색 fill, 일반 텍스트
  backgroundBlur,
}

/// Solid 버튼 — Figma `Button/Solid/*` 7종.
///
/// 모든 톤·사이즈 공통:
/// - Pill 형태 (radius=99)
/// - SemiBold(w600) 텍스트
/// - 좌/우 아이콘 옵션
class AppSolidButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppSolidButtonTone tone;
  final AppSolidButtonSize size;
  final IconData? leftIcon;
  final IconData? rightIcon;

  /// 가로폭 — null이면 콘텐츠 크기, double.infinity면 부모 가득
  final double? width;

  const AppSolidButton({
    super.key,
    required this.label,
    this.onPressed,
    this.tone = AppSolidButtonTone.primary,
    this.size = AppSolidButtonSize.large,
    this.leftIcon,
    this.rightIcon,
    this.width,
  });

  bool get _enabled => onPressed != null;

  // ── Size geometry (Figma 측정) — `AppButtonMetrics` 단일 룩업.
  AppButtonMetrics get _m => switch (size) {
        AppSolidButtonSize.large => AppButtonMetrics.large,
        AppSolidButtonSize.medium => AppButtonMetrics.medium,
        AppSolidButtonSize.small => AppButtonMetrics.small,
        AppSolidButtonSize.xsmall => AppButtonMetrics.xsmall,
      };

  double get _height => _m.height;
  EdgeInsets get _padding => _m.padding;
  double get _gap => _m.gap;
  double get _iconSize => _m.iconSize;
  TextStyle get _textStyle => _m.textStyle;

  // ── Tone colors (Figma 정확 매칭) ──────────────────────────────
  ({Color fill, Color fg, bool blur}) _colors(BuildContext context) {
    if (!_enabled) {
      return (
        fill: AppColor.interactionDisable,
        fg: AppColor.labelAssistive, // Figma `Label/assistive` (35%)
        blur: false,
      );
    }
    switch (tone) {
      case AppSolidButtonTone.primary:
        return (
          fill: AppColor.primaryNormal,
          fg: AppColor.staticLabelWhiteStrong,
          blur: false,
        );
      case AppSolidButtonTone.grayPrimary:
        return (
          fill: AppColor.componentFillNormal,
          fg: AppColor.primaryNormal,
          blur: false,
        );
      case AppSolidButtonTone.gray:
        return (
          fill: AppColor.componentFillNormal,
          fg: AppColor.labelNormal,
          blur: false,
        );
      case AppSolidButtonTone.liquidGlassPrimary:
        return (
          fill: AppColor.colorGlobalCommon100.withValues(alpha: 0.16),
          fg: AppColor.staticLabelWhiteNormal,
          blur: true,
        );
      case AppSolidButtonTone.liquidGlass:
        return (
          fill: AppColor.colorGlobalCommon0.withValues(alpha: 0.04),
          fg: AppColor.labelNormal,
          blur: true,
        );
      case AppSolidButtonTone.backgroundBlurPrimary:
        return (
          fill: AppColor.colorGlobalCommon100.withValues(alpha: 0.16),
          fg: AppColor.staticLabelWhiteNormal,
          blur: true,
        );
      case AppSolidButtonTone.backgroundBlur:
        return (
          fill: AppColor.componentFillNormal,
          fg: AppColor.labelNormal,
          blur: true,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = _colors(context);
    final radius = AppRadius.radiusButtonBorder;

    Widget body = Padding(
      padding: _padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: width == double.infinity
            ? MainAxisSize.max
            : MainAxisSize.min,
        children: [
          if (leftIcon != null) ...[
            Icon(leftIcon, size: _iconSize, color: c.fg),
            SizedBox(width: _gap),
          ],
          Text(label, style: _textStyle.copyWith(color: c.fg)),
          if (rightIcon != null) ...[
            SizedBox(width: _gap),
            Icon(rightIcon, size: _iconSize, color: c.fg),
          ],
        ],
      ),
    );

    Widget surface = Material(
      color: c.fill,
      borderRadius: radius,
      child: InkWell(
        onTap: onPressed,
        borderRadius: radius,
        child: body,
      ),
    );

    if (c.blur) {
      surface = ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: surface,
        ),
      );
    }

    return SizedBox(
      width: width,
      height: _height,
      child: surface,
    );
  }
}
