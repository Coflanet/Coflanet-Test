import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/modules/onboarding/survey_controller.dart';

class SurveyAnalyzingView extends GetView<SurveyController> {
  const SurveyAnalyzingView({super.key});

  @override
  Widget build(BuildContext context) {
    // Start analysis when view is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.analyzeSurvey();
    });

    return Scaffold(
      backgroundColor: AppColor.primaryNormal,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Loading animation
            SizedBox(
              width: 100,
              height: 100,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer ring
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white.withOpacity(0.3),
                      ),
                    ),
                  ),
                  // Inner icon
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(
                      Icons.coffee,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            Text(
              '${controller.userName}님의\n취향을 분석하고 있어요',
              textAlign: TextAlign.center,
              style: AppTextStyles.heading1Bold.copyWith(
                color: Colors.white,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              '잠시만 기다려 주세요...',
              style: AppTextStyles.body2NormalRegular.copyWith(
                color: Colors.white.withOpacity(0.8),
              ),
            ),

            const SizedBox(height: 60),

            // Loading dots animation
            const _LoadingDots(),
          ],
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
                color: Colors.white.withOpacity(opacity),
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      },
    );
  }
}
