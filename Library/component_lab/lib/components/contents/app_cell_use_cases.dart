import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../foundation/app_spacing.dart';
import 'app_cell.dart';

// ═══════════════════════════════════════════════════════════════
// CELL — Figma `Contents / Cell`
// ═══════════════════════════════════════════════════════════════
final List<WidgetbookComponent> cellUseCases = [
  WidgetbookComponent(
    name: 'Cell — Basic',
    useCases: [
      WidgetbookUseCase(
        name: 'Simple Cell',
        builder: (context) => _bg(
          context,
          AppCell(
            title: 'Cell Title',
            onTap: () {},
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Cell with Subtitle',
        builder: (context) => _bg(
          context,
          AppCell(
            title: 'Cell Title',
            subtitle: 'This is a subtitle',
            onTap: () {},
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Cell with Trailing Widget',
        builder: (context) => _bg(
          context,
          AppCell(
            title: 'Notifications',
            trailing: Switch(
              value: true,
              onChanged: (value) {},
            ),
          ),
        ),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Cell — Variations',
    useCases: [
      WidgetbookUseCase(
        name: 'With Leading Icon',
        builder: (context) => _bg(
          context,
          AppCell(
            title: 'Settings',
            leading: const Icon(Icons.settings_rounded),
            onTap: () {},
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Active State',
        builder: (context) => _bg(
          context,
          AppCell(
            title: 'Active Item',
            isActive: true,
            onTap: () {},
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Disabled State',
        builder: (context) => _bg(
          context,
          AppCell(
            title: 'Disabled Item',
            isDisabled: true,
            onTap: () {},
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Text Ellipsis',
        builder: (context) => _bg(
          context,
          AppCell(
            title: 'Very long title that should be truncated with ellipsis',
            subtitle:
                'Very long subtitle that should also be truncated with ellipsis',
            textEllipsis: true,
            onTap: () {},
          ),
        ),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Cell — List',
    useCases: [
      WidgetbookUseCase(
        name: 'Cell Group',
        builder: (context) => _bg(
          context,
          Column(
            children: [
              AppCell(
                title: 'Profile',
                leading: const Icon(Icons.person_rounded),
                trailing: const Icon(Icons.arrow_forward_rounded),
                onTap: () {},
              ),
              AppCell(
                title: 'Privacy',
                leading: const Icon(Icons.lock_rounded),
                trailing: const Icon(Icons.arrow_forward_rounded),
                onTap: () {},
              ),
              AppCell(
                title: 'Notifications',
                leading: const Icon(Icons.notifications_rounded),
                trailing: Switch(
                  value: true,
                  onChanged: (value) {},
                ),
              ),
              AppCell(
                title: 'Help & Support',
                leading: const Icon(Icons.help_rounded),
                trailing: const Icon(Icons.arrow_forward_rounded),
                onTap: () {},
              ),
            ],
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
