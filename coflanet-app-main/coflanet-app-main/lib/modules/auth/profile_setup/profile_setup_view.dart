import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/modules/auth/profile_setup/profile_setup_controller.dart';
import 'package:coflanet/modules/onboarding/widgets/survey_progress_bar.dart';
import 'package:coflanet/widgets/buttons/primary_button.dart';
import 'package:coflanet/widgets/forms/app_text_field.dart';

/// Profile setup screen for collecting user's name after social login
class ProfileSetupView extends GetView<ProfileSetupController> {
  const ProfileSetupView({super.key});

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress bar - Step 1 of 2
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SurveyProgressIndicator(progress: 0.5),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),

                    // Welcome title with emoji
                    _buildHeader(),

                    const SizedBox(height: 48),

                    // Name input field
                    _buildNameInput(),

                    const Spacer(),

                    // Continue button
                    _buildContinueButton(),

                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '반가워요! 👋',
          style: AppTextStyles.title2Bold.copyWith(color: AppColor.labelNormal),
        ),
        const SizedBox(height: 12),
        Text(
          '이름을 입력해주세요',
          style: AppTextStyles.title2Bold.copyWith(color: AppColor.labelNormal),
        ),
      ],
    );
  }

  Widget _buildNameInput() {
    return AppTextField(
      controller: controller.nameController,
      hintText: '이름 또는 닉네임',
      size: TextFieldSize.lg,
      autofocus: true,
      textCapitalization: TextCapitalization.words,
    );
  }

  Widget _buildContinueButton() {
    return Obx(
      () => PrimaryButton(
        text: '시작하기',
        onPressed: controller.isValid ? controller.saveAndContinue : null,
        isEnabled: controller.isValid,
      ),
    );
  }
}
