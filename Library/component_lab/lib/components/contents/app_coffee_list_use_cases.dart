import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../foundation/app_spacing.dart';
import 'app_coffee_list.dart';

// ═══════════════════════════════════════════════════════════════
// COFFEE LIST — Figma `Contents/Coffee List` (Button Touch)
// ═══════════════════════════════════════════════════════════════

const _attributes = <String, double>{
  '산미': 5.0,
  '바디감': 3.5,
  '단맛': 2.2,
  '쓴맛': 1.0,
  '밸런스': 4.2,
};

const _myPreference = <String, double>{
  '산미': 5.0,
  '바디감': 3.5,
  '단맛': 2.2,
  '쓴맛': 1.0,
  '밸런스': 4.2,
};

const _flavorNotes = <String>[
  '과일 향',
  '다크초콜릿',
  '꽃 향',
  '자스베리민',
  '로스팅 향',
];

final List<WidgetbookComponent> coffeeListUseCases = [
  WidgetbookComponent(
    name: 'Coffee List — Compact',
    useCases: [
      WidgetbookUseCase(
        name: 'Default (collapsed)',
        builder: (context) => _bg(
          context,
          AppCoffeeListItem(
            brand: '브랜드명 · 구독중',
            name: '원두 이름을 입력해주세요',
            onTap: () {},
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Selected (purple border + check)',
        builder: (context) => _bg(
          context,
          AppCoffeeListItem(
            brand: '브랜드명 · 구독중',
            name: '원두 이름을 입력해주세요',
            state: AppCoffeeListItemState.selected,
            onTap: () {},
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Disabled',
        builder: (context) => _bg(
          context,
          AppCoffeeListItem(
            brand: '브랜드명 · 구독중',
            name: '원두 이름을 입력해주세요',
            state: AppCoffeeListItemState.disabled,
            onTap: () {},
          ),
        ),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Coffee List — Expanded',
    useCases: [
      WidgetbookUseCase(
        name: 'Full card (single track)',
        builder: (context) => _bg(
          context,
          AppCoffeeListItem(
            brand: '브랜드명 · 구독중',
            name: '원두 이름을 입력해주세요',
            price: 12000,
            discountPercent: 12,
            attributes: _attributes,
            flavorNotes: _flavorNotes,
            expanded: true,
            isLiked: true,
            onLikeTap: () {},
            onDetailTap: () {},
            onRecipeTap: () {},
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Full card (dual track — 커피 vs 내취향)',
        builder: (context) => _bg(
          context,
          AppCoffeeListItem(
            brand: '브랜드명 · 구독중',
            name: '원두 이름을 입력해주세요',
            price: 12000,
            discountPercent: 12,
            attributes: _attributes,
            compared: _myPreference,
            flavorNotes: _flavorNotes,
            expanded: true,
            isLiked: true,
            state: AppCoffeeListItemState.selected,
            onLikeTap: () {},
            onDetailTap: () {},
            onRecipeTap: () {},
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'No actions (read-only)',
        builder: (context) => _bg(
          context,
          AppCoffeeListItem(
            brand: '브랜드명 · 구독중',
            name: '원두 이름을 입력해주세요',
            price: 12000,
            discountPercent: 12,
            attributes: _attributes,
            flavorNotes: _flavorNotes,
            expanded: true,
          ),
        ),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Coffee List — Stack',
    useCases: [
      WidgetbookUseCase(
        name: 'Mixed (compact + expanded selected)',
        builder: (context) => _bg(
          context,
          Column(
            children: [
              AppCoffeeListItem(
                brand: '브랜드명 · 구독중',
                name: '에티오피아 예가체프',
                onTap: () {},
              ),
              const SizedBox(height: AppSpacing.space8),
              AppCoffeeListItem(
                brand: '브랜드명 · 구독중',
                name: '콜롬비아 수프리모',
                state: AppCoffeeListItemState.selected,
                onTap: () {},
              ),
              const SizedBox(height: AppSpacing.space8),
              AppCoffeeListItem(
                brand: '브랜드명 · 구독중',
                name: '브라질 산토스',
                price: 12000,
                discountPercent: 12,
                attributes: _attributes,
                compared: _myPreference,
                flavorNotes: _flavorNotes,
                expanded: true,
                state: AppCoffeeListItemState.selected,
                isLiked: true,
                onLikeTap: () {},
                onDetailTap: () {},
                onRecipeTap: () {},
              ),
            ],
          ),
        ),
      ),
    ],
  ),
];

Widget _bg(BuildContext context, Widget child) {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(AppSpacing.space16),
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 480),
      child: Container(
        color: Theme.of(context).canvasColor,
        child: child,
      ),
    ),
  );
}
