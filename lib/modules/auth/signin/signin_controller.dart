import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    hide LocalStorage, AuthException;
import 'package:coflanet/constants/util_constant.dart';
import 'package:coflanet/core/base/base_controller.dart';
import 'package:coflanet/core/services/auth_service.dart';
import 'package:coflanet/core/services/survey_service.dart';
import 'package:coflanet/data/models/user_model.dart';
import 'package:coflanet/data/providers/auth_provider.dart';
import 'package:coflanet/data/repositories/repository_config.dart';
import 'package:coflanet/routes/app_pages.dart';

class SignInController extends BaseController {
  final AuthService _authService = Get.find<AuthService>();
  final SurveyService _surveyService = Get.find<SurveyService>();

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
    if (RepositoryConfig.isCiTest) {
      // Skip RPC in CI test mode — no real Supabase session
      Get.offAllNamed(Routes.profileSetup);
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
        // 이미 이름(닉네임)이 있는 사용자(재로그인/기가입)는 이름 입력 단계를
        // 건너뛰고 곧장 설문 흐름으로 보낸다. (이메일 로그인 경로와 동일하게 정렬)
        final hasNickname = result['has_nickname'] as bool? ?? false;
        if (hasNickname) {
          Get.offAllNamed(Routes.surveyIntro);
          return;
        }
        // 서버에 이름이 없지만 소셜 계정(카카오 등)이 이름(닉네임)을 제공하면,
        // 이름 입력 화면을 띄우지 않고 그 이름을 자동 저장한 뒤 다음 온보딩
        // 단계로 보낸다. (소셜 사용자가 이미 가진 이름을 다시 입력하지 않도록)
        final socialName = _authService.currentUser?.name?.trim();
        if (socialName != null && socialName.isNotEmpty) {
          try {
            await _surveyService.updateUserName(socialName);
            await _authService.updateUserName(socialName);
            final hasReasons = result['has_signup_reasons'] as bool? ?? false;
            // 이유 미선택(신규)이면 이유 선택부터, 선택돼 있으면 설문 인트로로.
            Get.offAllNamed(
              hasReasons ? Routes.surveyIntro : Routes.surveyReason,
            );
            return;
          } catch (e) {
            debugPrint('[SignIn] 소셜 이름 자동 저장 실패 — 이름 입력으로 폴백: $e');
            // 저장 실패 시 아래 프로필(이름) 설정 화면으로 폴백한다.
          }
        }
      }
    } catch (e) {
      debugPrint('[SignIn] get_onboarding_status error: $e');
    }
    // 이름 없음(신규·소셜 이름 미제공) 또는 상태 확인 실패 → 프로필(이름) 설정
    Get.offAllNamed(Routes.profileSetup);
  }

  /// Show error message via Snackbar
  void _showErrorSnackbar(String message) {
    setError(message);
    AppUtil.showErrorSnackbar('로그인 실패', message);
  }
}
