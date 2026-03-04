import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide LocalStorage;
import 'package:coflanet/core/base/base_controller.dart';
import 'package:coflanet/core/services/auth_service.dart';
import 'package:coflanet/routes/app_pages.dart';

class EmailLoginController extends BaseController {
  final AuthService _authService = Get.find<AuthService>();

  final email = ''.obs;
  final password = ''.obs;

  final emailError = Rxn<String>();
  final passwordError = Rxn<String>();

  bool get isFormValid =>
      email.value.isNotEmpty &&
      password.value.isNotEmpty &&
      email.value.contains('@');

  void onEmailChanged(String value) {
    email.value = value;
    emailError.value = null;
  }

  void onPasswordChanged(String value) {
    password.value = value;
    passwordError.value = null;
  }

  Future<void> signIn() async {
    if (email.value.isEmpty) {
      emailError.value = '이메일을 입력해주세요';
      return;
    }
    if (password.value.isEmpty) {
      passwordError.value = '비밀번호를 입력해주세요';
      return;
    }

    await executeWithLoading(() async {
      try {
        await _authService.signInWithEmail(email.value, password.value);
        await _navigateAfterLogin();
      } catch (e) {
        debugPrint('[EmailLogin] signInWithEmail error: $e');
        final message = e.toString();
        if (message.contains('Invalid login credentials') ||
            message.contains('invalid_credentials')) {
          passwordError.value = '이메일 또는 비밀번호가 올바르지 않습니다';
        } else if (message.contains('Email not confirmed')) {
          emailError.value = '이메일 인증이 완료되지 않았습니다';
        } else if (message.contains('rate limit') || message.contains('429')) {
          emailError.value = '요청이 너무 많습니다. 잠시 후 다시 시도해주세요.';
        } else {
          emailError.value = '로그인에 실패했습니다. 다시 시도해주세요.';
        }
      }
    });
  }

  /// 온보딩 완료 여부에 따라 적절한 화면으로 이동
  Future<void> _navigateAfterLogin() async {
    try {
      final result = await Supabase.instance.client.rpc(
        'get_onboarding_status',
      );
      if (result is Map<String, dynamic>) {
        final completed = result['has_completed_survey'] as bool? ?? false;
        if (completed) {
          Get.offAllNamed(Routes.mainShell, arguments: {'initialTab': 0});
          return;
        }
      }
    } catch (e) {
      debugPrint('[EmailLogin] get_onboarding_status error: $e');
    }
    // 온보딩 미완료 → 설문 인트로
    Get.offAllNamed(Routes.surveyIntro);
  }

  void goToSignUp() {
    Get.offNamed(Routes.emailSignUp);
  }
}
