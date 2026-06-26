import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/modules/onboarding/survey_controller.dart';
import 'package:coflanet/widgets/buttons/primary_button.dart';

/// Survey Complete View — Figma POC `Survey_Complete` (1114:59786)
/// 완료 화면: 상단 중앙 안내 텍스트 + 240×240 마스코트 + 하단 CTA.
/// 캔버스 흰색 유지(온보딩 흐름 일관).
class SurveyCompleteView extends GetView<SurveyController> {
  const SurveyCompleteView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);

    return Scaffold(
      backgroundColor: colors.backgroundNormalNormal,
      appBar: AppBar(
        backgroundColor: AppColor.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          '취향 분석',
          style: AppTextStyles.headline2Bold.copyWith(color: colors.labelStrong),
        ),
        // Figma엔 back/우측 아이콘이 있으나, 완료는 offNamed로 진입하는
        // 종료 화면이라 뒤로 가기를 숨긴다(이전 화면으로 돌아갈 수 없음).
        leading: const SizedBox.shrink(),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              AssetPath.iconSettings,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                colors.labelNormal,
                BlendMode.srcIn,
              ),
            ),
            onPressed: () {
              // 설정 화면 연결 (추후 구현)
            },
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.space16,
                ),
                child: Column(
                  children: [
                    const Spacer(flex: 2),

                    // Figma 1114:59790 — 상단 중앙 안내 텍스트 (22 SemiBold)
                    Text(
                      '${controller.userName}님의\n커피 취향을 찾았어요!',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.heading1Bold.copyWith(
                        color: colors.labelNormal,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.space40),

                    // Figma 1114:59789 — 240×240 마스코트 일러스트
                    Image.asset(
                      AssetPath.charGift,
                      width: 240,
                      height: 240,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 240,
                        height: 240,
                        decoration: BoxDecoration(
                          color: colors.primaryLight,
                          borderRadius: AppRadius.xlBorder,
                        ),
                        child: Icon(
                          Icons.card_giftcard_rounded,
                          size: AppSpacing.space48,
                          color: colors.primaryNormal,
                        ),
                      ),
                    ),

                    const Spacer(flex: 3),
                  ],
                ),
              ),
            ),

            // Figma 1271:13527 — BottomSheet_CTA (px16, pill 버튼)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.space16,
              ),
              child: SafeArea(
                top: false,
                minimum: const EdgeInsets.only(bottom: AppSpacing.space24),
                child: PrimaryButton(
                  text: '내 취향 커피 만나러 가기',
                  onPressed: () => controller.viewResult(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
