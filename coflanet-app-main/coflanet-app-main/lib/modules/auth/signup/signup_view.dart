import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/modules/auth/signup/signup_controller.dart';
import 'package:coflanet/widgets/buttons/primary_button.dart';

class SignUpView extends GetView<SignUpController> {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundNormalNormal,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),

                // Header
                _buildHeader(),

                const SizedBox(height: 40),

                // Form fields
                _buildForm(),

                const SizedBox(height: 32),

                // Sign up button
                _buildSignUpButton(),

                const SizedBox(height: 24),

                // Sign in link
                _buildSignInLink(),

                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColor.backgroundNormalNormal,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: SvgPicture.asset(
          AssetPath.iconArrowBack,
          width: 24,
          height: 24,
          colorFilter: ColorFilter.mode(AppColor.labelNormal, BlendMode.srcIn),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '이메일로 시작하기',
          style: AppTextStyles.heading1Bold.copyWith(
            color: AppColor.labelNormal,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '간단한 정보만 입력하면 바로 시작할 수 있어요',
          style: AppTextStyles.body2NormalRegular.copyWith(
            color: AppColor.labelAlternative,
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        // Email field
        _buildEmailField(),

        const SizedBox(height: 20),

        // Password field
        _buildPasswordField(),

        const SizedBox(height: 20),

        // Confirm password field
        _buildConfirmPasswordField(),
      ],
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
        hintText: '6자 이상 입력해주세요',
        errorText: controller.passwordError.value,
        obscureText: true,
        onChanged: controller.onPasswordChanged,
        prefixIcon: Icons.lock_outline,
      ),
    );
  }

  Widget _buildConfirmPasswordField() {
    return Obx(
      () => _buildTextField(
        label: '비밀번호 확인',
        hintText: '비밀번호를 다시 입력해주세요',
        errorText: controller.confirmPasswordError.value,
        obscureText: true,
        onChanged: controller.onConfirmPasswordChanged,
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

  Widget _buildSignUpButton() {
    return Obx(
      () => PrimaryButton(
        text: '회원가입',
        onPressed: controller.signUp,
        isLoading: controller.isLoading,
        isEnabled: controller.isFormValid,
      ),
    );
  }

  Widget _buildSignInLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '이미 계정이 있으신가요?',
          style: AppTextStyles.label1NormalRegular.copyWith(
            color: AppColor.labelAlternative,
          ),
        ),
        TextButton(
          onPressed: controller.goToSignIn,
          child: Text(
            '로그인',
            style: AppTextStyles.label1NormalMedium.copyWith(
              color: AppColor.primaryNormal,
            ),
          ),
        ),
      ],
    );
  }
}
