import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/modules/onboarding/survey_controller.dart';
import 'package:coflanet/widgets/buttons/primary_button.dart';

class SurveyCompleteView extends GetView<SurveyController> {
  const SurveyCompleteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundNormalNormal,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Success animation / illustration
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  color: AppColor.statusPositive.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(80),
                ),
                child: Icon(
                  Icons.check_circle_outline,
                  size: 80,
                  color: AppColor.statusPositive,
                ),
              ),

              const SizedBox(height: 40),

              // Complete message
              Text(
                '분석 완료!',
                style: AppTextStyles.heading1Bold.copyWith(
                  color: AppColor.labelNormal,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                '${controller.userName}님만의\n커피 취향을 찾았어요',
                textAlign: TextAlign.center,
                style: AppTextStyles.body1NormalRegular.copyWith(
                  color: AppColor.labelAlternative,
                  height: 1.5,
                ),
              ),

              const Spacer(flex: 3),

              // CTA Button
              PrimaryButton(
                text: '결과 보러 가기',
                onPressed: () => controller.viewResult(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
