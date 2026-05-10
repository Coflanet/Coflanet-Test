import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_spacing.dart';
import 'app_tasting_note.dart';

// ═══════════════════════════════════════════════════════════════
// TASTING NOTE — Figma `Contents/TastingNote`
// ═══════════════════════════════════════════════════════════════
final List<WidgetbookComponent> tastingNoteUseCases = [
  WidgetbookComponent(
    name: 'Tasting Note',
    useCases: [
      WidgetbookUseCase(
        name: 'Default (citrus)',
        builder: (context) => _bg(
          context,
          AppTastingNote(
            title: '시트러스',
            description: '레몬, 라임 계열의 상큼한 향미',
            onTap: () {},
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Custom leading + no chevron',
        builder: (context) => _bg(
          context,
          AppTastingNote(
            title: '베리',
            description: '딸기, 라즈베리, 블루베리 계열의 달콤한 향',
            leading: Icon(
              Icons.local_pizza_rounded,
              size: 20,
              color: AppColor.accentForegroundRed,
            ),
            trailingIcon: null,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Stack — flavor categories',
        builder: (context) => _bg(
          context,
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTastingNote(
                title: '시트러스',
                description: '레몬, 라임 계열의 상큼한 향미',
                onTap: () {},
              ),
              const SizedBox(height: AppSpacing.space8),
              AppTastingNote(
                title: '베리',
                description: '딸기, 라즈베리 계열의 달콤한 향',
                onTap: () {},
              ),
              const SizedBox(height: AppSpacing.space8),
              AppTastingNote(
                title: '초콜릿',
                description: '카카오, 다크초콜릿 계열의 진한 향',
                onTap: () {},
              ),
              const SizedBox(height: AppSpacing.space8),
              AppTastingNote(
                title: '플로럴',
                description: '꽃 향, 자스민 계열의 은은한 향',
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
    color: Theme.of(context).canvasColor,
    padding: const EdgeInsets.all(AppSpacing.space16),
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 480),
      child: child,
    ),
  );
}
