import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/data/models/survey_result_model.dart';
import 'package:coflanet/routes/app_pages.dart';

/// 매칭 결과 추천 원두 카드 — 가로 스크롤용 180px 카드.
///
/// 강조색 그라데이션 헤더 + 이름/원산지·로스팅 + '자세히 보기' 칩.
/// [accentColor] 는 섹션의 index 순환 팔레트에서 주입. 카드 탭 시 인앱 상품
/// 상세([Routes.productDetail], 홈 상품 카드와 동일)로 이동한다 — 구매 링크는
/// 상세 화면의 "구매하러 가기" CTA 에서 처리. 공통 ProductCard(세로 그리드+
/// 좋아요+가격) 및 온보딩 RecommendationCard(체크박스+썸네일+맛바)와는 토큰/
/// 구조가 전부 달라 통합하지 않는다 (matching 전용).
class MatchingRecommendationCard extends StatelessWidget {
  const MatchingRecommendationCard({
    super.key,
    required this.recommendation,
    required this.accentColor,
  });

  /// 추천 원두 데이터
  final CoffeeRecommendationModel recommendation;

  /// 카드 헤더 강조색 (라이트/다크 공통 고정)
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);
    final card = Container(
      width: 180,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: AppRadius.xxlBorder,
        boxShadow: AppShadows.shadowBlackEmphasize,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 강조색 그라데이션 헤더 + 커피 아이콘
          Container(
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [accentColor.withValues(alpha: 0.8), accentColor],
              ),
              borderRadius: AppRadius.top(AppRadius.xxl),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -20,
                  top: -20,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColor.staticLabelWhiteStrong.withValues(
                        alpha: 0.1,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Icon(
                    Icons.coffee,
                    color: AppColor.staticLabelWhiteStrong,
                    size: 36,
                  ),
                ),
              ],
            ),
          ),

          // 본문
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recommendation.name,
                    style: AppTextStyles.headline2Bold.copyWith(
                      color: colors.labelNormal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${recommendation.origin} · ${recommendation.roastLevel}',
                    style: AppTextStyles.caption1Regular.copyWith(
                      color: colors.labelAlternative,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.1),
                      borderRadius: AppRadius.mdBorder,
                    ),
                    child: Text(
                      '자세히 보기',
                      style: AppTextStyles.caption1Medium.copyWith(
                        color: accentColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    // '자세히 보기' — 인앱 상품 상세로 이동 (홈 상품 카드와 동일 패턴).
    // purchaseUrl 유무와 무관하게 탭 활성 — 구매 링크는 상세 화면 CTA 에서 처리.
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Get.toNamed(
        Routes.productDetail,
        arguments: {'product': recommendation},
      ),
      child: card,
    );
  }
}
