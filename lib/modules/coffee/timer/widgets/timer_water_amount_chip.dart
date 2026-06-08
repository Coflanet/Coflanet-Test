import 'package:flutter/material.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/style_constant.dart';

/// 물의 양 칩 — 물방울 아이콘 + N ml (회색 카드).
///
/// 순수 표시 위젯 (controller/Rx 미참조).
class TimerWaterAmountChip extends StatelessWidget {
  const TimerWaterAmountChip({super.key, required this.waterAmount});

  /// 물의 양 (ml)
  final int waterAmount;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: colors.surfaceCardStrong,
        borderRadius: AppRadius.lgBorder,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.water_drop_outlined,
            color: colors.primaryNormal,
            size: 18,
          ),
          const SizedBox(width: 6),
          Text(
            '${waterAmount}ml',
            style: AppTextStyles.body1NormalBold.copyWith(
              color: colors.primaryNormal,
            ),
          ),
        ],
      ),
    );
  }
}
