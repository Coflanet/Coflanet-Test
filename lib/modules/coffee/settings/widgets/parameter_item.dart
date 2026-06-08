import 'package:flutter/material.dart';
import 'package:coflanet/constants/app_color_scheme.dart';

/// 파라미터 그리드 1칸 — 값 + 라벨 (원두/물 온도/추출 시간/물의 양).
///
/// Figma: value 15/w500/labelNeutral + label 14/w400/labelAlternative.
/// [value] 는 호출부 Obx 클로저 안에서 평가된 문자열을 받는다 (Rx 미참조).
class ParameterItem extends StatelessWidget {
  const ParameterItem({
    super.key,
    required this.value,
    required this.label,
    required this.onTap,
  });

  /// 파라미터 값 (예: '18g')
  final String value;

  /// 파라미터 라벨 (예: '원두')
  final String label;

  /// 탭 콜백 (입력 모달 열기)
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 값 — Figma: Pretendard 15px/500, rgba(46,47,51,0.88)
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: colors.labelNeutral,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          // 라벨 — Figma: Pretendard 14px/400, rgba(55,56,60,0.61)
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: colors.labelAlternative,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
