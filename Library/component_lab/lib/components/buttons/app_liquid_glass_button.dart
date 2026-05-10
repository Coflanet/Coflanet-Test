import 'dart:ui';

import 'package:flutter/material.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_radius.dart';
import '../../foundation/app_spacing.dart';
import '../../foundation/app_text_style.dart';

/// LiquidGlass 버튼 사이즈.
enum AppLiquidGlassSize { md, lg, xl }

/// 반투명 유리 효과 버튼 (LiquidGlass).
///
/// 강조가 약한 컨텍스트 (이미지 위, 어두운 배경 위) 에서 자연스럽게 녹아드는
/// 디자인. 배경에 BackdropFilter blur + 반투명 fill + 가는 흰색 inner border.
///
/// 어두운 배경(이미지·다크모드) 위에서 가장 잘 보입니다.
class AppLiquidGlassButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final AppLiquidGlassSize size;
  final double? width;

  /// 텍스트·아이콘 색상. null이면 흰색(어두운 배경 가정).
  final Color? foregroundColor;

  const AppLiquidGlassButton({
    super.key,
    required this.text,
    this.onPressed,
    this.leadingIcon,
    this.trailingIcon,
    this.size = AppLiquidGlassSize.lg,
    this.width,
    this.foregroundColor,
  });

  double get _height {
    switch (size) {
      case AppLiquidGlassSize.md:
        return 48;
      case AppLiquidGlassSize.lg:
        return 52;
      case AppLiquidGlassSize.xl:
        return 56;
    }
  }

  TextStyle get _textStyle {
    switch (size) {
      case AppLiquidGlassSize.md:
        return AppTextStyles.headline2Bold;
      case AppLiquidGlassSize.lg:
      case AppLiquidGlassSize.xl:
        return AppTextStyles.headline1Bold;
    }
  }

  double get _iconSize {
    switch (size) {
      case AppLiquidGlassSize.md:
        return 18;
      case AppLiquidGlassSize.lg:
        return 20;
      case AppLiquidGlassSize.xl:
        return 22;
    }
  }

  @override
  Widget build(BuildContext context) {
    final fg = foregroundColor ?? AppColor.staticLabelWhiteStrong;
    final radius = AppRadius.radiusButtonBorder;
    final disabled = onPressed == null;

    final content = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (leadingIcon != null) ...[
          Icon(leadingIcon, size: _iconSize, color: fg),
          const SizedBox(width: AppSpacing.space8),
        ],
        Text(text, style: _textStyle.copyWith(color: fg)),
        if (trailingIcon != null) ...[
          const SizedBox(width: AppSpacing.space8),
          Icon(trailingIcon, size: _iconSize, color: fg),
        ],
      ],
    );

    return SizedBox(
      width: width,
      height: _height,
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Material(
            color: AppColor.colorGlobalCommon100
                .withValues(alpha: disabled ? 0.06 : 0.16),
            child: InkWell(
              onTap: onPressed,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: radius,
                  border: Border.all(
                    color: AppColor.colorGlobalCommon100
                        .withValues(alpha: disabled ? 0.12 : 0.28),
                    width: 1,
                  ),
                  // 미세 그라데이션 — 위쪽이 약간 밝게
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColor.colorGlobalCommon100
                          .withValues(alpha: 0.10),
                      AppColor.colorGlobalCommon100
                          .withValues(alpha: 0.02),
                    ],
                  ),
                ),
                alignment: Alignment.center,
                child: content,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
