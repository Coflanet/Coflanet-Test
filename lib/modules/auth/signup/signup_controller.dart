import 'package:get/get.dart';
import 'package:coflanet/core/base/base_controller.dart';
import 'package:coflanet/core/storage/local_storage.dart';
import 'package:coflanet/routes/app_pages.dart';

class SignUpController extends BaseController {
  final LocalStorage _storage = Get.find<LocalStorage>();

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

  /// Update email and validate
  void onEmailChanged(String value) {
    email.value = value;
    emailError.value = null;
  }

  /// Update password and validate
  void onPasswordChanged(String value) {
    password.value = value;
    passwordError.value = null;
    // Re-validate confirm password if already entered
    if (confirmPassword.value.isNotEmpty) {
      confirmPasswordError.value = _validateConfirmPassword(
        confirmPassword.value,
      );
    }
  }

  /// Update confirm password and validate
  void onConfirmPasswordChanged(String value) {
    confirmPassword.value = value;
    confirmPasswordError.value = null;
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
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 1500));

      // TODO: Replace with actual sign up API implementation
      // For now, save dummy token
      await _storage.saveAccessToken(
        'email_signup_token_${DateTime.now().millisecondsSinceEpoch}',
      );
      await _storage.saveUserId(
        'user_${DateTime.now().millisecondsSinceEpoch}',
      );
      final userName = email.value.split('@').first;
      await _storage.saveUserName(userName);

      // Navigate to sign up complete page
      Get.offNamed(Routes.signUpComplete, arguments: {'userName': userName});
    });
  }

  /// Navigate back to sign in
  void goToSignIn() {
    Get.back();
  }
}
