import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/modules/onboarding/survey_controller.dart';
import 'package:coflanet/widgets/buttons/primary_button.dart';

class SurveyIntroView extends GetView<SurveyController> {
  const SurveyIntroView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundNormalNormal,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColor.labelNormal),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const Spacer(flex: 1),

                    // Thumbnail / Resource area - placeholder for illustration
                    // TODO: Replace with actual onboarding_welcome.png asset
                    Container(
                      width: double.infinity,
                      height: 240,
                      decoration: BoxDecoration(
                        color: AppColor.componentFillNormal,
                        borderRadius: AppRadius.xlBorder,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_outlined,
                            size: 48,
                            color: AppColor.labelAssistive,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Illustration',
                            style: AppTextStyles.caption1Regular.copyWith(
                              color: AppColor.labelAssistive,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(flex: 1),

                    // Welcome text with emoji
                    Text(
                      '커플래닛에 오신 걸 환영해요 🎉',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.heading1Bold.copyWith(
                        color: AppColor.labelNormal,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Text(
                      '${controller.userName}님의 취향을 찾으러 가볼까요?',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body1NormalRegular.copyWith(
                        color: AppColor.labelAlternative,
                        height: 1.5,
                      ),
                    ),

                    const Spacer(flex: 2),
                  ],
                ),
              ),
            ),

            // Bottom CTA area (BottomSheet_CTA style)
            Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 34),
              decoration: BoxDecoration(color: AppColor.backgroundNormalNormal),
              child: PrimaryButton(
                text: '취향 찾으러 가기',
                onPressed: () => controller.startSurvey(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
