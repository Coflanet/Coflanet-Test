import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../foundation/app_spacing.dart';
import 'app_bottom_navigation.dart';

// ═══════════════════════════════════════════════════════════════
// BOTTOM NAVIGATION — Figma `Bottom Navigation`
// ═══════════════════════════════════════════════════════════════
final List<WidgetbookComponent> bottomNavigationUseCases = [
  WidgetbookComponent(
    name: 'Bottom Navigation',
    useCases: [
      WidgetbookUseCase(
        name: '3 Items',
        builder: (context) => _bg(
          context,
          Align(
            alignment: Alignment.bottomCenter,
            child: AppBottomNavigation(
              items: [
                BottomNavItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                  label: 'Home',
                ),
                BottomNavItem(
                  icon: Icons.search_outlined,
                  activeIcon: Icons.search_rounded,
                  label: 'Search',
                ),
                BottomNavItem(
                  icon: Icons.person_outline,
                  activeIcon: Icons.person_rounded,
                  label: 'Profile',
                ),
              ],
              currentIndex: 0,
              onTap: (index) {},
            ),
          ),
        ),
      ),
      WidgetbookUseCase(
        name: '4 Items',
        builder: (context) => _bg(
          context,
          Align(
            alignment: Alignment.bottomCenter,
            child: AppBottomNavigation(
              items: [
                BottomNavItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                  label: 'Home',
                ),
                BottomNavItem(
                  icon: Icons.favorite_outline,
                  activeIcon: Icons.favorite_rounded,
                  label: 'Likes',
                ),
                BottomNavItem(
                  icon: Icons.add_outlined,
                  activeIcon: Icons.add_rounded,
                  label: 'Create',
                ),
                BottomNavItem(
                  icon: Icons.person_outline,
                  activeIcon: Icons.person_rounded,
                  label: 'Profile',
                ),
              ],
              currentIndex: 2,
              onTap: (index) {},
            ),
          ),
        ),
      ),
      WidgetbookUseCase(
        name: '5 Items',
        builder: (context) => _bg(
          context,
          Align(
            alignment: Alignment.bottomCenter,
            child: AppBottomNavigation(
              items: [
                BottomNavItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                  label: 'Home',
                ),
                BottomNavItem(
                  icon: Icons.explore_outlined,
                  activeIcon: Icons.explore_rounded,
                  label: 'Explore',
                ),
                BottomNavItem(
                  icon: Icons.add_outlined,
                  activeIcon: Icons.add_rounded,
                  label: 'Add',
                ),
                BottomNavItem(
                  icon: Icons.mail_outline,
                  activeIcon: Icons.mail_rounded,
                  label: 'Messages',
                ),
                BottomNavItem(
                  icon: Icons.person_outline,
                  activeIcon: Icons.person_rounded,
                  label: 'Profile',
                ),
              ],
              currentIndex: 1,
              onTap: (index) {},
            ),
          ),
        ),
      ),
    ],
  ),
];

Widget _bg(BuildContext context, Widget child) {
  return Container(
    color: Theme.of(context).canvasColor,
    height: 200,
    child: child,
  );
}
