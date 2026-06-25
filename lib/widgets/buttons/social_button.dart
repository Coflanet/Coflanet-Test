import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';
import 'package:coflanet/constants/style_constant.dart';

enum SocialButtonType { kakao, naver, apple }

class SocialButton extends StatelessWidget {
  final SocialButtonType type;
  final VoidCallback? onPressed;
  final bool isLoading;

  const SocialButton({
    super.key,
    required this.type,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);
    // 애플 버튼은 검정 고정이라 다크 배경(순검정)과 구분되지 않으므로
    // 테두리만 추가해 경계를 살린다. (브랜드 색 자체는 유지)
    final BorderSide side = type == SocialButtonType.apple
        ? BorderSide(color: colors.lineNormalNormal)
        : BorderSide.none;

    return Semantics(
      button: true,
      label: _semanticLabel,
      child: SizedBox(
        width: double.infinity,
        // Figma `Button/Solid` py-12 + content(텍스트 24·아이콘 20) = 48
        height: AppSpacing.space48,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: _backgroundColor,
            foregroundColor: _foregroundColor,
            elevation: 0,
            shape: RoundedRectangleBorder(
              // Figma 사양 borderRadius 10. 토큰 AppRadius.lg(=12) 과 차이가 있어
              // 컴포넌트 단위로 override (전역 토큰 영향 방지).
              borderRadius: BorderRadius.circular(10),
              side: side,
            ),
          ),
          child: isLoading
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(_foregroundColor),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildIcon(),
                    // Figma 버튼 content gap = 6 (space6)
                    const SizedBox(width: AppSpacing.space6),
                    Text(
                      _buttonText,
                      // Figma `Button/Solid` 라벨: 16·SemiBold(w600)·lh1.5 = body1NormalBold
                      style: AppTextStyles.body1NormalBold.copyWith(
                        color: _foregroundColor,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Color get _backgroundColor {
    switch (type) {
      case SocialButtonType.kakao:
        return AppColor.socialKakao;
      case SocialButtonType.naver:
        return AppColor.socialNaver;
      case SocialButtonType.apple:
        return AppColor.socialApple;
    }
  }

  Color get _foregroundColor {
    switch (type) {
      case SocialButtonType.kakao:
        // 카카오 공식 가이드 #191919 (Figma 사양 일치)
        return AppColor.socialKakaoText;
      case SocialButtonType.naver:
        return AppColor.colorGlobalCommon100;
      case SocialButtonType.apple:
        return AppColor.colorGlobalCommon100;
    }
  }

  String get _buttonText {
    switch (type) {
      case SocialButtonType.kakao:
        return '카카오로 3초만에 시작하기';
      case SocialButtonType.naver:
        return '네이버로 로그인';
      case SocialButtonType.apple:
        return 'Apple로 로그인';
    }
  }

  String get _semanticLabel {
    switch (type) {
      case SocialButtonType.kakao:
        return '카카오로 로그인';
      case SocialButtonType.naver:
        return '네이버로 로그인';
      case SocialButtonType.apple:
        return 'Apple로 로그인';
    }
  }

  Widget _buildIcon() {
    switch (type) {
      // Figma `Left Icon` 높이 20
      case SocialButtonType.kakao:
        return SvgPicture.asset(AssetPath.iconKakao, width: 20, height: 20);
      case SocialButtonType.naver:
        return SvgPicture.asset(AssetPath.iconNaver, width: 20, height: 20);
      case SocialButtonType.apple:
        return SvgPicture.asset(
          AssetPath.iconApple,
          width: 20,
          height: 20,
          colorFilter: const ColorFilter.mode(
            AppColor.colorGlobalCommon100,
            BlendMode.srcIn,
          ),
        );
    }
  }
}
