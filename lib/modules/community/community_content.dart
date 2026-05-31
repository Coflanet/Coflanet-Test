import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';

/// 커뮤니티 탭 콘텐츠 — [백엔드 API 연동 대기]
/// 기능 미구현 상태로 안내 화면만 표시.
class CommunityContent extends StatelessWidget {
  const CommunityContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.backgroundNormalAlternative,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.chat_bubble_outline_rounded,
                size: 56,
                color: AppColor.primaryNormal.withValues(alpha: 0.6),
              ),
              const SizedBox(height: 20),
              Text(
                '커뮤니티',
                style: AppTextStyles.headline1Bold.copyWith(
                  color: AppColor.labelNormal,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                '커피러버들의 이야기를 나눌 수 있는\n공간을 준비 중이에요',
                style: AppTextStyles.body2NormalRegular.copyWith(
                  color: AppColor.labelAlternative,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
