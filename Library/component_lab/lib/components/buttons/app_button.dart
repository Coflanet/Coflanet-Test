import 'package:flutter/material.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_radius.dart';
import '../../foundation/app_text_style.dart';
import '../../foundation/app_spacing.dart';

/// Button variant — 시각적 강도.
enum AppButtonVariant {
  /// 가장 강한 강조 (Primary 채움)
  solidPrimary,

  /// 보조 채움 (어두운 회색 등)
  solidSecondary,

  /// 테두리만 있는 버튼
  outline,

  /// 배경/테두리 없는 텍스트 버튼 (hover 시 살짝 fill)
  ghost,

  /// 완전 텍스트 (padding 작음)
  text,
}

/// Button size — Figma 기준 5단계.
enum AppButtonSize {
  /// 56px height — headline1Bold
  xl,

  /// 52px height — headline1Bold (default)
  lg,

  /// 48px height — headline2Bold
  md,

  /// 40px height — label1NormalBold
  sm,

  /// 32px height — label2Bold
  xs,
}

/// 디자인 시스템 표준 버튼 (deprecated).
///
/// Use [AppSolidButton], [AppOutlinedButton], or [AppTextButton] instead.
///
/// ```dart
/// AppButton(
///   text: '확인',
///   onPressed: () {},
///   variant: AppButtonVariant.solidPrimary,
///   size: AppButtonSize.lg,
/// )
/// ```
@Deprecated('Use AppSolidButton, AppOutlinedButton, or AppTextButton instead')
class AppButton extends StatelessWidget {
  /// 버튼 텍스트 (필수)
  final String text;

  /// 탭 핸들러. null이면 비활성화.
  final VoidCallback? onPressed;

  /// 시각 변형
  final AppButtonVariant variant;

  /// 사이즈
  final AppButtonSize size;

  /// 로딩 중 표시 (스피너 표시 + 비활성)
  final bool isLoading;

  /// 비활성 강제 (onPressed 있어도)
  final bool isDisabled;

  /// 가로 폭. null이면 컨텐츠 크기, double.infinity면 부모 가득.
  final double? width;

  /// 텍스트 앞 아이콘
  final IconData? leadingIcon;

  /// 텍스트 뒤 아이콘
  final IconData? trailingIcon;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = AppButtonVariant.solidPrimary,
    this.size = AppButtonSize.lg,
    this.isLoading = false,
    this.isDisabled = false,
    this.width,
    this.leadingIcon,
    this.trailingIcon,
  });

  bool get _enabled => !isDisabled && !isLoading && onPressed != null;

  double get _height {
    switch (size) {
      case AppButtonSize.xl:
        return 56;
      case AppButtonSize.lg:
        return 52;
      case AppButtonSize.md:
        return 48;
      case AppButtonSize.sm:
        return 40;
      case AppButtonSize.xs:
        return 32;
    }
  }

  TextStyle get _textStyle {
    switch (size) {
      case AppButtonSize.xl:
      case AppButtonSize.lg:
        return AppTextStyles.headline1Bold;
      case AppButtonSize.md:
        return AppTextStyles.headline2Bold;
      case AppButtonSize.sm:
        return AppTextStyles.label1NormalBold;
      case AppButtonSize.xs:
        return AppTextStyles.label2Bold;
    }
  }

  double get _iconSize {
    switch (size) {
      case AppButtonSize.xl:
      case AppButtonSize.lg:
        return 20;
      case AppButtonSize.md:
        return 18;
      case AppButtonSize.sm:
        return 16;
      case AppButtonSize.xs:
        return 14;
    }
  }

  EdgeInsets get _padding {
    // Figma 기준: hor 8, ver 12 (xs)부터 사이즈에 따라 증가
    switch (size) {
      case AppButtonSize.xl:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.space20,
          vertical: AppSpacing.space16,
        );
      case AppButtonSize.lg:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.space16,
          vertical: AppSpacing.space14,
        );
      case AppButtonSize.md:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.space16,
          vertical: AppSpacing.space12,
        );
      case AppButtonSize.sm:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.space12,
          vertical: AppSpacing.space8,
        );
      case AppButtonSize.xs:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.buttonPaddingHorizontal,
          vertical: AppSpacing.buttonPaddingVertical,
        );
    }
  }

  ({Color bg, Color fg, BorderSide? border}) _colors(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final disabled = !_enabled;

    switch (variant) {
      case AppButtonVariant.solidPrimary:
        return (
          bg: disabled
              ? AppColor.interactionDisable
              : (isDark
                  ? AppColor.darkPrimaryNormal
                  : AppColor.primaryNormal),
          fg: disabled
              ? (isDark ? AppColor.darkLabelDisable : AppColor.labelDisable)
              : AppColor.staticLabelWhiteStrong,
          border: null,
        );
      case AppButtonVariant.solidSecondary:
        return (
          bg: disabled
              ? AppColor.interactionDisable
              : (isDark
                  ? AppColor.darkComponentFillStrong
                  : AppColor.componentFillStrong),
          fg: disabled
              ? (isDark ? AppColor.darkLabelDisable : AppColor.labelDisable)
              : (isDark ? AppColor.darkLabelNormal : AppColor.labelNormal),
          border: null,
        );
      case AppButtonVariant.outline:
        return (
          bg: AppColor.transparent,
          fg: disabled
              ? (isDark ? AppColor.darkLabelDisable : AppColor.labelDisable)
              : (isDark ? AppColor.darkLabelNormal : AppColor.labelNormal),
          border: BorderSide(
            color: disabled
                ? (isDark
                    ? AppColor.darkLineNormalNeutral
                    : AppColor.lineNormalNeutral)
                : (isDark
                    ? AppColor.darkLineSolidNormal
                    : AppColor.lineSolidNormal),
            width: 1,
          ),
        );
      case AppButtonVariant.ghost:
        return (
          bg: AppColor.transparent,
          fg: disabled
              ? (isDark ? AppColor.darkLabelDisable : AppColor.labelDisable)
              : (isDark ? AppColor.darkLabelNormal : AppColor.labelNormal),
          border: null,
        );
      case AppButtonVariant.text:
        return (
          bg: AppColor.transparent,
          fg: disabled
              ? (isDark ? AppColor.darkLabelDisable : AppColor.labelDisable)
              : (isDark
                  ? AppColor.darkPrimaryNormal
                  : AppColor.primaryNormal),
          border: null,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = _colors(context);

    final child = isLoading
        ? SizedBox(
            width: _iconSize,
            height: _iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(colors.fg),
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leadingIcon != null) ...[
                Icon(leadingIcon, size: _iconSize, color: colors.fg),
                SizedBox(width: AppSpacing.space8),
              ],
              Text(text, style: _textStyle.copyWith(color: colors.fg)),
              if (trailingIcon != null) ...[
                SizedBox(width: AppSpacing.space8),
                Icon(trailingIcon, size: _iconSize, color: colors.fg),
              ],
            ],
          );

    final button = Material(
      color: colors.bg,
      borderRadius: AppRadius.radiusButtonBorder,
      child: InkWell(
        onTap: _enabled ? onPressed : null,
        borderRadius: AppRadius.radiusButtonBorder,
        child: Container(
          height: _height,
          padding: _padding,
          decoration: BoxDecoration(
            borderRadius: AppRadius.radiusButtonBorder,
            border: colors.border != null
                ? Border.fromBorderSide(colors.border!)
                : null,
          ),
          child: Center(child: child),
        ),
      ),
    );

    return SizedBox(
      width: width,
      child: button,
    );
  }
}
