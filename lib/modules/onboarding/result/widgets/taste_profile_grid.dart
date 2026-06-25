import 'package:flutter/material.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/data/models/survey_result_model.dart';

/// 맛 프로필 4타일 그리드 — 산미/바디감/단맛/쓴맛.
///
/// 값에 따라 이모지/레벨 텍스트 결정:
/// 70 이상 👍 좋음 / 40 이상 😐 보통 / 미만 👎 싫음.
/// Figma: 흰 pill 타일 + 옅은 그림자, 타일 사이 세로 구분선.
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

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.space20,
        AppSpacing.space20,
        AppSpacing.space20,
        AppSpacing.space20,
      ),
      child: Row(
        children: [
          for (int i = 0; i < items.length; i++)
            Expanded(
              child: _buildTile(
                colors: colors,
                label: items[i].$1,
                value: items[i].$2,
                showDivider: i < items.length - 1,
              ),
            ),
        ],
      ),
    );
  }

  /// 개별 타일 — 라벨 + 이모지 + 레벨 텍스트 (+ 우측 세로 구분선)
  Widget _buildTile({
    required AppColorScheme colors,
    required String label,
    required int value,
    required bool showDivider,
  }) {
    final String emoji;
    final String levelText;
    if (value >= 70) {
      emoji = '👍';
      levelText = '좋음';
    } else if (value >= 40) {
      emoji = '😐';
      levelText = '보통';
    } else {
      emoji = '👎';
      levelText = '싫음';
    }

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.space16,
              horizontal: AppSpacing.space8,
            ),
            decoration: BoxDecoration(
              color: colors.backgroundNormalNormal,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              boxShadow: [
                BoxShadow(
                  color: AppColor.colorGlobalCommon0.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: AppTextStyles.caption1Medium.copyWith(
                    color: colors.labelAlternative,
                  ),
                ),
                const SizedBox(height: AppSpacing.space8),
                Text(emoji, style: const TextStyle(fontSize: 24)),
                const SizedBox(height: AppSpacing.space4),
                Text(
                  levelText,
                  style: AppTextStyles.caption2Medium.copyWith(
                    color: colors.labelNeutral,
                  ),
                ),
              ],
            ),
          ),
        ),
        // 타일 사이 세로 구분선 (Figma: 얇은 회색 라인)
        if (showDivider)
          Container(
            width: 1,
            height: 40,
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.space4),
            color: colors.lineNormalNeutral,
          ),
      ],
    );
  }
}
