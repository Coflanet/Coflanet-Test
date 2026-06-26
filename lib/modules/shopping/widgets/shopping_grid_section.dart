import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/spacing_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/data/models/survey_result_model.dart';
import 'package:coflanet/modules/home/widgets/home_section_more_button.dart';
import 'package:coflanet/widgets/cards/card_section.dart';
import 'package:coflanet/widgets/cards/product_card.dart';

/// 쇼핑 2열 그리드 상품 섹션 — Figma `recommend_item_list`/`Time_Sale` 1:1.
///
/// 타이틀(+우측 trailing) → 선택적 헤더(필터 칩 등) → 2열 상품 그리드 →
/// 하단 풀폭 버튼. '카테고리별 베스트', '타임세일' 이 공유한다.
class ShoppingGridSection extends StatelessWidget {
  const ShoppingGridSection({
    super.key,
    required this.title,
    required this.items,
    required this.isLiked,
    required this.onLikeTap,
    required this.onItemTap,
    this.trailing,
    this.header,
    this.childAspectRatio = 0.54,
    this.badgesFor,
    this.moreLabel,
    this.onMoreTap,
  });

  final String title;

  /// 타이틀 우측 위젯 (예: 타임세일 카운트다운 pill)
  final Widget? trailing;

  /// 타이틀 아래 헤더 영역 (예: 필터 칩 Row) — null 이면 생략
  final Widget? header;

  final List<CoffeeRecommendationModel> items;
  final bool Function(String id) isLiked;
  final void Function(String id) onLikeTap;
  final void Function(CoffeeRecommendationModel item) onItemTap;

  /// 그리드 셀 종횡비 — 별점/뱃지 유무에 따라 호출부가 조정
  final double childAspectRatio;

  /// 인덱스별 상태 뱃지 (New/Best) — null 이면 뱃지 없음
  final List<String> Function(int index)? badgesFor;

  final String? moreLabel;
  final VoidCallback? onMoreTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);
    return CardSection(
      padding: const EdgeInsets.only(
        top: AppSpacing.space32,
        bottom: AppSpacing.space16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 타이틀 행 (+ trailing)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space24),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.heading2Bold.copyWith(
                      color: colors.labelStrong,
                    ),
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: AppSpacing.xs),
                  trailing!,
                ],
              ],
            ),
          ),
          if (header != null) ...[
            const SizedBox(height: AppSpacing.md),
            header!,
          ],
          const SizedBox(height: AppSpacing.space24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space16),
            child: _buildGrid(),
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

  Widget _buildGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.sm,
        mainAxisSpacing: AppSpacing.space24,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Obx(
          () => ProductCard(
            name: item.name,
            subtitle: '${item.manufacturer ?? '브랜드명'} | ${item.origin}',
            isLiked: isLiked(item.id),
            onLikeTap: () => onLikeTap(item.id),
            onTap: () => onItemTap(item),
            imageUrl: item.imageUrl,
            discountPercent: item.discountPercent,
            price: item.discountPrice ?? item.originalPrice,
            rating: item.rating,
            reviewCount: item.reviewCount,
            badges: badgesFor?.call(index) ?? const [],
          ),
        );
      },
    );
  }
}
