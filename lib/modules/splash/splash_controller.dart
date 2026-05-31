import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide LocalStorage;
import 'package:coflanet/core/base/base_controller.dart';
import 'package:coflanet/core/storage/local_storage.dart';
import 'package:coflanet/core/services/survey_service.dart';
import 'package:coflanet/core/services/app_config_service.dart';
import 'package:coflanet/data/repositories/repository_config.dart';
import 'package:coflanet/routes/app_pages.dart';

class SplashController extends BaseController {
  final LocalStorage _storage = Get.find<LocalStorage>();
  final AppConfigService _config = Get.find<AppConfigService>();

  /// View 에서 로드 상태/재시도 UI 를 구독하기 위한 노출
  AppConfigService get config => _config;

  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // 전역 상수(lookup) 프리로드. 실패하면 error 상태로 두고 중단한다.
      // (SplashView 가 '다시 시도' UI 를 표시하고, retry() 로 재진입)
      await _config.loadAll();
      if (_config.hasError) return;

      // Wait for 2 seconds to show splash screen
      await Future.delayed(const Duration(seconds: 2));

      // Navigate based on login and onboarding status
      await _navigateToNextScreen();
    } catch (e, stackTrace) {
      // Keep error logging for debugging critical issues
      if (kDebugMode) {
        debugPrint('[SplashController] Error: $e');
        debugPrint('[SplashController] StackTrace: $stackTrace');
      }
      // Fallback: go to sign in on error
      _safeNavigate(Routes.signIn);
    }
  }

  /// 프리로드 실패 후 사용자가 '다시 시도' 를 눌렀을 때 재로드한다.
  Future<void> retry() async {
    await _config.loadAll();
    if (_config.isReady) {
      await _navigateToNextScreen();
    }
  }

  Future<void> _navigateToNextScreen() async {
    // 로그인/세션 상태를 검사해 다음 화면을 결정한다.
    if (RepositoryConfig.dataSource == DataSource.supabase) {
      await _navigateSupabase();
    } else {
      _navigateLocal();
    }
  }

  /// Supabase mode: check Supabase Auth session
  Future<void> _navigateSupabase() async {
    final session = Supabase.instance.client.auth.currentSession;

    // 유효한 세션이 없으면 로그인 화면으로
    if (session == null) {
      _safeNavigate(Routes.signIn);
      return;
    }

    // Session exists — check onboarding via server RPC
    bool isOnboardingComplete = false;
    if (RepositoryConfig.isCiTest) {
      isOnboardingComplete = _storage.isOnboardingComplete;
    } else {
      try {
        final result = await Supabase.instance.client.rpc(
          'get_onboarding_status',
        );
        if (result is Map<String, dynamic>) {
          isOnboardingComplete =
              result['has_completed_survey'] as bool? ?? false;
        }
      } catch (e) {
        debugPrint('[SplashController] get_onboarding_status error: $e');
        isOnboardingComplete = _storage.isOnboardingComplete;
      }
    }

    // Refresh user data (userName, surveyResult) before navigating
    try {
      await Get.find<SurveyService>().refresh();
    } catch (e) {
      debugPrint('[SplashController] SurveyService refresh error: $e');
    }

    if (!isOnboardingComplete) {
      _safeNavigate(Routes.surveyIntro);
    } else {
      Get.offAllNamed(Routes.mainShell, arguments: {'initialTab': 0});
    }
  }

  /// Local/Dummy mode: check LocalStorage
  void _navigateLocal() {
    final isLoggedIn = _storage.isLoggedIn;
    final isOnboardingComplete = _storage.isOnboardingComplete;

    if (!isLoggedIn) {
      // Not logged in -> go to sign in
      _safeNavigate(Routes.signIn);
    } else if (!isOnboardingComplete) {
      // Logged in but onboarding not complete -> go to survey intro
      _safeNavigate(Routes.surveyIntro);
    } else {
      // Logged in and onboarding complete -> go to main shell (원두 탭)
      // Per Figma: MainShell (Select Coffee Section) is the Home
      Get.offAllNamed(Routes.mainShell, arguments: {'initialTab': 0});
    }
  }

  void _safeNavigate(String route) {
    Get.offAllNamed(route);
  }
}
