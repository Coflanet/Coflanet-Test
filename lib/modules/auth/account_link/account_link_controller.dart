import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/core/base/base_controller.dart';
import 'package:coflanet/core/services/auth_service.dart';
import 'package:coflanet/data/models/user_model.dart';
import 'package:coflanet/data/providers/auth_provider.dart';

class AccountLinkController extends BaseController {
  final AuthService _authService = Get.find<AuthService>();

  // 이메일 입력
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _emailError = Rxn<String>();
  String? get emailError => _emailError.value;

  final _passwordError = Rxn<String>();
  String? get passwordError => _passwordError.value;

  bool get isFormValid =>
      emailController.text.isNotEmpty && passwordController.text.length >= 6;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  /// 소셜 계정으로 연동
  Future<void> linkWithSocial(SocialLoginType type) async {
    try {
      isLoading = true;
      clearError();
      await _authService.linkWithSocial(type);
      Get.back();
      Get.snackbar(
        '완료',
        '계정이 연결되었습니다',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColor.primaryNormal.withValues(alpha: 0.9),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } on AuthException catch (e) {
      _showError(e.message);
    } catch (e) {
      _showError('계정 연결에 실패했습니다');
    } finally {
      isLoading = false;
    }
  }

  /// 이메일 계정으로 연동
  Future<void> linkWithEmail() async {
    _emailError.value = null;
    _passwordError.value = null;

    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || !GetUtils.isEmail(email)) {
      _emailError.value = '올바른 이메일을 입력해주세요';
      return;
    }
    if (password.length < 6) {
      _passwordError.value = '비밀번호는 6자 이상이어야 합니다';
      return;
    }

    try {
      isLoading = true;
      clearError();
      await _authService.linkWithEmail(email, password);
      Get.back();
      Get.snackbar(
        '완료',
        '이메일 계정이 연결되었습니다',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColor.primaryNormal.withValues(alpha: 0.9),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } on AuthException catch (e) {
      _showError(e.message);
    } catch (e) {
      _showError('계정 연결에 실패했습니다');
    } finally {
      isLoading = false;
    }
  }

  void _showError(String message) {
    setError(message);
    Get.snackbar(
      '연결 실패',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColor.statusNegative.withValues(alpha: 0.9),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 4),
      icon: const Icon(Icons.error_outline, color: Colors.white),
    );
  }
}
