import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/routes/app_pages.dart';
import 'package:coflanet/widgets/buttons/primary_button.dart';

/// 회원가입 완료 화면 (11-completion-page)
/// 회원가입 성공 후 환영 메시지와 함께 온보딩으로 안내
class SignUpCompleteView extends StatelessWidget {
  const SignUpCompleteView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get user name from arguments or use default
    final userName = Get.arguments?['userName'] as String? ?? '사용자';

    return Scaffold(
      backgroundColor: AppColor.backgroundNormalNormal,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Celebration illustration
              _buildCelebrationIllustration(),

              const SizedBox(height: 40),

              // Welcome text
              _buildWelcomeText(userName),

              const Spacer(flex: 3),

              // CTA Button
              _buildCTAButton(),

              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColor.backgroundNormalNormal,
      elevation: 0,
      leading: const SizedBox.shrink(), // No back button - arrived via offNamed
    );
  }

  /// Clapping hands illustration from storyboard 11-completion-page.png
  Widget _buildCelebrationIllustration() {
    return Image.asset(
      AssetPath.completionClappingHands,
      width: 200,
      height: 200,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) =>
          _buildFallbackIllustration(),
    );
  }

  /// Fallback illustration if image fails to load
  Widget _buildFallbackIllustration() {
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColor.primaryLight,
            AppColor.primaryLight.withValues(alpha: 0.5),
          ],
        ),
        shape: BoxShape.circle,
      ),
      child: Center(child: Text('👏', style: AppTextStyles.emojiXLarge)),
    );
  }

  Widget _buildWelcomeText(String userName) {
    return Column(
      children: [
        Text(
          '$userName님, 환영합니다!',
          style: AppTextStyles.title1Bold.copyWith(color: AppColor.labelNormal),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          '회원가입이 완료되었어요',
          style: AppTextStyles.body1NormalRegular.copyWith(
            color: AppColor.labelAlternative,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCTAButton() {
    return PrimaryButton(
      text: '시작하기',
      onPressed: () {
        // Navigate to survey intro for onboarding
        Get.offAllNamed(Routes.surveyIntro);
      },
    );
  }
}
