import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../foundation/app_spacing.dart';
import 'app_select.dart';

// ═══════════════════════════════════════════════════════════════
// SELECT / DROPDOWN — Figma `Selection and Input / Select`
// ═══════════════════════════════════════════════════════════════
final List<WidgetbookComponent> selectUseCases = [
  WidgetbookComponent(
    name: 'Select Dropdown',
    useCases: [
      WidgetbookUseCase(
        name: 'Basic Select',
        builder: (context) => _bg(
          context,
          AppSelect<String>(
            items: ['Option 1', 'Option 2', 'Option 3'],
            itemLabel: (item) => item,
            selectedItem: 'Option 1',
            onChanged: (value) {},
            label: 'Select an option',
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Select with Placeholder',
        builder: (context) => _bg(
          context,
          AppSelect<String>(
            items: ['Apple', 'Banana', 'Cherry', 'Date'],
            itemLabel: (item) => item,
            onChanged: (value) {},
            label: 'Fruits',
            hintText: '과일을 선택하세요',
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Select with Helper Text',
        builder: (context) => _bg(
          context,
          AppSelect<String>(
            items: ['Male', 'Female', 'Other'],
            itemLabel: (item) => item,
            selectedItem: 'Male',
            onChanged: (value) {},
            label: 'Gender',
            helperText: 'Please select your gender',
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Select with Error',
        builder: (context) => _bg(
          context,
          AppSelect<String>(
            items: ['Red', 'Green', 'Blue'],
            itemLabel: (item) => item,
            onChanged: (value) {},
            label: 'Color',
            isError: true,
            errorText: 'This field is required',
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Disabled Select',
        builder: (context) => _bg(
          context,
          AppSelect<String>(
            items: ['Option 1', 'Option 2', 'Option 3'],
            itemLabel: (item) => item,
            selectedItem: 'Option 2',
            label: 'Disabled Select',
            isDisabled: true,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Select with Custom Objects',
        builder: (context) {
          final countries = [
            {'name': 'South Korea', 'code': 'KR'},
            {'name': 'United States', 'code': 'US'},
            {'name': 'Japan', 'code': 'JP'},
            {'name': 'China', 'code': 'CN'},
          ];

          return _bg(
            context,
            AppSelect<Map<String, String>>(
              items: countries,
              itemLabel: (item) => '${item['name']} (${item['code']})',
              selectedItem: countries[0],
              onChanged: (value) {},
              label: 'Country',
            ),
          );
        },
      ),
      WidgetbookUseCase(
        name: 'Select with Many Items',
        builder: (context) => _bg(
          context,
          AppSelect<int>(
            items: List.generate(50, (i) => i + 1),
            itemLabel: (item) => 'Item $item',
            selectedItem: 1,
            onChanged: (value) {},
            label: 'Select from many items',
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
    child: SizedBox(
      width: 300,
      child: child,
    ),
  );
}
