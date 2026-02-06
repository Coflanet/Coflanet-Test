import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/asset_constant.dart';
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
      appBar: AppBar(
        backgroundColor: AppColor.transparent,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            AssetPath.iconArrowBack,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              AppColor.labelNormal,
              BlendMode.srcIn,
            ),
          ),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),

                    // Header text
                    Text(
                      '${controller.userName}님께',
                      style: AppTextStyles.heading1Bold.copyWith(
                        color: AppColor.labelNormal,
                      ),
                    ),
                    Text(
                      '커피 경험 질문을 드릴게요!',
                      style: AppTextStyles.heading1Bold.copyWith(
                        color: AppColor.labelNormal,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Subtitle
                    Text(
                      '취향 분석은 이런 단계로 진행돼요.',
                      style: AppTextStyles.body1NormalRegular.copyWith(
                        color: AppColor.labelAlternative,
                      ),
                    ),
                    Text(
                      '예상 소요 시간은 10분 입니다.',
                      style: AppTextStyles.body1NormalRegular.copyWith(
                        color: AppColor.labelAlternative,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Step indicators
                    _buildStepIndicator(1, '커피 경험 질문', isActive: true),
                    _buildVerticalLine(),
                    _buildStepIndicator(2, '기본 맛 취향', isActive: false),
                    _buildVerticalLine(),
                    _buildStepIndicator(3, '특성 향미 취향', isActive: false),

                    const Spacer(),
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

  /// Build a step indicator row with circle and text
  Widget _buildStepIndicator(int step, String label, {required bool isActive}) {
    return Row(
      children: [
        // Circle with number
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? AppColor.primaryNormal : AppColor.transparent,
            border: isActive
                ? null
                : Border.all(color: AppColor.lineNormalNormal, width: 1.5),
          ),
          child: Center(
            child: Text(
              '$step',
              style: AppTextStyles.label1NormalMedium.copyWith(
                color: isActive
                    ? AppColor.staticLabelWhiteNormal
                    : AppColor.labelAlternative,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Label text
        Text(
          label,
          style: AppTextStyles.body1NormalMedium.copyWith(
            color: isActive ? AppColor.primaryNormal : AppColor.labelNormal,
          ),
        ),
      ],
    );
  }

  /// Build vertical connecting line between steps
  Widget _buildVerticalLine() {
    return Padding(
      padding: const EdgeInsets.only(left: 13), // Center under 28px circle
      child: Container(
        width: 2,
        height: 24,
        color: AppColor.primaryNormal.withOpacity(0.3),
      ),
    );
  }
}
