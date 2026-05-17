import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../foundation/app_spacing.dart';
import 'app_coffee_profile.dart';

// ═══════════════════════════════════════════════════════════════
// COFFEE PROFILE — Figma `Contents/Coffee Profile`
// ═══════════════════════════════════════════════════════════════

const _attributes = <String, double>{
  '산미': 5.0,
  '바디감': 3.5,
  '단맛': 2.2,
  '쓴맛': 1.0,
  '밸런스': 4.2,
};

const _myPreference = <String, double>{
  '산미': 5.0,
  '바디감': 3.5,
  '단맛': 2.2,
  '쓴맛': 1.0,
  '밸런스': 4.2,
};

const _flavorNotes = <String>[
  '과일 향',
  '다크초콜릿',
  '꽃 향',
  '자스베리민',
  '로스팅 향',
];

final List<WidgetbookComponent> coffeeProfileUseCases = [
  WidgetbookComponent(
    name: 'Coffee Profile — Attributes',
    useCases: [
      WidgetbookUseCase(
        name: 'Single Track (커피만)',
        builder: (context) => _bg(
          context,
          AppCoffeeAttributesChart(values: _attributes),
        ),
      ),
      WidgetbookUseCase(
        name: 'Dual Track (커피 vs 내취향)',
        builder: (context) => _bg(
          context,
          AppCoffeeAttributesChart(
            values: _attributes,
            compared: _myPreference,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Single Bar (label + value)',
        builder: (context) => _bg(
          context,
          AppCoffeeAttributeBar(label: '산미', value: 5.0),
        ),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Coffee Profile — Flavor Notes',
    useCases: [
      WidgetbookUseCase(
        name: 'Plain chip cluster',
        builder: (context) => _bg(
          context,
          AppFlavorNotesChips(notes: _flavorNotes),
        ),
      ),
      WidgetbookUseCase(
        name: 'Few notes',
        builder: (context) => _bg(
          context,
          AppFlavorNotesChips(notes: ['과일 향', '꽃 향']),
        ),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Coffee Profile — Combined Card',
    useCases: [
      WidgetbookUseCase(
        name: 'Single track + flavor notes',
        builder: (context) => _bg(
          context,
          AppCoffeeProfileCard(
            values: _attributes,
            flavorNotes: _flavorNotes,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Dual track + flavor notes',
        builder: (context) => _bg(
          context,
          AppCoffeeProfileCard(
            values: _attributes,
            compared: _myPreference,
            flavorNotes: _flavorNotes,
          ),
        ),
      ),
    ],
  ),
];

Widget _bg(BuildContext context, Widget child) {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(AppSpacing.s16),
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 480),
      child: Container(
        color: Theme.of(context).canvasColor,
        child: child,
      ),
    ),
  );
}
