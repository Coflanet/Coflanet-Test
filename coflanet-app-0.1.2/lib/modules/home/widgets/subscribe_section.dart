import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/data/models/coffee_item_model.dart';
import 'package:coflanet/modules/home/widgets/home_coffee_card.dart';

/// Subscribe item list section for Home screen
/// Figma: 3 states - Empty(Min), 1-3 items(List), 3+ items(PageView)
class SubscribeSection extends StatefulWidget {
  final List<CoffeeItem> items;
  final VoidCallback? onEditTap;
  final VoidCallback? onViewAllTap;
  final VoidCallback? onEmptyTap;
  final void Function(CoffeeItem)? onItemTap;

  const SubscribeSection({
    super.key,
    required this.items,
    this.onEditTap,
    this.onViewAllTap,
    this.onEmptyTap,
    this.onItemTap,
  });

  @override
  State<SubscribeSection> createState() => _SubscribeSectionState();
}

class _SubscribeSectionState extends State<SubscribeSection> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return _buildEmpty();
    }
    return _buildFilled();
  }

  /// Case A: Empty state - violet pill with CTA text + thumbnail
  /// Figma: subscribe_item_list_Min, h:120, radius:40, p:24
  Widget _buildEmpty() {
    return GestureDetector(
      onTap: widget.onEmptyTap,
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: AppColor.primaryNormal,
          borderRadius: AppRadius.sectionBorder,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                '원두를 구독하시거나\n레시피를 등록해보세요',
                style: AppTextStyles.heading2Bold.copyWith(
                  color: AppColor.staticLabelWhiteNormal,
                ),
              ),
            ),
            // Thumbnail placeholder
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColor.primaryStrong,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Icon(
                  Icons.coffee_outlined,
                  color: AppColor.colorGlobalCoolNeutral90,
                  size: 32,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Case B & C: Filled state - violet section with card list
  /// Figma: subscribe_item_list, bg:#6541F2, radius:40, pt:32, pb:16, gap:16
  Widget _buildFilled() {
    final bool usePageView = widget.items.length > 3;

    return Container(
      decoration: BoxDecoration(
        color: AppColor.accentBackgroundViolet,
        borderRadius: AppRadius.sectionBorder,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Heading: title + edit button, px:24, pt:32
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl, // px: 24
              AppSpacing.space32, // pt: 32
              AppSpacing.xl, // px: 24
              0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '레시피를 시작해볼까요?',
                  style: AppTextStyles.heading2Bold.copyWith(
                    color: AppColor.staticLabelWhiteNormal,
                  ),
                ),
                GestureDetector(
                  onTap: widget.onEditTap,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      '편집하기',
                      style: AppTextStyles.body1NormalMedium.copyWith(
                        color: AppColor.staticLabelWhiteNeutral,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md), // gap: 16

          // Container: card list + button, px:16
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Column(
              children: [
                // Card list area
                usePageView
                    ? _buildPageViewCards()
                    : _buildVerticalCards(),

                if (usePageView) ...[
                  const SizedBox(height: AppSpacing.md),
                  _buildPaginationDots(),
                ],

                const SizedBox(height: AppSpacing.xl), // gap: 24

                // "전체보기" CTA button - LiquidGlass style, h:48, pill
                _buildViewAllButton(),

                const SizedBox(height: AppSpacing.md), // pb: 16
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Case B: Vertical card list (1-3 items), gap:4
  Widget _buildVerticalCards() {
    return Column(
      children: widget.items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: HomeCoffeeCard(
            item: item,
            onTap: () => widget.onItemTap?.call(item),
          ),
        );
      }).toList(),
    );
  }

  /// Case C: Horizontal PageView (3+ items), column width:320, gap:12
  Widget _buildPageViewCards() {
    // Group items into pages of 3
    final pages = <List<CoffeeItem>>[];
    for (int i = 0; i < widget.items.length; i += 3) {
      final end = (i + 3 > widget.items.length) ? widget.items.length : i + 3;
      pages.add(widget.items.sublist(i, end));
    }

    return SizedBox(
      height: 320, // 3 cards * 104 + 2 gaps * 4 = 320
      child: PageView.builder(
        itemCount: pages.length,
        onPageChanged: (index) => setState(() => _currentPage = index),
        controller: PageController(viewportFraction: 0.97),
        itemBuilder: (context, pageIndex) {
          final pageItems = pages[pageIndex];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Column(
              children: pageItems.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: HomeCoffeeCard(
                    item: item,
                    onTap: () => widget.onItemTap?.call(item),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  /// Pagination dots: 8x8, gap:8, active:white, inactive:white@16%
  Widget _buildPaginationDots() {
    final pageCount = ((widget.items.length + 2) / 3).ceil();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pageCount, (index) {
        final isActive = index == _currentPage;
        return Container(
          width: 8,
          height: 8,
          margin: EdgeInsets.only(right: index < pageCount - 1 ? 8 : 0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColor.staticLabelWhiteNormal.withOpacity(
              isActive ? 1.0 : 0.16,
            ),
          ),
        );
      }),
    );
  }

  /// "전체보기" button - Figma: Button/Solid/LiquidGlass, h:48, pill
  Widget _buildViewAllButton() {
    return GestureDetector(
      onTap: widget.onViewAllTap,
      child: Container(
        height: 48,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(99),
          // LiquidGlass: translucent white glass effect on violet
          color: AppColor.colorGlobalCommon100.withOpacity(0.18),
        ),
        alignment: Alignment.center,
        child: Text(
          '전체보기',
          style: AppTextStyles.body1NormalMedium.copyWith(
            color: AppColor.staticLabelWhiteNormal,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
