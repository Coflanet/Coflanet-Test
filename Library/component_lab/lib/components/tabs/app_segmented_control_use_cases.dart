import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../foundation/app_spacing.dart';
import 'app_segmented_control.dart';

// ═══════════════════════════════════════════════════════════════
// SEGMENTED CONTROL — Figma `Segmented Control`
// ═══════════════════════════════════════════════════════════════
final List<WidgetbookComponent> segmentedControlUseCases = [
  WidgetbookComponent(
    name: 'Segmented Control',
    useCases: [
      WidgetbookUseCase(
        name: 'Large Size',
        builder: (context) => _bg(
          context,
          AppSegmentedControl(
            items: const [
              AppSegmentItem(label: 'List'),
              AppSegmentItem(label: 'Grid'),
              AppSegmentItem(label: 'Map'),
            ],
            selectedIndex: 0,
            onChanged: (index) {},
            size: AppSegmentedControlSize.large,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Medium Size',
        builder: (context) => _bg(
          context,
          AppSegmentedControl(
            items: const [
              AppSegmentItem(label: 'Day'),
              AppSegmentItem(label: 'Week'),
              AppSegmentItem(label: 'Month'),
            ],
            selectedIndex: 1,
            onChanged: (index) {},
            size: AppSegmentedControlSize.medium,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Small Size',
        builder: (context) => _bg(
          context,
          AppSegmentedControl(
            items: const [
              AppSegmentItem(label: 'All'),
              AppSegmentItem(label: 'Active'),
              AppSegmentItem(label: 'Done'),
            ],
            selectedIndex: 2,
            onChanged: (index) {},
            size: AppSegmentedControlSize.small,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'With Icons',
        builder: (context) => _bg(
          context,
          Column(
            children: [
              AppSegmentedControl(
                items: const [
                  AppSegmentItem(label: 'Grid', icon: Icons.grid_view_rounded),
                  AppSegmentItem(label: 'List', icon: Icons.list_rounded),
                ],
                selectedIndex: 0,
                onChanged: (index) {},
              ),
              const SizedBox(height: AppSpacing.space24),
              AppSegmentedControl(
                items: const [
                  AppSegmentItem(label: 'Heart', icon: Icons.favorite_rounded),
                  AppSegmentItem(label: 'Star', icon: Icons.star_rounded),
                  AppSegmentItem(label: 'Share', icon: Icons.share_rounded),
                ],
                selectedIndex: 1,
                onChanged: (index) {},
              ),
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Two Options',
        builder: (context) => _bg(
          context,
          AppSegmentedControl(
            items: const [
              AppSegmentItem(label: 'On'),
              AppSegmentItem(label: 'Off'),
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
    padding: const EdgeInsets.all(AppSpacing.space16),
    color: Theme.of(context).canvasColor,
    child: child,
  );
}
