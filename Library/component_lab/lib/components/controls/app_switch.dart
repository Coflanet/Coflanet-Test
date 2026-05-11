import 'package:flutter/material.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_color_theme.dart';

/// Switch 사이즈.
enum AppSwitchSize { sm, md }

/// 디자인 시스템 표준 Switch.
class AppSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final AppSwitchSize size;

  const AppSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.size = AppSwitchSize.md,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final isSm = size == AppSwitchSize.sm;
    final width = isSm ? 36.0 : 44.0;
    final height = isSm ? 20.0 : 24.0;
    final thumb = isSm ? 16.0 : 20.0;

    final disabled = onChanged == null;
    final trackOn = disabled
        ? AppColor.interactionDisable
        : (c.primaryNormal);
    final trackOff = c.componentFillStrong;

    return GestureDetector(
      onTap: disabled ? null : () => onChanged!(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        width: width,
        height: height,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: value ? trackOn : trackOff,
          borderRadius: BorderRadius.circular(height / 2),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: thumb,
            height: thumb,
            decoration: BoxDecoration(
              color: AppColor.staticLabelWhiteStrong,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColor.colorGlobalCommon0.withValues(alpha: 0.12),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
