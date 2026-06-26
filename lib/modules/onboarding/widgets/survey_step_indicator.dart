import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';
import 'package:coflanet/constants/style_constant.dart';

/// 설문 진행 단계 스테퍼 — Figma POC `Survey_index01~03` (Step 1401:20044).
/// 인덱스/섹션 인트로 화면이 공유한다.
/// 불릿 24×24, 활성=primary 채움+흰 숫자, 완료=회색 채움+체크, 비활성=회색 채움+숫자.
/// 단계 사이는 1px 연결선(좌측 불릿 중심 정렬).
class SurveyStepIndicator extends StatelessWidget {
  const SurveyStepIndicator({
    super.key,
    required this.colors,
    required this.labels,
    required this.currentStep,
  });

  final AppColorScheme colors;

  /// 단계 라벨 (1단계부터 순서대로)
  final List<String> labels;

  /// 현재 단계 (1-based). 이전 단계는 완료, 이후 단계는 비활성.
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (int i = 0; i < labels.length; i++) {
      final step = i + 1;
      final state = step < currentStep
          ? _StepState.completed
          : step == currentStep
          ? _StepState.active
          : _StepState.inactive;
      children.add(_buildStep(step, labels[i], state));
      if (i < labels.length - 1) {
        children.add(_buildConnector());
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  Widget _buildStep(int step, String label, _StepState state) {
    final isActive = state == _StepState.active;
    final isCompleted = state == _StepState.completed;

    return Row(
      children: [
        // Figma I…;2411:28630 — 불릿 24×24
        Container(
          width: AppSpacing.space24,
          height: AppSpacing.space24,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isActive ? colors.primaryNormal : colors.componentFillNormal,
            borderRadius: AppRadius.xlBorder,
          ),
          child: isCompleted
              ? SvgPicture.asset(
                  AssetPath.iconCheck,
                  width: AppSpacing.space16,
                  height: AppSpacing.space16,
                  colorFilter: ColorFilter.mode(
                    colors.labelAssistive,
                    BlendMode.srcIn,
                  ),
                )
              : Text(
                  '$step',
                  style: AppTextStyles.label1NormalBold.copyWith(
                    color: isActive
                        ? AppColor.staticLabelWhiteNormal
                        : colors.labelNeutral,
                  ),
                ),
        ),
        const SizedBox(width: AppSpacing.space16),
        // 라벨
        Expanded(
          child: Text(
            label,
            style:
                (isActive
                        ? AppTextStyles.body1NormalBold
                        : AppTextStyles.body1NormalRegular)
                    .copyWith(
                      color: isActive
                          ? colors.primaryNormal
                          : isCompleted
                          ? colors.labelAlternative
                          : colors.labelNeutral,
                    ),
          ),
        ),
      ],
    );
  }

  /// 단계 사이 1px 연결선 (24px 불릿 중심 아래로 정렬, 위아래 4px 여백)
  Widget _buildConnector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.space4),
      child: SizedBox(
        width: AppSpacing.space24,
        child: Center(
          child: Container(
            width: 1,
            height: AppSpacing.space16,
            color: colors.lineNormalNormal,
          ),
        ),
      ),
    );
  }
}

enum _StepState { completed, active, inactive }
