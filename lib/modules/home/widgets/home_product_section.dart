import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/spacing_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/data/models/survey_result_model.dart';
import 'package:coflanet/modules/home/widgets/home_empty_card.dart';
import 'package:coflanet/modules/home/widgets/home_section_more_button.dart';
import 'package:coflanet/widgets/cards/card_section.dart';
import 'package:coflanet/widgets/cards/product_card.dart';

/// 홈 상품 섹션 — 섹션 타이틀 + 2열 상품 그리드 (또는 빈 상태 카드) + 하단 '더 보기' 버튼.
///
/// 취향 추천 / 인기 랭킹 / 실시간 인기 등 모든 상품 섹션이 공유한다.
/// iyumi 카드 패턴의 큰 카드([CardSection], radius 40, surfaceCard)로 그리며,
/// 그리드 하단에 항상 [HomeSectionMoreButton] 더 보기 버튼을 노출한다.
///
/// 좋아요 반응성: 카드 단위 Obx 로 [isLiked] 를 구독 — 한 카드 토글이
/// 다른 카드를 리빌드하지 않는다 (전체 그리드 단일 Obx 금지).
class HomeProductSection extends StatelessWidget {
  const HomeProductSection({
    super.key,
    required this.title,
    required this.items,
    required this.emptyMessage,
    required this.isLiked,
    required this.onLikeTap,
    this.onItemTap,
    this.onMoreTap,
    this.moreLabel = '추천 원두 더 보기',
  });

  /// 섹션 타이틀
  final String title;

  /// 상품 목록 — 비어 있으면 [emptyMessage] 빈 카드 노출
  final List<CoffeeRecommendationModel> items;

  /// 빈 상태 안내 문구
  final String emptyMessage;

  /// 좋아요 여부 조회 (Rx 기반 — 카드별 Obx 안에서 호출됨)
  final bool Function(String id) isLiked;

  /// 좋아요 토글 콜백
  final void Function(String id) onLikeTap;

  /// 상품 카드 탭 콜백 (C1) — 인앱 상품 상세로 이동. null 이면 비탭.
  final void Function(CoffeeRecommendationModel item)? onItemTap;

  /// 더 보기 버튼 탭 콜백 — null 이면 동작 없음 ([백엔드 API 연동 대기])
  final VoidCallback? onMoreTap;

  /// 더 보기 버튼 라벨
  final String moreLabel;

  @override
  Widget build(BuildContext context) {
    // 큰 카드(CardSection) — 카드 안이므로 색은 of(context).
    // Figma recommend_item_list(83:13254): pt32/pb16, 타이틀 px24, 그리드 px16,
    // 타이틀↔그리드 gap24. 섹션 자체 좌우 패딩 0 — 자식이 각자 px 를 가진다.
    return CardSection(
      padding: const EdgeInsets.only(
        top: AppSpacing.space32,
        bottom: AppSpacing.space16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 타이틀 — Figma title 블록 px24, SemiBold 20 = heading2Bold
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.space24,
            ),
            child: Text(
              title,
              style: AppTextStyles.heading2Bold.copyWith(
                color: AppColorScheme.of(context).labelStrong,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.space24),
          // 그리드/빈 상태 — Figma item_list px16
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.space16,
            ),
            child: items.isNotEmpty
                ? _buildGrid()
                : HomeEmptyCard(message: emptyMessage),
          ),
          const SizedBox(height: AppSpacing.md),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.space16,
            ),
            child: HomeSectionMoreButton(label: moreLabel, onTap: onMoreTap),
          ),
        ],
      ),
    );
  }

  /// 공통 상품 그리드 (2열) — Figma item_list gap[24,12] (행 24, 열 12).
  Widget _buildGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.sm,
        mainAxisSpacing: AppSpacing.space24,
        // 정사각 이미지 + 텍스트(태그/브랜드/이름 2줄/가격/구독할인가) 수용 높이.
        // 오버플로우 방지는 ProductCard 내부 Expanded+Flexible 구조가 보장.
        childAspectRatio: 0.56,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        // 인앱 상품 상세로 이동하므로 purchaseUrl 유무와 무관하게 탭 활성
        // (구매 링크는 상세 화면 CTA 에서 처리)
        final bool tappable = onItemTap != null;
        // 카드별 Obx — 해당 카드의 좋아요 상태만 구독
        return Obx(
          () => ProductCard(
            name: item.name,
            subtitle: '${item.manufacturer ?? '브랜드명'} | ${item.origin}',
            isLiked: isLiked(item.id),
            onLikeTap: () => onLikeTap(item.id),
            onTap: tappable ? () => onItemTap!(item) : null,
            imageUrl: item.imageUrl,
            matchPercent: item.matchPercent,
            discountPercent: item.discountPercent,
            price: item.discountPrice ?? item.originalPrice,
          ),
        );
      },
    );
  }
}
