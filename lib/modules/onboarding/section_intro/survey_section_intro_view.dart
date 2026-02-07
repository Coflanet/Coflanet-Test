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
/// - Section 1: Before step 0 (커피 경험 질문)
/// - Section 2: Before step 2 (기본 맛 취향)
/// - Section 3: Before step 6 (특성 향미 취향)
class SurveySectionIntroView extends GetView<SurveyController> {
  const SurveySectionIntroView({super.key});

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
                      '예상 소요 시간은 10분 입니다.',
                      style: AppTextStyles.body1NormalRegular.copyWith(
                        color: AppColor.labelAlternative,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Vertical stepper
                    _buildStepIndicator(
                      step: 1,
                      label: '커피 경험 질문',
                      state: _getStepState(1, sectionNumber),
                    ),
                    _buildVerticalLine(isCompleted: sectionNumber > 1),
                    _buildStepIndicator(
                      step: 2,
                      label: '기본 맛 취향',
                      state: _getStepState(2, sectionNumber),
                    ),
                    _buildVerticalLine(isCompleted: sectionNumber > 2),
                    _buildStepIndicator(
                      step: 3,
                      label: '특성 향미 취향',
                      state: _getStepState(3, sectionNumber),
                    ),

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
    );
  }

  Widget _buildTitle(int sectionNumber) {
    final userName = controller.userName;

    String line1;
    String line2;

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

/// Step states for the vertical stepper
enum _StepState {
  completed, // Gray circle with checkmark
  active, // Purple filled circle with number
  inactive, // Purple outline circle with number
}
