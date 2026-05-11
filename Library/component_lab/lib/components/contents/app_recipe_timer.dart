import 'package:flutter/material.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_radius.dart';
import '../../foundation/app_spacing.dart';
import '../../foundation/app_text_style.dart';

/// Recipe / Timer Stepper — Figma `Contents/Recipe-Timmer`.
///
/// 라벨 + [-/+] 숫자 stepper 행. 숫자에 단위(예: "초", "g")가 함께 표시된다.
class AppRecipeStepper extends StatelessWidget {
  const AppRecipeStepper({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    this.minValue = 0,
    this.maxValue = 999,
    this.onChanged,
    this.placeholderText,
  });

  final String label;
  final int value;

  /// 값 뒤에 붙는 단위 라벨 (예: '초', 'g', '단위').
  final String unit;

  final int minValue;
  final int maxValue;

  final ValueChanged<int>? onChanged;

  /// 값이 0일 때 회색으로 보일 placeholder 텍스트 (예: '00단위').
  /// null 이면 `00$unit` 자동 생성.
  final String? placeholderText;

  void _delta(int d) {
    if (onChanged == null) return;
    final next = (value + d).clamp(minValue, maxValue);
    onChanged!(next);
  }

  @override
  Widget build(BuildContext context) {
    final isEmpty = value == 0;
    final placeholder = placeholderText ?? '00$unit';
    final text = isEmpty ? placeholder : '$value$unit';
    final color = isEmpty ? AppColor.labelAssistive : AppColor.labelNormal;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.label1NormalRegular.copyWith(
                color: AppColor.labelAlternative,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColor.lineSolidNeutral,
              borderRadius: BorderRadius.circular(AppRadius.radiusPill),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _StepperButton(
                  icon: Icons.add_rounded,
                  onTap: onChanged == null ? null : () => _delta(1),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.backgroundNormalNormal,
                    borderRadius: BorderRadius.circular(AppRadius.radius6),
                  ),
                  child: Text(
                    text,
                    style: AppTextStyles.label2RegularTabular.copyWith(
                      color: color,
                    ),
                  ),
                ),
                _StepperButton(
                  icon: Icons.remove_rounded,
                  onTap: onChanged == null ? null : () => _delta(-1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({required this.icon, this.onTap});
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        width: 20,
        height: 20,
        child: Icon(
          icon,
          size: 14,
          color: onTap == null
              ? AppColor.labelDisable
              : AppColor.labelAlternative,
        ),
      ),
    );
  }
}

/// Recipe Card — Figma `Contents/Recipe-Timmer`.
///
/// 타이틀 + 우상단 삭제 버튼 + 내부 [AppRecipeStepper] N개를 묶은 카드.
class AppRecipeCard extends StatelessWidget {
  const AppRecipeCard({
    super.key,
    required this.title,
    required this.steppers,
    this.onDelete,
  });

  final String title;

  /// 내부에 표시할 단계 위젯들. `AppRecipeStepper` 권장이지만 임의의 위젯 주입 가능.
  final List<Widget> steppers;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.backgroundNormalNormal,
        borderRadius: BorderRadius.circular(AppRadius.radius12),
        border: Border.all(color: AppColor.lineNormalNormal),
      ),
      padding: const EdgeInsets.all(AppSpacing.space16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.body1NormalBold.copyWith(
                    color: AppColor.labelNormal,
                  ),
                ),
              ),
              if (onDelete != null)
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onDelete,
                  child: Icon(
                    Icons.delete_outline_rounded,
                    size: 18,
                    color: AppColor.labelAlternative,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.space8),
          Container(height: 1, color: AppColor.lineNormalAlternative),
          ...steppers,
        ],
      ),
    );
  }
}
