import 'package:flutter/material.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/data/models/survey_result_model.dart';

/// 맛 프로필 4타일 그리드 — 산미/바디감/단맛/쓴맛.
///
/// Figma(Survey_Result `1114:59823` TasteProfile_Row_Body): 흰 타일 4개,
/// 타일 사이 gap 2, 각 타일 radius 24·px8/py20·gap4, 레벨별 은은한 accent 틴트.
/// 값에 따라 이모지/레벨: 70↑ 👍 좋음(blue) / 40↑ 😐 보통(yellow) / 미만 👎 싫음(red).
/// 그림자·세로 구분선 없음(표면/틴트 대비로만 분리).
class TasteProfileGrid extends StatelessWidget {
  const TasteProfileGrid({super.key, required this.profile});

  /// 맛 프로필 (0-100 값 4종)
  final TasteProfileModel profile;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);

    final items = [
      ('산미', profile.acidity),
      ('바디감', profile.body),
      ('단맛', profile.sweetness),
      ('쓴맛', profile.bitterness),
    ];

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int i = 0; i < items.length; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.space2),
            Expanded(
              child: _buildTile(
                colors: colors,
                label: items[i].$1,
                value: items[i].$2,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// 개별 타일 — accent 틴트 흰 타일 + 라벨/이모지/레벨
  Widget _buildTile({
    required AppColorScheme colors,
    required String label,
    required int value,
  }) {
    final String emoji;
    final String levelText;
    final Color accent;
    if (value >= 70) {
      emoji = '👍';
      levelText = '좋음';
      accent = AppColor.accentBackgroundBlue;
    } else if (value >= 40) {
      emoji = '😐';
      levelText = '보통';
      accent = AppColor.accentBackgroundYellow;
    } else {
      emoji = '👎';
      levelText = '싫음';
      accent = AppColor.accentBackgroundRed;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.space20,
        horizontal: AppSpacing.space8,
      ),
      decoration: BoxDecoration(
        // Figma: 흰 타일 + accent 블롭 틴트(22%) — 상단 은은한 틴트가 하단 흰색으로
        // 페이드하는 그라디언트로 근사.
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.5, 1.0],
          colors: [
            Color.alphaBlend(
              accent.withValues(alpha: 0.20),
              colors.backgroundNormalNormal,
            ),
            colors.backgroundNormalNormal,
            colors.backgroundNormalNormal,
          ],
        ),
        borderRadius: AppRadius.xxxlBorder,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.headline2Bold.copyWith(
              color: colors.labelNormal,
            ),
          ),
          const SizedBox(height: AppSpacing.space4),
          Text(emoji, style: AppTextStyles.emojiMedium.copyWith(height: 1.4)),
          const SizedBox(height: AppSpacing.space4),
          Text(
            levelText,
            textAlign: TextAlign.center,
            style: AppTextStyles.label1NormalRegular.copyWith(
              color: colors.labelNeutral,
            ),
          ),
        ],
      ),
    );
  }
}
