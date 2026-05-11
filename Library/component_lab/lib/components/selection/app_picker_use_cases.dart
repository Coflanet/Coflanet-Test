import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_spacing.dart';
import 'app_date_picker.dart';
import 'app_time_picker.dart';

final List<WidgetbookComponent> datePickerUseCases = [
  WidgetbookComponent(
    name: 'AppDatePicker',
    useCases: [
      WidgetbookUseCase(
        name: 'Single — empty',
        builder: (context) => _wrap(context, const [
          AppDatePicker(label: '날짜', placeholder: '날짜를 선택하세요'),
        ]),
      ),
      WidgetbookUseCase(
        name: 'Single — preset',
        builder: (context) => _wrap(context, [
          AppDatePicker(
            label: '생년월일',
            initialDate: DateTime(1995, 3, 14),
          ),
        ]),
      ),
      WidgetbookUseCase(
        name: 'Range',
        builder: (context) => _wrap(context, const [
          AppDatePicker(
            mode: AppDatePickerMode.range,
            label: '기간',
            placeholder: '시작일 ~ 종료일',
          ),
        ]),
      ),
      WidgetbookUseCase(
        name: 'Disabled',
        builder: (context) => _wrap(context, const [
          AppDatePicker(label: '비활성', isEnabled: false),
        ]),
      ),
    ],
  ),
];

final List<WidgetbookComponent> timePickerUseCases = [
  WidgetbookComponent(
    name: 'AppTimePicker',
    useCases: [
      WidgetbookUseCase(
        name: '24h — empty',
        builder: (context) => _wrap(context, const [
          AppTimePicker(label: '시간', placeholder: '시간을 선택하세요'),
        ]),
      ),
      WidgetbookUseCase(
        name: '12h — preset',
        builder: (context) => _wrap(context, const [
          AppTimePicker(
            label: '알람',
            use24HourFormat: false,
            initialTime: TimeOfDay(hour: 7, minute: 30),
          ),
        ]),
      ),
      WidgetbookUseCase(
        name: 'Disabled',
        builder: (context) => _wrap(context, const [
          AppTimePicker(label: '비활성', isEnabled: false),
        ]),
      ),
    ],
  ),
];

Widget _wrap(BuildContext context, List<Widget> children) {
  return Container(
    color: AppColor.backgroundNormalNormal,
    padding: const EdgeInsets.all(AppSpacing.space16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.space16),
          children[i],
        ],
      ],
    ),
  );
}
