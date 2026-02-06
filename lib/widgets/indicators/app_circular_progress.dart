import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';

/// 원형 진행 표시기 사이즈
enum CircularProgressSize {
  /// 16px
  xs,

  /// 20px
  sm,

  /// 24px (default)
  md,

  /// 32px
  lg,

  /// 48px
  xl,
}

/// 원형 진행 표시기 / 로딩 스피너
///
/// Figma: ⏳ Progress Indicators 페이지
///
/// Usage:
/// ```dart
/// // 기본 로딩 스피너
/// AppCircularProgress()
///
/// // 진행률 표시
/// AppCircularProgress(value: 0.7)
///
/// // 사이즈 지정
/// AppCircularProgress(size: CircularProgressSize.lg)
///
/// // 색상 커스텀
/// AppCircularProgress(
///   color: AppColor.statusPositive,
/// )
/// ```
class AppCircularProgress extends StatelessWidget {
  /// 진행률 (0.0 ~ 1.0). null이면 indeterminate 모드
  final double? value;

  /// 색상 (기본: primaryNormal)
  final Color? color;

  /// 배경 색상 (기본: componentFillNormal)
  final Color? backgroundColor;

  /// 사이즈 (기본: md)
  final CircularProgressSize size;

  /// 선 두께 배율 (기본: 1.0)
  final double strokeWidthFactor;

  const AppCircularProgress({
    super.key,
    this.value,
    this.color,
    this.backgroundColor,
    this.size = CircularProgressSize.md,
    this.strokeWidthFactor = 1.0,
  });

  /// 무한 로딩 (indeterminate) 모드
  const AppCircularProgress.indeterminate({
    super.key,
    this.color,
    this.backgroundColor,
    this.size = CircularProgressSize.md,
    this.strokeWidthFactor = 1.0,
  }) : value = null;

  double get _size {
    switch (size) {
      case CircularProgressSize.xs:
        return 16;
      case CircularProgressSize.sm:
        return 20;
      case CircularProgressSize.md:
        return 24;
      case CircularProgressSize.lg:
        return 32;
      case CircularProgressSize.xl:
        return 48;
    }
  }

  double get _strokeWidth {
    switch (size) {
      case CircularProgressSize.xs:
        return 2.0 * strokeWidthFactor;
      case CircularProgressSize.sm:
        return 2.5 * strokeWidthFactor;
      case CircularProgressSize.md:
        return 3.0 * strokeWidthFactor;
      case CircularProgressSize.lg:
        return 3.5 * strokeWidthFactor;
      case CircularProgressSize.xl:
        return 4.0 * strokeWidthFactor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColor.primaryNormal;
    final effectiveBackgroundColor =
        backgroundColor ?? AppColor.componentFillNormal;

    return SizedBox(
      width: _size,
      height: _size,
      child: CircularProgressIndicator(
        value: value?.clamp(0.0, 1.0),
        strokeWidth: _strokeWidth,
        valueColor: AlwaysStoppedAnimation(effectiveColor),
        backgroundColor: value != null ? effectiveBackgroundColor : null,
        strokeCap: StrokeCap.round,
      ),
    );
  }
}

/// 퍼센트를 표시하는 원형 진행 표시기
///
/// Usage:
/// ```dart
/// AppCircularProgressWithLabel(
///   value: 0.75,
///   size: CircularProgressSize.xl,
/// )
/// ```
class AppCircularProgressWithLabel extends StatelessWidget {
  /// 진행률 (0.0 ~ 1.0)
  final double value;

  /// 색상 (기본: primaryNormal)
  final Color? color;

  /// 배경 색상
  final Color? backgroundColor;

  /// 사이즈 (xl 권장)
  final CircularProgressSize size;

  /// 라벨 표시 여부
  final bool showLabel;

  /// 커스텀 라벨 위젯
  final Widget? labelWidget;

  const AppCircularProgressWithLabel({
    super.key,
    required this.value,
    this.color,
    this.backgroundColor,
    this.size = CircularProgressSize.xl,
    this.showLabel = true,
    this.labelWidget,
  });

  double get _size {
    switch (size) {
      case CircularProgressSize.xs:
        return 16;
      case CircularProgressSize.sm:
        return 20;
      case CircularProgressSize.md:
        return 24;
      case CircularProgressSize.lg:
        return 32;
      case CircularProgressSize.xl:
        return 48;
    }
  }

  double get _fontSize {
    switch (size) {
      case CircularProgressSize.xs:
        return 6;
      case CircularProgressSize.sm:
        return 8;
      case CircularProgressSize.md:
        return 10;
      case CircularProgressSize.lg:
        return 12;
      case CircularProgressSize.xl:
        return 14;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AppCircularProgress(
          value: value,
          color: color,
          backgroundColor: backgroundColor,
          size: size,
        ),
        if (showLabel)
          labelWidget ??
              Text(
                '${(value * 100).toInt()}%',
                style: TextStyle(
                  fontSize: _fontSize,
                  fontWeight: FontWeight.w600,
                  color: color ?? AppColor.primaryNormal,
                ),
              ),
      ],
    );
  }
}
