import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../foundation/app_spacing.dart';
import 'app_control_box.dart';

// ═══════════════════════════════════════════════════════════════
// CONTROL BOX — Figma `Control Box`
// ═══════════════════════════════════════════════════════════════
final List<WidgetbookComponent> controlBoxUseCases = [
  WidgetbookComponent(
    name: 'Control Box — Checkbox',
    useCases: [
      WidgetbookUseCase(
        name: 'Basic Checkbox',
        builder: (context) => _bg(
          context,
          Column(
            children: [
              AppControlBox(
                label: 'Remember me',
                isSelected: true,
                onChanged: (value) {},
                type: AppControlBoxType.checkbox,
              ),
              const SizedBox(height: AppSpacing.s16),
              AppControlBox(
                label: 'I agree to terms',
                isSelected: false,
                onChanged: (value) {},
                type: AppControlBoxType.checkbox,
              ),
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Checkbox with Subtitle',
        builder: (context) => _bg(
          context,
          AppControlBox(
            label: 'Enable notifications',
            subtitle: 'Get updates about your account activity',
            isSelected: true,
            onChanged: (value) {},
            type: AppControlBoxType.checkbox,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Disabled Checkbox',
        builder: (context) => _bg(
          context,
          Column(
            children: [
              AppControlBox(
                label: 'Disabled (Selected)',
                isSelected: true,
                onChanged: (value) {},
                type: AppControlBoxType.checkbox,
                isDisabled: true,
              ),
              const SizedBox(height: AppSpacing.s16),
              AppControlBox(
                label: 'Disabled (Unselected)',
                isSelected: false,
                onChanged: (value) {},
                type: AppControlBoxType.checkbox,
                isDisabled: true,
              ),
            ],
          ),
        ),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Control Box — Radio',
    useCases: [
      WidgetbookUseCase(
        name: 'Basic Radio Group',
        builder: (context) => _bg(
          context,
          Column(
            children: [
              AppControlBox(
                label: 'Option 1',
                isSelected: true,
                onChanged: (value) {},
                type: AppControlBoxType.radio,
              ),
              const SizedBox(height: AppSpacing.s12),
              AppControlBox(
                label: 'Option 2',
                isSelected: false,
                onChanged: (value) {},
                type: AppControlBoxType.radio,
              ),
              const SizedBox(height: AppSpacing.s12),
              AppControlBox(
                label: 'Option 3',
                isSelected: false,
                onChanged: (value) {},
                type: AppControlBoxType.radio,
              ),
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Radio with Subtitle',
        builder: (context) => _bg(
          context,
          Column(
            children: [
              AppControlBox(
                label: 'Delivery Method',
                subtitle: 'Express delivery (2-3 business days)',
                isSelected: true,
                onChanged: (value) {},
                type: AppControlBoxType.radio,
              ),
              const SizedBox(height: AppSpacing.s16),
              AppControlBox(
                label: 'Standard delivery',
                subtitle: 'Regular delivery (5-7 business days)',
                isSelected: false,
                onChanged: (value) {},
                type: AppControlBoxType.radio,
              ),
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Disabled Radio',
        builder: (context) => _bg(
          context,
          Column(
            children: [
              AppControlBox(
                label: 'Disabled (Selected)',
                isSelected: true,
                onChanged: (value) {},
                type: AppControlBoxType.radio,
                isDisabled: true,
              ),
              const SizedBox(height: AppSpacing.s12),
              AppControlBox(
                label: 'Disabled (Unselected)',
                isSelected: false,
                onChanged: (value) {},
                type: AppControlBoxType.radio,
                isDisabled: true,
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
