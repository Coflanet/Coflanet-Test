import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/data/models/survey_question_model.dart';
import 'package:coflanet/modules/onboarding/survey_controller.dart';
import 'package:coflanet/modules/onboarding/widgets/survey_checkbox_item.dart';
import 'package:coflanet/modules/onboarding/widgets/survey_equipment_grid_item.dart';
import 'package:coflanet/modules/onboarding/widgets/survey_multi_rating_item.dart';
import 'package:coflanet/modules/onboarding/widgets/survey_progress_bar.dart';
import 'package:coflanet/modules/onboarding/widgets/survey_rating_row.dart';
import 'package:coflanet/widgets/buttons/primary_button.dart';

/// 설문 질문 화면 — 진행바 / 질문 / 유형별 옵션 / 하단 버튼.
///
/// 옵션 UI 는 widgets/ 로 분리 (SurveyRatingRow, SurveyMultiRatingItem,
/// SurveyEquipmentGridItem, SurveyCheckboxItem).
///
/// 반응성: L45 의 `Obx(() => _buildContent())` 가 currentQuestion 과
/// answers(선택 상태) 를 함께 구독한다. 선택 상태 read
/// (_getSelectedRatingValue, isOptionSelected, getMultiRating) 는
/// 반드시 이 Obx 클로저 안(= _buildContent 호출 경로)에서 실행되어야 한다.
class SurveyQuestionView extends GetView<SurveyController> {
  const SurveyQuestionView({super.key});

