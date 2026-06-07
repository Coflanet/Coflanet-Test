import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/style_constant.dart';

/// 추출 설정 요약 박스 — 값 + 라벨 (총 물의 양 / 총 추출시간).
///
/// [value] 는 호출부 Obx 클로저 안에서 평가된 문자열을 받는다 (Rx 미참조).
class SummaryBox extends StatelessWidget {
  const SummaryBox({super.key, required this.value, required this.label});

  /// 요약 값 (예: '250ml', '03:00')
  final String value;

  /// 라벨 (예: '총 물의 양')
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84,
      decoration: BoxDecoration(
        color: AppColor.componentFillNormal,
        borderRadius: AppRadius.xxlBorder,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: AppTextStyles.headline1Bold.copyWith(
              color: AppColor.labelNeutral,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.label1NormalRegular.copyWith(
              color: AppColor.labelAlternative,
            ),
          ),
        ],
      ),
    );
  }
}
