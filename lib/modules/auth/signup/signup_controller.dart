import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:coflanet/core/base/base_controller.dart';
import 'package:coflanet/core/services/auth_service.dart';
import 'package:coflanet/routes/app_pages.dart';

class SignUpController extends BaseController {
  final AuthService _authService = Get.find<AuthService>();

  // Form fields
  final email = ''.obs;
  final password = ''.obs;
  final confirmPassword = ''.obs;

  // Field-specific error messages
  final emailError = Rxn<String>();
  final passwordError = Rxn<String>();
  final confirmPasswordError = Rxn<String>();

  // Validation states
  bool get isEmailValid => _validateEmail(email.value) == null;
  bool get isPasswordValid => _validatePassword(password.value) == null;
  bool get isConfirmPasswordValid =>
      _validateConfirmPassword(confirmPassword.value) == null;

  bool get isFormValid =>
      email.value.isNotEmpty &&
      password.value.isNotEmpty &&
      confirmPassword.value.isNotEmpty &&
      isEmailValid &&
      isPasswordValid &&
      isConfirmPasswordValid;

  /// Validate email format
  String? _validateEmail(String value) {
    if (value.isEmpty) {
      return '이메일을 입력해주세요';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return '올바른 이메일 형식이 아닙니다';
    }
    return null;
  }

  /// Validate password (minimum 6 characters)
  String? _validatePassword(String value) {
    if (value.isEmpty) {
      return '비밀번호를 입력해주세요';
    }
    if (value.length < 6) {
      return '비밀번호는 6자 이상이어야 합니다';
    }
    return null;
  }

  /// Validate confirm password matches
  String? _validateConfirmPassword(String value) {
    if (value.isEmpty) {
      return '비밀번호 확인을 입력해주세요';
    }
    if (value != password.value) {
      return '비밀번호가 일치하지 않습니다';
    }
    return null;
  }

  /// Update email and validate in real-time
  void onEmailChanged(String value) {
    email.value = value;
    // 입력 중일 때는 빈 값이면 에러 숨김, 값이 있으면 실시간 검증
    if (value.isEmpty) {
      emailError.value = null;
    } else {
      emailError.value = _validateEmail(value);
    }
  }

  /// Update password and validate in real-time
  void onPasswordChanged(String value) {
    password.value = value;
    if (value.isEmpty) {
      passwordError.value = null;
    } else {
      passwordError.value = _validatePassword(value);
    }
    // Re-validate confirm password if already entered
    if (confirmPassword.value.isNotEmpty) {
      confirmPasswordError.value = _validateConfirmPassword(
        confirmPassword.value,
      );
    }
  }

  /// Update confirm password and validate in real-time
  void onConfirmPasswordChanged(String value) {
    confirmPassword.value = value;
    if (value.isEmpty) {
      confirmPasswordError.value = null;
    } else {
      confirmPasswordError.value = _validateConfirmPassword(value);
    }
  }

  /// Validate all fields and show errors
  bool validateAll() {
    emailError.value = _validateEmail(email.value);
    passwordError.value = _validatePassword(password.value);
    confirmPasswordError.value = _validateConfirmPassword(
      confirmPassword.value,
    );

    return emailError.value == null &&
        passwordError.value == null &&
        confirmPasswordError.value == null;
  }

  /// Handle sign up
  Future<void> signUp() async {
    if (!validateAll()) return;

    await executeWithLoading(() async {
      try {
        await _authService.signUpWithEmail(email.value, password.value);
        // Navigate to profile setup (name input → survey reason → complete)
        Get.offNamed(Routes.profileSetup);
      } catch (e) {
        debugPrint('[SignUp] signUpWithEmail error: $e');
        final message = e.toString();
        if (message.contains('already registered') ||
            message.contains('already exists')) {
          emailError.value = '이미 가입된 이메일입니다';
        } else if (message.contains('rate limit') || message.contains('429')) {
          emailError.value = '요청이 너무 많습니다. 잠시 후 다시 시도해주세요.';
        } else if (message.contains('email_address_invalid') ||
            message.contains('invalid')) {
          emailError.value = '유효하지 않은 이메일 주소입니다';
        } else {
          emailError.value = '회원가입에 실패했습니다. 다시 시도해주세요.';
        }
      }
    });
  }

  /// Navigate to email login
  void goToSignIn() {
    Get.offNamed(Routes.emailLogin);
  }
}
