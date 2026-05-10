import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../foundation/app_spacing.dart';
import 'app_slider.dart';

// ═══════════════════════════════════════════════════════════════
// SLIDER — Figma `Selection and Input / Slider`
// ═══════════════════════════════════════════════════════════════
final List<WidgetbookComponent> sliderUseCases = [
  WidgetbookComponent(
    name: 'Slider',
    useCases: [
      WidgetbookUseCase(
        name: 'Basic Slider (0.0 - 1.0)',
        builder: (context) => _bg(
          context,
          AppSlider(
            value: 0.5,
            onChanged: (value) {},
            min: 0.0,
            max: 1.0,
            showValue: true,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Slider with Label',
        builder: (context) => _bg(
          context,
          AppSlider(
            value: 60,
            onChanged: (value) {},
            min: 0,
            max: 100,
            label: 'Volume',
            showValue: true,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Slider with Divisions (Integer)',
        builder: (context) => _bg(
          context,
          AppSlider(
            value: 5,
            onChanged: (value) {},
            min: 0,
            max: 10,
            divisions: 10,
            label: 'Rating',
            showValue: true,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Disabled Slider',
        builder: (context) => _bg(
          context,
          AppSlider(
            value: 0.5,
            onChanged: null,
            label: 'Disabled Slider',
            isDisabled: true,
            showValue: true,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Custom Color',
        builder: (context) => _bg(
          context,
          AppSlider(
            value: 75,
            onChanged: (value) {},
            min: 0,
            max: 100,
            label: 'Brightness',
            activeColor: Colors.orange,
            showValue: true,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Multiple Sliders',
        builder: (context) => _bg(
          context,
          Column(
            children: [
              AppSlider(
                value: 30,
                onChanged: (value) {},
                min: 0,
                max: 100,
                label: 'Red',
                activeColor: Colors.red,
                showValue: true,
              ),
              const SizedBox(height: AppSpacing.space24),
              AppSlider(
                value: 60,
                onChanged: (value) {},
                min: 0,
                max: 100,
                label: 'Green',
                activeColor: Colors.green,
                showValue: true,
              ),
              const SizedBox(height: AppSpacing.space24),
              AppSlider(
                value: 90,
                onChanged: (value) {},
                min: 0,
                max: 100,
                label: 'Blue',
                activeColor: Colors.blue,
                showValue: true,
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
