import 'package:flutter/material.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_radius.dart';
import '../../foundation/app_spacing.dart';
import '../../foundation/app_text_style.dart';

/// Checkbox 사이즈.
enum AppCheckboxSize { sm, md }

/// 디자인 시스템 표준 Checkbox.
///
/// `value`가 `null`이면 indeterminate (-).
class AppCheckbox extends StatelessWidget {
  final bool? value;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final AppCheckboxSize size;

  const AppCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.size = AppCheckboxSize.md,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final disabled = onChanged == null;
    final isSm = size == AppCheckboxSize.sm;
    final box = isSm ? 18.0 : 22.0;
    final iconSize = isSm ? 14.0 : 18.0;

    final on = (value ?? false) || value == null;
    final fill = disabled
        ? AppColor.interactionDisable
        : (on
            ? (isDark ? AppColor.darkPrimaryNormal : AppColor.primaryNormal)
            : Colors.transparent);
    final borderColor = on
        ? Colors.transparent
        : (isDark
            ? AppColor.darkLineSolidNormal
            : AppColor.lineSolidNormal);
    final iconColor = AppColor.staticLabelWhiteStrong;
    final labelColor =
        isDark ? AppColor.darkLabelNormal : AppColor.labelNormal;

    final boxWidget = AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      width: box,
      height: box,
      decoration: BoxDecoration(
        color: fill,
        borderRadius: AppRadius.radiusCheckboxBorder,
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: value == null
          ? Icon(Icons.remove_rounded, size: iconSize, color: iconColor)
          : (value!
              ? Icon(Icons.check_rounded, size: iconSize, color: iconColor)
              : null),
    );

    final body = label == null
        ? boxWidget
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              boxWidget,
              const SizedBox(width: AppSpacing.space8),
              Text(
                label!,
                style: (isSm
                        ? AppTextStyles.label2Regular
                        : AppTextStyles.label1NormalRegular)
                    .copyWith(color: labelColor),
              ),
            ],
          );

    return GestureDetector(
      onTap: disabled ? null : () => onChanged!(!(value ?? false)),
      child: body,
    );
  }
}
