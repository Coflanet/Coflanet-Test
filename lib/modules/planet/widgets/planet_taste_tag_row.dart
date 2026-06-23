import 'package:flutter/material.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/data/models/survey_result_model.dart';

/// 마이플래닛 취향 태그 4종 가로 행 — 산미/바디감/단맛/쓴맛 그라데이션 타일.
///
/// 모델 통째 주입 — [profile] 이 null 이면 빈 위젯 (원본 가드 보존).
/// 타일 그라데이션: 카드색 50% 까지 → 하단 강조색 페이드 (stops 0/0.5/1).
/// 강조색은 AppColor.tasteTag* 고정 토큰 (산미=Orange, 바디감=Yellow,
/// 단맛=Pink, 쓴맛=Purple). 온보딩 결과의 TasteProfileGrid 와는 이모지/
/// 그라데이션/폰트/구분 방식이 전부 달라 통합하지 않는다 (planet 전용).
class PlanetTasteTagRow extends StatelessWidget {
  const PlanetTasteTagRow({super.key, required this.profile});

  /// 취향 프로필 (null 이면 SizedBox.shrink 렌더)
  final TasteProfileModel? profile;

  /// 점수 → 레벨 텍스트 (70 이상 좋음 / 40 이상 보통 / 미만 싫음)
  static String _levelText(int value) {
    if (value >= 70) return '좋음';
    if (value >= 40) return '보통';
    return '싫음';
  }

  @override
  Widget build(BuildContext context) {
    final profile = this.profile;
    if (profile == null) return const SizedBox.shrink();

    final colors = AppColorScheme.of(context);
    // Figma colors — AppColor.tasteTag* 고정 토큰
    final items = [
      (
        label: '산미',
        level: _levelText(profile.acidity),
        color: AppColor.tasteTagAcidity,
      ),
      (
        label: '바디감',
        level: _levelText(profile.body),
        color: AppColor.tasteTagBody,
      ),
      (
        label: '단맛',
        level: _levelText(profile.sweetness),
        color: AppColor.tasteTagSweetness,
      ),
      (
        label: '쓴맛',
        level: _levelText(profile.bitterness),
        color: AppColor.tasteTagBitterness,
      ),
    ];

    return Row(
      children: [
        for (int i = 0; i < items.length; i++) ...[
          Expanded(
            child: _buildTasteTag(
              colors: colors,
              label: items[i].label,
              level: items[i].level,
              color: items[i].color,
            ),
          ),
          // 태그 사이 갭
          if (i < items.length - 1) const SizedBox(width: AppSpacing.xs),
        ],
      ],
    );
  }

  /// 개별 취향 태그 — Figma: 독립 둥근 컨테이너, 상단 카드색 → 하단 강조색 페이드
  Widget _buildTasteTag({
    required AppColorScheme colors,
    required String label,
    required String level,
    required Color color,
  }) {
    return Container(
      height: 86, // Figma: 86px (타일 고정 높이 — 시맨틱 spacing 토큰 비대상)
      decoration: BoxDecoration(
        borderRadius: AppRadius.xlBorder, // 16
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.5, 1.0], // 카드색 50% 까지, 이후 강조색 페이드
          // 흰 프로필 섹션 위에서 칩으로 분리되도록 인셋 톤(surfaceCardStrong) 기반
          colors: [
            colors.surfaceCardStrong,
            colors.surfaceCardStrong,
            color.withValues(alpha: 0.6),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 라벨 — Figma: 17px, 600 weight
          Text(
            label,
            style: AppTextStyles.headline2Bold.copyWith(
              color: colors.labelNormal,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xxs),
          // 레벨 — Figma: 14px, 400 weight
          Text(
            level,
            style: AppTextStyles.caption1Regular.copyWith(
              color: colors.labelNeutral,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
