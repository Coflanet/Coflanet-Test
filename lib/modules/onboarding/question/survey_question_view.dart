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
            // Progress bar below AppBar - section-specific progress
            Obx(
              () => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SurveyProgressIndicator(
                  progress: _calculateSectionProgress(),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(child: Obx(() => _buildContent())),
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
      centerTitle: true,
      title: Obx(
        () => Text(
          controller.currentStepTitle,
          style: AppTextStyles.headline2Bold.copyWith(
            color: AppColor.labelNormal,
          ),
        ),
      ),
      actions: [
        // X 닫기 버튼 (Figma 디자인)
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

  Widget _buildContent() {
    final question = controller.currentQuestion;
    if (question == null) return const SizedBox();

    // For rating questions, center the options vertically
    final isRatingQuestion = question.questionType == SurveyQuestionType.rating;

    if (isRatingQuestion) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 24),
            // Question text at top
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                question.question,
                style: AppTextStyles.heading1Bold.copyWith(
                  color: AppColor.labelNormal,
                ),
              ),
            ),
            if (question.description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  question.description,
                  style: AppTextStyles.body2NormalRegular.copyWith(
                    color: AppColor.labelAlternative,
                  ),
                ),
              ),
            ],
            // Position rating buttons slightly above center (per Figma)
            Expanded(
              child: Align(
                alignment: const Alignment(0, -0.4),
                child: _buildOptionsForType(question),
              ),
            ),
          ],
        ),
      );
    }

    // For other question types, use scrollable layout
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),

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
      ),
    );
  }

  Widget _buildBottomButton() {
    return Obx(() {
      // Section 2-3 (steps 2-9): rating questions - no button, auto-advance
      if (controller.currentStep >= 2) {
        return const SizedBox.shrink();
      }

      // Section 1 (steps 0-1): checkbox questions - show button
      final buttonText = '선택했어요';

      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColor.backgroundNormalNormal,
          boxShadow: AppShadows.shadowBlackNormal,
        ),
        child: PrimaryButton(
          text: buttonText,
          isEnabled: controller.hasSelection,
          onPressed: () => controller.nextQuestion(),
        ),
      );
    });
  }

  /// Calculate progress within current section
  /// Standard: Section 1 (0-1), Section 2 (2-5), Section 3 (6-9)
  /// Lifestyle: Section 1 (0-1), Section 2 (2-5), Section 3 (6-9), Section 4 (10-11)
  double _calculateSectionProgress() {
    final step = controller.currentStep;
    final isLifestyle = controller.surveyType == SurveyType.lifestyle;

    if (step <= 1) {
      // Section 1: steps 0-1 (2 questions)
      return (step + 1) / 2;
    } else if (step <= 5) {
      // Section 2: steps 2-5 (4 questions)
      return (step - 2 + 1) / 4;
    } else if (step <= 9) {
      // Section 3: steps 6-9 (4 questions)
      return (step - 6 + 1) / 4;
    } else if (isLifestyle && step <= 11) {
      // Section 4 (lifestyle only): steps 10-11 (2 questions)
      return (step - 10 + 1) / 2;
    } else {
      return 1.0;
    }
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
        // Check if question has 3 options (기본 맛 취향) or 2 options (특성 향미 취향)
        if (question.options.length == 3) {
          return _buildTernaryRating(question); // 싫어요/보통/좋아요
        } else {
          return _buildBinaryRating(question); // 싫어요/좋아요
        }

      case SurveyQuestionType.imageGrid:
        // Image grid for equipment selection
        return _buildImageGrid(question);

      case SurveyQuestionType.multiRating:
        // Multiple rating items on one screen
        return _buildMultiRating(question);
    }
  }

  /// Build multi-rating items for taste/aroma preferences
  Widget _buildMultiRating(SurveyQuestionModel question) {
    final items = question.multiRatingItems;
    if (items == null || items.isEmpty) return const SizedBox();

    return Column(
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _MultiRatingItemWidget(
            item: item,
            selectedValue: controller.getMultiRating(item.id),
            onValueChanged: (value) =>
                controller.setMultiRating(item.id, value),
          ),
        );
      }).toList(),
    );
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

  /// Build ternary rating (싫어요/보통/좋아요 - 3 options for 기본 맛 취향)
  Widget _buildTernaryRating(SurveyQuestionModel question) {
    final selectedValue = _getSelectedRatingValue();

    return Row(
      children: [
        // 싫어요 (Dislike) - RED
        Expanded(
          child: GestureDetector(
            onTap: () => controller.selectOption('dislike'),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: selectedValue == -1
                    ? AppColor.colorGlobalRed50
                    : AppColor.colorGlobalRed95,
                borderRadius: AppRadius.lgBorder,
                border: Border.all(
                  color: selectedValue == -1
                      ? AppColor.colorGlobalRed40
                      : AppColor.colorGlobalRed90,
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('👎', style: const TextStyle(fontSize: 36)),
                  const SizedBox(height: 8),
                  Text(
                    '싫어요',
                    style: AppTextStyles.body1NormalBold.copyWith(
                      color: selectedValue == -1
                          ? AppColor.colorGlobalCommon100
                          : AppColor.colorGlobalRed50,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        // 보통 (Neutral) - GRAY
        Expanded(
          child: GestureDetector(
            onTap: () => controller.selectOption('neutral'),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: selectedValue == 0
                    ? AppColor.labelAssistive
                    : AppColor.componentFillNormal,
                borderRadius: AppRadius.lgBorder,
                border: Border.all(
                  color: selectedValue == 0
                      ? AppColor.labelNormal
                      : AppColor.lineNormalNeutral,
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('😐', style: const TextStyle(fontSize: 36)),
                  const SizedBox(height: 8),
                  Text(
                    '보통',
                    style: AppTextStyles.body1NormalBold.copyWith(
                      color: selectedValue == 0
                          ? AppColor.colorGlobalCommon100
                          : AppColor.labelNormal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        // 좋아요 (Like) - BLUE
        Expanded(
          child: GestureDetector(
            onTap: () => controller.selectOption('like'),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: selectedValue == 1
                    ? AppColor.colorGlobalBlue50
                    : AppColor.colorGlobalBlue95,
                borderRadius: AppRadius.lgBorder,
                border: Border.all(
                  color: selectedValue == 1
                      ? AppColor.colorGlobalBlue40
                      : AppColor.colorGlobalBlue90,
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('👍', style: const TextStyle(fontSize: 36)),
                  const SizedBox(height: 8),
                  Text(
                    '좋아요',
                    style: AppTextStyles.body1NormalBold.copyWith(
                      color: selectedValue == 1
                          ? AppColor.colorGlobalCommon100
                          : AppColor.colorGlobalBlue50,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Build binary rating (싫어요/좋아요 with Red/Blue colors - for 특성 향미 취향)
  Widget _buildBinaryRating(SurveyQuestionModel question) {
    final selectedValue = _getSelectedRatingValue();

    return Row(
      children: [
        // 싫어요 (Dislike) - RED
        Expanded(
          child: GestureDetector(
            onTap: () => controller.selectOption('dislike'),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                color: selectedValue == -1
                    ? AppColor.colorGlobalRed50
                    : AppColor.colorGlobalRed95,
                borderRadius: AppRadius.lgBorder,
                border: Border.all(
                  color: selectedValue == -1
                      ? AppColor.colorGlobalRed40
                      : AppColor.colorGlobalRed90,
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('👎', style: const TextStyle(fontSize: 48)),
                  const SizedBox(height: 12),
                  Text(
                    '싫어요',
                    style: AppTextStyles.headline1Bold.copyWith(
                      color: selectedValue == -1
                          ? AppColor.colorGlobalCommon100
                          : AppColor.colorGlobalRed50,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(width: 16),

        // 좋아요 (Like) - BLUE
        Expanded(
          child: GestureDetector(
            onTap: () => controller.selectOption('like'),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                color: selectedValue == 1
                    ? AppColor.colorGlobalBlue50
                    : AppColor.colorGlobalBlue95,
                borderRadius: AppRadius.lgBorder,
                border: Border.all(
                  color: selectedValue == 1
                      ? AppColor.colorGlobalBlue40
                      : AppColor.colorGlobalBlue90,
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('👍', style: const TextStyle(fontSize: 48)),
                  const SizedBox(height: 12),
                  Text(
                    '좋아요',
                    style: AppTextStyles.headline1Bold.copyWith(
                      color: selectedValue == 1
                          ? AppColor.colorGlobalCommon100
                          : AppColor.colorGlobalBlue50,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Build image grid for equipment selection (2 columns)
  /// Per Figma: Grid shows 5 equipment options, "잘 모르겠어요" is a separate link below
  Widget _buildImageGrid(SurveyQuestionModel question) {
    final isUnknownSelected = controller.isOptionSelected('unknown');

    return Column(
      children: [
        // Equipment grid (5 options)
        GridView.count(
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
        ),

        // "잘 모르겠어요" link below the grid (per Figma)
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () => controller.selectOption('unknown'),
          child: Text(
            '잘 모르겠어요',
            style: AppTextStyles.body2NormalMedium.copyWith(
              color: isUnknownSelected
                  ? AppColor.primaryNormal
                  : AppColor.labelAssistive,
              decoration: TextDecoration.underline,
              decorationColor: isUnknownSelected
                  ? AppColor.primaryNormal
                  : AppColor.labelAssistive,
            ),
          ),
        ),
      ],
    );
  }
}

/// Widget for a single multi-rating item in the survey
/// Displays question, description, and rating buttons
class _MultiRatingItemWidget extends StatelessWidget {
  final MultiRatingItem item;
  final int? selectedValue; // -1: dislike, 0: neutral, 1: like
  final ValueChanged<int> onValueChanged;

  const _MultiRatingItemWidget({
    required this.item,
    required this.selectedValue,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.backgroundNormalNormal,
        borderRadius: AppRadius.lgBorder,
        border: Border.all(color: AppColor.lineNormalNeutral, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question text
          Text(
            item.question,
            style: AppTextStyles.body1NormalMedium.copyWith(
              color: AppColor.labelNormal,
            ),
          ),
          const SizedBox(height: 4),

          // Description text
          if (item.description.isNotEmpty) ...[
            Text(
              item.description,
              style: AppTextStyles.caption1Regular.copyWith(
                color: AppColor.labelAlternative,
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Rating buttons row
          Row(
            children: [
              // Dislike button
              Expanded(
                child: _RatingButton(
                  emoji: '👎',
                  label: '싫어요',
                  isSelected: selectedValue == -1,
                  onTap: () => onValueChanged(-1),
                ),
              ),

              // Neutral button (only if hasNeutral is true)
              if (item.hasNeutral) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: _RatingButton(
                    emoji: '😐',
                    label: '보통',
                    isSelected: selectedValue == 0,
                    onTap: () => onValueChanged(0),
                  ),
                ),
              ],

              // Like button
              const SizedBox(width: 8),
              Expanded(
                child: _RatingButton(
                  emoji: '👍',
                  label: '좋아요',
                  isSelected: selectedValue == 1,
                  onTap: () => onValueChanged(1),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Individual rating button for multi-rating items
class _RatingButton extends StatelessWidget {
  final String emoji;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _RatingButton({
    required this.emoji,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColor.primaryLight
              : AppColor.componentFillNormal,
          borderRadius: AppRadius.mdBorder,
          border: Border.all(
            color: isSelected ? AppColor.primaryNormal : AppColor.transparent,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.caption1Medium.copyWith(
                color: isSelected
                    ? AppColor.primaryNormal
                    : AppColor.labelNormal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
