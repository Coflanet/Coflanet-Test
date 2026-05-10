import 'package:flutter/material.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_radius.dart';
import '../../foundation/app_spacing.dart';
import '../../foundation/app_text_style.dart';

/// 소셜 로그인 프로바이더.
enum AppSocialProvider { kakao, naver, apple, google }

/// 소셜 로그인 버튼 — 브랜드 컬러 + 로고 + 텍스트.
///
/// 로고 아이콘은 임시로 Material Icons 사용. 실제 브랜드 로고 SVG는
/// `coflanet/assets/icons` 또는 `component_lab/assets`에서 별도 연결 권장.
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

  ({Color bg, Color fg, IconData icon, String label, BorderSide? border})
      _config() {
    switch (provider) {
      case AppSocialProvider.kakao:
        return (
          bg: AppColor.socialKakao,
          fg: AppColor.colorGlobalCommon0,
          icon: Icons.chat_bubble_rounded,
          label: '카카오로 시작하기',
          border: null,
        );
      case AppSocialProvider.naver:
        return (
          bg: AppColor.socialNaver,
          fg: AppColor.colorGlobalCommon100,
          icon: Icons.text_fields_rounded,
          label: '네이버로 시작하기',
          border: null,
        );
      case AppSocialProvider.apple:
        return (
          bg: AppColor.socialApple,
          fg: AppColor.colorGlobalCommon100,
          icon: Icons.apple_rounded,
          label: 'Apple로 시작하기',
          border: null,
        );
      case AppSocialProvider.google:
        return (
          bg: AppColor.colorGlobalCommon100,
          fg: AppColor.colorGlobalCommon0,
          icon: Icons.g_mobiledata_rounded,
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
                Icon(c.icon, size: 22, color: c.fg),
                const SizedBox(width: AppSpacing.space8),
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
