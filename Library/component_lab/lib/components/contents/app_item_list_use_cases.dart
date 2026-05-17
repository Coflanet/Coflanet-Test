import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../foundation/app_spacing.dart';
import 'app_item_list.dart';

// ═══════════════════════════════════════════════════════════════
// ITEM LIST — Figma `Contents/Item List`
// ═══════════════════════════════════════════════════════════════

final List<WidgetbookComponent> itemListUseCases = [
  WidgetbookComponent(
    name: 'Item List — Heart Toggle',
    useCases: [
      WidgetbookUseCase(
        name: 'Default (unliked)',
        builder: (context) => _bg(
          context,
          AppItemHeart(isLiked: false, onTap: () {}),
        ),
      ),
      WidgetbookUseCase(
        name: 'Liked',
        builder: (context) => _bg(
          context,
          AppItemHeart(isLiked: true, onTap: () {}),
        ),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Item List — Vertical Card',
    useCases: [
      WidgetbookUseCase(
        name: 'Basic vertical',
        builder: (context) => _bg(
          context,
          AppItemCard(
            name: '원두 이름을 입력해주세요',
            price: 12000,
            onLikeTap: () {},
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'With brand tags + discount',
        builder: (context) => _bg(
          context,
          AppItemCard(
            name: '원두 이름을 입력해주세요',
            price: 12000,
            discountPercent: 12,
            brandTags: const ['NEW', 'BEST'],
            onLikeTap: () {},
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Liked + rating',
        builder: (context) => _bg(
          context,
          AppItemCard(
            name: '원두 이름을 입력해주세요',
            price: 12000,
            discountPercent: 12,
            rating: 4.8,
            reviewCount: 31,
            isLiked: true,
            onLikeTap: () {},
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Grid (3 columns)',
        builder: (context) => _bg(
          context,
          Wrap(
            spacing: AppSpacing.s12,
            runSpacing: AppSpacing.s16,
            children: List.generate(
              3,
              (i) => AppItemCard(
                name: '원두 이름 ${i + 1}',
                price: 12000,
                discountPercent: 12,
                rating: 4.8,
                reviewCount: 31,
                brandTags: i == 0 ? ['NEW'] : (i == 1 ? ['BEST'] : []),
                isLiked: i == 1,
                onLikeTap: () {},
              ),
            ),
          ),
        ),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Item List — Horizontal Card',
    useCases: [
      WidgetbookUseCase(
        name: 'Basic horizontal',
        builder: (context) => _bg(
          context,
          AppItemCard(
            layout: AppItemCardLayout.horizontal,
            name: '원두 이름을 입력해주세요',
            price: 12000,
            onLikeTap: () {},
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Full info',
        builder: (context) => _bg(
          context,
          AppItemCard(
            layout: AppItemCardLayout.horizontal,
            name: '원두 이름을 입력해주세요 두 줄까지 표시',
            price: 12000,
            discountPercent: 12,
            brandTags: const ['신미 강함', '자몽', '라벤더', '외 5개'],
            rating: 4.8,
            reviewCount: 31,
            isLiked: true,
            onLikeTap: () {},
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'List (vertical stack)',
        builder: (context) => _bg(
          context,
          Column(
            children: List.generate(
              3,
              (i) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.s12),
                child: AppItemCard(
                  layout: AppItemCardLayout.horizontal,
                  name: '원두 이름 ${i + 1}',
                  price: 12000 + i * 1000,
                  discountPercent: 12,
                  rating: 4.8,
                  reviewCount: 31,
                  isLiked: i == 0,
                  onLikeTap: () {},
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  ),
];

Widget _bg(BuildContext context, Widget child) {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(AppSpacing.s16),
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 480),
      child: Container(
        color: Theme.of(context).canvasColor,
        child: child,
      ),
    ),
  );
}
