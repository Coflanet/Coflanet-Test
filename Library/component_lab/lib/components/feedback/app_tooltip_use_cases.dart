import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../foundation/app_spacing.dart';
import 'app_tooltip.dart';

// ═══════════════════════════════════════════════════════════════
// TOOLTIP — Figma `Feedback / Tooltip`
// ═══════════════════════════════════════════════════════════════
final List<WidgetbookComponent> tooltipUseCases = [
  WidgetbookComponent(
    name: 'Tooltip — Compact',
    useCases: [
      WidgetbookUseCase(
        name: 'Compact Normal (Dark)',
        builder: (context) => _bg(
          context,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AppTooltipCompact(
                message: 'Save your work',
                variant: AppTooltipVariant.normal,
              ),
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Compact Inverse (Light)',
        builder: (context) => _bg(
          context,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AppTooltipCompact(
                message: 'Delete this item',
                variant: AppTooltipVariant.inverse,
              ),
            ],
          ),
        ),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Tooltip — Extended',
    useCases: [
      WidgetbookUseCase(
        name: 'Extended with Title & Description',
        builder: (context) => _bg(
          context,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppTooltipExtended(
                title: 'Share to social media',
                description: 'Post this content to your social channels',
                showCloseButton: false,
              ),
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Extended with Close Button',
        builder: (context) => _bg(
          context,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppTooltipExtended(
                title: 'Advanced settings',
                description: 'Configure advanced options for this feature',
                showCloseButton: true,
                onClose: () {},
              ),
            ],
          ),
        ),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Tooltip — Multiple Compact',
    useCases: [
      WidgetbookUseCase(
        name: 'Multiple Tooltips',
        builder: (context) => _bg(
          context,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  AppTooltipCompact(
                    message: 'Home',
                    variant: AppTooltipVariant.normal,
                  ),
                  SizedBox(width: AppSpacing.s16),
                  AppTooltipCompact(
                    message: 'Search',
                    variant: AppTooltipVariant.normal,
                  ),
                  SizedBox(width: AppSpacing.s16),
                  AppTooltipCompact(
                    message: 'Settings',
                    variant: AppTooltipVariant.normal,
                  ),
                ],
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
