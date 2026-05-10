import 'package:flutter/material.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_spacing.dart';
import '../../foundation/app_text_style.dart';

/// 디자인 시스템 표준 Radio.
class AppRadio<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final String? label;

  const AppRadio({
    super.key,
    required this.value,
    required this.groupValue,
    this.onChanged,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final disabled = onChanged == null;
    final isSelected = value == groupValue;
    final outerColor = disabled
        ? AppColor.interactionDisable
        : isSelected
            ? (isDark ? AppColor.darkPrimaryNormal : AppColor.primaryNormal)
            : (isDark
                ? AppColor.darkLineSolidNormal
                : AppColor.lineSolidNormal);
    final labelColor =
        isDark ? AppColor.darkLabelNormal : AppColor.labelNormal;

    final radio = AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: outerColor, width: 1.5),
      ),
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: isSelected ? 12 : 0,
          height: isSelected ? 12 : 0,
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
              const SizedBox(width: AppSpacing.space8),
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
