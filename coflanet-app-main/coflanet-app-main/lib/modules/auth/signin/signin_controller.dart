import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    hide LocalStorage, AuthException;
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/core/base/base_controller.dart';
import 'package:coflanet/core/services/auth_service.dart';
import 'package:coflanet/data/models/user_model.dart';
import 'package:coflanet/data/providers/auth_provider.dart';
import 'package:coflanet/routes/app_pages.dart';

class SignInController extends BaseController {
  final AuthService _authService = Get.find<AuthService>();

  /// Handle social login
  Future<void> signInWithSocial(SocialLoginType type) async {
    try {
      isLoading = true;
      clearError();

      await _authService.signIn(type);
      await _navigateAfterLogin();
    } on AuthException catch (e) {
      _showErrorSnackbar(e.message);
    } catch (e) {
      _showErrorSnackbar('로그인 중 오류가 발생했습니다: ${e.toString()}');
    } finally {
      isLoading = false;
    }
  }

  /// Continue as guest (always new → profile setup)
  Future<void> continueAsGuest() async {
    try {
      isLoading = true;
      clearError();

      await _authService.continueAsGuest();
      Get.toNamed(Routes.profileSetup);
    } catch (e) {
      _showErrorSnackbar('게스트 로그인 중 오류가 발생했습니다.');
    } finally {
      isLoading = false;
    }
  }

  /// Check onboarding status and navigate accordingly
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
      debugPrint('[SignIn] get_onboarding_status error: $e');
    }
    // 온보딩 미완료 → 프로필 설정
    Get.offAllNamed(Routes.profileSetup);
  }

  /// Show error message via Snackbar
  void _showErrorSnackbar(String message) {
    setError(message);
    Get.snackbar(
      '로그인 실패',
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
