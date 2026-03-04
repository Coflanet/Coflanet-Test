import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';

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
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _backgroundColor,
          foregroundColor: _foregroundColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.lgBorder,
            side: BorderSide.none,
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
                  const SizedBox(width: 8),
                  Text(
                    _buttonText,
                    style: AppTextStyles.headline2Bold.copyWith(
                      color: _foregroundColor,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Color get _backgroundColor {
    switch (type) {
      case SocialButtonType.kakao:
        return const Color(0xFFFEE500);
      case SocialButtonType.naver:
        return const Color(0xFF03C75A);
      case SocialButtonType.apple:
        return Colors.black;
    }
  }

  Color get _foregroundColor {
    switch (type) {
      case SocialButtonType.kakao:
        return const Color(0xFF191919);
      case SocialButtonType.naver:
        return Colors.white;
      case SocialButtonType.apple:
        return Colors.white;
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

  Widget _buildIcon() {
    switch (type) {
      case SocialButtonType.kakao:
        return SvgPicture.asset(AssetPath.iconKakao, width: 24, height: 24);
      case SocialButtonType.naver:
        return SvgPicture.asset(AssetPath.iconNaver, width: 24, height: 24);
      case SocialButtonType.apple:
        return SvgPicture.asset(
          AssetPath.iconApple,
          width: 24,
          height: 24,
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        );
    }
  }
}
