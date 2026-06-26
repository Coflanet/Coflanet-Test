import 'package:flutter/material.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';
import 'package:coflanet/constants/style_constant.dart';

/// 타임세일 카운트다운 pill — Figma `Time_Sale` 우상단(05:32:17).
///
/// 연한 보라 배경 + primary 텍스트. 시간 문자열은 호출부 Obx 가 주입한다.
class ShoppingCountdownPill extends StatelessWidget {
  const ShoppingCountdownPill({super.key, required this.time});

  /// 'HH:MM:SS' 형식 잔여 시간
  final String time;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.space6,
      ),
      decoration: BoxDecoration(
        color: colors.primaryLight,
        borderRadius: AppRadius.mdBorder,
      ),
      child: Text(
        time,
        style: AppTextStyles.body2NormalBold.copyWith(
          color: colors.primaryNormal,
        ),
      ),
    );
  }
}
