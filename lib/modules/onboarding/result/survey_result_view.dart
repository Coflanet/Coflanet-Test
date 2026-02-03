import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/modules/onboarding/survey_controller.dart';
import 'package:coflanet/widgets/buttons/primary_button.dart';

class SurveyResultView extends GetView<SurveyController> {
  const SurveyResultView({super.key});

  @override
  Widget build(BuildContext context) {
    final result = controller.surveyResult;

    return Scaffold(
      backgroundColor: AppColor.backgroundNormalNormal,
      body: CustomScrollView(
        slivers: [
          // Hero section with result
          SliverToBoxAdapter(
            child: _buildHeroSection(result),
          ),

          // Taste profile
          SliverToBoxAdapter(
            child: _buildTasteProfile(result),
          ),

          // Recommendations
          SliverToBoxAdapter(
            child: _buildRecommendations(result),
          ),

          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildHeroSection(result) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColor.primaryNormal,
            AppColor.primaryStrong,
          ],
        ),
      ),
      child: Column(
        children: [
          // Close button
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => controller.completeOnboarding(),
            ),
          ),

          const SizedBox(height: 20),

          // User's coffee type badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${controller.userName}님의 커피 취향',
              style: AppTextStyles.label1NormalMedium.copyWith(
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Coffee type
          Text(
            result?.coffeeType ?? '밸런스파',
            style: AppTextStyles.display2Bold.copyWith(
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 16),

          // Description
          Text(
            result?.coffeeTypeDescription ?? '',
            textAlign: TextAlign.center,
            style: AppTextStyles.body2NormalRegular.copyWith(
              color: Colors.white.withOpacity(0.9),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasteProfile(result) {
    final profile = result?.tasteProfile;
    if (profile == null) return const SizedBox();

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '나의 맛 프로필',
            style: AppTextStyles.headline1Bold.copyWith(
              color: AppColor.labelNormal,
            ),
          ),

          const SizedBox(height: 20),

          // Taste bars
          _buildTasteBar('산미', profile.acidity),
          _buildTasteBar('단맛', profile.sweetness),
          _buildTasteBar('쓴맛', profile.bitterness),
          _buildTasteBar('바디감', profile.body),
          _buildTasteBar('향', profile.aroma),
        ],
      ),
    );
  }

  Widget _buildTasteBar(String label, int value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: AppTextStyles.label1NormalMedium.copyWith(
                color: AppColor.labelNormal,
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColor.lineNormalAlternative,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: value / 100,
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColor.primaryNormal,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 36,
            child: Text(
              '$value',
              style: AppTextStyles.label1NormalBold.copyWith(
                color: AppColor.primaryNormal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendations(result) {
    final recommendations = result?.recommendations ?? [];
    if (recommendations.isEmpty) return const SizedBox();

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '추천 원두',
            style: AppTextStyles.headline1Bold.copyWith(
              color: AppColor.labelNormal,
            ),
          ),

          const SizedBox(height: 16),

          ...recommendations.map((rec) => _buildRecommendationCard(rec)),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard(rec) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.backgroundNormalNormal,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.lineNormalNeutral),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Coffee icon placeholder
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColor.primaryLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.coffee,
                  color: AppColor.primaryNormal,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rec.name,
                      style: AppTextStyles.headline2Bold.copyWith(
                        color: AppColor.labelNormal,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${rec.origin} · ${rec.roastLevel}',
                      style: AppTextStyles.caption1Regular.copyWith(
                        color: AppColor.labelAlternative,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            rec.description,
            style: AppTextStyles.body2NormalRegular.copyWith(
              color: AppColor.labelAlternative,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColor.backgroundNormalNormal,
        boxShadow: AppShadows.shadowBlackHeavyBottom,
      ),
      child: SafeArea(
        child: PrimaryButton(
          text: '홈으로 가기',
          onPressed: () => controller.completeOnboarding(),
        ),
      ),
    );
  }
}
