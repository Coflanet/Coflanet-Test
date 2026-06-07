import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/data/providers/auth_provider.dart';
import 'package:coflanet/modules/auth/signin/signin_controller.dart';
import 'package:coflanet/routes/app_pages.dart';
import 'package:coflanet/widgets/buttons/social_button.dart';

class SignInView extends GetView<SignInController> {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);
    return Scaffold(
      backgroundColor: colors.backgroundNormalNormal,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Figma 720 디자인에서 헤더 top:128px = 17.78% → 1:4 비율 = 20% 로 근접
              const Spacer(flex: 1),

              // Logo and welcome text
              _buildHeader(colors),

              // 헤더 ~ 버튼 사이 큰 여백 (Figma 와 동일한 비율)
              const Spacer(flex: 4),

              // Social login buttons
              _buildSocialButtons(),

              const SizedBox(height: 24),

              _buildBottomLinks(colors),

              // Figma 사양 bottom: 34px (`1:3955` "txt_btn_list")
              const SizedBox(height: 34),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppColorScheme colors) {
    // Figma MCP 정확값: Title 2/Bold (Pretendard Bold 28 / lh 1.358 / ls -0.6608)
    // 토큰 `AppTextStyles.heading1Bold` 는 22/1.4 이므로 컴포넌트 단위 override 유지.
    // 토큰 전역 수정은 다른 화면 영향 범위가 커서 보류 (typography 토큰 원본 부재).
    return Text(
      '로그인하고\n내 취향을 찾아볼까요?',
      textAlign: TextAlign.center,
      style: AppTextStyles.heading1Bold.copyWith(
        color: colors.labelNormal,
        fontSize: 28,
        height: 1.358,
        letterSpacing: -0.6608,
      ),
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
          // Figma 사양 Spacing/Button/hor = 8 (`1:3951` "button_list" gap)
          const SizedBox(height: 8),

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
            const SizedBox(height: 8),
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

  Widget _buildBottomLinks(AppColorScheme colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () => Get.toNamed(Routes.emailSignUp),
          child: Text(
            '회원가입',
            style: AppTextStyles.label1NormalMedium.copyWith(
              color: colors.labelAlternative,
            ),
          ),
        ),
        Container(
          width: 1,
          height: 12,
          // Figma 사양: #70737C α22% (`Line/Normal/Normal`) → 시맨틱 lineNormalNormal 매핑
          color: colors.lineNormalNormal,
          margin: const EdgeInsets.symmetric(horizontal: 8),
        ),
        TextButton(
          onPressed: () => Get.toNamed(Routes.emailLogin),
          child: Text(
            '이메일 로그인',
            style: AppTextStyles.label1NormalMedium.copyWith(
              color: colors.labelAlternative,
            ),
          ),
        ),
      ],
    );
  }
}
