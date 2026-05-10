import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../foundation/app_spacing.dart';
import 'app_tab_bar.dart';

// ═══════════════════════════════════════════════════════════════
// TAB BAR — Figma `Tab Bar`
// ═══════════════════════════════════════════════════════════════
final List<WidgetbookComponent> tabBarUseCases = [
  WidgetbookComponent(
    name: 'Tab Bar',
    useCases: [
      WidgetbookUseCase(
        name: 'Size Large',
        builder: (context) => _bg(
          context,
          AppTabBar(
            tabs: const ['Tab 1', 'Tab 2', 'Tab 3'],
            selectedIndex: 0,
            onTabChanged: (index) {},
            size: AppTabBarSize.large,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Size Medium',
        builder: (context) => _bg(
          context,
          AppTabBar(
            tabs: const ['Tab 1', 'Tab 2', 'Tab 3'],
            selectedIndex: 1,
            onTabChanged: (index) {},
            size: AppTabBarSize.medium,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Size Small',
        builder: (context) => _bg(
          context,
          AppTabBar(
            tabs: const ['Tab 1', 'Tab 2', 'Tab 3'],
            selectedIndex: 2,
            onTabChanged: (index) {},
            size: AppTabBarSize.small,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Resize Hug (Scrollable)',
        builder: (context) => _bg(
          context,
          AppTabBar(
            tabs: const ['Short', 'Medium Tab', 'Very Long Tab Name'],
            selectedIndex: 0,
            onTabChanged: (index) {},
            resize: AppTabBarResize.hug,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Resize Fill (Full width)',
        builder: (context) => _bg(
          context,
          AppTabBar(
            tabs: const ['Tab 1', 'Tab 2', 'Tab 3'],
            selectedIndex: 0,
            onTabChanged: (index) {},
            resize: AppTabBarResize.fill,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'With Trailing Icon',
        builder: (context) => _bg(
          context,
          AppTabBar(
            tabs: const ['Home', 'Search', 'Settings'],
            selectedIndex: 0,
            onTabChanged: (index) {},
            trailingIcon: Icons.close_rounded,
          ),
        ),
      ),
    ],
  ),
];

Widget _bg(BuildContext context, Widget child) {
  return Container(
    padding: const EdgeInsets.all(AppSpacing.space16),
    color: Theme.of(context).canvasColor,
    child: child,
  );
}
