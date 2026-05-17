import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_spacing.dart';
import 'app_search_input.dart';
import 'app_text_field.dart';

final List<WidgetbookComponent> searchInputUseCases = [
  WidgetbookComponent(
    name: 'AppSearchInput',
    useCases: [
      WidgetbookUseCase(
        name: 'Sizes — sm / md / lg',
        builder: (context) => _wrap(context, const [
          AppSearchInput(size: AppTextFieldSize.sm, hintText: '검색 (sm)'),
          AppSearchInput(size: AppTextFieldSize.md, hintText: '검색 (md)'),
          AppSearchInput(size: AppTextFieldSize.lg, hintText: '검색 (lg)'),
        ]),
      ),
      WidgetbookUseCase(
        name: 'With onSubmitted',
        builder: (context) => _wrap(context, [
          AppSearchInput(
            hintText: 'Enter 키로 검색',
            onSubmitted: (q) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('검색: $q')),
              );
            },
          ),
        ]),
      ),
      WidgetbookUseCase(
        name: 'Disabled',
        builder: (context) => _wrap(context, const [
          AppSearchInput(hintText: '비활성', isEnabled: false),
        ]),
      ),
    ],
  ),
];

Widget _wrap(BuildContext context, List<Widget> children) {
  return Container(
    color: AppColor.backgroundNormalNormal,
    padding: const EdgeInsets.all(AppSpacing.s16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.s16),
          children[i],
        ],
      ],
    ),
  );
}
