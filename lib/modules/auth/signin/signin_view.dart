import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/data/providers/auth_provider.dart';
import 'package:coflanet/modules/auth/signin/signin_controller.dart';
import 'package:coflanet/routes/app_pages.dart';
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo and welcome text - 상단에 가깝게 (SafeArea 바로 아래)
              _buildHeader(),

              const Spacer(),

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
        // Logo
        ClipRRect(
          borderRadius: AppRadius.xlBorder,
          child: Image.asset(
            AssetPath.logoMain,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColor.primaryLight,
                borderRadius: AppRadius.xlBorder,
              ),
              child: Icon(
                Icons.all_inclusive_rounded,
                size: 40,
                color: AppColor.primaryNormal,
              ),
            ),
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
      ],
    );
  }

  Widget _buildSocialButtons() {
    return Obx(
      () => Column(
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
          // Apple Login - iOS only
          if (Platform.isIOS) ...[
            const SizedBox(height: 12),
            SocialButton(
              type: SocialButtonType.apple,
              onPressed: controller.isLoading
                  ? null
                  : () => controller.signInWithSocial(SocialLoginType.apple),
              isLoading: controller.isLoading,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildGuestLogin() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () => Get.toNamed(Routes.emailLogin),
          child: Text(
            '이메일 로그인',
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
