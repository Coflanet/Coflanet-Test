import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../foundation/app_spacing.dart';
import 'app_accordion.dart';

// ═══════════════════════════════════════════════════════════════
// ACCORDION — Figma `Contents / Accordion`
// ═══════════════════════════════════════════════════════════════
final List<WidgetbookComponent> accordionUseCases = [
  WidgetbookComponent(
    name: 'Accordion — Basic',
    useCases: [
      WidgetbookUseCase(
        name: 'Basic Accordion',
        builder: (context) => _bg(
          context,
          AppAccordion(
            title: 'Accordion Title',
            content: Padding(
              padding: const EdgeInsets.all(AppSpacing.space16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'This is the accordion content. It can contain any widget you want.',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Accordion with Subtitle',
        builder: (context) => _bg(
          context,
          AppAccordion(
            title: 'Section Title',
            subtitle: 'Additional information',
            content: Padding(
              padding: const EdgeInsets.all(AppSpacing.space16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Accordion content goes here.'),
                ],
              ),
            ),
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Initially Expanded',
        builder: (context) => _bg(
          context,
          AppAccordion(
            title: 'Expanded by Default',
            initiallyExpanded: true,
            content: Padding(
              padding: const EdgeInsets.all(AppSpacing.space16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('This accordion is expanded by default.'),
                ],
              ),
            ),
          ),
        ),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Accordion — Variants',
    useCases: [
      WidgetbookUseCase(
        name: 'Padding Large',
        builder: (context) => _bg(
          context,
          AppAccordion(
            title: 'Large Padding',
            padding: AppAccordionPadding.large,
            content: Padding(
              padding: const EdgeInsets.all(AppSpacing.space16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [Text('Content with large padding')],
              ),
            ),
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Padding Medium',
        builder: (context) => _bg(
          context,
          AppAccordion(
            title: 'Medium Padding',
            padding: AppAccordionPadding.medium,
            content: Padding(
              padding: const EdgeInsets.all(AppSpacing.space16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [Text('Content with medium padding')],
              ),
            ),
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'With Complete Indicator',
        builder: (context) => _bg(
          context,
          AppAccordion(
            title: 'Completed Section',
            isComplete: true,
            content: Padding(
              padding: const EdgeInsets.all(AppSpacing.space16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [Text('This section is marked complete.')],
              ),
            ),
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'With Leading Icon',
        builder: (context) => _bg(
          context,
          AppAccordion(
            title: 'Settings',
            leading: const Icon(Icons.settings_rounded),
            content: Padding(
              padding: const EdgeInsets.all(AppSpacing.space16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [Text('Settings content here.')],
              ),
            ),
          ),
        ),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Accordion — Group',
    useCases: [
      WidgetbookUseCase(
        name: 'Accordion Group',
        builder: (context) => _bg(
          context,
          Column(
            children: [
              AppAccordion(
                title: 'Section 1',
                subtitle: 'Click to expand',
                content: Padding(
                  padding: const EdgeInsets.all(AppSpacing.space16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [Text('Content for section 1')],
                  ),
                ),
              ),
              AppAccordion(
                title: 'Section 2',
                subtitle: 'Click to expand',
                content: Padding(
                  padding: const EdgeInsets.all(AppSpacing.space16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [Text('Content for section 2')],
                  ),
                ),
              ),
              AppAccordion(
                title: 'Section 3',
                subtitle: 'Click to expand',
                isComplete: true,
                content: Padding(
                  padding: const EdgeInsets.all(AppSpacing.space16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [Text('Content for section 3')],
                  ),
                ),
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
    padding: const EdgeInsets.all(AppSpacing.space16),
    color: Theme.of(context).canvasColor,
    child: child,
  );
}
