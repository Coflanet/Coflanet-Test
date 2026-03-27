import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/data/models/coffee_item_model.dart';

/// Recommend item list section for Home screen
/// Figma: recommend_item_list, bg:white, radius:40, py:32, gap:24
/// Contains title + hashtags + 2-column grid of vertical item cards
class RecommendSection extends StatelessWidget {
  final String title;
  final List<String> hashtags;
  final List<CoffeeItem> items;
  final void Function(CoffeeItem)? onItemTap;

  const RecommendSection({
    super.key,
    this.title = '이런 원두는 어떠세요?',
    this.hashtags = const ['ㅇㅇㅇ님의', '취향저격', '원두'],
    required this.items,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.backgroundNormalNormal,
        borderRadius: AppRadius.sectionBorder,
      ),
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.space32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title area: px:24, gap:4
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.heading2Bold.copyWith(
                    color: AppColor.labelNormal,
                  ),
                ),
                const SizedBox(height: 4),
                // Hashtags row
                Row(
                  children: hashtags.map((tag) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Text(
                        '#$tag',
                        style: AppTextStyles.body2NormalRegular.copyWith(
                          color: AppColor.labelAlternative,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl), // gap: 24

          // 2-column grid: px:16, gap: 24(v) 12(h)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: _buildGrid(),
          ),
        ],
      ),
    );
  }

  /// 2-column wrap grid, item width:158 (flexible), gap: 12h, 24v
  Widget _buildGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final spacing = 12.0;
        final itemWidth = (constraints.maxWidth - spacing) / 2;

        return Wrap(
          spacing: spacing,
          runSpacing: 24,
          children: items.map((item) {
            return SizedBox(
              width: itemWidth,
              child: _RecommendItemCard(
                item: item,
                onTap: () => onItemTap?.call(item),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

/// Vertical item card for recommend grid
/// Figma: List/Item/Vertical - thumbnail(1:1, r:20) + text info
class _RecommendItemCard extends StatelessWidget {
  final CoffeeItem item;
  final VoidCallback? onTap;

  const _RecommendItemCard({required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail: 1:1 aspect ratio, radius:20
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                color: AppColor.componentFillNormal,
                borderRadius: BorderRadius.circular(20),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  // Image
                  if (item.imageUrl != null)
                    Positioned.fill(
                      child: Image.network(
                        item.imageUrl!,
                        fit: BoxFit.cover,
                      ),
                    )
                  else
                    Center(
                      child: Icon(
                        Icons.coffee,
                        color: item.color,
                        size: 40,
                      ),
                    ),
                  // Heart icon overlay (top right)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColor.colorGlobalCommon0.withOpacity(0.2),
                      ),
                      child: const Icon(
                        Icons.favorite_border,
                        color: AppColor.colorGlobalCommon100,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Text info
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Brand + origin
              Row(
                children: [
                  Flexible(
                    child: Text(
                      item.brand ?? '브랜드명',
                      style: AppTextStyles.label2Regular.copyWith(
                        color: AppColor.labelAlternative,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (item.origin != null) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Container(
                        width: 1,
                        height: 10,
                        color: AppColor.lineNormalNeutral,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        item.origin!,
                        style: AppTextStyles.label2Regular.copyWith(
                          color: AppColor.labelAlternative,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 4),
              // Coffee name
              Text(
                item.name,
                style: AppTextStyles.label1NormalMedium.copyWith(
                  color: AppColor.labelNormal,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
