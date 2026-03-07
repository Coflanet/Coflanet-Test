import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/modules/auth/email_login/email_login_controller.dart';
import 'package:coflanet/widgets/buttons/primary_button.dart';

class EmailLoginView extends GetView<EmailLoginController> {
  const EmailLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundNormalNormal,
      appBar: AppBar(
        backgroundColor: AppColor.backgroundNormalNormal,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: SvgPicture.asset(
            AssetPath.iconArrowBack,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              AppColor.labelNormal,
              BlendMode.srcIn,
            ),
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
                    color: AppColor.labelNormal,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '가입한 이메일과 비밀번호를 입력해주세요',
                  style: AppTextStyles.body2NormalRegular.copyWith(
                    color: AppColor.labelAlternative,
                  ),
                ),
                const SizedBox(height: 40),
                _buildEmailField(),
                const SizedBox(height: 20),
                _buildPasswordField(),
                const SizedBox(height: 32),
                _buildLoginButton(),
                const SizedBox(height: 24),
                _buildSignUpLink(),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return Obx(
      () => _buildTextField(
        label: '이메일',
        hintText: 'example@email.com',
        errorText: controller.emailError.value,
        keyboardType: TextInputType.emailAddress,
        onChanged: controller.onEmailChanged,
        prefixIcon: Icons.email_outlined,
      ),
    );
  }

  Widget _buildPasswordField() {
    return Obx(
      () => _buildTextField(
        label: '비밀번호',
        hintText: '비밀번호를 입력해주세요',
        errorText: controller.passwordError.value,
        obscureText: true,
        onChanged: controller.onPasswordChanged,
        prefixIcon: Icons.lock_outline,
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hintText,
    String? errorText,
    bool obscureText = false,
    TextInputType? keyboardType,
    required Function(String) onChanged,
    IconData? prefixIcon,
  }) {
    final hasError = errorText != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.label1NormalMedium.copyWith(
            color: AppColor.labelNormal,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColor.componentFillAlternative,
            borderRadius: AppRadius.lgBorder,
            border: Border.all(
              color: hasError
                  ? AppColor.statusNegative
                  : AppColor.lineNormalNeutral,
              width: 1,
            ),
          ),
          child: TextField(
            onChanged: onChanged,
            obscureText: obscureText,
            keyboardType: keyboardType,
            style: AppTextStyles.body1NormalRegular.copyWith(
              color: AppColor.labelNormal,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: AppTextStyles.body1NormalRegular.copyWith(
                color: AppColor.labelAssistive,
              ),
              prefixIcon: prefixIcon != null
                  ? Icon(
                      prefixIcon,
                      color: hasError
                          ? AppColor.statusNegative
                          : AppColor.labelAlternative,
                      size: 20,
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                Icons.error_outline,
                size: 14,
                color: AppColor.statusNegative,
              ),
              const SizedBox(width: 4),
              Text(
                errorText,
                style: AppTextStyles.caption1Regular.copyWith(
                  color: AppColor.statusNegative,
                ),
              ),
            ],
          ),
        ],
      ],
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

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '계정이 없으신가요?',
          style: AppTextStyles.label1NormalRegular.copyWith(
            color: AppColor.labelAlternative,
          ),
        ),
        TextButton(
          onPressed: controller.goToSignUp,
          child: Text(
            '회원가입',
            style: AppTextStyles.label1NormalMedium.copyWith(
              color: AppColor.primaryNormal,
            ),
          ),
        ),
      ],
    );
  }
}
