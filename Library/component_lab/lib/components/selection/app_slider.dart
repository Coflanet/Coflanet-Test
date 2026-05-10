import 'package:flutter/material.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_radius.dart';
import '../../foundation/app_text_style.dart';

/// Slider 컴포넌트 — Figma Selection and Input 페이지.
///
/// 슬라이더 + 라벨 + 값 표시
class AppSlider extends StatelessWidget {
  const AppSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.label,
    this.showValue = true,
    this.activeColor,
    this.isDisabled = false,
  });

  final double value;
  final ValueChanged<double>? onChanged;
  final double min;
  final double max;
  final int? divisions;
  final String? label;
  final bool showValue;
  final Color? activeColor;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    final active = activeColor ?? AppColor.colorGlobalCoolNeutral10;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null || showValue)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                if (label != null)
                  Expanded(
                    child: Text(
                      label!,
                      style: AppTextStyles.label1NormalMedium.copyWith(
                        color: AppColor.colorGlobalCoolNeutral10,
                      ),
                    ),
                  ),
                if (showValue)
                  Text(
                    divisions != null
                        ? value.round().toString()
                        : value.toStringAsFixed(1),
                    style: AppTextStyles.label1NormalBold.copyWith(
                      color: active,
                    ),
                  ),
              ],
            ),
          ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: active,
            inactiveTrackColor: AppColor.colorGlobalCoolNeutral95,
            thumbColor: AppColor.colorGlobalCommon100,
            overlayColor: active.withValues(alpha: 0.12),
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 10,
              elevation: 2,
            ),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
            trackShape: const RoundedRectSliderTrackShape(),
          ),
          child: Slider(
            value: value,
            onChanged: isDisabled ? null : onChanged,
            min: min,
            max: max,
            divisions: divisions,
          ),
        ),
      ],
    );
  }
}
