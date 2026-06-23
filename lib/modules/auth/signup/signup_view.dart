import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/modules/auth/signup/signup_controller.dart';
import 'package:coflanet/modules/onboarding/widgets/survey_progress_bar.dart';
import 'package:coflanet/widgets/buttons/primary_button.dart';
import 'package:coflanet/widgets/forms/app_text_field.dart';

class SignUpView extends GetView<SignUpController> {
  const SignUpView({super.key});

  // Figma 사양: Pretendard SemiBold 22 / lineHeight 1.36 / letterSpacing -0.4268
  // 색상은 Label/strong 토큰 매핑
  // signup 멀티스텝 4개 헤더 (step=0/1/2/3) 모두 동일 사양 사용
  TextStyle _stepHeaderStyle(AppColorScheme colors) =>
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
      appBar: _buildAppBar(colors),
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.space24,
                ),
                child: SurveyProgressIndicator(progress: controller.progress),
              ),
            ),
            Expanded(child: Obx(() => _buildStepContent(colors))),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(AppColorScheme colors) {
    return AppBar(
      backgroundColor: colors.backgroundNormalNormal,
      elevation: 0,
      leading: IconButton(
        onPressed: () => controller.previousStep(),
        icon: SvgPicture.asset(
          AssetPath.iconArrowBack,
          width: AppSpacing.space24,
          height: AppSpacing.space24,
          colorFilter: ColorFilter.mode(colors.labelNormal, BlendMode.srcIn),
        ),
        tooltip: '뒤로 가기',
      ),
    );
  }

  Widget _buildStepContent(AppColorScheme colors) {
    return switch (controller.currentStep) {
      0 => _buildTermsStep(colors),
      1 => _buildEmailStep(colors),
      2 => _buildPasswordStep(colors),
      3 => _buildConfirmPasswordStep(colors),
      _ => const SizedBox.shrink(),
    };
  }

  // --- Step 0: 서비스 약관 ---

  Widget _buildTermsStep(AppColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.space32),
          Text('서비스 약관에\n동의해 주세요', style: _stepHeaderStyle(colors)),
          const SizedBox(height: AppSpacing.space40),
          _buildTermCheckbox(
            colors: colors,
            label: '전체 동의하기',
            value: controller.termsAll.value,
            onChanged: controller.toggleAll,
            isBold: true,
          ),
          Divider(color: colors.lineNormalNeutral, height: 1),
          const SizedBox(height: AppSpacing.space20),
          _buildTermCheckbox(
            colors: colors,
            label: '회원 약관 동의',
            tag: '필수',
            value: controller.termsService.value,
            onChanged: (v) => controller.toggleTerm(controller.termsService, v),
          ),
          _buildTermCheckbox(
            colors: colors,
            label: '회원 약관 동의',
            tag: '선택',
            value: controller.termsServiceOptional.value,
            onChanged: (v) =>
                controller.toggleTerm(controller.termsServiceOptional, v),
          ),
          _buildTermCheckbox(
            colors: colors,
            label: '개인정보 수집 및 이용 동의',
            tag: '필수',
            value: controller.termsPrivacy.value,
            onChanged: (v) => controller.toggleTerm(controller.termsPrivacy, v),
          ),
          _buildTermCheckbox(
            colors: colors,
            label: '만 14세 이상이에요',
            tag: '필수',
            value: controller.termsAge.value,
            onChanged: (v) => controller.toggleTerm(controller.termsAge, v),
            description:
                '만 14세 이상부터 회원가입이 가능합니다.\n해당 정보는 저장되지 않으며, 만 14세 이상 확인\n용도로만 사용합니다.',
          ),
          const Spacer(),
          PrimaryButton(
            text: '다음',
            onPressed: controller.isCurrentStepValid
                ? controller.nextStep
                : null,
            isEnabled: controller.isCurrentStepValid,
          ),
          const SizedBox(height: AppSpacing.space48),
        ],
      ),
    );
  }

  Widget _buildTermCheckbox({
    required AppColorScheme colors,
    required String label,
    String? tag,
    required bool value,
    required ValueChanged<bool?> onChanged,
    bool isBold = false,
    String? description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.space16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: AppSpacing.space24,
                height: AppSpacing.space24,
                child: Checkbox(
                  value: value,
                  onChanged: onChanged,
                  activeColor: colors.primaryNormal,
                  shape: const CircleBorder(),
                  side: BorderSide(color: colors.lineNormalNeutral, width: 1.5),
                ),
              ),
              const SizedBox(width: AppSpacing.space12),
              Expanded(
                child: Row(
                  children: [
                    Text(
                      label,
                      style:
                          (isBold
                                  ? AppTextStyles.body1NormalBold
                                  : AppTextStyles.body2NormalRegular)
                              .copyWith(color: colors.labelNormal),
                    ),
                    if (tag != null) ...[
                      const SizedBox(width: AppSpacing.space4),
                      Text(
                        '($tag)',
                        style: AppTextStyles.body2NormalRegular.copyWith(
                          color: tag == '필수'
                              ? colors.primaryNormal
                              : colors.labelAssistive,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: AppSpacing.space20,
                color: colors.labelAssistive,
              ),
            ],
          ),
          if (description != null) ...[
            Padding(
              // left 36 = 체크박스 24 + 갭 12 정렬용 (토큰 합성)
              padding: const EdgeInsets.only(
                left: AppSpacing.space24 + AppSpacing.space12,
                top: AppSpacing.space4,
              ),
              child: Text(
                description,
                style: AppTextStyles.caption1Regular.copyWith(
                  color: colors.labelAlternative,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // --- Step 1: 이메일 입력 ---

  Widget _buildEmailStep(AppColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.space32),
          Text('메일을 입력해 주세요', style: _stepHeaderStyle(colors)),
          const SizedBox(height: AppSpacing.space56),
          AppTextField(
            controller: controller.emailTextController,
            label: '메일',
            hintText: '메일',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            errorText: controller.emailError.value,
            autofocus: true,
            onSubmitted: (_) {
              if (controller.isCurrentStepValid) controller.nextStep();
            },
          ),
          const Spacer(),
          PrimaryButton(
            text: '확인',
            onPressed: controller.isCurrentStepValid
                ? controller.nextStep
                : null,
            isEnabled: controller.isCurrentStepValid,
          ),
          const SizedBox(height: AppSpacing.space48),
        ],
      ),
    );
  }

  // --- Step 2: 비밀번호 입력 ---

  Widget _buildPasswordStep(AppColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.space32),
          Text('비밀번호를 입력해 주세요', style: _stepHeaderStyle(colors)),
          const SizedBox(height: AppSpacing.space56),
          AppTextField(
            controller: controller.passwordTextController,
            label: '비밀번호',
            hintText: '비밀번호',
            obscureText: !controller.isPasswordVisible.value,
            showPasswordToggle: true,
            errorText: controller.passwordError.value,
            helperText: '8~20자 이내 / 대소문자, 숫자, 특수문자 포함',
            autofocus: true,
            onSubmitted: (_) {
              if (controller.isCurrentStepValid) controller.nextStep();
            },
          ),
          const Spacer(),
          PrimaryButton(
            text: '다음',
            onPressed: controller.isCurrentStepValid
                ? controller.nextStep
                : null,
            isEnabled: controller.isCurrentStepValid,
          ),
          const SizedBox(height: AppSpacing.space48),
        ],
      ),
    );
  }

  // --- Step 3: 비밀번호 확인 ---

  Widget _buildConfirmPasswordStep(AppColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.space32),
          RichText(
            text: TextSpan(
              style: _stepHeaderStyle(colors),
              children: [
                const TextSpan(text: '비밀번호를 '),
                // "한번 더" 강조: 같은 폰트/weight/size/lh/ls, 색상만 primary 로 override
                // (spec: 05_password_confirm_spec.md — 별도 강조 폰트 스타일 없음)
                TextSpan(
                  text: '한번 더',
                  style: _stepHeaderStyle(
                    colors,
                  ).copyWith(color: colors.primaryNormal),
                ),
                const TextSpan(text: ' 입력해 주세요'),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.space56),
          AppTextField(
            controller: controller.confirmPasswordTextController,
            label: '비밀번호 확인',
            hintText: '비밀번호 확인',
            obscureText: !controller.isConfirmPasswordVisible.value,
            showPasswordToggle: true,
            errorText: controller.confirmPasswordError.value,
            autofocus: true,
            onSubmitted: (_) {
              if (controller.isCurrentStepValid) controller.nextStep();
            },
          ),
          const SizedBox(height: AppSpacing.space20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.space16,
              vertical: AppSpacing.space14,
            ),
            decoration: BoxDecoration(
              color: colors.componentFillAlternative,
              borderRadius: AppRadius.lgBorder,
              border: Border.all(color: colors.lineNormalNeutral, width: 1),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '비밀번호',
                        style: AppTextStyles.caption1Regular.copyWith(
                          color: colors.labelAlternative,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.space4),
                      Text(
                        '●' * controller.password.value.length.clamp(0, 10),
                        style: AppTextStyles.body1NormalRegular.copyWith(
                          color: colors.labelNormal,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.visibility_off_outlined,
                  color: colors.labelAssistive,
                  size: AppSpacing.space20,
                ),
              ],
            ),
          ),
          if (controller.passwordError.value == null)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.space6),
              child: Text(
                '8~20자 이내 / 대소문자, 숫자, 특수문자 포함',
                style: AppTextStyles.caption1Regular.copyWith(
                  color: colors.labelAssistive,
                ),
              ),
            ),
          const Spacer(),
          PrimaryButton(
            text: '확인',
            onPressed: controller.isCurrentStepValid
                ? controller.nextStep
                : null,
            isEnabled: controller.isCurrentStepValid,
          ),
          const SizedBox(height: AppSpacing.space48),
        ],
      ),
    );
  }
}
