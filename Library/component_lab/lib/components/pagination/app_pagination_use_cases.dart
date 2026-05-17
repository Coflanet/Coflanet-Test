import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../foundation/app_spacing.dart';
import 'app_pagination.dart';

// ═══════════════════════════════════════════════════════════════
// PAGINATION — Figma `Pagination`
// ═══════════════════════════════════════════════════════════════
final List<WidgetbookComponent> paginationUseCases = [
  WidgetbookComponent(
    name: 'Pagination Counter — Dot',
    useCases: [
      WidgetbookUseCase(
        name: 'Dot Counter — Current 1 of 5',
        builder: (context) => _bg(
          context,
          AppPaginationCounter(
            currentPage: 1,
            totalPages: 5,
            size: AppPaginationCounterSize.medium,
            alternative: false,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Dot Counter — Current 3 of 8',
        builder: (context) => _bg(
          context,
          AppPaginationCounter(
            currentPage: 3,
            totalPages: 8,
            size: AppPaginationCounterSize.small,
            alternative: false,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Dot Counter — Last page (5 of 5)',
        builder: (context) => _bg(
          context,
          AppPaginationCounter(
            currentPage: 5,
            totalPages: 5,
            alternative: false,
          ),
        ),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Pagination Counter — Numeric',
    useCases: [
      WidgetbookUseCase(
        name: 'Numeric Counter — 1 of 10',
        builder: (context) => _bg(
          context,
          AppPaginationCounter(
            currentPage: 1,
            totalPages: 10,
            alternative: true,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Numeric Counter — 5 of 20',
        builder: (context) => _bg(
          context,
          AppPaginationCounter(
            currentPage: 5,
            totalPages: 20,
            alternative: true,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Numeric Counter — Last page',
        builder: (context) => _bg(
          context,
          AppPaginationCounter(
            currentPage: 100,
            totalPages: 100,
            alternative: true,
          ),
        ),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Pagination Navigation',
    useCases: [
      WidgetbookUseCase(
        name: 'Extended — First Page',
        builder: (context) => _bg(
          context,
          AppPaginationNavigation(
            currentPage: 1,
            totalPages: 10,
            variant: AppPaginationNavigationVariant.extended,
            onPageChanged: (page) {},
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Extended — Middle Page',
        builder: (context) => _bg(
          context,
          AppPaginationNavigation(
            currentPage: 5,
            totalPages: 10,
            variant: AppPaginationNavigationVariant.extended,
            onPageChanged: (page) {},
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Extended — Last Page',
        builder: (context) => _bg(
          context,
          AppPaginationNavigation(
            currentPage: 10,
            totalPages: 10,
            variant: AppPaginationNavigationVariant.extended,
            onPageChanged: (page) {},
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Compact',
        builder: (context) => _bg(
          context,
          AppPaginationNavigation(
            currentPage: 5,
            totalPages: 50,
            variant: AppPaginationNavigationVariant.compact,
            onPageChanged: (page) {},
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Minimize',
        builder: (context) => _bg(
          context,
          AppPaginationNavigation(
            currentPage: 7,
            totalPages: 25,
            variant: AppPaginationNavigationVariant.minimize,
            onPageChanged: (page) {},
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
