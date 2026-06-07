import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/core/storage/local_storage.dart';
import 'package:coflanet/routes/app_pages.dart';
import 'package:coflanet/widgets/buttons/primary_button.dart';

/// 완료페이지 (Figma: 937:45601)
/// "홍길동님, 환영합니다!" + "회원가입이 완료되었어요"
class SignUpCompleteView extends StatelessWidget {
  const SignUpCompleteView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get user name from storage
    final storage = Get.find<LocalStorage>();
    final userName = storage.getUserName() ?? '사용자';
    final colors = AppColorScheme.of(context);

    return Scaffold(
      backgroundColor: colors.backgroundNormalNormal,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Celebration illustration (182x182 per Figma)
              _buildCelebrationIllustration(colors),

              const SizedBox(height: 40),

              // Welcome text
              _buildWelcomeText(colors, userName),

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

  /// Celebration illustration - clapping hands image (Figma: 182x182)
  Widget _buildCelebrationIllustration(AppColorScheme colors) {
    return Image.asset(
      AssetPath.completionClappingHands,
      width: 182,
      height: 182,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => Container(
        width: 182,
        height: 182,
        decoration: BoxDecoration(
          color: colors.primaryLight.withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        child: const Center(child: Text('👏', style: TextStyle(fontSize: 80))),
      ),
    );
  }

  /// Welcome text per Figma (937:45601)
  /// - "홍길동님, 환영합니다!" (28px, Bold)
  /// - "회원가입이 완료되었어요" (16px, Regular)
  Widget _buildWelcomeText(AppColorScheme colors, String userName) {
    return Column(
      children: [
        Text(
          '$userName님, 환영합니다!',
          style: AppTextStyles.heading1Bold.copyWith(
            color: colors.labelNormal,
            fontSize: 28,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          '회원가입이 완료되었어요',
          style: AppTextStyles.body1NormalRegular.copyWith(
            color: colors.labelAlternative,
            fontSize: 16,
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
        // 회원가입 완료 → 취향 설문 인트로로 진행
        // (profileSetup 으로 보내면 이름입력→이유→완료가 무한 반복됨)
        Get.offAllNamed(Routes.surveyIntro);
      },
    );
  }
}
