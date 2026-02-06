import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';

/// 단계 표시기 스타일
enum StepIndicatorStyle {
  /// 원형 점 스타일
  dot,

  /// 숫자 표시 스타일
  numbered,

  /// 진행 바 스타일
  progress,

  /// 아이콘 스타일
  icon,
}

/// 단계 표시기
///
/// Figma: ⏳ Progress Indicators 페이지
///
/// 온보딩, 설문조사 등에서 진행 단계를 표시할 때 사용
///
/// Usage:
/// ```dart
/// // 기본 점 스타일
/// AppStepIndicator(
///   totalSteps: 6,
///   currentStep: 3,
/// )
///
/// // 숫자 스타일
/// AppStepIndicator(
///   totalSteps: 4,
///   currentStep: 2,
///   style: StepIndicatorStyle.numbered,
/// )
///
/// // 진행 바 스타일
/// AppStepIndicator(
///   totalSteps: 5,
///   currentStep: 3,
///   style: StepIndicatorStyle.progress,
/// )
/// ```
class AppStepIndicator extends StatelessWidget {
  /// 전체 단계 수
  final int totalSteps;

  /// 현재 단계 (1부터 시작)
  final int currentStep;

  /// 스타일
  final StepIndicatorStyle style;

  /// 활성 색상
  final Color? activeColor;

  /// 완료된 단계 색상
  final Color? completedColor;

  /// 비활성 색상
  final Color? inactiveColor;

  /// 단계 라벨 (numbered 스타일에서 사용)
  final List<String>? labels;

  /// 단계 간 커넥터 표시 여부
  final bool showConnector;

  const AppStepIndicator({
    super.key,
    required this.totalSteps,
    required this.currentStep,
    this.style = StepIndicatorStyle.dot,
    this.activeColor,
    this.completedColor,
    this.inactiveColor,
    this.labels,
    this.showConnector = true,
  });

  @override
  Widget build(BuildContext context) {
    switch (style) {
      case StepIndicatorStyle.dot:
        return _buildDotStyle();
      case StepIndicatorStyle.numbered:
        return _buildNumberedStyle();
      case StepIndicatorStyle.progress:
        return _buildProgressStyle();
      case StepIndicatorStyle.icon:
        return _buildIconStyle();
    }
  }

  Widget _buildDotStyle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        final stepNumber = index + 1;
        final isActive = stepNumber == currentStep;
        final isCompleted = stepNumber < currentStep;

        Color dotColor;
        if (isActive) {
          dotColor = activeColor ?? AppColor.primaryNormal;
        } else if (isCompleted) {
          dotColor = completedColor ?? AppColor.primaryNormal;
        } else {
          dotColor = inactiveColor ?? AppColor.componentFillNormal;
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.space4),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: isActive ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: dotColor,
              borderRadius: AppRadius.fullBorder,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildNumberedStyle() {
    final effectiveActiveColor = activeColor ?? AppColor.primaryNormal;
    final effectiveCompletedColor = completedColor ?? AppColor.primaryNormal;
    final effectiveInactiveColor =
        inactiveColor ?? AppColor.componentFillNormal;

    return Row(
      children: List.generate(totalSteps * 2 - 1, (index) {
        // 홀수 인덱스는 커넥터
        if (index.isOdd) {
          if (!showConnector) return const SizedBox.shrink();
          final prevStepNumber = (index ~/ 2) + 1;
          final isCompleted = prevStepNumber < currentStep;
          return Expanded(
            child: Container(
              height: 2,
              color: isCompleted
                  ? effectiveCompletedColor
                  : effectiveInactiveColor,
            ),
          );
        }

        // 짝수 인덱스는 단계 원
        final stepNumber = (index ~/ 2) + 1;
        final isActive = stepNumber == currentStep;
        final isCompleted = stepNumber < currentStep;

        Color circleColor;
        Color textColor;
        if (isActive) {
          circleColor = effectiveActiveColor;
          textColor = AppColor.staticLabelWhiteStrong;
        } else if (isCompleted) {
          circleColor = effectiveCompletedColor;
          textColor = AppColor.staticLabelWhiteStrong;
        } else {
          circleColor = effectiveInactiveColor;
          textColor = AppColor.labelAssistive;
        }

        return Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(color: circleColor, shape: BoxShape.circle),
          child: Center(
            child: isCompleted
                ? Icon(Icons.check_rounded, size: 18, color: textColor)
                : Text(
                    '$stepNumber',
                    style: AppTextStyles.label1NormalBold.copyWith(
                      color: textColor,
                    ),
                  ),
          ),
        );
      }),
    );
  }

  Widget _buildProgressStyle() {
    final progress = currentStep / totalSteps;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$currentStep / $totalSteps',
              style: AppTextStyles.label2Medium.copyWith(
                color: activeColor ?? AppColor.primaryNormal,
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: AppTextStyles.label2Medium.copyWith(
                color: AppColor.labelAlternative,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.space8),
        ClipRRect(
          borderRadius: AppRadius.fullBorder,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: progress),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return LinearProgressIndicator(
                value: value,
                minHeight: 6,
                valueColor: AlwaysStoppedAnimation(
                  activeColor ?? AppColor.primaryNormal,
                ),
                backgroundColor: inactiveColor ?? AppColor.componentFillNormal,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildIconStyle() {
    final effectiveActiveColor = activeColor ?? AppColor.primaryNormal;
    final effectiveCompletedColor = completedColor ?? AppColor.primaryNormal;
    final effectiveInactiveColor =
        inactiveColor ?? AppColor.componentFillNormal;

    return Row(
      children: List.generate(totalSteps * 2 - 1, (index) {
        // 홀수 인덱스는 커넥터
        if (index.isOdd) {
          if (!showConnector) return const SizedBox.shrink();
          final prevStepNumber = (index ~/ 2) + 1;
          final isCompleted = prevStepNumber < currentStep;
          return Expanded(
            child: Container(
              height: 2,
              margin: EdgeInsets.symmetric(horizontal: AppSpacing.space4),
              color: isCompleted
                  ? effectiveCompletedColor
                  : effectiveInactiveColor,
            ),
          );
        }

        // 짝수 인덱스는 단계 아이콘
        final stepNumber = (index ~/ 2) + 1;
        final isActive = stepNumber == currentStep;
        final isCompleted = stepNumber < currentStep;

        Color circleColor;
        Color iconColor;
        IconData iconData;

        if (isCompleted) {
          circleColor = effectiveCompletedColor;
          iconColor = AppColor.staticLabelWhiteStrong;
          iconData = Icons.check_rounded;
        } else if (isActive) {
          circleColor = effectiveActiveColor;
          iconColor = AppColor.staticLabelWhiteStrong;
          iconData = Icons.circle;
        } else {
          circleColor = effectiveInactiveColor;
          iconColor = AppColor.labelAssistive;
          iconData = Icons.circle_outlined;
        }

        return Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(color: circleColor, shape: BoxShape.circle),
          child: Center(
            child: Icon(iconData, size: isActive ? 10 : 16, color: iconColor),
          ),
        );
      }),
    );
  }
}

/// 간단한 텍스트 단계 표시기
///
/// Usage:
/// ```dart
/// AppStepLabel(
///   currentStep: 3,
///   totalSteps: 6,
/// )
/// // 결과: "3/6"
/// ```
class AppStepLabel extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final TextStyle? textStyle;
  final Color? color;

  const AppStepLabel({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.textStyle,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '$currentStep/$totalSteps',
      style: (textStyle ?? AppTextStyles.label1NormalMedium).copyWith(
        color: color ?? AppColor.labelAlternative,
      ),
    );
  }
}
