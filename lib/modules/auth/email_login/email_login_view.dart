import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/modules/auth/email_login/email_login_controller.dart';
import 'package:coflanet/widgets/buttons/primary_button.dart';
import 'package:coflanet/widgets/forms/app_text_field.dart';

class EmailLoginView extends GetView<EmailLoginController> {
  const EmailLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);
    return Scaffold(
      backgroundColor: colors.backgroundNormalNormal,
      appBar: AppBar(
        backgroundColor: colors.backgroundNormalNormal,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: SvgPicture.asset(
            AssetPath.iconArrowBack,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(colors.labelNormal, BlendMode.srcIn),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Text(
                  '이메일로 로그인',
                  style: AppTextStyles.heading1Bold.copyWith(
                    color: colors.labelNormal,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '가입한 이메일과 비밀번호를 입력해주세요',
                  style: AppTextStyles.body2NormalRegular.copyWith(
                    color: colors.labelAlternative,
                  ),
                ),
                const SizedBox(height: 40),
                _buildEmailField(),
                const SizedBox(height: 20),
                _buildPasswordField(),
                const SizedBox(height: 32),
                _buildLoginButton(),
                const SizedBox(height: 24),
                _buildSignUpLink(colors),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 공통 AppTextField 사용 — 입력 필드 스타일 3종 분기를 공통으로 통일
  Widget _buildEmailField() {
    return Obx(
      () => AppTextField(
        controller: controller.emailTextController,
        label: '이메일',
        hintText: 'example@email.com',
        errorText: controller.emailError.value,
        keyboardType: TextInputType.emailAddress,
        prefixIcon: Icons.email_outlined,
        onChanged: controller.onEmailChanged,
      ),
    );
  }

  Widget _buildPasswordField() {
    return Obx(
      () => AppTextField(
        controller: controller.passwordTextController,
        label: '비밀번호',
        hintText: '비밀번호를 입력해주세요',
        errorText: controller.passwordError.value,
        obscureText: true,
        prefixIcon: Icons.lock_outline,
        onChanged: controller.onPasswordChanged,
      ),
    );
  }

  Widget _buildLoginButton() {
    return Obx(
      () => PrimaryButton(
        text: '로그인',
        onPressed: controller.signIn,
        isLoading: controller.isLoading,
        isEnabled: controller.isFormValid,
      ),
    );
  }

  Widget _buildSignUpLink(AppColorScheme colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '계정이 없으신가요?',
          style: AppTextStyles.label1NormalRegular.copyWith(
            color: colors.labelAlternative,
          ),
        ),
        TextButton(
          onPressed: controller.goToSignUp,
          child: Text(
            '회원가입',
            style: AppTextStyles.label1NormalMedium.copyWith(
              color: colors.primaryNormal,
            ),
          ),
        ),
      ],
    );
  }
}
