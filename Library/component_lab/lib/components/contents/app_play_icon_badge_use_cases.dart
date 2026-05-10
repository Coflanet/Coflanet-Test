import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../foundation/app_spacing.dart';
import 'app_play_icon_badge.dart';

// ═══════════════════════════════════════════════════════════════
// PLAY ICON BADGE — Figma `Contents/Play Icon Badge`
// ═══════════════════════════════════════════════════════════════
final List<WidgetbookComponent> playIconBadgeUseCases = [
  WidgetbookComponent(
    name: 'Play Icon Badge',
    useCases: [
      WidgetbookUseCase(
        name: 'Sizes — small / medium / large',
        builder: (context) => _bg(
          context,
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              AppPlayIconBadge(size: AppPlayIconBadgeSize.small),
              SizedBox(width: AppSpacing.space16),
              AppPlayIconBadge(size: AppPlayIconBadgeSize.medium),
              SizedBox(width: AppSpacing.space16),
              AppPlayIconBadge(size: AppPlayIconBadgeSize.large),
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Alternative (true/false)',
        builder: (context) => _bg(
          context,
          Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              AppPlayIconBadge(variant: AppPlayIconBadgeVariant.normal),
              SizedBox(width: AppSpacing.space16),
              AppPlayIconBadge(
                variant: AppPlayIconBadgeVariant.alternative,
              ),
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Matrix (3 sizes × 2 variants)',
        builder: (context) => _bg(
          context,
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  AppPlayIconBadge(size: AppPlayIconBadgeSize.small),
                  SizedBox(width: AppSpacing.space12),
                  AppPlayIconBadge(size: AppPlayIconBadgeSize.medium),
                  SizedBox(width: AppSpacing.space12),
                  AppPlayIconBadge(size: AppPlayIconBadgeSize.large),
                ],
              ),
              const SizedBox(height: AppSpacing.space16),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  AppPlayIconBadge(
                    size: AppPlayIconBadgeSize.small,
                    variant: AppPlayIconBadgeVariant.alternative,
                  ),
                  SizedBox(width: AppSpacing.space12),
                  AppPlayIconBadge(
                    size: AppPlayIconBadgeSize.medium,
                    variant: AppPlayIconBadgeVariant.alternative,
                  ),
                  SizedBox(width: AppSpacing.space12),
                  AppPlayIconBadge(
                    size: AppPlayIconBadgeSize.large,
                    variant: AppPlayIconBadgeVariant.alternative,
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
    padding: const EdgeInsets.all(AppSpacing.space24),
    color: Theme.of(context).canvasColor,
    alignment: Alignment.center,
    child: child,
  );
}
