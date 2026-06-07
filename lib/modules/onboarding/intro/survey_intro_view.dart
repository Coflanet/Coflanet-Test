import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/modules/onboarding/survey_controller.dart';
import 'package:coflanet/widgets/buttons/primary_button.dart';

/// Survey Intro View - Figma: Survey_intro.png
/// 환영 화면 + "나중에 찾기 | 취향 찾으러 가기" 2개 버튼
class SurveyIntroView extends GetView<SurveyController> {
  const SurveyIntroView({super.key});

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
      appBar: AppBar(
        backgroundColor: AppColor.transparent,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            AssetPath.iconArrowBack,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              colors.labelNormal,
              BlendMode.srcIn,
            ),
          ),
          tooltip: '뒤로 가기',
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              // Figma: "[이름]님의 취향을 찾으러 가볼까요?"
              Text(
                '${controller.userName}님의 취향을',
                style: _screenHeaderStyle(colors),
              ),
              Text('찾으러 가볼까요?', style: _screenHeaderStyle(colors)),
              const SizedBox(height: 16),

              // 안내 문구
              Text(
                '간단한 설문으로 나에게 맞는 커피를 찾아드려요',
                style: AppTextStyles.body1NormalRegular.copyWith(
                  color: colors.labelAlternative,
                ),
              ),

              const Spacer(),

              // Figma: 캐릭터 일러스트
              Center(
                child: Image.asset(
                  AssetPath.charDrinkCoffee,
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) =>
                      const Text('☕', style: TextStyle(fontSize: 80)),
                ),
              ),

              const Spacer(),

              // Figma: "취향 찾으러 가기" CTA 버튼
              PrimaryButton(
                text: '취향 찾으러 가기',
                onPressed: () => controller.startSurvey(),
              ),
              const SizedBox(height: 12),

              // Figma: "나중에 찾기" 링크
              Center(
                child: GestureDetector(
                  onTap: () => controller.skipSurvey(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      '나중에 찾기',
                      style: AppTextStyles.body2NormalMedium.copyWith(
                        color: colors.labelAssistive,
                        decoration: TextDecoration.underline,
                        decorationColor: colors.labelAssistive,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 34),
            ],
          ),
        ),
      ),
    );
  }
}
