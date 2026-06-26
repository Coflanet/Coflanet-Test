import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/data/models/survey_result_model.dart';
import 'package:coflanet/modules/onboarding/result/widgets/flavor_notes_list.dart';
import 'package:coflanet/modules/onboarding/result/widgets/recommendation_card.dart';
import 'package:coflanet/modules/onboarding/result/widgets/recommendation_like_button.dart';
import 'package:coflanet/modules/onboarding/result/widgets/result_banner.dart';
import 'package:coflanet/modules/onboarding/result/widgets/result_bottom_links.dart';
import 'package:coflanet/modules/onboarding/result/widgets/taste_profile_grid.dart';
import 'package:coflanet/modules/onboarding/survey_controller.dart';
import 'package:coflanet/widgets/buttons/primary_button.dart';
import 'package:coflanet/widgets/cards/card_section.dart';
import 'package:coflanet/widgets/navigation/app_bottom_bar.dart';

/// 설문 결과 화면 — Figma Survey_Result(POC `1114:59814`) 충실 재구성.
///
/// 검정 캔버스 + 통일 헤더 위에 카드가 떠 있는 iyumi 카드 시스템(coflanet-design-guide):
/// - Profile 카드(취향 배너 + 맛 프로필 + 향미 노트)
/// - Preference_List 카드(추천 원두 + 카드 리스트 + 더보기/링크)
/// - 하단 고정 CTA(검정 바 위 보라 pill)
///
/// ScreenScaffold 는 하단 고정 바 슬롯이 없어 캔버스/헤더를 동일 토큰으로 직접
/// 조립하고, 하단 CTA 는 Scaffold.bottomNavigationBar 로 고정한다.
///
/// 반응형 구독(Obx)은 이 View 에 잔류:
/// - 추천 카드: 카드 단위 Obx(isBeanSelected) + 좋아요 버튼만 별도 Obx
/// - 하단 CTA: selectedBeanCount 구독
class SurveyResultView extends GetView<SurveyController> {
  const SurveyResultView({super.key});

  @override
  Widget build(BuildContext context) {
    final result = controller.surveyResult;

    return Scaffold(
      backgroundColor: AppColor.staticBlack,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: AppSpacing.space20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (result != null) _buildProfileCard(context, result),
                    const SizedBox(height: AppSpacing.cardGap),
                    _buildPreferenceCard(context, result),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomCTA(),
    );
  }

  /// 통일 헤더 — 검정 캔버스 위(canvas 다크 스킴), 상단 마진 32, chevron + 타이틀.
  Widget _buildHeader() {
    final canvas = AppColorScheme.canvas;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.headerHorizontalPadding,
        AppSpacing.screenTopMargin,
        AppSpacing.headerHorizontalPadding,
        AppSpacing.md,
      ),
      child: Row(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Get.back(),
            child: Icon(Icons.chevron_left, color: canvas.labelNormal, size: 28),
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              '나의 커피 취향',
              style: AppTextStyles.title2Bold.copyWith(
                color: canvas.labelNormal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Profile 카드 — 취향 배너 + 맛 프로필 그리드 + 향미 노트. 표면 #F4F4F5, 패딩 16, gap 4.
  Widget _buildProfileCard(BuildContext context, SurveyResultModel result) {
    final colors = AppColorScheme.of(context);
    final descriptions = result.flavorDescriptions;
    return CardSection(
      color: colors.surfaceCardStrong,
      padding: const EdgeInsets.all(AppSpacing.space16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ResultBanner(
            userName: controller.userName,
            description: result.coffeeTypeDescription,
          ),
          const SizedBox(height: AppSpacing.cardGap),
          TasteProfileGrid(profile: result.tasteProfile),
          if (descriptions.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.cardGap),
            FlavorNotesList(descriptions: descriptions),
          ],
        ],
      ),
    );
  }

  /// Preference_List 카드 — 추천 원두 헤더 + 카드 리스트 + 더보기/링크. 표면 #F4F4F5.
  Widget _buildPreferenceCard(BuildContext context, SurveyResultModel? result) {
    final colors = AppColorScheme.of(context);
    final recommendations = result?.recommendations ?? [];

    return CardSection(
      color: colors.surfaceCardStrong,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space16,
        vertical: AppSpacing.space32,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 타이틀 블록 (px8 인셋)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '추천 원두',
                  style: AppTextStyles.title3Bold.copyWith(
                    color: colors.labelNormal,
                  ),
                ),
                const SizedBox(height: AppSpacing.space4),
                Text(
                  '${controller.userName}님의 취향과 가까운 원두예요 🤗',
                  style: AppTextStyles.body1NormalRegular.copyWith(
                    color: colors.labelNeutral,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.space20),

          // 카드 리스트 (gap 8)
          for (int i = 0; i < recommendations.length; i++) ...[
            if (i > 0) const SizedBox(height: AppSpacing.space8),
            // 카드 단위 Obx — 해당 카드의 선택 상태만 구독.
            Obx(
              () => RecommendationCard(
                recommendation: recommendations[i],
                isSelected: controller.isBeanSelected(recommendations[i].id),
                onTap: () =>
                    controller.toggleBeanSelection(recommendations[i].id),
                likeButton: Obx(
                  () => RecommendationLikeButton(
                    isLiked: controller.isBeanLiked(recommendations[i].id),
                    onTap: () =>
                        controller.toggleBeanLike(recommendations[i].id),
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.space20),

          // 더보기 + 링크
          ResultBottomLinks(
            // [백엔드 API 연동 대기] 추천 원두 전체 목록
            onMoreTap: () {},
            onRetakeTap: () => controller.startSurvey(),
            // 원두 선택 없이 홈으로 — 선택 0개면 원두 저장 생략
            onSkipTap: () => controller.completeOnboarding(),
          ),
        ],
      ),
    );
  }

  /// 하단 CTA — 검정 바 위 보라 pill. 선택 수 기반 활성화.
  Widget _buildBottomCTA() {
    return Obx(() {
      final count = controller.selectedBeanCount;
      return AppBottomBar(
        backgroundColor: AppColor.staticBlack,
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.space20,
          AppSpacing.space12,
          AppSpacing.space20,
          AppSpacing.space12,
        ),
        child: PrimaryButton(
          text: '총 $count개 원두 목록 추가',
          isEnabled: count > 0,
          onPressed: count > 0 ? () => controller.completeOnboarding() : null,
        ),
      );
    });
  }
}
