import 'package:flutter/material.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';
import 'package:coflanet/constants/style_constant.dart';

/// 홈 섹션 카드 하단 공통 '더 보기' 버튼 — pill (Figma: 추천 원두 더 보기).
///
/// 상품 섹션 / 커뮤니티 섹션이 공유한다. 섹션 카드(surfaceCard) 위에서
/// 한 단계 대비되는 pill 로 표시된다 (테마 반응).
class HomeSectionMoreButton extends StatelessWidget {
  const HomeSectionMoreButton({super.key, required this.label, this.onTap});

  /// 버튼 라벨 (예: '추천 원두 더 보기')
  final String label;

  /// 탭 콜백 — null 이면 동작 없음 ([백엔드 API 연동 대기])
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);

    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.buttonPaddingV,
          ),
          decoration: BoxDecoration(
            color: colors.componentFillStrong,
            borderRadius: AppRadius.fullBorder,
          ),
          child: Center(
            child: Text(
              label,
              style: AppTextStyles.body2NormalBold.copyWith(
                color: colors.labelStrong,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
