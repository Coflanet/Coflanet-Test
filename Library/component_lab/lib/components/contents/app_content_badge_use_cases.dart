import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../foundation/app_spacing.dart';
import 'app_content_badge.dart';

// ═══════════════════════════════════════════════════════════════
// CONTENT BADGE — Figma `Contents/Content Badge`
// ═══════════════════════════════════════════════════════════════
final List<WidgetbookComponent> contentBadgeUseCases = [
  WidgetbookComponent(
    name: 'Content Badge — Variant',
    useCases: [
      WidgetbookUseCase(
        name: 'Solid (default) / Outlined',
        builder: (context) => _bg(
          context,
          Wrap(
            spacing: AppSpacing.space8,
            children: const [
              AppContentBadge(label: '텍스트', variant: AppContentBadgeVariant.solid),
              AppContentBadge(
                label: '텍스트',
                variant: AppContentBadgeVariant.outlined,
              ),
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'With icons (leading / trailing)',
        builder: (context) => _bg(
          context,
          Wrap(
            spacing: AppSpacing.space8,
            children: const [
              AppContentBadge(label: '텍스트'),
              AppContentBadge(label: '텍스트', leadingIcon: Icons.info_outline),
              AppContentBadge(
                label: '텍스트',
                trailingIcon: Icons.chevron_right_rounded,
              ),
              AppContentBadge(
                label: '텍스트',
                leadingIcon: Icons.info_outline,
                trailingIcon: Icons.chevron_right_rounded,
              ),
            ],
          ),
        ),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Content Badge — Size',
    useCases: [
      WidgetbookUseCase(
        name: 'xsmall / small / medium',
        builder: (context) => _bg(
          context,
          Wrap(
            spacing: AppSpacing.space8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: const [
              AppContentBadge(label: '텍스트', size: AppContentBadgeSize.xsmall),
              AppContentBadge(label: '텍스트', size: AppContentBadgeSize.small),
              AppContentBadge(label: '텍스트', size: AppContentBadgeSize.medium),
            ],
          ),
        ),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Content Badge — Color',
    useCases: [
      WidgetbookUseCase(
        name: 'Neutral × Accent (solid + outlined)',
        builder: (context) => _bg(
          context,
          Wrap(
            spacing: AppSpacing.space8,
            runSpacing: AppSpacing.space8,
            children: const [
              AppContentBadge(label: '텍스트', color: AppContentBadgeColor.neutral),
              AppContentBadge(label: '텍스트', color: AppContentBadgeColor.accent),
              AppContentBadge(
                label: '텍스트',
                variant: AppContentBadgeVariant.outlined,
                color: AppContentBadgeColor.neutral,
              ),
              AppContentBadge(
                label: '텍스트',
                variant: AppContentBadgeVariant.outlined,
                color: AppContentBadgeColor.accent,
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
    alignment: Alignment.centerLeft,
    child: child,
  );
}
