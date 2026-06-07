import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/modules/profile/my_taste_controller.dart';
import 'package:coflanet/modules/profile/widgets/taste_action_tile.dart';
import 'package:coflanet/modules/profile/widgets/taste_summary_card.dart';
import 'package:coflanet/modules/profile/widgets/taste_vertical_bar_chart.dart';
import 'package:coflanet/widgets/buttons/primary_button.dart';

class MyTasteView extends GetView<MyTasteController> {
  const MyTasteView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);
    return Scaffold(
      backgroundColor: colors.backgroundNormalNormal,
      appBar: _buildAppBar(colors),
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!controller.hasResult) {
          return _buildNoResultState(colors);
        }

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // 취향 요약 카드 — Rx getter 는 Obx 클로저 안에서 평가해 주입
              TasteSummaryCard(
                userName: controller.userName,
                coffeeType: controller.surveyResult!.coffeeType,
                description: controller.surveyResult!.coffeeTypeDescription,
                onViewDetail: () => controller.viewMatchingResult(),
              ),

              // 맛 프로필 차트 (모델 통째 주입 — null 가드는 위젯 내부)
              TasteVerticalBarChart(profile: controller.tasteProfile),

              // 액션 버튼
              _buildActionButtons(colors),

              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }

  PreferredSizeWidget _buildAppBar(AppColorScheme colors) {
    return AppBar(
      backgroundColor: colors.backgroundNormalNormal,
      elevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset(
          AssetPath.iconArrowBack,
          width: 24,
          height: 24,
          colorFilter: ColorFilter.mode(colors.labelNormal, BlendMode.srcIn),
        ),
        onPressed: () => controller.goBack(),
      ),
      title: Text(
        '내 취향',
        style: AppTextStyles.headline1Bold.copyWith(color: colors.labelNormal),
      ),
      centerTitle: true,
    );
  }

  Widget _buildNoResultState(AppColorScheme colors) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated coffee bean illustration
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 800),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColor.colorGlobalOrange90,
                          AppColor.colorGlobalOrange95,
                        ],
                      ),
                      borderRadius: AppRadius.fullBorder,
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.colorGlobalOrange50.withValues(
                            alpha: 0.2,
                          ),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.favorite_border_rounded,
                      size: 64,
                      color: AppColor.colorGlobalOrange50,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
            Text(
              '아직 취향을 설정하지 않으셨어요',
              style: AppTextStyles.headline1Bold.copyWith(
                color: colors.labelNormal,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              '간단한 테스트로 나만의 커피 취향을\n발견해보세요',
              style: AppTextStyles.body1NormalRegular.copyWith(
                color: colors.labelAlternative,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            PrimaryButton(
              text: '취향 테스트 시작하기',
              onPressed: () => controller.retakeSurvey(),
              width: 220,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(AppColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // 매칭 결과 자세히 보기 — 오렌지는 브랜드 의미색 (raw 토큰 유지)
          TasteActionTile(
            icon: Icons.coffee_rounded,
            iconColor: AppColor.colorGlobalOrange50,
            iconBgColor: AppColor.colorGlobalOrange95,
            title: '매칭 결과 자세히 보기',
            subtitle: '추천 원두와 상세 분석 확인',
            onTap: () => controller.viewMatchingResult(),
          ),

          const SizedBox(height: 12),

          // 취향 다시 설정하기
          TasteActionTile(
            icon: Icons.refresh_rounded,
            iconColor: colors.primaryNormal,
            iconBgColor: colors.primaryLight,
            title: '취향 다시 설정하기',
            subtitle: '새로운 취향 테스트로 업데이트',
            onTap: () => controller.retakeSurvey(),
          ),
        ],
      ),
    );
  }
}
