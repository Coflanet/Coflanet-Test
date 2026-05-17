import 'package:flutter/material.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_color_theme.dart';
import '../../foundation/app_spacing.dart';
import '../../foundation/app_text_style.dart';

/// AppRadio 사이즈. Checkbox/Switch와 API 통일을 위해 동일 enum 스키마.
enum AppRadioSize { sm, md }

/// 디자인 시스템 표준 Radio.
class AppRadio<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final String? label;
  final AppRadioSize size;

  const AppRadio({
    super.key,
    required this.value,
    required this.groupValue,
    this.onChanged,
    this.label,
    this.size = AppRadioSize.md,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final disabled = onChanged == null;
    final isSelected = value == groupValue;
    final isSm = size == AppRadioSize.sm;
    final box = isSm ? 18.0 : 22.0;
    final dot = isSm ? 10.0 : 12.0;
    final outerColor = disabled
        ? AppColor.interactionDisable
        : isSelected
            ? (c.primaryNormal)
            : (c.lineSolidNormal);
    final labelColor =
        c.labelNormal;

    final radio = AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      width: box,
      height: box,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: outerColor, width: 1.5),
      ),
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: isSelected ? dot : 0,
          height: isSelected ? dot : 0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: outerColor,
          ),
        ),
      ),
    );

    final body = label == null
        ? radio
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              radio,
              const SizedBox(width: AppSpacing.s8),
              Text(
                label!,
                style: AppTextStyles.label1NormalRegular
                    .copyWith(color: labelColor),
              ),
            ],
          );

    return GestureDetector(
      onTap: disabled ? null : () => onChanged!(value),
      child: body,
    );
  }
}