  // Figma 사양: Pretendard SemiBold 22 / lineHeight 1.36 / letterSpacing -0.4268
  // 색상은 Label/strong (#000000) 토큰 매핑
  // Auth 카테고리에서 통일한 페이지 헤더 스타일과 동일
  TextStyle _screenHeaderStyle(AppColorScheme colors) =>
      AppTextStyles.heading1Bold.copyWith(
        fontWeight: FontWeight.w600,
        height: 1.36,
        letterSpacing: -0.4268,
        color: colors.labelStrong,
      );

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);

    return Scaffold(
      backgroundColor: colors.backgroundNormalNormal,
      appBar: _buildAppBar(colors),
      body: SafeArea(
        child: Column(
          children: [
            // AppBar 아래 진행바 — 전체 설문 진행률(현재/총 질문)
            // Figma: 인디케이터는 전 화면 단조 증가(섹션 리셋 없음).
            Obx(
              () => Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.space20,
                ),
                child: SurveyProgressIndicator(progress: controller.progress),
              ),
            ),
            const SizedBox(height: AppSpacing.space8),
            Expanded(child: Obx(() => _buildContent(colors))),
            _buildBottomButton(colors),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(AppColorScheme colors) {
    return AppBar(
      backgroundColor: AppColor.transparent,
      elevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset(
          AssetPath.iconArrowBack,
          width: 24,
          height: 24,
          colorFilter: ColorFilter.mode(colors.labelNormal, BlendMode.srcIn),
        ),
        onPressed: () => controller.previousQuestion(),
      ),
      centerTitle: true,
      title: Obx(
        () => Text(
          controller.currentStepTitle,
          style: AppTextStyles.headline2Bold.copyWith(
            color: colors.labelNormal,
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
            colorFilter: ColorFilter.mode(colors.labelNormal, BlendMode.srcIn),
          ),
          onPressed: () => controller.skipSurvey(),
        ),
      ],
    );
  }

  Widget _buildContent(AppColorScheme colors) {
    final question = controller.currentQuestion;
    if (question == null) return const SizedBox();

    // rating 질문은 옵션을 세로 중앙 부근에 배치
    final isRatingQuestion = question.questionType == SurveyQuestionType.rating;

    if (isRatingQuestion) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space20),
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.space24),
            // 질문 텍스트 (상단)
            Align(
              alignment: Alignment.centerLeft,
              child: Text(question.question, style: _screenHeaderStyle(colors)),
            ),
            if (question.description.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.space8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  question.description,
                  style: AppTextStyles.body2NormalRegular.copyWith(
                    color: colors.labelAlternative,
                  ),
                ),
              ),
            ],
            // rating 버튼은 중앙보다 약간 위 (Figma)
            Expanded(
              child: Align(
                alignment: const Alignment(0, -0.4),
                child: _buildOptionsForType(colors, question),
              ),
            ),
          ],
        ),
      );
    }

    // 그 외 질문 유형은 스크롤 레이아웃
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.space24),

          // 질문 텍스트
          Text(question.question, style: _screenHeaderStyle(colors)),

          if (question.description.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.space8),
            Text(
              question.description,
              style: AppTextStyles.body2NormalRegular.copyWith(
                color: colors.labelAlternative,
              ),
            ),
          ],

          const SizedBox(height: AppSpacing.space32),

          // 질문 유형별 옵션 렌더링
          _buildOptionsForType(colors, question),

          const SizedBox(height: AppSpacing.space24),
        ],
      ),
    );
  }

  Widget _buildBottomButton(AppColorScheme colors) {
    return Obx(() {
      // 섹션 2-3 (step 2-9): rating 질문 — 버튼 없음, 자동 진행
      if (controller.currentStep >= 2) {
        return const SizedBox.shrink();
      }

      // 섹션 1 (step 0-1): 체크박스 질문 — 버튼 표시
      final buttonText = '선택했어요';

      return Container(
        // Figma BottomSheet_CTA: 좌우 16 패딩 + 풀폭 pill 버튼
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space16,
          vertical: AppSpacing.space16,
        ),
        decoration: BoxDecoration(
          color: colors.backgroundNormalNormal,
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

  /// 현재 답변에서 선택된 rating 값 추출 (-1/0/1)
  /// 주의: answers(.obs) 를 읽으므로 반드시 Obx 클로저 안에서 호출
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

  /// 질문 유형별 옵션 렌더링
  Widget _buildOptionsForType(
    AppColorScheme colors,
    SurveyQuestionModel question,
  ) {
    switch (question.questionType) {
      case SurveyQuestionType.checkbox:
        // 텍스트 전용 체크박스 (step 0)
        return Column(
          children: question.options
              .map(
                (option) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.space8),
                  child: SurveyCheckboxItem(
                    label: option.label,
                    icon: option.icon,
                    description: option.description,
                    isSelected: controller.isOptionSelected(option.id),
                    onTap: () => controller.selectOption(option.id),
                    showIcon: false,
                  ),
                ),
              )
              .toList(),
        );

      case SurveyQuestionType.checkboxWithIcon:
        // 이모지 + 라벨 + 설명 체크박스
        return Column(
          children: question.options
              .map(
                (option) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.space8),
                  child: SurveyCheckboxItem(
                    label: option.label,
                    icon: option.icon,
                    description: option.description,
                    isSelected: controller.isOptionSelected(option.id),
                    onTap: () => controller.selectOption(option.id),
                    showIcon: true,
                  ),
                ),
              )
              .toList(),
        );

      case SurveyQuestionType.rating:
        // 3개 옵션 (기본 맛 취향) → ternary / 2개 옵션 (특성 향미) → binary
        return SurveyRatingRow(
          hasNeutral: question.options.length == 3,
          selectedValue: _getSelectedRatingValue(),
          onSelect: controller.selectOption,
        );

      case SurveyQuestionType.imageGrid:
        // 추출 기구 선택 그리드
        return _buildImageGrid(colors, question);

      case SurveyQuestionType.multiRating:
        // 한 화면에 여러 레이팅 항목
        return _buildMultiRating(question);
    }
  }

  /// 멀티레이팅 항목 리스트 — 맛/향 선호
  Widget _buildMultiRating(SurveyQuestionModel question) {
    final items = question.multiRatingItems;
    if (items == null || items.isEmpty) return const SizedBox();

    return Column(
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.space16),
          child: SurveyMultiRatingItem(
            item: item,
            selectedValue: controller.getMultiRating(item.id),
            onValueChanged: (value) =>
                controller.setMultiRating(item.id, value),
          ),
        );
      }).toList(),
    );
  }

  /// 추출 기구 선택 그리드 (2열) + "잘 모르겠어요" 링크
  Widget _buildImageGrid(AppColorScheme colors, SurveyQuestionModel question) {
    final isUnknownSelected = controller.isOptionSelected('unknown');

    return Column(
      children: [
        // 기구 그리드 (5개 옵션) — Figma: 정사각 카드(156×156) 2열, 간격 8
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: AppSpacing.space8,
          crossAxisSpacing: AppSpacing.space8,
          childAspectRatio: 1.0,
          children: question.options.map((option) {
            return SurveyEquipmentGridItem(
              label: option.label,
              isSelected: controller.isOptionSelected(option.id),
              onTap: () => controller.selectOption(option.id),
            );
          }).toList(),
        ),

        // "잘 모르겠어요" 링크 (그리드 아래, Figma)
        const SizedBox(height: AppSpacing.space20),
        GestureDetector(
          onTap: () => controller.selectOption('unknown'),
          child: Text(
            '잘 모르겠어요',
            style: AppTextStyles.body2NormalMedium.copyWith(
              color: isUnknownSelected
                  ? colors.primaryNormal
                  : colors.labelAssistive,
              decoration: TextDecoration.underline,
              decorationColor: isUnknownSelected
                  ? colors.primaryNormal
                  : colors.labelAssistive,
            ),
          ),
        ),
      ],
    );
  }
}
