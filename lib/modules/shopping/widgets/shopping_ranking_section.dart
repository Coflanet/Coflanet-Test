import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/util_constant.dart';
import 'package:coflanet/data/models/survey_result_model.dart';
import 'package:coflanet/modules/home/widgets/home_section_more_button.dart';
import 'package:coflanet/widgets/cards/card_section.dart';

/// 인기 원두 랭킹 섹션 — Figma `recommend_item_list`(101:28393) 1:1.
///
/// 타이틀 → 순위 행(랭크 배지 + 썸네일 + 정보 + 향미 태그) 목록 → 전체보기 버튼.
class ShoppingRankingSection extends StatelessWidget {
  const ShoppingRankingSection({
    super.key,
    required this.title,
    required this.items,
    required this.isLiked,
    required this.onLikeTap,
    required this.onItemTap,
    this.moreLabel,
    this.onMoreTap,
  });

  final String title;
  final List<CoffeeRecommendationModel> items;
  final bool Function(String id) isLiked;
  final void Function(String id) onLikeTap;
  final void Function(CoffeeRecommendationModel item) onItemTap;
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space24),
            child: Text(
              title,
              style: AppTextStyles.heading2Bold.copyWith(
                color: colors.labelStrong,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.space24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space24),
            child: Column(
              children: [
                for (int i = 0; i < items.length; i++) ...[
                  if (i > 0) const SizedBox(height: AppSpacing.space20),
                  Obx(
                    () => _RankingRow(
                      rank: i + 1,
                      item: items[i],
                      isLiked: isLiked(items[i].id),
                      onLikeTap: () => onLikeTap(items[i].id),
                      onTap: () => onItemTap(items[i]),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (moreLabel != null) ...[
            const SizedBox(height: AppSpacing.xl),
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

/// 단일 순위 행 — 랭크 배지 + 썸네일 + 정보(이름/가격/별점/향미).
class _RankingRow extends StatelessWidget {
  const _RankingRow({
    required this.rank,
    required this.item,
    required this.isLiked,
    required this.onLikeTap,
    required this.onTap,
  });

  final int rank;
  final CoffeeRecommendationModel item;
  final bool isLiked;
  final VoidCallback onLikeTap;
  final VoidCallback onTap;

  /// 썸네일 한 변 (레이아웃 치수)
  static const double _thumbSize = 72;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRankBadge(colors),
          const SizedBox(width: AppSpacing.sm),
          _buildThumb(colors),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: _buildInfo(colors)),
          const SizedBox(width: AppSpacing.xs),
          _buildLikeButton(colors),
        ],
      ),
    );
  }

  /// 랭크 배지 — 1위는 primary 강조, 그 외 중립.
  Widget _buildRankBadge(AppColorScheme colors) {
    final bool top = rank == 1;
    return Container(
      width: AppSpacing.space24,
      height: AppSpacing.space24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: top ? colors.primaryNormal : colors.componentFillAlternative,
        borderRadius: AppRadius.fullBorder,
      ),
      child: Text(
        '$rank',
        style: AppTextStyles.caption1Bold.copyWith(
          color: top ? AppColor.staticWhite : colors.labelNormal,
        ),
      ),
    );
  }

  Widget _buildThumb(AppColorScheme colors) {
    return Container(
      width: _thumbSize,
      height: _thumbSize,
      decoration: BoxDecoration(
        color: colors.surfaceCardStrong,
        borderRadius: AppRadius.xlBorder,
        image: item.imageUrl != null
            ? DecorationImage(
                image: NetworkImage(item.imageUrl!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: item.imageUrl == null
          ? Icon(Icons.coffee, size: AppSpacing.space32, color: colors.primaryNormal)
          : null,
    );
  }

  Widget _buildInfo(AppColorScheme colors) {
    final price = item.discountPrice ?? item.originalPrice;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${item.manufacturer ?? '브랜드명'} | ${item.origin}',
          style: AppTextStyles.caption1Regular.copyWith(
            color: colors.labelAlternative,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSpacing.space2),
        Text(
          item.name,
          style: AppTextStyles.body2NormalMedium.copyWith(
            color: colors.labelNormal,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSpacing.space4),
        Row(
          children: [
            if (item.discountPercent != null) ...[
              Text(
                '${item.discountPercent}%',
                style: AppTextStyles.body2NormalBold.copyWith(
                  color: colors.primaryNormal,
                ),
              ),
              const SizedBox(width: AppSpacing.space2),
            ],
            if (price != null)
              Text(
                AppUtil.changeNumberToWon(price),
                style: AppTextStyles.body2NormalBold.copyWith(
                  color: colors.labelNormal,
                ),
              ),
          ],
        ),
        if (item.rating != null) ...[
          const SizedBox(height: AppSpacing.space4),
          Row(
            children: [
              const Icon(
                Icons.star_rounded,
                size: AppSpacing.space16,
                color: AppColor.colorGlobalYellow50,
              ),
              const SizedBox(width: AppSpacing.space2),
              Text(
                item.rating!.toStringAsFixed(2),
                style: AppTextStyles.caption1Bold.copyWith(
                  color: colors.labelNormal,
                ),
              ),
              if (item.reviewCount != null) ...[
                const SizedBox(width: AppSpacing.space2),
                Text(
                  '리뷰 ${AppUtil.formatNumberWithComma(item.reviewCount)}',
                  style: AppTextStyles.caption1Regular.copyWith(
                    color: colors.labelAssistive,
                  ),
                ),
              ],
            ],
          ),
        ],
        if (item.flavorTags.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.space6),
          Text(
            _flavorLine(item.flavorTags),
            style: AppTextStyles.caption1Regular.copyWith(
              color: colors.labelAlternative,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  /// 향미 태그 — 앞 3개 ' · ' 연결 + '외 N개'
  String _flavorLine(List<String> tags) {
    const maxShown = 3;
    final shown = tags.take(maxShown).join(' · ');
    if (tags.length > maxShown) {
      return '$shown 외 ${tags.length - maxShown}개';
    }
    return shown;
  }

  Widget _buildLikeButton(AppColorScheme colors) {
    return Semantics(
      label: isLiked ? '좋아요 취소' : '좋아요',
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onLikeTap,
        child: Icon(
          isLiked ? Icons.favorite : Icons.favorite_border,
          size: AppSpacing.space24,
          color: isLiked ? colors.primaryNormal : colors.labelAssistive,
        ),
      ),
    );
  }
}
