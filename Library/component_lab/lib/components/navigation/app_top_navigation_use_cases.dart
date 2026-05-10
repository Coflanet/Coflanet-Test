import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import 'app_top_navigation.dart';

// ═══════════════════════════════════════════════════════════════
// TOP NAVIGATION — Figma `Top Navigation`
// ═══════════════════════════════════════════════════════════════
final List<WidgetbookComponent> topNavigationUseCases = [
  WidgetbookComponent(
    name: 'Top Navigation — Normal',
    useCases: [
      WidgetbookUseCase(
        name: 'With Leading & Trailing Actions',
        builder: (context) => _bg(
          context,
          AppTopNavigation(
            title: 'Page Title',
            variant: TopNavigationVariant.normal,
            leadingIcon: Icons.arrow_back_rounded,
            onLeadingPressed: () {},
            trailingActions: [
              TopNavAction(icon: Icons.search_rounded),
              TopNavAction(icon: Icons.notifications_none),
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'With Leading Icon Only',
        builder: (context) => _bg(
          context,
          AppTopNavigation(
            title: 'Page Title',
            variant: TopNavigationVariant.normal,
            leadingIcon: Icons.menu_rounded,
            onLeadingPressed: () {},
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'With Trailing Actions Only',
        builder: (context) => _bg(
          context,
          AppTopNavigation(
            title: 'Settings',
            variant: TopNavigationVariant.normal,
            trailingActions: [
              TopNavAction(icon: Icons.search_rounded),
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'No Icons',
        builder: (context) => _bg(
          context,
          const AppTopNavigation(
            title: 'Simple Title',
            variant: TopNavigationVariant.normal,
          ),
        ),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Top Navigation — Extended',
    useCases: [
      WidgetbookUseCase(
        name: 'Extended Variant',
        builder: (context) => _bg(
          context,
          AppTopNavigation(
            title: 'Extended Navigation',
            variant: TopNavigationVariant.extended,
            leadingIcon: Icons.arrow_back_rounded,
            onLeadingPressed: () {},
            trailingActions: [
              TopNavAction(icon: Icons.info_rounded),
            ],
          ),
        ),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Top Navigation — Floating',
    useCases: [
      WidgetbookUseCase(
        name: 'Floating Variant',
        builder: (context) => _bg(
          context,
          AppTopNavigation(
            title: 'Floating Navigation',
            variant: TopNavigationVariant.floating,
            leadingIcon: Icons.arrow_back_rounded,
            onLeadingPressed: () {},
            trailingActions: [
              TopNavAction(icon: Icons.bookmark_rounded),
            ],
          ),
        ),
      ),
    ],
  ),
];

Widget _bg(BuildContext context, Widget child) {
  return Container(
    color: Theme.of(context).canvasColor,
    child: child,
  );
}
