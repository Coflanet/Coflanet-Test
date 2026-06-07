import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';

/// 레시피 폼 선택형 칩 — 회색 fill 고정 + 선택 시 보라 테두리/텍스트.
///
/// 잔수(h44/lgPlus)·진하기(h48/xxxl/fullWidth) 칩이 공유한다.
/// 온보딩의 선택 칩(선택 시 primaryLight 배경 채움)과는 배경 체계가 달라
/// 공통 위젯으로 승격하지 않는다 (시각 변화 0 원칙).
///
/// [isSelected] 는 평범한 bool — 호출부 Obx 클로저 안에서 평가해 주입한다.
class SelectableChip extends StatelessWidget {
  const SelectableChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.height,
    required this.radius,
    required this.onTap,
    this.fullWidth = false,
  });

  /// 칩 라벨
  final String label;

  /// 선택 여부
  final bool isSelected;

  /// 칩 높이
  final double height;

  /// 모서리 radius 값
  final double radius;

  /// 탭 콜백
  final VoidCallback onTap;

  /// true 면 가로 풀폭
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: height,
        width: fullWidth ? double.infinity : null,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColor.componentFillNormal,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color: isSelected ? AppColor.primaryNormal : AppColor.transparent,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.body2NormalMedium.copyWith(
            color: isSelected
                ? AppColor.primaryNormal
                : AppColor.labelAlternative,
          ),
        ),
      ),
    );
  }
}
