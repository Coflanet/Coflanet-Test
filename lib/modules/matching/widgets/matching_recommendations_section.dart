import 'package:flutter/material.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/data/models/survey_result_model.dart';
import 'package:coflanet/modules/matching/widgets/matching_recommendation_card.dart';

/// 매칭 결과 추천 원두 섹션 — 헤더 + 가로 스크롤 카드 리스트.
///
/// [recommendations] 가 비어 있으면 빈 위젯 (원본 가드 보존).
/// 헤더 아이콘/배경은 raw orange 고정 토큰, 제목은 시맨틱 labelNormal —
/// 맛 프로필 헤더(시맨틱 primary)와 색 체계가 갈려 공통 헤더로 묶지 않는다.
/// 카드 강조색은 4색 팔레트 index 순환 (라이트/다크 공통 고정).
class MatchingRecommendationsSection extends StatelessWidget {
  const MatchingRecommendationsSection({
    super.key,
    required this.recommendations,
  });

  /// 추천 원두 목록 (비어 있으면 SizedBox.shrink 렌더)
  final List<CoffeeRecommendationModel> recommendations;

  /// 카드 헤더 강조색 팔레트 (accent — 라이트/다크 공통 고정)
  static const List<Color> _accentColors = [
    AppColor.colorGlobalOrange50,
    AppColor.colorGlobalViolet50,
    AppColor.colorGlobalCyan50,
    AppColor.colorGlobalGreen50,
  ];

  @override
  Widget build(BuildContext context) {
    if (recommendations.isEmpty) return const SizedBox.shrink();

    final colors = AppColorScheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 섹션 헤더 — 아이콘 박스는 raw orange 고정, 제목은 시맨틱 라벨
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColor.colorGlobalOrange95,
                  borderRadius: AppRadius.lgBorder,
                ),
                child: Icon(
                  Icons.coffee_rounded,
                  color: AppColor.colorGlobalOrange50,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Text(
                '추천 원두',
                style: AppTextStyles.headline1Bold.copyWith(
                  color: colors.labelNormal,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 가로 스크롤 추천 카드 리스트
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: recommendations.length,
            itemBuilder: (context, index) {
              final rec = recommendations[index];
              return KeyedSubtree(
                key: ValueKey(rec.id),
                child: MatchingRecommendationCard(
                  recommendation: rec,
                  accentColor: _accentColors[index % _accentColors.length],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
