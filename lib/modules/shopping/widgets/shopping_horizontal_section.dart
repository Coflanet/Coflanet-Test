import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/spacing_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/data/models/survey_result_model.dart';
import 'package:coflanet/modules/home/widgets/home_section_more_button.dart';
import 'package:coflanet/widgets/cards/card_section.dart';
import 'package:coflanet/widgets/cards/product_card.dart';

/// 쇼핑 가로 스크롤 상품 섹션 — Figma `recommend_item_list`(101:28344) 1:1.
///
/// 큰 카드([CardSection]) 안에 타이틀(+보조문구) → 가로 스크롤 상품 카드 →
/// 하단 풀폭 버튼 순으로 쌓는다. '님을 위한 추천 원두', '실시간 인기' 가 공유한다.
///
/// 좋아요 반응성: 카드 단위 Obx 로 [isLiked] 를 구독한다(전체 단일 Obx 금지).
class ShoppingHorizontalSection extends StatelessWidget {
  const ShoppingHorizontalSection({
    super.key,
    required this.title,
    required this.items,
    required this.isLiked,
    required this.onLikeTap,
    required this.onItemTap,
    this.subtitle,
    this.moreLabel,
    this.onMoreTap,
  });

  /// 섹션 타이틀
  final String title;

  /// 타이틀 아래 보조 문구 (예: '#닉네임의 #취향저격') — null 이면 생략
  final String? subtitle;

  /// 상품 목록
  final List<CoffeeRecommendationModel> items;

  final bool Function(String id) isLiked;
  final void Function(String id) onLikeTap;
  final void Function(CoffeeRecommendationModel item) onItemTap;

  /// 하단 버튼 라벨 — null 이면 버튼 생략
  final String? moreLabel;
  final VoidCallback? onMoreTap;

  /// 가로 카드 너비 / 리스트 높이 (이미지 1:1 + 텍스트 블록 수용 레이아웃 치수)
  static const double _cardWidth = 150;
  static const double _listHeight = 300;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);
    // Figma recommend_item_list: pt32/pb16, 타이틀 px24, 리스트 px16, 타이틀↔리스트 gap24.
    return CardSection(
      padding: const EdgeInsets.only(
        top: AppSpacing.space32,
        bottom: AppSpacing.space16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.heading2Bold.copyWith(
                    color: colors.labelStrong,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: AppSpacing.space6),
                  Text(
                    subtitle!,
                    style: AppTextStyles.label1NormalMedium.copyWith(
                      color: colors.labelAlternative,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.space24),
          SizedBox(
            height: _listHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.space16,
              ),
              itemCount: items.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: AppSpacing.space12),
              itemBuilder: (context, index) {
                final item = items[index];
                return SizedBox(
                  width: _cardWidth,
                  child: Obx(
                    () => ProductCard(
                      name: item.name,
                      subtitle:
                          '${item.manufacturer ?? '브랜드명'} | ${item.origin}',
                      isLiked: isLiked(item.id),
                      onLikeTap: () => onLikeTap(item.id),
                      onTap: () => onItemTap(item),
                      imageUrl: item.imageUrl,
                      discountPercent: item.discountPercent,
                      price: item.discountPrice ?? item.originalPrice,
                      rating: item.rating,
                      reviewCount: item.reviewCount,
                    ),
                  ),
                );
              },
            ),
          ),
          if (moreLabel != null) ...[
            const SizedBox(height: AppSpacing.md),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.space16,
              ),
              child: HomeSectionMoreButton(
                label: moreLabel!,
                onTap: onMoreTap,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
