import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/data/models/survey_result_model.dart';
import 'package:coflanet/modules/onboarding/result/widgets/flavor_description_row.dart';
import 'package:coflanet/modules/onboarding/result/widgets/recommendation_card.dart';
import 'package:coflanet/modules/onboarding/result/widgets/recommendation_like_button.dart';
import 'package:coflanet/modules/onboarding/result/widgets/result_banner.dart';
import 'package:coflanet/modules/onboarding/result/widgets/result_bottom_links.dart';
import 'package:coflanet/modules/onboarding/result/widgets/taste_profile_grid.dart';
import 'package:coflanet/modules/onboarding/survey_controller.dart';
import 'package:coflanet/widgets/navigation/app_bottom_bar.dart';
import 'package:coflanet/widgets/typography/section_title.dart';

/// 설문 결과 화면 — 취향 배너 / 맛 프로필 / 향미 설명 / 추천 원두 / 하단 CTA.
///
/// 섹션 UI 는 result/widgets/ 로 분리. 반응형 구독(Obx)은 이 View 에 잔류:
/// - 추천 카드: 카드 단위 Obx (isBeanSelected) + 좋아요 버튼만 별도 Obx (중첩 입자 보존)
/// - 하단 CTA: selectedBeanCount 구독
/// surveyResult 는 결과 화면 진입 후 불변이라 Obx 없이 1회 read 한다.
/// [스펙 미확정] 추천 목록 비동기 갱신 도입 시 Obx 승격 필요.
class SurveyResultView extends GetView<SurveyController> {
  const SurveyResultView({super.key});

  @override
  Widget build(BuildContext context) {
    final result = controller.surveyResult;

    return Scaffold(
      backgroundColor: AppColor.backgroundNormalNormal,
      appBar: AppBar(
        backgroundColor: AppColor.backgroundNormalNormal,
        surfaceTintColor: AppColor.backgroundNormalNormal,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            AssetPath.iconArrowBack,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              AppColor.labelNormal,
              BlendMode.srcIn,
            ),
          ),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text(
          '나의 커피 취향',
          style: AppTextStyles.headline1Bold.copyWith(
            color: AppColor.labelNormal,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // ── 보라 그라디언트 배너 ──
          SliverToBoxAdapter(
            child: ResultBanner(
              userName: controller.userName,
              description: result?.coffeeTypeDescription ?? '',
            ),
          ),

          // ── 맛 프로필 4타일 그리드 ──
          if (result != null)
            SliverToBoxAdapter(
              child: TasteProfileGrid(profile: result.tasteProfile),
            ),

          // ── 향미 설명 ──
          SliverToBoxAdapter(child: _buildFlavorDescriptions(result)),

          // ── 구분선 ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Divider(height: 1, color: AppColor.lineNormalNeutral),
            ),
          ),

          // ── 추천 원두 ──
          SliverToBoxAdapter(child: _buildRecommendationsSection(result)),

          // ── 하단 액션 링크 ──
          SliverToBoxAdapter(
            child: ResultBottomLinks(
              // [백엔드 API 연동 대기] 추천 원두 전체 목록
              onMoreTap: () {},
              onRetakeTap: () => controller.startSurvey(),
            ),
          ),

          // CTA 바에 가리지 않도록 하단 여백
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
      bottomNavigationBar: _buildBottomCTA(),
    );
  }

  /// 향미 설명 리스트 — 비어 있으면 미표시
  Widget _buildFlavorDescriptions(SurveyResultModel? result) {
    final descriptions = result?.flavorDescriptions ?? [];
    if (descriptions.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: descriptions
            .map((desc) => FlavorDescriptionRow(description: desc))
            .toList(),
      ),
    );
  }

  /// 추천 원두 섹션 — 헤더 + 추천 카드 리스트
  Widget _buildRecommendationsSection(SurveyResultModel? result) {
    final recommendations = result?.recommendations ?? [];
    if (recommendations.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
            title: '추천 원두',
            titleStyle: AppTextStyles.headline1Bold.copyWith(
              color: AppColor.labelNormal,
            ),
            subtitle: '${controller.userName}님의 취향과 가까운 원두예요 🤗',
          ),
          const SizedBox(height: 20),
          ...recommendations.map(
            // 카드 단위 Obx — 해당 카드의 선택 상태만 구독.
            // 좋아요는 슬롯 내부의 별도 Obx 가 구독 (카드 전체 리빌드 방지).
            (rec) => Obx(
              () => RecommendationCard(
                recommendation: rec,
                isSelected: controller.isBeanSelected(rec.id),
                onTap: () => controller.toggleBeanSelection(rec.id),
                likeButton: Obx(
                  () => RecommendationLikeButton(
                    isLiked: controller.isBeanLiked(rec.id),
                    onTap: () => controller.toggleBeanLike(rec.id),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 하단 CTA — 선택 수 기반 활성화 (AppBottomBar 재사용, padding 원본 1:1)
  Widget _buildBottomCTA() {
    return Obx(() {
      final count = controller.selectedBeanCount;
      return AppBottomBar.primaryButton(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
        text: '총 $count개 원두 리스트 추가',
        isEnabled: count > 0,
        onPressed: count > 0 ? () => controller.completeOnboarding() : null,
      );
    });
  }
}
