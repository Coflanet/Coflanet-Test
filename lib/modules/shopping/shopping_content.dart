import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';

/// 쇼핑 탭 콘텐츠 — [백엔드 API 연동 대기]
/// 상품 데이터 미연동 상태로 안내 화면만 표시.
class ShoppingContent extends StatelessWidget {
  const ShoppingContent({super.key});

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
                Icons.shopping_bag_outlined,
                size: 56,
                color: AppColor.primaryNormal.withValues(alpha: 0.6),
              ),
              const SizedBox(height: 20),
              Text(
                '쇼핑',
                style: AppTextStyles.headline1Bold.copyWith(
                  color: AppColor.labelNormal,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                '나에게 어울리는 원두를 만날 수 있는\n쇼핑 화면을 준비 중이에요',
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
