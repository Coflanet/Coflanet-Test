import 'package:flutter/material.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_spacing.dart';
import '../../foundation/app_radius.dart';
import '../../foundation/app_text_style.dart';

/// Gauge 컴포넌트 — Figma 🌡️ Gauge 페이지 (`gauge_txt`).
///
/// 5단계 게이지 바 + 선택된 단계를 표시합니다.
/// Gauge=5 고정, Select=1~5
class AppGauge extends StatelessWidget {
  const AppGauge({
    super.key,
    required this.value,
    this.maxValue = 5,
    this.labels,
    this.activeColor,
    this.inactiveColor,
    this.height = 8,
    this.showLabel = true,
  });

  /// 현재 값 (1-based, 1~maxValue)
  final int value;

  /// 최대 값 (기본 5)
  final int maxValue;

  /// 각 단계별 라벨 (예: ['매우 약함', '약함', '보통', '강함', '매우 강함'])
  final List<String>? labels;

  /// 활성 게이지 색상 (기본: CoolNeutral10)
  final Color? activeColor;

  /// 비활성 게이지 색상 (기본: CoolNeutral95)
  final Color? inactiveColor;

  /// 게이지 바 높이
  final double height;

  /// 라벨 표시 여부
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final active = activeColor ?? AppColor.colorGlobalCoolNeutral10;
    final inactive = inactiveColor ?? AppColor.colorGlobalCoolNeutral95;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 게이지 바
        Row(
          children: List.generate(maxValue, (i) {
            final isActive = i < value;
            final isFirst = i == 0;
            final isLast = i == maxValue - 1;

            return Expanded(
              child: Container(
                height: height,
                margin: EdgeInsets.only(right: isLast ? 0 : 2),
                decoration: BoxDecoration(
                  color: isActive ? active : inactive,
                  borderRadius: BorderRadius.horizontal(
                    left: isFirst
                        ? Radius.circular(AppRadius.radius4)
                        : Radius.zero,
                    right: isLast
                        ? Radius.circular(AppRadius.radius4)
                        : Radius.zero,
                  ),
                ),
              ),
            );
          }),
        ),

        // 라벨
        if (showLabel && labels != null && labels!.length == maxValue) ...[
          const SizedBox(height: AppSpacing.space8),
          Row(
            children: List.generate(maxValue, (i) {
              final isActive = i == value - 1;
              return Expanded(
                child: Text(
                  labels![i],
                  textAlign: i == 0
                      ? TextAlign.left
                      : i == maxValue - 1
                          ? TextAlign.right
                          : TextAlign.center,
                  style: AppTextStyles.caption1Regular.copyWith(
                    color: isActive
                        ? AppColor.colorGlobalCoolNeutral10
                        : AppColor.colorGlobalCoolNeutral60,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }
}
