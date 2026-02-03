import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/modules/auth/signin/signin_controller.dart';
import 'package:coflanet/widgets/buttons/social_button.dart';

class SignInView extends GetView<SignInController> {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundNormalNormal,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Logo and welcome text
              _buildHeader(),

              const Spacer(flex: 2),

              // Social login buttons
              _buildSocialButtons(),

              const SizedBox(height: 24),

              // Guest login link
              _buildGuestLogin(),

              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Logo placeholder
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: AppColor.primaryLight,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            Icons.coffee,
            size: 48,
            color: AppColor.primaryNormal,
          ),
        ),
        const SizedBox(height: 32),
        Text(
          '로그인하고\n내 취향을 찾아볼까요?',
          textAlign: TextAlign.center,
          style: AppTextStyles.heading1Bold.copyWith(
            color: AppColor.labelNormal,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          '소셜 로그인으로 간편하게 시작하세요',
          style: AppTextStyles.body2NormalRegular.copyWith(
            color: AppColor.labelAlternative,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButtons() {
    return Obx(() => Column(
          children: [
            // Kakao Login
            SocialButton(
              type: SocialButtonType.kakao,
              onPressed: controller.isLoading
                  ? null
                  : () => controller.signInWithSocial(SocialLoginType.kakao),
              isLoading: controller.isLoading,
            ),
            const SizedBox(height: 12),

            // Naver Login
            SocialButton(
              type: SocialButtonType.naver,
              onPressed: controller.isLoading
                  ? null
                  : () => controller.signInWithSocial(SocialLoginType.naver),
              isLoading: controller.isLoading,
            ),
            const SizedBox(height: 12),

            // Apple Login
            SocialButton(
              type: SocialButtonType.apple,
              onPressed: controller.isLoading
                  ? null
                  : () => controller.signInWithSocial(SocialLoginType.apple),
              isLoading: controller.isLoading,
            ),
          ],
        ));
  }

  Widget _buildGuestLogin() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            // TODO: Navigate to sign up
          },
          child: Text(
            '회원가입',
            style: AppTextStyles.label1NormalMedium.copyWith(
              color: AppColor.labelAlternative,
            ),
          ),
        ),
        Container(
          width: 1,
          height: 12,
          color: AppColor.lineNormalNeutral,
          margin: const EdgeInsets.symmetric(horizontal: 8),
        ),
        TextButton(
          onPressed: () => controller.continueAsGuest(),
          child: Text(
            '게스트로 로그인',
            style: AppTextStyles.label1NormalMedium.copyWith(
              color: AppColor.labelAlternative,
            ),
          ),
        ),
      ],
    );
  }
}
