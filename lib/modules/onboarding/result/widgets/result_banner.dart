import 'package:flutter/material.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';
import 'package:coflanet/constants/style_constant.dart';

/// 설문 결과 상단 취향 타입 배너 — Profile 카드 안의 보라 박스.
///
/// Figma(Survey_Result `1114:59817` Title): primary/normal 단색, radius 32,
/// px24/py32, gap8. 캡션(inverse/label/neutral 16 Regular) + 헤드라인
/// (inverse/label/normal 24 Bold 2줄 + 이모지). 그라디언트·그림자 없음.
class ResultBanner extends StatelessWidget {
  const ResultBanner({
    super.key,
    required this.userName,
    required this.description,
  });

  /// 사용자 이름
  final String userName;

  /// 취향 타입 설명 (예: '진하고 깊은 풍미를')
  final String description;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space24,
        vertical: AppSpacing.space32,
      ),
      decoration: BoxDecoration(
        color: colors.primaryNormal,
        borderRadius: AppRadius.roundBorder,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 캡션 — "OOO님은" (inverse/label/neutral, 16 Regular)
          Text(
            '$userName님은',
            style: AppTextStyles.body1NormalRegular.copyWith(
              color: colors.inverseLabelNeutral,
            ),
          ),
          const SizedBox(height: AppSpacing.space8),

          // 헤드라인 — 2줄 + 이모지 (inverse/label/normal, 24 Bold)
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '$description\n즐기시네요!',
                  style: AppTextStyles.title3Bold.copyWith(
                    color: colors.inverseLabelNormal,
                    height: 1.334,
                  ),
                ),
                const TextSpan(text: ' ☕'),
              ],
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}
