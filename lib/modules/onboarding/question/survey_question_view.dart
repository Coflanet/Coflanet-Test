import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/data/models/survey_question_model.dart';
import 'package:coflanet/modules/onboarding/survey_controller.dart';
import 'package:coflanet/modules/onboarding/widgets/survey_progress_bar.dart';
import 'package:coflanet/modules/onboarding/widgets/survey_checkbox_item.dart';
import 'package:coflanet/modules/onboarding/widgets/survey_rating_item.dart';
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
      backgroundColor: AppColor.transparent,
      elevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset(
          AssetPath.iconArrowBack,
          width: 24,
          height: 24,
          colorFilter: ColorFilter.mode(AppColor.labelNormal, BlendMode.srcIn),
        ),
        onPressed: () => controller.previousQuestion(),
      ),
      title: Obx(
        () => SurveyProgressBar(
          current: controller.currentStep + 1,
          total: controller.totalSteps,
        ),
      ),
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

        // Question number (skip for step 0 - survey reason)
        if (question.step > 0) ...[
          Text(
            'Q${question.step}',
            style: AppTextStyles.label1NormalBold.copyWith(
              color: AppColor.primaryNormal,
            ),
          ),
          const SizedBox(height: 8),
        ],

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

        // Render options based on question type
        _buildOptionsForType(question),

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
      child: Obx(() {
        String buttonText;
        if (controller.currentStep == 0) {
          buttonText = '원두 취향 찾으러 가기';
        } else if (controller.currentStep < controller.totalSteps - 1) {
          buttonText = '다음';
        } else {
          buttonText = '완료';
        }
        return PrimaryButton(
          text: buttonText,
          isEnabled: controller.hasSelection,
          onPressed: controller.hasSelection
              ? () => controller.nextQuestion()
              : null,
        );
      }),
    );
  }

  /// Build options based on question type
  Widget _buildOptionsForType(SurveyQuestionModel question) {
    switch (question.questionType) {
      case SurveyQuestionType.checkbox:
        // Text-only checkboxes (step 0)
        return Column(
          children: question.options
              .map(
                (option) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SurveyCheckboxItem(
                    label: option.label,
                    icon: option.icon,
                    description: option.description,
                    isSelected: controller.isOptionSelected(option.id),
                    onTap: () => controller.selectOption(option.id),
                    showIcon: false, // Text-only
                  ),
                ),
              )
              .toList(),
        );

      case SurveyQuestionType.checkboxWithIcon:
        // Emoji + label + description checkboxes
        return Column(
          children: question.options
              .map(
                (option) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SurveyCheckboxItem(
                    label: option.label,
                    icon: option.icon,
                    description: option.description,
                    isSelected: controller.isOptionSelected(option.id),
                    onTap: () => controller.selectOption(option.id),
                    showIcon: true, // Show emoji
                  ),
                ),
              )
              .toList(),
        );

      case SurveyQuestionType.rating:
        // Rating style (👎😐👍)
        return SurveyRatingItem(
          label: question.question,
          selectedValue: _getSelectedRatingValue(),
          onValueChanged: (value) {
            // Map rating value to option id
            final optionId = switch (value) {
              -1 => 'dislike',
              0 => 'neutral',
              1 => 'like',
              _ => 'neutral',
            };
            controller.selectOption(optionId);
          },
        );

      case SurveyQuestionType.imageGrid:
        // Image grid for equipment selection
        return _buildImageGrid(question);
    }
  }

  /// Get selected rating value from current answers
  int? _getSelectedRatingValue() {
    final stepAnswers = controller.answers[controller.currentStep];
    if (stepAnswers == null || stepAnswers.isEmpty) return null;
    final id = stepAnswers.first;
    return switch (id) {
      'dislike' => -1,
      'neutral' => 0,
      'like' => 1,
      _ => null,
    };
  }

  /// Build image grid for equipment selection (2 columns)
  Widget _buildImageGrid(SurveyQuestionModel question) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.2,
      children: question.options.map((option) {
        final isSelected = controller.isOptionSelected(option.id);
        return GestureDetector(
          onTap: () => controller.selectOption(option.id),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColor.primaryLight
                  : AppColor.componentFillNormal,
              borderRadius: AppRadius.lgBorder,
              border: Border.all(
                color: isSelected
                    ? AppColor.primaryNormal
                    : AppColor.transparent,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Placeholder for equipment image
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColor.backgroundNormalAlternative,
                    borderRadius: AppRadius.mdBorder,
                  ),
                  child: Icon(
                    Icons.coffee_rounded,
                    color: isSelected
                        ? AppColor.primaryNormal
                        : AppColor.labelAssistive,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  option.label,
                  style: AppTextStyles.label1NormalMedium.copyWith(
                    color: isSelected
                        ? AppColor.primaryNormal
                        : AppColor.labelNormal,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
