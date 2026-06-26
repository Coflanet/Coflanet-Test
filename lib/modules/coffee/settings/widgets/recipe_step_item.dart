import 'package:flutter/material.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';
import 'package:coflanet/constants/style_constant.dart';

/// 레시피 진행 스텝 데이터
class RecipeStep {
  final int number;
  final String title;
  final String description;

  const RecipeStep({
    required this.number,
    required this.title,
    required this.description,
  });
}

/// 레시피 진행 트래커 1행 — 번호 배지 + 세로선 + 타이틀 + 설명.
///
/// Figma: 배지 20x20 CoolNeutral96 원형 + 번호 12/w600,
/// 세로선 1x28, 타이틀 width100 16/w500/labelAlternative,
/// 설명 14/w400/labelAssistive 우측정렬.
class RecipeStepItem extends StatelessWidget {
  const RecipeStepItem({super.key, required this.step, required this.isLast});

  /// 스텝 데이터
  final RecipeStep step;

  /// 마지막 행 여부 (세로선 미표시)
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 좌측: 번호 배지 + 세로선
        Column(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                // Figma CoolNeutral96(#e1e2e4) — 전 스텝 균일(상태 미구분, Figma 일치)
                color: colors.lineSolidNormal,
                borderRadius: AppRadius.fullBorder,
              ),
              child: Center(
                child: Text(
                  '${step.number}',
                  // Figma: Caption 1/Bold (12/600)
                  style: AppTextStyles.caption1Bold.copyWith(
                    color: colors.labelAlternative,
                  ),
                ),
              ),
            ),
            if (!isLast)
              Container(width: 1, height: 28, color: colors.lineSolidNormal),
          ],
        ),
        const SizedBox(width: AppSpacing.space12),
        // 스텝 타이틀 — Figma: width 100, Body 1/Normal-Medium (16/500)
        SizedBox(
          width: 100,
          child: Text(
            step.title,
            style: AppTextStyles.body1NormalMedium.copyWith(
              color: colors.labelAlternative,
            ),
          ),
        ),
        const Spacer(),
        // 스텝 설명 — Figma: Label 1/Normal-Regular (14/400), 우측정렬
        Text(
          step.description,
          style: AppTextStyles.label1NormalRegular.copyWith(
            color: colors.labelAssistive,
          ),
          textAlign: TextAlign.right,
        ),
      ],
    );
  }
}
