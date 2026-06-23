import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/core/base/base_controller.dart';
import 'package:coflanet/core/services/auth_service.dart';
import 'package:coflanet/routes/app_pages.dart';

class SignUpController extends BaseController {
  final AuthService _authService = Get.find<AuthService>();

  // Step management (0: terms, 1: email, 2: password, 3: confirmPassword)
  static const int totalSteps = 4;
  final _currentStep = 0.obs;
  int get currentStep => _currentStep.value;

  double get progress => (_currentStep.value + 1) / totalSteps;

  // Text controllers
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();

  // Form fields
  final email = ''.obs;
  final password = ''.obs;
  final confirmPassword = ''.obs;

  // Field-specific error messages
  final emailError = Rxn<String>();
  final passwordError = Rxn<String>();
  final confirmPasswordError = Rxn<String>();

  // Terms acceptance
  final termsAll = false.obs;
  final termsService = false.obs;
  final termsServiceOptional = false.obs;
  final termsPrivacy = false.obs;
  final termsAge = false.obs;

  bool get isRequiredTermsAccepted =>
      termsService.value && termsPrivacy.value && termsAge.value;

  // Password visibility
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;

  // Per-step validation
  bool get isCurrentStepValid {
    return switch (currentStep) {
      0 => isRequiredTermsAccepted,
      1 => email.value.isNotEmpty && _validateEmail(email.value) == null,
      2 =>
        password.value.isNotEmpty && _validatePassword(password.value) == null,
      3 =>
        confirmPassword.value.isNotEmpty &&
            _validateConfirmPassword(confirmPassword.value) == null,
      _ => false,
    };
  }

  String get currentButtonText {
    return switch (currentStep) {
      0 => '다음',
      1 => '확인',
      2 => '다음',
      3 => '확인',
      _ => '확인',
    };
  }

  @override
  void onInit() {
    super.onInit();
    emailTextController.addListener(() {
      email.value = emailTextController.text;
      if (email.value.isNotEmpty) {
        emailError.value = _validateEmail(email.value);
      } else {
        emailError.value = null;
      }
    });
    passwordTextController.addListener(() {
      password.value = passwordTextController.text;
      if (password.value.isNotEmpty) {
        passwordError.value = _validatePassword(password.value);
      } else {
        passwordError.value = null;
      }
    });
    confirmPasswordTextController.addListener(() {
      confirmPassword.value = confirmPasswordTextController.text;
      if (confirmPassword.value.isNotEmpty) {
        confirmPasswordError.value = _validateConfirmPassword(
          confirmPassword.value,
        );
      } else {
        confirmPasswordError.value = null;
      }
    });
  }

  @override
  void onClose() {
    emailTextController.dispose();
    passwordTextController.dispose();
    confirmPasswordTextController.dispose();
    super.onClose();
  }

  // --- Terms ---

  void toggleAll(bool? value) {
    final v = value ?? false;
    termsAll.value = v;
    termsService.value = v;
    termsServiceOptional.value = v;
    termsPrivacy.value = v;
    termsAge.value = v;
  }

  void toggleTerm(RxBool term, bool? value) {
    term.value = value ?? false;
    _syncAllCheckbox();
  }

  void _syncAllCheckbox() {
    termsAll.value =
        termsService.value &&
        termsServiceOptional.value &&
        termsPrivacy.value &&
        termsAge.value;
  }

  // --- Validation ---

  String? _validateEmail(String value) {
    if (value.isEmpty) return '이메일을 입력해주세요';
    final emailRegex = RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return '올바른 이메일 형식이 아닙니다';
    return null;
  }

  String? _validatePassword(String value) {
    if (value.isEmpty) return '비밀번호를 입력해주세요';
    if (value.length < 8 || value.length > 20) {
      return '8~20자 이내로 입력해주세요';
    }
    if (!RegExp(r'[a-z]').hasMatch(value) ||
        !RegExp(r'[A-Z]').hasMatch(value)) {
      return '대소문자를 포함해주세요';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return '숫자를 포함해주세요';
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return '특수문자를 포함해주세요';
    }
    return null;
  }

  String? _validateConfirmPassword(String value) {
    if (value.isEmpty) return '비밀번호를 다시 입력해주세요';
    if (value != password.value) return '비밀번호가 일치하지 않습니다';
    return null;
  }

  // --- Navigation ---

  void nextStep() {
    if (!isCurrentStepValid) return;

    if (currentStep < totalSteps - 1) {
      _currentStep.value++;
    } else {
      _submitSignUp();
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      _currentStep.value--;
    } else {
      Get.back();
    }
  }

  // --- Submit ---

  Future<void> _submitSignUp() async {
    await executeWithLoading(() async {
      try {
        await _authService.signUpWithEmail(email.value, password.value);
        // Figma 완료 페이지 활용: signup → signup_complete → profileSetup
        Get.offNamed(Routes.signUpComplete);
      } catch (e) {
        debugPrint('[SignUp] signUpWithEmail error: $e');
        final message = e.toString();
        if (message.contains('already registered') ||
            message.contains('already exists')) {
          emailError.value = '이미 가입된 이메일입니다';
          _currentStep.value = 1;
        } else if (message.contains('rate limit') || message.contains('429')) {
          emailError.value = '요청이 너무 많습니다. 잠시 후 다시 시도해주세요.';
          _currentStep.value = 1;
        } else {
          emailError.value = '회원가입에 실패했습니다. 다시 시도해주세요.';
          _currentStep.value = 1;
        }
      }
    });
  }

  void goToSignIn() {
    Get.offNamed(Routes.emailLogin);
  }
}
