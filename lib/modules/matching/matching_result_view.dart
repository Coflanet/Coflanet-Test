import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/modules/matching/matching_controller.dart';
import 'package:coflanet/modules/matching/widgets/matching_hero_card.dart';
import 'package:coflanet/modules/matching/widgets/matching_recommendations_section.dart';
import 'package:coflanet/modules/matching/widgets/matching_taste_profile_card.dart';
import 'package:coflanet/widgets/buttons/primary_button.dart';
import 'package:coflanet/widgets/navigation/app_bottom_bar.dart';

/// 매칭 결과 화면 — 히어로 카드 + 맛 프로필 + 추천 원두 (섹션 위젯은 widgets/ 분리).
///
/// 반응형 getter(isLoading/hasResult/surveyResult/userName)는 body 의 Obx
/// 클로저 안에서 평가해 값으로 주입한다. bottomNavigationBar 는 hasResult 만
/// 구독하는 별도 Obx 경계 (원본 구조 보존).
class MatchingResultView extends GetView<MatchingController> {
  const MatchingResultView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);
    return Scaffold(
      backgroundColor: colors.backgroundNormalAlternative,
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!controller.hasResult) {
          return _buildNoResultState(colors);
        }

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // App bar with back button
            SliverAppBar(
              backgroundColor: AppColor.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colors.backgroundNormalNormal,
                    borderRadius: AppRadius.lgBorder,
                    boxShadow: AppShadows.shadowBlackNormal,
                  ),
                  child: SvgPicture.asset(
                    AssetPath.iconArrowBack,
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      colors.labelNormal,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                onPressed: () => controller.goBack(),
              ),
              pinned: false,
              floating: true,
            ),

            // 히어로 카드 — Rx getter 는 Obx 클로저 안에서 평가해 주입
            SliverToBoxAdapter(
              child: MatchingHeroCard(
                userName: controller.userName,
                coffeeType: controller.surveyResult!.coffeeType,
                description: controller.surveyResult!.coffeeTypeDescription,
              ),
            ),

            // 맛 프로필 카드 (tasteProfile 은 모델의 required 비-null 필드)
            SliverToBoxAdapter(
              child: MatchingTasteProfileCard(
                profile: controller.surveyResult!.tasteProfile,
              ),
            ),

            // 추천 원두 섹션 (isEmpty 가드는 위젯 내부)
            SliverToBoxAdapter(
              child: MatchingRecommendationsSection(
                recommendations: controller.surveyResult!.recommendations,
              ),
            ),

            // Bottom spacing
            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        );
      }),
      bottomNavigationBar: Obx(() {
        if (!controller.hasResult) return const SizedBox.shrink();
        return _buildBottomBar();
      }),
    );
  }

  Widget _buildNoResultState(AppColorScheme colors) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColor.colorGlobalOrange95,
                borderRadius: AppRadius.fullBorder,
              ),
              child: Icon(
                Icons.coffee_outlined,
                size: 56,
                color: AppColor.colorGlobalOrange50,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              '아직 취향 테스트를 하지 않으셨네요',
              style: AppTextStyles.headline1Bold.copyWith(
                color: colors.labelNormal,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              '간단한 설문으로 나만의 커피 취향을\n찾아보세요!',
              style: AppTextStyles.body1NormalRegular.copyWith(
                color: colors.labelAlternative,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            PrimaryButton(
              text: '취향 테스트 하기',
              onPressed: () => controller.retakeSurvey(),
              width: 200,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return AppBottomBar.twoButtons(
      secondaryText: '다시 테스트하기',
      onSecondary: () => controller.retakeSurvey(),
      primaryText: '홈으로',
      onPrimary: () => controller.goBack(),
    );
  }
}
