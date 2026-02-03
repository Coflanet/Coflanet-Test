import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/modules/onboarding/survey_controller.dart';
import 'package:coflanet/widgets/buttons/primary_button.dart';

class SurveyIntroView extends GetView<SurveyController> {
  const SurveyIntroView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundNormalNormal,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(flex: 1),

              // Welcome illustration
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: AppColor.primaryLight,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Icon(
                  Icons.coffee,
                  size: 80,
                  color: AppColor.primaryNormal,
                ),
              ),

              const Spacer(flex: 1),

              // Welcome text
              Text(
                '커플래닛에 오신 걸\n환영해요!',
                textAlign: TextAlign.center,
                style: AppTextStyles.heading1Bold.copyWith(
                  color: AppColor.labelNormal,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),

              Text(
                '${controller.userName}님의\n취향을 찾으러 가볼까요?',
                textAlign: TextAlign.center,
                style: AppTextStyles.body1NormalRegular.copyWith(
                  color: AppColor.labelAlternative,
                  height: 1.5,
                ),
              ),

              const Spacer(flex: 2),

              // CTA Button
              PrimaryButton(
                text: '취향 찾으러 가기',
                onPressed: () => controller.startSurvey(),
              ),

              const SizedBox(height: 16),

              // Skip button
              TextButton(
                onPressed: () => controller.completeOnboarding(),
                child: Text(
                  '나중에 하기',
                  style: AppTextStyles.label1NormalMedium.copyWith(
                    color: AppColor.labelAssistive,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
