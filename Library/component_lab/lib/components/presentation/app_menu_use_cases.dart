import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../foundation/app_spacing.dart';
import 'app_menu.dart';

// ═══════════════════════════════════════════════════════════════
// MENU — Figma `Presentation / Menu`
// ═══════════════════════════════════════════════════════════════
final List<WidgetbookComponent> menuUseCases = [
  WidgetbookComponent(
    name: 'Menu — Normal',
    useCases: [
      WidgetbookUseCase(
        name: 'Normal Menu',
        builder: (context) => _bg(
          context,
          AppMenu(
            variant: AppMenuVariant.normal,
            items: [
              const AppMenuItem(
                label: 'Edit',
                icon: Icons.edit_rounded,
              ),
              const AppMenuItem(
                label: 'Copy',
                icon: Icons.copy_rounded,
              ),
              const AppMenuItem(
                label: 'Delete',
                icon: Icons.delete_rounded,
                isDestructive: true,
              ),
            ],
            onItemTap: (index) {},
          ),
        ),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Menu — Radio',
    useCases: [
      WidgetbookUseCase(
        name: 'Radio Menu (Selection)',
        builder: (context) => _bg(
          context,
          AppMenu(
            variant: AppMenuVariant.radio,
            items: [
              const AppMenuItem(
                label: 'Option 1',
                isSelected: true,
              ),
              const AppMenuItem(
                label: 'Option 2',
              ),
              const AppMenuItem(
                label: 'Option 3',
              ),
            ],
            onItemTap: (index) {},
          ),
        ),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Menu — Checkbox',
    useCases: [
      WidgetbookUseCase(
        name: 'Checkbox Menu (Multi-select)',
        builder: (context) => _bg(
          context,
          AppMenu(
            variant: AppMenuVariant.checkbox,
            items: [
              const AppMenuItem(
                label: 'Enable notifications',
                isSelected: true,
              ),
              const AppMenuItem(
                label: 'Show in list',
              ),
              const AppMenuItem(
                label: 'Mark as favorite',
                isSelected: true,
              ),
            ],
            onItemTap: (index) {},
          ),
        ),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Menu — Cell Padding',
    useCases: [
      WidgetbookUseCase(
        name: 'Padding 12px',
        builder: (context) => _bg(
          context,
          AppMenu(
            variant: AppMenuVariant.normal,
            cellPadding: AppMenuCellPadding.px12,
            items: [
              const AppMenuItem(
                label: 'Item with 12px padding',
                icon: Icons.star_rounded,
              ),
              const AppMenuItem(
                label: 'Another item',
                icon: Icons.favorite_rounded,
              ),
            ],
            onItemTap: (index) {},
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Padding 8px',
        builder: (context) => _bg(
          context,
          AppMenu(
            variant: AppMenuVariant.normal,
            cellPadding: AppMenuCellPadding.px8,
            items: [
              const AppMenuItem(
                label: 'Item with 8px padding',
                icon: Icons.share_rounded,
              ),
              const AppMenuItem(
                label: 'Another item',
                icon: Icons.download_rounded,
              ),
            ],
            onItemTap: (index) {},
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
