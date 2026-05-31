import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide LocalStorage;
import 'package:coflanet/core/base/base_controller.dart';
import 'package:coflanet/core/services/auth_service.dart';
import 'package:coflanet/data/repositories/repository_config.dart';
import 'package:coflanet/routes/app_pages.dart';

class EmailLoginController extends BaseController {
  final AuthService _authService = Get.find<AuthService>();

  final email = ''.obs;
  final password = ''.obs;

  /// 입력 필드 컨트롤러 — 디버그 빌드에서 테스트 계정 prefill 에 사용
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  final emailError = Rxn<String>();
  final passwordError = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    _prefillDevCredentials();
  }

  @override
  void onClose() {
    emailTextController.dispose();
    passwordTextController.dispose();
    super.onClose();
  }

  /// 디버그 빌드에서만 .env 의 DEV_LOGIN_EMAIL / DEV_LOGIN_PASSWORD 를
  /// 입력 필드에 채워 테스트 로그인을 빠르게 한다. 키가 없으면 아무것도 안 함.
  /// 릴리스 빌드에서는 kDebugMode 가드로 완전히 비활성화된다.
  void _prefillDevCredentials() {
    if (!kDebugMode) return;
    final devEmail = dotenv.env['DEV_LOGIN_EMAIL'] ?? '';
    final devPassword = dotenv.env['DEV_LOGIN_PASSWORD'] ?? '';
    if (devEmail.isEmpty && devPassword.isEmpty) return;

    emailTextController.text = devEmail;
    passwordTextController.text = devPassword;
    email.value = devEmail;
    password.value = devPassword;
  }

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
    if (RepositoryConfig.isCiTest) {
      // Skip RPC in CI test mode — no real Supabase session
      Get.offAllNamed(Routes.surveyIntro);
      return;
    }
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
