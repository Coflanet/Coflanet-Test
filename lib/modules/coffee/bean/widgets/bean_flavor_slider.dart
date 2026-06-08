import 'package:flutter/material.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/style_constant.dart';

/// 향미 프로필 슬라이더 — 라벨 + 현재 값 + Material Slider (0-100).
///
/// 상태 변경(setState + 변경 플래그)은 호출부 onChanged 클로저에 잔류.
/// controller/State 미참조 — 값/콜백만 주입.
class BeanFlavorSlider extends StatelessWidget {
  const BeanFlavorSlider({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  /// 슬라이더 라벨 (예: '산미')
  final String label;

  /// 현재 값 (0-100)
  final double value;

  /// 값 변경 콜백
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: AppTextStyles.body2NormalMedium.copyWith(
                  color: colors.labelAlternative,
                ),
              ),
              Text(
                value.round().toString(),
                style: AppTextStyles.body2NormalBold.copyWith(
                  color: colors.primaryNormal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: colors.primaryNormal,
              inactiveTrackColor: colors.lineSolidNormal,
              thumbColor: colors.primaryNormal,
              overlayColor: colors.primaryNormal.withValues(alpha: 0.15),
              trackHeight: 6,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            ),
            child: Slider(
              value: value,
              min: 0,
              max: 100,
              divisions: 100,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
