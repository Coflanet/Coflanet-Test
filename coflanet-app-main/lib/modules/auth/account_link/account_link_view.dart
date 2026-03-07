import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/data/providers/auth_provider.dart';
import 'package:coflanet/modules/auth/account_link/account_link_controller.dart';
import 'package:coflanet/widgets/buttons/social_button.dart';

class AccountLinkView extends GetView<AccountLinkController> {
  const AccountLinkView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundNormalNormal,
      appBar: AppBar(
        backgroundColor: AppColor.backgroundNormalNormal,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColor.labelNormal),
          onPressed: () => Get.back(),
        ),
        title: Text(
          '계정 연결',
          style: AppTextStyles.headline1Bold.copyWith(
            color: AppColor.labelNormal,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Obx(() {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 32),
                Text(
                  '게스트 데이터를 유지하면서\n계정을 연결합니다',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.title3Bold.copyWith(
                    color: AppColor.labelNormal,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '연결 후에도 기존 데이터가 그대로 유지됩니다',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body1NormalRegular.copyWith(
                    color: AppColor.labelAlternative,
                  ),
                ),
                const SizedBox(height: 48),

                // 소셜 로그인 버튼
                SocialButton(
                  type: SocialButtonType.kakao,
                  onPressed: controller.isLoading
                      ? null
                      : () => controller.linkWithSocial(SocialLoginType.kakao),
                  isLoading: controller.isLoading,
                ),
                const SizedBox(height: 12),
                SocialButton(
                  type: SocialButtonType.naver,
                  onPressed: controller.isLoading
                      ? null
                      : () => controller.linkWithSocial(SocialLoginType.naver),
                  isLoading: controller.isLoading,
                ),
                if (Platform.isIOS) ...[
                  const SizedBox(height: 12),
                  SocialButton(
                    type: SocialButtonType.apple,
                    onPressed: controller.isLoading
                        ? null
                        : () =>
                              controller.linkWithSocial(SocialLoginType.apple),
                    isLoading: controller.isLoading,
                  ),
                ],

                const SizedBox(height: 32),

                // 구분선
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: AppColor.lineNormalNeutral,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '또는',
                        style: AppTextStyles.caption1Regular.copyWith(
                          color: AppColor.labelAlternative,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: AppColor.lineNormalNeutral,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // 이메일 연동 폼
                _buildTextField(
                  controller: controller.emailController,
                  label: '이메일',
                  hint: 'example@email.com',
                  keyboardType: TextInputType.emailAddress,
                  error: controller.emailError,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  controller: controller.passwordController,
                  label: '비밀번호',
                  hint: '6자 이상 입력',
                  obscureText: true,
                  error: controller.passwordError,
                ),
                const SizedBox(height: 24),

                // 이메일로 연결 버튼
                GestureDetector(
                  onTap: controller.isLoading
                      ? null
                      : () => controller.linkWithEmail(),
                  child: Container(
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColor.primaryNormal,
                      borderRadius: AppRadius.lgBorder,
                    ),
                    child: Center(
                      child: controller.isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              '이메일로 연결',
                              style: AppTextStyles.headline2Bold.copyWith(
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 48),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? error,
  }) {
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
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: AppTextStyles.body1NormalRegular.copyWith(
            color: AppColor.labelNormal,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.body1NormalRegular.copyWith(
              color: AppColor.labelDisable,
            ),
            filled: true,
            fillColor: AppColor.componentFillNormal,
            border: OutlineInputBorder(
              borderRadius: AppRadius.lgBorder,
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            errorText: error,
          ),
        ),
      ],
    );
  }
}
