import 'package:flutter/material.dart';
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
        return const _KakaoIcon();
      case SocialButtonType.naver:
        return const _NaverIcon();
      case SocialButtonType.apple:
        return const Icon(Icons.apple, size: 24, color: Colors.white);
    }
  }
}

class _KakaoIcon extends StatelessWidget {
  const _KakaoIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: const BoxDecoration(
        color: Color(0xFF191919),
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Icon(Icons.chat_bubble, size: 12, color: Color(0xFFFEE500)),
      ),
    );
  }
}

class _NaverIcon extends StatelessWidget {
  const _NaverIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.xsBorder,
      ),
      child: const Center(
        child: Text(
          'N',
          style: TextStyle(
            color: Color(0xFF03C75A),
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}
