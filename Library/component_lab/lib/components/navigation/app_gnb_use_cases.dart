import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../foundation/app_spacing.dart';
import 'app_gnb.dart';

// ═══════════════════════════════════════════════════════════════
// GNB (Global Navigation Bar) — Figma `GNB`
// ═══════════════════════════════════════════════════════════════
final List<WidgetbookComponent> gnbUseCases = [
  WidgetbookComponent(
    name: 'GNB — Logo + Trailing Actions',
    useCases: [
      WidgetbookUseCase(
        name: 'Basic GNB',
        builder: (context) => _bg(
          context,
          AppGnb(
            logo: SizedBox(
              height: 28,
              child: Text(
                'Coflanet',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            actions: [
              GnbAction(icon: Icons.search_rounded),
              GnbAction(icon: Icons.shopping_cart_rounded),
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'GNB with Badge',
        builder: (context) => _bg(
          context,
          AppGnb(
            logo: SizedBox(
              height: 28,
              child: Text(
                'Shop',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            actions: [
              GnbAction(
                icon: Icons.notifications_rounded,
                showBadge: true,
              ),
              GnbAction(
                icon: Icons.shopping_bag_rounded,
                showBadge: true,
              ),
              GnbAction(icon: Icons.account_circle_rounded),
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'GNB with Multiple Actions',
        builder: (context) => _bg(
          context,
          AppGnb(
            logo: SizedBox(
              height: 28,
              child: Text(
                'Dashboard',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            actions: [
              GnbAction(icon: Icons.search_rounded),
              GnbAction(icon: Icons.tune_rounded),
              GnbAction(
                icon: Icons.notifications_rounded,
                showBadge: true,
              ),
              GnbAction(icon: Icons.settings_rounded),
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
