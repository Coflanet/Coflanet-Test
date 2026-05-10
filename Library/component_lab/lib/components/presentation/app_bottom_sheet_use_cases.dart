import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../foundation/app_spacing.dart';
import 'app_bottom_sheet.dart';

// ═══════════════════════════════════════════════════════════════
// BOTTOM SHEET — Figma `Presentation / Bottom Sheet`
// ═══════════════════════════════════════════════════════════════
final List<WidgetbookComponent> bottomSheetUseCases = [
  WidgetbookComponent(
    name: 'Bottom Sheet',
    useCases: [
      WidgetbookUseCase(
        name: 'Basic Bottom Sheet',
        builder: (context) => _bg(
          context,
          AppBottomSheet(
            showHandle: true,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.space16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Bottom Sheet Content'),
                  const SizedBox(height: AppSpacing.space24),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Action'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'With Title',
        builder: (context) => _bg(
          context,
          AppBottomSheet(
            title: 'Options',
            showHandle: true,
            showCloseButton: true,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.space16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: const Text('Option 1'),
                    onTap: () {},
                  ),
                  ListTile(
                    title: const Text('Option 2'),
                    onTap: () {},
                  ),
                  ListTile(
                    title: const Text('Option 3'),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'With Handle Only',
        builder: (context) => _bg(
          context,
          AppBottomSheet(
            showHandle: true,
            showCloseButton: false,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.space16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text('Swipe up to dismiss'),
                ],
              ),
            ),
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'With Title and Close Button',
        builder: (context) => _bg(
          context,
          AppBottomSheet(
            title: 'Settings',
            showHandle: true,
            showCloseButton: true,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.space16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SwitchListTile(
                    title: const Text('Dark Mode'),
                    value: true,
                    onChanged: (value) {},
                  ),
                  SwitchListTile(
                    title: const Text('Notifications'),
                    value: false,
                    onChanged: (value) {},
                  ),
                ],
              ),
            ),
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
    height: 400,
    child: child,
  );
}
