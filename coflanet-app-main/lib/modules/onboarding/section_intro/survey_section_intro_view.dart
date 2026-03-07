import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/modules/onboarding/survey_controller.dart';
import 'package:coflanet/widgets/buttons/primary_button.dart';

/// Survey Section Intro View
/// Shows vertical stepper with intro text before each section starts
/// Standard: 3 sections (커피 경험, 기본 맛 취향, 특성 향미 취향)
/// Lifestyle: 4 sections (커피 경험, 라이프스타일, 맛 취향, 감각/성향)
class SurveySectionIntroView extends GetView<SurveyController> {
  const SurveySectionIntroView({super.key});

  /// Check if current survey is lifestyle type
  bool get _isLifestyle => controller.surveyType == SurveyType.lifestyle;

  /// Get section labels based on survey type
  List<String> get _sectionLabels => _isLifestyle
      ? ['커피 경험 질문', '라이프스타일', '맛 취향', '감각/성향']
      : ['커피 경험 질문', '기본 맛 취향', '특성 향미 취향'];

  /// Get estimated time based on survey type
  String get _estimatedTime => _isLifestyle ? '3분' : '10분';

  @override
  Widget build(BuildContext context) {
    // Get section number from route parameter
    final sectionParam = Get.parameters['section'] ?? '1';
    final sectionNumber = int.tryParse(sectionParam) ?? 1;

    return Scaffold(
      backgroundColor: AppColor.backgroundNormalNormal,
      appBar: _buildAppBar(sectionNumber),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),

                    // Main title based on section
                    _buildTitle(sectionNumber),
                    const SizedBox(height: 16),

                    // Subtitle
                    Text(
                      '취향 분석은 이런 단계로 진행돼요.',
                      style: AppTextStyles.body1NormalRegular.copyWith(
                        color: AppColor.labelAlternative,
                      ),
                    ),
                    Text(
                      '예상 소요 시간은 $_estimatedTime 입니다.',
                      style: AppTextStyles.body1NormalRegular.copyWith(
                        color: AppColor.labelAlternative,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Vertical stepper - dynamic based on survey type
                    ..._buildStepper(sectionNumber),

                    const Spacer(),
                  ],
                ),
              ),
            ),

            // Bottom CTA
            Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 34),
              decoration: BoxDecoration(color: AppColor.backgroundNormalNormal),
              child: PrimaryButton(
                text: '다음',
                onPressed: () => _onNextPressed(sectionNumber),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build stepper widgets dynamically based on survey type
  List<Widget> _buildStepper(int currentSection) {
    final labels = _sectionLabels;
    final widgets = <Widget>[];

    for (int i = 0; i < labels.length; i++) {
      final step = i + 1;
      widgets.add(
        _buildStepIndicator(
          step: step,
          label: labels[i],
          state: _getStepState(step, currentSection),
        ),
      );
      if (i < labels.length - 1) {
        widgets.add(_buildVerticalLine(isCompleted: currentSection > step));
      }
    }

    return widgets;
  }

  PreferredSizeWidget _buildAppBar(int sectionNumber) {
    return AppBar(
      backgroundColor: AppColor.transparent,
      elevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset(
          AssetPath.iconArrowBack,
          width: 24,
          height: 24,
          colorFilter: ColorFilter.mode(AppColor.labelNormal, BlendMode.srcIn),
        ),
        onPressed: () => Get.back(),
      ),
      centerTitle: true,
      title: Text(
        '취향 분석',
        style: AppTextStyles.headline2Bold.copyWith(
          color: AppColor.labelNormal,
        ),
      ),
      actions: [
        // X 닫기 버튼 (건너뛰기)
        IconButton(
          icon: SvgPicture.asset(
            AssetPath.iconClose,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              AppColor.labelNormal,
              BlendMode.srcIn,
            ),
          ),
          onPressed: () => controller.skipSurvey(),
        ),
      ],
    );
  }

  Widget _buildTitle(int sectionNumber) {
    final userName = controller.userName;

    String line1;
    String line2;

    if (_isLifestyle) {
      // Lifestyle survey titles
      switch (sectionNumber) {
        case 1:
          line1 = '$userName님께';
          line2 = '커피 경험 질문을 드릴게요!';
          break;
        case 2:
          line1 = '$userName님께';
          line2 = '라이프스타일 질문을 드릴게요!';
          break;
        case 3:
          line1 = '$userName님께';
          line2 = '맛 취향 질문을 드릴게요!';
          break;
        case 4:
          line1 = '$userName님께';
          line2 = '감각/성향 질문을 드릴게요!';
          break;
        default:
          line1 = '$userName님의';
          line2 = '취향을 분석할게요';
      }
    } else {
      // Standard survey titles
      switch (sectionNumber) {
        case 1:
          line1 = '$userName님께';
          line2 = '커피 경험 질문을 드릴게요!';
          break;
        case 2:
          line1 = '$userName님의';
          line2 = '기본 맛 취향을 알려주세요';
          break;
        case 3:
          line1 = '$userName님의';
          line2 = '특성 향미 취향을 알려주세요';
          break;
        default:
          line1 = '$userName님의';
          line2 = '취향을 분석할게요';
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          line1,
          style: AppTextStyles.heading1Bold.copyWith(
            color: AppColor.labelNormal,
          ),
        ),
        Text(
          line2,
          style: AppTextStyles.heading1Bold.copyWith(
            color: AppColor.labelNormal,
          ),
        ),
      ],
    );
  }

  /// Determine step state based on current section
  _StepState _getStepState(int step, int currentSection) {
    if (step < currentSection) {
      return _StepState.completed;
    } else if (step == currentSection) {
      return _StepState.active;
    } else {
      return _StepState.inactive;
    }
  }

  /// Build a step indicator row with circle (number/checkmark) and text
  Widget _buildStepIndicator({
    required int step,
    required String label,
    required _StepState state,
  }) {
    return Row(
      children: [
        // Circle indicator
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: state == _StepState.active
                ? AppColor.primaryNormal
                : AppColor.componentFillNormal,
            border: state == _StepState.inactive
                ? Border.all(color: AppColor.primaryNormal, width: 1.5)
                : null,
          ),
          child: Center(
            child: state == _StepState.completed
                ? SvgPicture.asset(
                    AssetPath.iconCheck,
                    width: 16,
                    height: 16,
                    colorFilter: ColorFilter.mode(
                      AppColor.labelAssistive,
                      BlendMode.srcIn,
                    ),
                  )
                : Text(
                    '$step',
                    style: AppTextStyles.label1NormalBold.copyWith(
                      color: state == _StepState.active
                          ? AppColor.staticLabelWhiteNormal
                          : AppColor.primaryNormal,
                    ),
                  ),
          ),
        ),
        const SizedBox(width: 12),
        // Label text
        Text(
          label,
          style: AppTextStyles.body1NormalMedium.copyWith(
            color: state == _StepState.active
                ? AppColor.primaryNormal
                : AppColor.labelAssistive,
            fontWeight: state == _StepState.active
                ? FontWeight.w600
                : FontWeight.w400,
          ),
        ),
      ],
    );
  }

  /// Build vertical connecting line between steps
  Widget _buildVerticalLine({required bool isCompleted}) {
    return Padding(
      padding: const EdgeInsets.only(left: 15), // Center under 32px circle
      child: Container(
        width: 2,
        height: 32,
        color: isCompleted
            ? AppColor.labelAssistive.withValues(alpha: 0.3)
            : AppColor.primaryNormal.withValues(alpha: 0.3),
      ),
    );
  }

  /// Handle next button press - navigate to first question of the section
  void _onNextPressed(int sectionNumber) {
    if (_isLifestyle) {
      // Lifestyle survey section navigation
      switch (sectionNumber) {
        case 1:
          controller.goToStep(0);
          break;
        case 2:
          controller.goToStep(2); // Lifestyle starts at step 2
          break;
        case 3:
          controller.goToStep(6); // 맛 취향 starts at step 6
          break;
        case 4:
          controller.goToStep(10); // 감각/성향 starts at step 10
          break;
      }
    } else {
      // Standard survey section navigation
      switch (sectionNumber) {
        case 1:
          controller.goToStep(0);
          break;
        case 2:
          controller.goToStep(2);
          break;
        case 3:
          controller.goToStep(6);
          break;
      }
    }
  }
}

/// Step states for the vertical stepper
enum _StepState {
  completed, // Gray circle with checkmark
  active, // Purple filled circle with number
  inactive, // Purple outline circle with number
}
