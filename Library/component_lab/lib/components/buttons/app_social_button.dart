import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_radius.dart';
import '../../foundation/app_spacing.dart';
import '../../foundation/app_text_style.dart';
import '../../foundation/coflanet_icons.dart';

/// 소셜 로그인 프로바이더.
enum AppSocialProvider { kakao, naver, apple, google }

/// 소셜 로그인 버튼 — 브랜드 컬러 + 로고 + 텍스트.
class AppSocialButton extends StatelessWidget {
  final AppSocialProvider provider;
  final VoidCallback? onPressed;
  final String? customText;

  /// 가로 폭 — 기본은 부모 가득
  final double? width;

  /// 높이 — 기본 52
  final double height;

  const AppSocialButton({
    super.key,
    required this.provider,
    this.onPressed,
    this.customText,
    this.width,
    this.height = 52,
  });

  ({Color bg, Color fg, String iconAsset, String label, BorderSide? border})
      _config() {
    switch (provider) {
      case AppSocialProvider.kakao:
        return (
          bg: AppColor.socialKakao,
          fg: AppColor.colorGlobalCommon0,
          iconAsset: CoflanetIcons.logoKakao,
          label: '카카오로 시작하기',
          border: null,
        );
      case AppSocialProvider.naver:
        return (
          bg: AppColor.socialNaver,
          fg: AppColor.colorGlobalCommon100,
          iconAsset: CoflanetIcons.logoNaver,
          label: '네이버로 시작하기',
          border: null,
        );
      case AppSocialProvider.apple:
        return (
          bg: AppColor.socialApple,
          fg: AppColor.colorGlobalCommon100,
          iconAsset: CoflanetIcons.logoApple,
          label: 'Apple로 시작하기',
          border: null,
        );
      case AppSocialProvider.google:
        return (
          bg: AppColor.colorGlobalCommon100,
          fg: AppColor.colorGlobalCommon0,
          // 전용 logoGoogle 에셋 미보유 — 가장 가까운 Google Play 브랜드 마크 사용.
          iconAsset: CoflanetIcons.logoGooglePlay,
          label: 'Google로 시작하기',
          border: BorderSide(color: AppColor.lineSolidNormal, width: 1),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = _config();
    final radius = AppRadius.radiusButtonBorder;

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: Material(
        color: c.bg,
        borderRadius: radius,
        child: InkWell(
          onTap: onPressed,
          borderRadius: radius,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: radius,
              border:
                  c.border != null ? Border.fromBorderSide(c.border!) : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  c.iconAsset,
                  width: 22,
                  height: 22,
                  colorFilter: ColorFilter.mode(c.fg, BlendMode.srcIn),
                ),
                const SizedBox(width: AppSpacing.s8),
                Text(
                  customText ?? c.label,
                  style: AppTextStyles.headline2Bold.copyWith(color: c.fg),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
