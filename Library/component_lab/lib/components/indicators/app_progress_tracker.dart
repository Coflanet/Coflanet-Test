import 'package:flutter/material.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_spacing.dart';
import '../../foundation/app_text_style.dart';

/// Step 진행 상태.
enum AppProgressStepState {
  /// 완료
  complete,

  /// 현재 단계 (강조)
  active,

  /// 미진행
  pending,
}

/// 단일 step 정의.
class AppProgressStep {
  const AppProgressStep({required this.label, this.subLabel});

  final String label;

  /// 보조 텍스트 (예: '2025-05-11 14:30').
  final String? subLabel;
}

/// 방향.
enum AppProgressTrackerAxis { horizontal, vertical }

/// Progress Tracker — Figma `Progress Tracker/{Horizontal,Vertical,Step}`.
///
/// Step 인디케이터(원형 + 번호 또는 체크) + connector(선) + 라벨로 구성된 진행도 표시.
/// `currentStep` 인덱스 기준으로 [0, currentStep) → complete, == currentStep → active,
/// 그 이후는 pending. 명시적 상태 오버라이드는 P0에선 미지원 (P1+에서 추가 가능).
class AppProgressTracker extends StatelessWidget {
  const AppProgressTracker({
    super.key,
    required this.steps,
    required this.currentStep,
    this.axis = AppProgressTrackerAxis.horizontal,
  }) : assert(steps.length > 0, 'steps must not be empty');

  final List<AppProgressStep> steps;

  /// 현재 step 인덱스 (0-based). steps.length 이상이면 모두 complete.
  final int currentStep;
  final AppProgressTrackerAxis axis;

  AppProgressStepState _stateOf(int i) {
    if (i < currentStep) return AppProgressStepState.complete;
    if (i == currentStep) return AppProgressStepState.active;
    return AppProgressStepState.pending;
  }

  @override
  Widget build(BuildContext context) {
    return axis == AppProgressTrackerAxis.horizontal
        ? _buildHorizontal()
        : _buildVertical();
  }

  Widget _buildHorizontal() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < steps.length; i++) ...[
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    if (i > 0)
                      Expanded(
                        child: _Connector(
                          state: _stateOf(i),
                          horizontal: true,
                        ),
                      )
                    else
                      const Spacer(),
                    _StepCircle(index: i, state: _stateOf(i)),
                    if (i < steps.length - 1)
                      Expanded(
                        child: _Connector(
                          state: _stateOf(i + 1),
                          horizontal: true,
                        ),
                      )
                    else
                      const Spacer(),
                  ],
                ),
                const SizedBox(height: AppSpacing.space8),
                _StepLabel(step: steps[i], state: _stateOf(i), centered: true),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildVertical() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < steps.length; i++)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _StepCircle(index: i, state: _stateOf(i)),
                    if (i < steps.length - 1)
                      Expanded(
                        child: _Connector(
                          state: _stateOf(i + 1),
                          horizontal: false,
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: AppSpacing.space12),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: i < steps.length - 1 ? AppSpacing.space16 : 0,
                  ),
                  child: _StepLabel(
                    step: steps[i],
                    state: _stateOf(i),
                    centered: false,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _StepCircle extends StatelessWidget {
  const _StepCircle({required this.index, required this.state});

  final int index;
  final AppProgressStepState state;

  @override
  Widget build(BuildContext context) {
    final (bg, fg, border) = switch (state) {
      AppProgressStepState.complete => (
          AppColor.primaryNormal,
          AppColor.colorGlobalCommon100,
          null,
        ),
      AppProgressStepState.active => (
          AppColor.primaryLight,
          AppColor.primaryNormal,
          AppColor.primaryNormal,
        ),
      AppProgressStepState.pending => (
          AppColor.backgroundElevatedNormal,
          AppColor.labelAlternative,
          AppColor.lineNormalNeutral,
        ),
    };

    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        border: border != null ? Border.all(color: border, width: 1.5) : null,
      ),
      alignment: Alignment.center,
      child: state == AppProgressStepState.complete
          ? Icon(Icons.check_rounded, size: 16, color: fg)
          : Text(
              '${index + 1}',
              style: AppTextStyles.label2Bold.copyWith(color: fg),
            ),
    );
  }
}

class _Connector extends StatelessWidget {
  const _Connector({required this.state, required this.horizontal});

  final AppProgressStepState state;
  final bool horizontal;

  @override
  Widget build(BuildContext context) {
    final color = state == AppProgressStepState.pending
        ? AppColor.lineNormalNeutral
        : AppColor.primaryNormal;
    return horizontal
        ? Container(
            height: 2,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            color: color,
          )
        : Container(
            width: 2,
            margin: const EdgeInsets.symmetric(vertical: 4),
            color: color,
          );
  }
}

class _StepLabel extends StatelessWidget {
  const _StepLabel({
    required this.step,
    required this.state,
    required this.centered,
  });

  final AppProgressStep step;
  final AppProgressStepState state;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    final color = state == AppProgressStepState.pending
        ? AppColor.labelAlternative
        : AppColor.labelNormal;
    final weight = state == AppProgressStepState.active
        ? AppTextStyles.label1NormalBold
        : AppTextStyles.label1NormalRegular;
    return Column(
      crossAxisAlignment:
          centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          step.label,
          textAlign: centered ? TextAlign.center : TextAlign.start,
          style: weight.copyWith(color: color),
        ),
        if (step.subLabel != null) ...[
          const SizedBox(height: 2),
          Text(
            step.subLabel!,
            textAlign: centered ? TextAlign.center : TextAlign.start,
            style: AppTextStyles.caption1Regular.copyWith(
              color: AppColor.labelAlternative,
            ),
          ),
        ],
      ],
    );
  }
}
