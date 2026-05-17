import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../foundation/app_spacing.dart';
import 'app_category.dart';

// ═══════════════════════════════════════════════════════════════
// CATEGORY — Figma `Category`
// ═══════════════════════════════════════════════════════════════
final List<WidgetbookComponent> categoryUseCases = [
  WidgetbookComponent(
    name: 'Category',
    useCases: [
      WidgetbookUseCase(
        name: 'Normal Variant — Medium',
        builder: (context) => _bg(
          context,
          Column(
            children: [
              AppCategory(
                items: ['All', 'Nature', 'Urban', 'Food'],
                selectedIndex: 0,
                onChanged: (index) {},
                variant: AppCategoryVariant.normal,
                size: AppCategorySize.medium,
              ),
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Normal Variant — Small',
        builder: (context) => _bg(
          context,
          AppCategory(
            items: ['All', 'Design', 'Code', 'Art'],
            selectedIndex: 1,
            onChanged: (index) {},
            variant: AppCategoryVariant.normal,
            size: AppCategorySize.small,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Alternative Variant — Medium',
        builder: (context) => _bg(
          context,
          AppCategory(
            items: ['All', 'Trending', 'Popular', 'Latest'],
            selectedIndex: 2,
            onChanged: (index) {},
            variant: AppCategoryVariant.alternative,
            size: AppCategorySize.medium,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Alternative Variant — Small',
        builder: (context) => _bg(
          context,
          AppCategory(
            items: ['React', 'Vue', 'Angular', 'Svelte'],
            selectedIndex: 0,
            onChanged: (index) {},
            variant: AppCategoryVariant.alternative,
            size: AppCategorySize.small,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Multiple Items (Scroll)',
        builder: (context) => _bg(
          context,
          AppCategory(
            items: [
              'Electronics',
              'Fashion',
              'Home & Garden',
              'Beauty',
              'Toys & Games',
              'Sports',
              'Books'
            ],
            selectedIndex: 0,
            onChanged: (index) {},
          ),
        ),
      ),
    ],
  ),
];

Widget _bg(BuildContext context, Widget child) {
  return Container(
    padding: const EdgeInsets.all(AppSpacing.s16),
    color: Theme.of(context).canvasColor,
    child: child,
  );
}
