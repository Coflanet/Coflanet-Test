import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../foundation/app_spacing.dart';
import 'app_gauge.dart';

// ═══════════════════════════════════════════════════════════════
// GAUGE — Figma `Gauge`
// ═══════════════════════════════════════════════════════════════
final List<WidgetbookComponent> gaugeUseCases = [
  WidgetbookComponent(
    name: 'Gauge',
    useCases: [
      WidgetbookUseCase(
        name: '5-Step Gauge — Step 1',
        builder: (context) => _bg(
          context,
          AppGauge(
            value: 1,
            maxValue: 5,
            labels: const ['Very Weak', 'Weak', 'Normal', 'Strong', 'Very Strong'],
            showLabel: true,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: '5-Step Gauge — Step 3 (Middle)',
        builder: (context) => _bg(
          context,
          AppGauge(
            value: 3,
            maxValue: 5,
            labels: const ['Very Weak', 'Weak', 'Normal', 'Strong', 'Very Strong'],
            showLabel: true,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: '5-Step Gauge — Step 5 (Complete)',
        builder: (context) => _bg(
          context,
          AppGauge(
            value: 5,
            maxValue: 5,
            labels: const ['Very Weak', 'Weak', 'Normal', 'Strong', 'Very Strong'],
            showLabel: true,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Without Labels',
        builder: (context) => _bg(
          context,
          AppGauge(
            value: 2,
            maxValue: 5,
            showLabel: false,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Different Gauge Variations',
        builder: (context) => _bg(
          context,
          Column(
            children: [
              AppGauge(
                value: 1,
                maxValue: 3,
                labels: const ['Low', 'Medium', 'High'],
                showLabel: true,
              ),
              const SizedBox(height: AppSpacing.s24),
              AppGauge(
                value: 4,
                maxValue: 6,
                labels: const ['1', '2', '3', '4', '5', '6'],
                showLabel: true,
              ),
              const SizedBox(height: AppSpacing.s24),
              AppGauge(
                value: 7,
                maxValue: 10,
                showLabel: false,
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
