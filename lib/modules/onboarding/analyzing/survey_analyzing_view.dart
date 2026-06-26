import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/modules/onboarding/survey_controller.dart';

/// Survey Analyzing View — Figma POC `Survey_Analyzing` (1114:59780)
/// 분석 중 화면: 상단 중앙 안내 텍스트 + 그 아래 160×160 일러스트.
/// 캔버스 흰색 유지(온보딩 흐름 일관). Figma엔 로딩 닷이 없어 제거.
class SurveyAnalyzingView extends GetView<SurveyController> {
  const SurveyAnalyzingView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);

    // Start analysis when view is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.analyzeSurvey();
    });

    return Scaffold(
      backgroundColor: colors.backgroundNormalNormal,
      // Figma엔 상단 내비게이션 내용이 없어(분석 중) AppBar 없이 구성.
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(flex: 2),

            // Figma 1114:59783 — 상단 중앙 안내 텍스트 (22 SemiBold)
            // width 풀폭 강제 → textAlign.center 가 화면 가로 중앙 정렬을 보장
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.space16,
              ),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  '${controller.userName}님의\n취향을 분석하고 있어요.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.heading1Bold.copyWith(
                    color: colors.labelNormal,
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.space40),

            // Figma 1114:59782 — 160×160 일러스트
            Image.asset(
              AssetPath.charDrinkCoffee,
              width: 160,
              height: 160,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  color: colors.componentFillNormal,
                  borderRadius: AppRadius.xlBorder,
                ),
                child: Icon(
                  Icons.image_outlined,
                  size: AppSpacing.space48,
                  color: colors.labelAssistive,
                ),
              ),
            ),

            const Spacer(flex: 5),
          ],
        ),
      ),
    );
  }
}
