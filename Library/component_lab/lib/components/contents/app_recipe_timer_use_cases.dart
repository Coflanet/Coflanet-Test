import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../foundation/app_spacing.dart';
import 'app_recipe_timer.dart';

// ═══════════════════════════════════════════════════════════════
// RECIPE / TIMER — Figma `Contents/Recipe-Timmer`
// ═══════════════════════════════════════════════════════════════
final List<WidgetbookComponent> recipeTimerUseCases = [
  WidgetbookComponent(
    name: 'Recipe / Timer — Stepper',
    useCases: [
      WidgetbookUseCase(
        name: 'Empty (placeholder)',
        builder: (context) => _bg(
          context,
          AppRecipeStepper(
            label: '시간',
            value: 0,
            unit: '단위',
            onChanged: (_) {},
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'With value',
        builder: (context) => _bg(
          context,
          AppRecipeStepper(
            label: '시간',
            value: 30,
            unit: '초',
            onChanged: (_) {},
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Disabled (no onChanged)',
        builder: (context) => _bg(
          context,
          AppRecipeStepper(
            label: '시간',
            value: 30,
            unit: '초',
          ),
        ),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Recipe / Timer — Card',
    useCases: [
      WidgetbookUseCase(
        name: 'Single stepper',
        builder: (context) => _bg(
          context,
          AppRecipeCard(
            title: '타이틀을 입력해 주세요',
            onDelete: () {},
            steppers: [
              AppRecipeStepper(
                label: '시간',
                value: 0,
                unit: '단위',
                onChanged: (_) {},
              ),
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Multiple steppers',
        builder: (context) => _bg(
          context,
          AppRecipeCard(
            title: '타이틀을 입력해 주세요',
            onDelete: () {},
            steppers: [
              AppRecipeStepper(
                label: '텍스트 입력',
                value: 0,
                unit: '단위',
                onChanged: (_) {},
              ),
              AppRecipeStepper(
                label: '시간',
                value: 0,
                unit: '단위',
                onChanged: (_) {},
              ),
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Filled values (실제 사용 예)',
        builder: (context) => _bg(
          context,
          AppRecipeCard(
            title: 'V60 핸드드립',
            onDelete: () {},
            steppers: [
              AppRecipeStepper(
                label: '원두량',
                value: 18,
                unit: 'g',
                onChanged: (_) {},
              ),
              AppRecipeStepper(
                label: '물량',
                value: 300,
                unit: 'ml',
                onChanged: (_) {},
              ),
              AppRecipeStepper(
                label: '추출 시간',
                value: 180,
                unit: '초',
                onChanged: (_) {},
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
