import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/spacing_constant.dart';
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
          // Figma `Signin` 좌우 마진 5.56% × 360 = 20 (`Margin/Navigation`)
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.headerHorizontalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Figma `Signin` 헤더 top 128/720 = 17.8% → 1:3 비율로 근접
              const Spacer(flex: 1),

              // Logo and welcome text
              _buildHeader(colors),

              // 헤더 ~ 버튼 사이 큰 여백 (Figma 와 동일한 비율)
              const Spacer(flex: 3),

              // Social login buttons
              _buildSocialButtons(),

              // Figma: button_list(bottom 115) ~ txt_btn_list(top 62) 간격 ≈ 53 → space48 근접
              const SizedBox(height: AppSpacing.space48),

              _buildBottomLinks(colors),

              // Figma 사양 bottom: 34px (`1:3955` "txt_btn_list") → space32(=32) 토큰 근접
              const SizedBox(height: AppSpacing.space32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppColorScheme colors) {
    // Figma MCP 정확값: Title 2/Bold (Pretendard Bold 28 / lh 1.358 / ls -0.6608).
    // 토큰 `title2Bold` 가 정확히 동일(28·w700·1.358·-0.6608) → 토큰 그대로 사용.
    return Text(
      '로그인하고\n내 취향을 찾아볼까요?',
      textAlign: TextAlign.center,
      style: AppTextStyles.title2Bold.copyWith(color: colors.labelNormal),
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
          // Figma `button_list` gap = `spacing/button/hor` = 4 (space4)
          const SizedBox(height: AppSpacing.space4),

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
            const SizedBox(height: AppSpacing.space4),
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

  // Figma `Button/Text/Assistive`: 세로 패딩 4(py-4), 좌우는 row gap(8)으로 처리.
  // 기본 TextButton 의 넓은 패딩을 줄여 디바이더와의 간격을 Figma 8 에 맞추되,
  // 접근성 탭 타깃은 기본값(최소 48)을 유지한다.
  static final ButtonStyle _textLinkStyle = TextButton.styleFrom(
    // 좌우 4 + 디바이더 margin 4 = 텍스트↔디바이더 8 (Figma row gap-8)
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.space4,
      vertical: AppSpacing.space4,
    ),
    minimumSize: Size.zero,
  );

  Widget _buildBottomLinks(AppColorScheme colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () => Get.toNamed(Routes.emailSignUp),
          // Figma `Button/Text/Assistive`: 14·SemiBold(w600)·label/alternative
          style: _textLinkStyle,
          child: Text(
            '회원가입',
            style: AppTextStyles.label1NormalBold.copyWith(
              color: colors.labelAlternative,
            ),
          ),
        ),
        Container(
          width: 1,
          // Figma `Basic/Divider`(vertical) 높이 10 (`Line/Normal/Normal` #70737C α22%)
          height: AppSpacing.space10,
          color: colors.lineNormalNormal,
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.space4),
        ),
        TextButton(
          // 의도된 결정: 게스트 제거, "이메일 로그인" 유지 (Figma의 게스트로 되돌리지 않음)
          onPressed: () => Get.toNamed(Routes.emailLogin),
          style: _textLinkStyle,
          child: Text(
            '이메일 로그인',
            style: AppTextStyles.label1NormalBold.copyWith(
              color: colors.labelAlternative,
            ),
          ),
        ),
      ],
    );
  }
}
