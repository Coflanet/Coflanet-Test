import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';

/// 선형 진행 표시기 사이즈
enum LinearProgressSize {
  /// 2px height
  xs,

  /// 4px height (default)
  sm,

  /// 6px height
  md,

  /// 8px height
  lg,
}

/// 선형 진행 표시기
///
/// Figma: ⏳ Progress Indicators 페이지
///
/// Usage:
/// ```dart
/// // 기본 사용
/// AppLinearProgress(value: 0.7)
///
/// // 사이즈 지정
/// AppLinearProgress(
///   value: 0.5,
///   size: LinearProgressSize.lg,
/// )
///
/// // 색상 커스텀
/// AppLinearProgress(
///   value: 0.3,
///   color: AppColor.statusPositive,
/// )
///
/// // 무한 로딩 (indeterminate)
/// AppLinearProgress.indeterminate()
/// ```
class AppLinearProgress extends StatelessWidget {
  /// 진행률 (0.0 ~ 1.0). null이면 indeterminate 모드
  final double? value;

  /// 진행 바 색상 (기본: primaryNormal)
  final Color? color;

  /// 배경 색상 (기본: componentFillNormal)
  final Color? backgroundColor;

  /// 사이즈 (기본: sm)
  final LinearProgressSize size;

  /// 애니메이션 적용 여부
  final bool animate;

  const AppLinearProgress({
    super.key,
    this.value,
    this.color,
    this.backgroundColor,
    this.size = LinearProgressSize.sm,
    this.animate = true,
  });

  /// 무한 로딩 (indeterminate) 모드
  const AppLinearProgress.indeterminate({
    super.key,
    this.color,
    this.backgroundColor,
    this.size = LinearProgressSize.sm,
  }) : value = null,
       animate = true;

  double get _height {
    switch (size) {
      case LinearProgressSize.xs:
        return 2;
      case LinearProgressSize.sm:
        return 4;
      case LinearProgressSize.md:
        return 6;
      case LinearProgressSize.lg:
        return 8;
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColor.primaryNormal;
    final effectiveBackgroundColor =
        backgroundColor ?? AppColor.componentFillNormal;

    return ClipRRect(
      borderRadius: AppRadius.fullBorder,
      child: SizedBox(
        height: _height,
        child: value != null
            ? _buildDeterminateProgress(
                effectiveColor,
                effectiveBackgroundColor,
              )
            : _buildIndeterminateProgress(
                effectiveColor,
                effectiveBackgroundColor,
              ),
      ),
    );
  }

  Widget _buildDeterminateProgress(Color color, Color backgroundColor) {
    if (animate) {
      return TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: value!.clamp(0.0, 1.0)),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        builder: (context, animatedValue, child) {
          return LinearProgressIndicator(
            value: animatedValue,
            minHeight: _height,
            valueColor: AlwaysStoppedAnimation(color),
            backgroundColor: backgroundColor,
          );
        },
      );
    }

    return LinearProgressIndicator(
      value: value!.clamp(0.0, 1.0),
      minHeight: _height,
      valueColor: AlwaysStoppedAnimation(color),
      backgroundColor: backgroundColor,
    );
  }

  Widget _buildIndeterminateProgress(Color color, Color backgroundColor) {
    return LinearProgressIndicator(
      minHeight: _height,
      valueColor: AlwaysStoppedAnimation(color),
      backgroundColor: backgroundColor,
    );
  }
}

/// 세그먼트형 진행 표시기
///
/// 여러 단계를 나누어 표시할 때 사용
///
/// Usage:
/// ```dart
/// AppSegmentedProgress(
///   totalSegments: 5,
///   completedSegments: 3,
/// )
/// ```
class AppSegmentedProgress extends StatelessWidget {
  /// 전체 세그먼트 수
  final int totalSegments;

  /// 완료된 세그먼트 수
  final int completedSegments;

  /// 완료된 세그먼트 색상
  final Color? completedColor;

  /// 미완료 세그먼트 색상
  final Color? incompleteColor;

  /// 세그먼트 간격
  final double gap;

  /// 높이
  final double height;

  const AppSegmentedProgress({
    super.key,
    required this.totalSegments,
    required this.completedSegments,
    this.completedColor,
    this.incompleteColor,
    this.gap = 4,
    this.height = 4,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveCompletedColor = completedColor ?? AppColor.primaryNormal;
    final effectiveIncompleteColor =
        incompleteColor ?? AppColor.componentFillNormal;

    return Row(
      children: List.generate(totalSegments, (index) {
        final isCompleted = index < completedSegments;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: index < totalSegments - 1 ? gap : 0),
            height: height,
            decoration: BoxDecoration(
              color: isCompleted
                  ? effectiveCompletedColor
                  : effectiveIncompleteColor,
              borderRadius: AppRadius.fullBorder,
            ),
          ),
        );
      }),
    );
  }
}
