import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/style_constant.dart';

/// 홈 섹션 카드 하단 공통 '더 보기' 버튼 — 다크 pill (Figma: 추천 원두 더 보기).
///
/// 상품 섹션 / 커뮤니티 섹션이 공유한다. 다크 카드(CoolNeutral15) 위에서
/// 한 단계 밝은 회색 pill 로 표시된다.
class HomeSectionMoreButton extends StatelessWidget {
  const HomeSectionMoreButton({super.key, required this.label, this.onTap});

  /// 버튼 라벨 (예: '추천 원두 더 보기')
  final String label;

  /// 탭 콜백 — null 이면 동작 없음 ([백엔드 API 연동 대기])
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: AppColor.colorGlobalCoolNeutral22,
            borderRadius: AppRadius.fullBorder,
          ),
          child: Center(
            child: Text(
              label,
              style: AppTextStyles.body2NormalBold.copyWith(
                color: AppColor.colorGlobalCommon100,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
