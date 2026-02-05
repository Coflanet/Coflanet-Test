import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/modules/matching/matching_controller.dart';
import 'package:coflanet/widgets/buttons/primary_button.dart';

class MatchingResultView extends GetView<MatchingController> {
  const MatchingResultView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundNormalAlternative,
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!controller.hasResult) {
          return _buildNoResultState();
        }

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // App bar with back button
            SliverAppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColor.backgroundNormalNormal,
                    borderRadius: AppRadius.lgBorder,
                    boxShadow: AppShadows.shadowBlackNormal,
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: AppColor.labelNormal,
                    size: 18,
                  ),
                ),
                onPressed: () => controller.goBack(),
              ),
              pinned: false,
              floating: true,
            ),

            // Hero card with coffee type
            SliverToBoxAdapter(child: _buildHeroCard()),

            // Taste profile section
            SliverToBoxAdapter(child: _buildTasteProfileSection()),

            // Recommendations section
            SliverToBoxAdapter(child: _buildRecommendationsSection()),

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

  Widget _buildNoResultState() {
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
                color: AppColor.labelNormal,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              '간단한 설문으로 나만의 커피 취향을\n찾아보세요!',
              style: AppTextStyles.body1NormalRegular.copyWith(
                color: AppColor.labelAlternative,
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

  Widget _buildHeroCard() {
    final result = controller.surveyResult!;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColor.colorGlobalOrange50, AppColor.colorGlobalOrange70],
        ),
        borderRadius: AppRadius.xxxlBorder,
        boxShadow: [
          BoxShadow(
            color: AppColor.colorGlobalOrange50.withOpacity(0.3),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background pattern
          Positioned(
            right: -40,
            top: -40,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.staticLabelWhiteStrong.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            right: 20,
            bottom: -30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.staticLabelWhiteStrong.withOpacity(0.08),
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.staticLabelWhiteStrong.withOpacity(0.2),
                    borderRadius: AppRadius.xxlBorder,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.person_rounded,
                        color: AppColor.staticLabelWhiteStrong,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${controller.userName}님의 커피 매칭',
                        style: AppTextStyles.caption1Medium.copyWith(
                          color: AppColor.staticLabelWhiteStrong,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Coffee type
                Text(
                  result.coffeeType,
                  style: AppTextStyles.display2Bold.copyWith(
                    color: AppColor.staticLabelWhiteStrong,
                    letterSpacing: -0.5,
                  ),
                ),

                const SizedBox(height: 12),

                // Description
                Text(
                  result.coffeeTypeDescription,
                  style: AppTextStyles.body2NormalRegular.copyWith(
                    color: AppColor.staticLabelWhiteStrong.withOpacity(0.9),
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasteProfileSection() {
    final profile = controller.surveyResult!.tasteProfile;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColor.backgroundNormalNormal,
        borderRadius: AppRadius.xxlBorder,
        boxShadow: AppShadows.shadowBlackEmphasize,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColor.primaryLight,
                  borderRadius: AppRadius.lgBorder,
                ),
                child: Icon(
                  Icons.equalizer_rounded,
                  color: AppColor.primaryNormal,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Text(
                '맛 프로필',
                style: AppTextStyles.headline1Bold.copyWith(
                  color: AppColor.labelNormal,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Taste bars with animation
          _buildAnimatedTasteBar(
            '산미',
            profile.acidity,
            AppColor.colorGlobalYellow50,
          ),
          _buildAnimatedTasteBar(
            '단맛',
            profile.sweetness,
            AppColor.colorGlobalPink50,
          ),
          _buildAnimatedTasteBar(
            '쓴맛',
            profile.bitterness,
            AppColor.colorGlobalOrange50,
          ),
          _buildAnimatedTasteBar(
            '바디감',
            profile.body,
            AppColor.colorGlobalViolet50,
          ),
          _buildAnimatedTasteBar(
            '향',
            profile.aroma,
            AppColor.colorGlobalGreen50,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedTasteBar(
    String label,
    int value,
    Color color, {
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: AppTextStyles.label1NormalMedium.copyWith(
                  color: AppColor.labelNormal,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColor.staticLabelWhiteStrong.withOpacity(0.2),
                  borderRadius: AppRadius.xxlBorder,
                ),
                child: Text(
                  '$value',
                  style: AppTextStyles.label1NormalBold.copyWith(color: color),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Stack(
            children: [
              // Background bar
              Container(
                height: 10,
                decoration: BoxDecoration(
                  color: AppColor.lineNormalAlternative,
                  borderRadius: AppRadius.smBorder,
                ),
              ),
              // Value bar with gradient
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: value / 100),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutCubic,
                builder: (context, animValue, child) {
                  return FractionallySizedBox(
                    widthFactor: animValue,
                    child: Container(
                      height: 10,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [color.withOpacity(0.7), color],
                        ),
                        borderRadius: AppRadius.smBorder,
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationsSection() {
    final recommendations = controller.surveyResult!.recommendations;
    if (recommendations.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColor.colorGlobalOrange95,
                  borderRadius: AppRadius.lgBorder,
                ),
                child: Icon(
                  Icons.coffee_rounded,
                  color: AppColor.colorGlobalOrange50,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Text(
                '추천 원두',
                style: AppTextStyles.headline1Bold.copyWith(
                  color: AppColor.labelNormal,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Horizontal scrolling recommendations
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: recommendations.length,
            itemBuilder: (context, index) {
              final rec = recommendations[index];
              return _buildRecommendationCard(rec, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendationCard(rec, int index) {
    final colors = [
      AppColor.colorGlobalOrange50,
      AppColor.colorGlobalViolet50,
      AppColor.colorGlobalCyan50,
      AppColor.colorGlobalGreen50,
    ];
    final color = colors[index % colors.length];

    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: AppColor.backgroundNormalNormal,
        borderRadius: AppRadius.xxlBorder,
        boxShadow: AppShadows.shadowBlackEmphasize,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon
          Container(
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color.withOpacity(0.8), color],
              ),
              borderRadius: AppRadius.top(AppRadius.xxl),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -20,
                  top: -20,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColor.staticLabelWhiteStrong.withOpacity(0.1),
                    ),
                  ),
                ),
                Center(
                  child: Icon(
                    Icons.coffee,
                    color: AppColor.staticLabelWhiteStrong,
                    size: 36,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rec.name,
                    style: AppTextStyles.headline2Bold.copyWith(
                      color: AppColor.labelNormal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${rec.origin} \u00B7 ${rec.roastLevel}',
                    style: AppTextStyles.caption1Regular.copyWith(
                      color: AppColor.labelAlternative,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: AppRadius.mdBorder,
                    ),
                    child: Text(
                      '자세히 보기',
                      style: AppTextStyles.caption1Medium.copyWith(
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: BoxDecoration(
        color: AppColor.backgroundNormalNormal,
        boxShadow: AppShadows.shadowBlackHeavyBottom,
        borderRadius: AppRadius.top(AppRadius.xxxl),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Secondary button
            Expanded(
              child: GestureDetector(
                onTap: () => controller.retakeSurvey(),
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColor.componentFillNormal,
                    borderRadius: AppRadius.lgBorder,
                  ),
                  child: Center(
                    child: Text(
                      '다시 테스트하기',
                      style: AppTextStyles.headline2Medium.copyWith(
                        color: AppColor.labelNormal,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Primary button
            Expanded(
              child: PrimaryButton(
                text: '홈으로',
                onPressed: () => controller.goBack(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
