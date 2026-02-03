import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/modules/onboarding/survey_controller.dart';
import 'package:coflanet/modules/onboarding/widgets/survey_progress_bar.dart';
import 'package:coflanet/modules/onboarding/widgets/survey_checkbox_item.dart';
import 'package:coflanet/widgets/buttons/primary_button.dart';

class SurveyQuestionView extends GetView<SurveyController> {
  const SurveyQuestionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundNormalNormal,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Obx(() => _buildContent()),
              ),
            ),
            _buildBottomButton(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: AppColor.labelNormal),
        onPressed: () => controller.previousQuestion(),
      ),
      title: Obx(() => SurveyProgressBar(
            current: controller.currentStep,
            total: controller.totalSteps,
          )),
      actions: [
        TextButton(
          onPressed: () => controller.completeOnboarding(),
          child: Text(
            '건너뛰기',
            style: AppTextStyles.label1NormalMedium.copyWith(
              color: AppColor.labelAssistive,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    final question = controller.currentQuestion;
    if (question == null) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),

        // Question number
        Text(
          'Q${question.step}',
          style: AppTextStyles.label1NormalBold.copyWith(
            color: AppColor.primaryNormal,
          ),
        ),
        const SizedBox(height: 8),

        // Question text
        Text(
          question.question,
          style: AppTextStyles.heading1Bold.copyWith(
            color: AppColor.labelNormal,
          ),
        ),

        if (question.description.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            question.description,
            style: AppTextStyles.body2NormalRegular.copyWith(
              color: AppColor.labelAlternative,
            ),
          ),
        ],

        const SizedBox(height: 32),

        // Options
        ...question.options.map((option) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SurveyCheckboxItem(
                label: option.label,
                icon: option.icon,
                description: option.description,
                isSelected: controller.isOptionSelected(option.id),
                onTap: () => controller.selectOption(option.id),
              ),
            )),

        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColor.backgroundNormalNormal,
        boxShadow: AppShadows.shadowBlackNormal,
      ),
      child: Obx(() => PrimaryButton(
            text: controller.currentStep < controller.totalSteps
                ? '다음'
                : '완료',
            isEnabled: controller.hasSelection,
            onPressed: controller.hasSelection
                ? () => controller.nextQuestion()
                : null,
          )),
    );
  }
}
