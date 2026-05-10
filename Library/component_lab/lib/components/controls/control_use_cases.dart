import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_spacing.dart';
import 'app_checkbox.dart';
import 'app_radio.dart';
import 'app_switch.dart';

final List<WidgetbookComponent> switchUseCases = [
  WidgetbookComponent(
    name: 'AppSwitch',
    useCases: [
      WidgetbookUseCase(
        name: 'On / Off / Disabled — sm/md',
        builder: (context) => _wrap(context, [
          const _Cell('Off (md)', AppSwitch(value: false)),
          const _Cell('On (md)', AppSwitch(value: true)),
          const _Cell('Off (sm)', AppSwitch(value: false, size: AppSwitchSize.sm)),
          const _Cell('On (sm)', AppSwitch(value: true, size: AppSwitchSize.sm)),
          _Cell('Stateful', _StatefulSwitch()),
        ]),
      ),
    ],
  ),
];

final List<WidgetbookComponent> checkboxUseCases = [
  WidgetbookComponent(
    name: 'AppCheckbox',
    useCases: [
      WidgetbookUseCase(
        name: 'States + sizes',
        builder: (context) => _wrap(context, [
          const _Cell('Unchecked', AppCheckbox(value: false)),
          const _Cell('Checked', AppCheckbox(value: true)),
          const _Cell('Indeterminate', AppCheckbox(value: null)),
          const _Cell(
              'Disabled', AppCheckbox(value: true, onChanged: null)),
          const _Cell(
            'With label',
            AppCheckbox(value: true, label: '약관 동의'),
          ),
          _Cell('Stateful', _StatefulCheckbox()),
        ]),
      ),
    ],
  ),
];

final List<WidgetbookComponent> radioUseCases = [
  WidgetbookComponent(
    name: 'AppRadio',
    useCases: [
      WidgetbookUseCase(
        name: 'Group of 3',
        builder: (context) => Container(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColor.darkBackgroundNormalNormal
              : AppColor.backgroundNormalNormal,
          padding: const EdgeInsets.all(24),
          child: const _StatefulRadioGroup(),
        ),
      ),
    ],
  ),
];

class _StatefulSwitch extends StatefulWidget {
  @override
  State<_StatefulSwitch> createState() => _StatefulSwitchState();
}

class _StatefulSwitchState extends State<_StatefulSwitch> {
  bool _value = false;
  @override
  Widget build(BuildContext context) {
    return AppSwitch(
      value: _value,
      onChanged: (v) => setState(() => _value = v),
    );
  }
}

class _StatefulCheckbox extends StatefulWidget {
  @override
  State<_StatefulCheckbox> createState() => _StatefulCheckboxState();
}

class _StatefulCheckboxState extends State<_StatefulCheckbox> {
  bool _value = false;
  @override
  Widget build(BuildContext context) {
    return AppCheckbox(
      value: _value,
      label: '인터랙티브',
      onChanged: (v) => setState(() => _value = v),
    );
  }
}

class _StatefulRadioGroup extends StatefulWidget {
  const _StatefulRadioGroup();
  @override
  State<_StatefulRadioGroup> createState() => _StatefulRadioGroupState();
}

class _StatefulRadioGroupState extends State<_StatefulRadioGroup> {
  String _selected = 'a';
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final v in const ['a', 'b', 'c']) ...[
          AppRadio<String>(
            value: v,
            groupValue: _selected,
            label: '옵션 ${v.toUpperCase()}',
            onChanged: (val) => setState(() => _selected = val ?? 'a'),
          ),
          const SizedBox(height: AppSpacing.space12),
        ],
      ],
    );
  }
}

class _Cell extends StatelessWidget {
  final String label;
  final Widget child;
  const _Cell(this.label, this.child);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final altColor = isDark
        ? AppColor.darkLabelAlternative
        : AppColor.labelAlternative;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        child,
        const SizedBox(height: AppSpacing.space4),
        Text(label, style: TextStyle(color: altColor, fontSize: 11)),
      ],
    );
  }
}

Widget _wrap(BuildContext context, List<Widget> children) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final bg = isDark
      ? AppColor.darkBackgroundNormalNormal
      : AppColor.backgroundNormalNormal;
  return Container(
    color: bg,
    padding: const EdgeInsets.all(24),
    child: Wrap(
      spacing: 24,
      runSpacing: 24,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: children,
    ),
  );
}
