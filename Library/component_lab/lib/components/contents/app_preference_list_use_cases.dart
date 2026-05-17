import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../foundation/app_spacing.dart';
import 'app_preference_list.dart';

// ═══════════════════════════════════════════════════════════════
// PREFERENCE LIST — Figma `Contents/Preference List`
// ═══════════════════════════════════════════════════════════════

const _summaryTags = ['산미 강함', '자몽', '라벤더', '외 5개'];

List<AppTasteChip> _tasteChips() => const [
      AppTasteChip(label: '산미', level: AppTasteLevel.good),
      AppTasteChip(label: '바디감', level: AppTasteLevel.normal),
      AppTasteChip(label: '단맛', level: AppTasteLevel.normal),
      AppTasteChip(label: '쓴맛', level: AppTasteLevel.bad),
    ];

List<AppPreferenceFlavorChip> _flavorChips() => const [
      AppPreferenceFlavorChip(label: '과일 향'),
      AppPreferenceFlavorChip(label: '다크초콜릿'),
      AppPreferenceFlavorChip(label: '꽃 향'),
      AppPreferenceFlavorChip(label: '자스베리민'),
      AppPreferenceFlavorChip(label: '로스팅 향'),
    ];

final List<WidgetbookComponent> preferenceListUseCases = [
  WidgetbookComponent(
    name: 'Preference List — Item State',
    useCases: [
      WidgetbookUseCase(
        name: 'Default (collapsed)',
        builder: (context) => _bg(
          context,
          AppPreferenceItem(
            title: '제목을 입력해주세요',
            summaryTags: _summaryTags,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Selected (purple border)',
        builder: (context) => _bg(
          context,
          AppPreferenceItem(
            title: '제목을 입력해주세요',
            summaryTags: _summaryTags,
            state: AppPreferenceItemState.selected,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Disabled',
        builder: (context) => _bg(
          context,
          AppPreferenceItem(
            title: '제목을 입력해주세요',
            summaryTags: _summaryTags,
            state: AppPreferenceItemState.disabled,
          ),
        ),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Preference List — Expanded',
    useCases: [
      WidgetbookUseCase(
        name: 'Expanded with full content',
        builder: (context) => _bg(
          context,
          AppPreferenceItem(
            title: '제목을 입력해주세요',
            summaryTags: _summaryTags,
            tasteChips: _tasteChips(),
            flavorChips: _flavorChips(),
            expanded: true,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Expanded + selected',
        builder: (context) => _bg(
          context,
          AppPreferenceItem(
            title: '제목을 입력해주세요',
            summaryTags: _summaryTags,
            tasteChips: _tasteChips(),
            flavorChips: _flavorChips(),
            expanded: true,
            state: AppPreferenceItemState.selected,
          ),
        ),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Preference List — Atomic Chips',
    useCases: [
      WidgetbookUseCase(
        name: 'Taste chip — good / normal / bad',
        builder: (context) => _bg(
          context,
          Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              AppTasteChip(label: '산미', level: AppTasteLevel.good),
              SizedBox(width: AppSpacing.s8),
              AppTasteChip(label: '바디감', level: AppTasteLevel.normal),
              SizedBox(width: AppSpacing.s8),
              AppTasteChip(label: '쓴맛', level: AppTasteLevel.bad),
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Flavor chip cluster',
        builder: (context) => _bg(
          context,
          Wrap(
            spacing: AppSpacing.s8,
            runSpacing: AppSpacing.s8,
            children: _flavorChips(),
          ),
        ),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Preference List — Stack',
    useCases: [
      WidgetbookUseCase(
        name: 'Mixed states (4 items)',
        builder: (context) => _bg(
          context,
          Column(
            children: [
              AppPreferenceItem(
                title: '제목을 입력해주세요',
                summaryTags: _summaryTags,
              ),
              const SizedBox(height: AppSpacing.s12),
              AppPreferenceItem(
                title: '제목을 입력해주세요',
                summaryTags: _summaryTags,
                state: AppPreferenceItemState.selected,
              ),
              const SizedBox(height: AppSpacing.s12),
              AppPreferenceItem(
                title: '제목을 입력해주세요',
                summaryTags: _summaryTags,
                tasteChips: _tasteChips(),
                flavorChips: _flavorChips(),
                expanded: true,
              ),
              const SizedBox(height: AppSpacing.s12),
              AppPreferenceItem(
                title: '제목을 입력해주세요',
                summaryTags: _summaryTags,
                state: AppPreferenceItemState.disabled,
              ),
            ],
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
