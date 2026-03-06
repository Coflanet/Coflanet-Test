import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/modules/onboarding/reason/survey_reason_controller.dart';
import 'package:coflanet/modules/onboarding/widgets/survey_checkbox_item.dart';
import 'package:coflanet/modules/onboarding/widgets/survey_progress_bar.dart';
import 'package:coflanet/widgets/buttons/primary_button.dart';

/// Survey Reason Screen (Figma: 937:45569 - Onboarding_Survey_Reason)
/// "커플래닛을 찾게 된 이유를 알려주세요." - 중복 선택 가능
class SurveyReasonView extends GetView<SurveyReasonController> {
  const SurveyReasonView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundNormalNormal,
      appBar: _buildAppBar(),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // Progress bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SurveyProgressIndicator(progress: 1.0),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),

                    // Title
                    Text(
                      '커플래닛을 찾게 된',
                      style: AppTextStyles.heading1Bold.copyWith(
                        color: AppColor.labelNormal,
                      ),
                    ),
                    Text(
                      '이유를 알려주세요.',
                      style: AppTextStyles.heading1Bold.copyWith(
                        color: AppColor.labelNormal,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Subtitle
                    Text(
                      '중복 선택 가능해요.',
                      style: AppTextStyles.body1NormalRegular.copyWith(
                        color: AppColor.labelAlternative,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Checkbox options
                    _buildOptions(),
                  ],
                ),
              ),
            ),

            // Bottom CTA
            _buildBottomCTA(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColor.transparent,
      elevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset(
          AssetPath.iconArrowBack,
          width: 24,
          height: 24,
          colorFilter: ColorFilter.mode(AppColor.labelNormal, BlendMode.srcIn),
        ),
        onPressed: () => Get.back(),
      ),
    );
  }

  Widget _buildOptions() {
    return Obx(
      () => Column(
        children: controller.options.map((option) {
          final isSelected = controller.isSelected(option.id);
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: SurveyCheckboxItem(
              label: option.label,
              isSelected: isSelected,
              onTap: () => controller.toggleOption(option.id),
              showIcon: false,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBottomCTA() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 34),
      decoration: BoxDecoration(color: AppColor.backgroundNormalNormal),
      child: Obx(
        () => PrimaryButton(
          text: '완료',
          onPressed: controller.complete,
          isEnabled: controller.hasSelection,
        ),
      ),
    );
  }
}
