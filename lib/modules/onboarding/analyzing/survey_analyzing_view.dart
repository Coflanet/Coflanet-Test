import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/modules/onboarding/survey_controller.dart';

class SurveyAnalyzingView extends GetView<SurveyController> {
  const SurveyAnalyzingView({super.key});

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

    // Start analysis when view is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.analyzeSurvey();
    });

    return Scaffold(
      backgroundColor: colors.backgroundNormalNormal,
      appBar: AppBar(
        backgroundColor: AppColor.transparent,
        elevation: 0,
        leading: const SizedBox.shrink(), // No back button during analysis
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Character illustration - astronaut bunny drinking coffee
              ClipRRect(
                borderRadius: AppRadius.xlBorder,
                child: Image.asset(
                  AssetPath.charDrinkCoffee,
                  width: double.infinity,
                  height: 240,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: double.infinity,
                    height: 240,
                    decoration: BoxDecoration(
                      color: colors.componentFillNormal,
                      borderRadius: AppRadius.xlBorder,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.show_chart_rounded,
                          size: 64,
                          color: colors.labelAssistive,
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 120,
                          child: LinearProgressIndicator(
                            backgroundColor: colors.lineNormalAlternative,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              colors.primaryNormal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 48),

              // Analysis text
              Text(
                '${controller.userName}님의 취향을\n분석하고 있어요.',
                textAlign: TextAlign.center,
                style: _screenHeaderStyle(colors),
              ),

              const SizedBox(height: 60),

              // Loading dots animation
              const _LoadingDots(),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadingDots extends StatefulWidget {
  const _LoadingDots();

  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            final delay = index * 0.2;
            final value = ((_controller.value + delay) % 1.0);
            final opacity = 0.3 + 0.7 * (1 - (value - 0.5).abs() * 2);

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: colors.primaryNormal.withValues(alpha: opacity),
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      },
    );
  }
}
