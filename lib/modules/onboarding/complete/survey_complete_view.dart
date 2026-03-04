import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/modules/onboarding/survey_controller.dart';
import 'package:coflanet/widgets/buttons/primary_button.dart';

class SurveyCompleteView extends GetView<SurveyController> {
  const SurveyCompleteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundNormalNormal,
      appBar: AppBar(
        backgroundColor: AppColor.transparent,
        elevation: 0,
        leading:
            const SizedBox.shrink(), // No back button - arrived via offNamed
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              AssetPath.iconSettings,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                AppColor.labelAlternative,
                BlendMode.srcIn,
              ),
            ),
            onPressed: () {
              // 설정 화면 연결 (추후 구현)
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const Spacer(flex: 1),

                  // Mascot illustration - astronaut bunny with gift
                  ClipRRect(
                    borderRadius: AppRadius.fullBorder,
                    child: Image.asset(
                      AssetPath.charGift,
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: AppColor.primaryLight,
                          borderRadius: AppRadius.fullBorder,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.card_giftcard_rounded,
                              size: 64,
                              color: AppColor.primaryNormal,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Mascot',
                              style: AppTextStyles.caption1Regular.copyWith(
                                color: AppColor.primaryNormal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const Spacer(flex: 1),

                  // Complete message matching Figma
                  Text(
                    '${controller.userName}님의\n커피 취향을 찾았어요!',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.heading1Bold.copyWith(
                      color: AppColor.labelNormal,
                      height: 1.4,
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
              text: '내 취향 커피 만나러 가기',
              onPressed: () => controller.viewResult(),
            ),
          ),
        ],
      ),
    );
  }
}
