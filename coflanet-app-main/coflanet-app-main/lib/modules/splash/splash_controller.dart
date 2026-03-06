import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide LocalStorage;
import 'package:coflanet/core/base/base_controller.dart';
import 'package:coflanet/core/storage/local_storage.dart';
import 'package:coflanet/core/services/survey_service.dart';
import 'package:coflanet/data/repositories/repository_config.dart';
import 'package:coflanet/routes/app_pages.dart';

class SplashController extends BaseController {
  final LocalStorage _storage = Get.find<LocalStorage>();

  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
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

  // [DEV] Set to true to always go to survey intro for testing
  static const bool _devForceOnboarding = false;
  // [DEV] Set to true to reset login state (starts from SignIn)
  static const bool _devForceSignIn = false;
  // [DEV] Set to true to go directly to survey result for testing
  static const bool _devForceSurveyResult = false;
  // [DEV] Set to true to go directly to MainShell for UI testing
  static const bool _devForceMainShell = false;

  Future<void> _navigateToNextScreen() async {
    // [DEV] Direct navigation to MainShell for UI testing
    if (_devForceMainShell) {
      Get.offAllNamed(Routes.mainShell, arguments: {'initialTab': 0});
      return;
    }

    // [DEV] Direct navigation to survey result for UI testing
    if (_devForceSurveyResult) {
      _safeNavigate(Routes.surveyResult);
      return;
    }

    if (RepositoryConfig.dataSource == DataSource.supabase) {
      await _navigateSupabase();
    } else {
      _navigateLocal();
    }
  }

  /// Supabase mode: check Supabase Auth session
  Future<void> _navigateSupabase() async {
    final session = Supabase.instance.client.auth.currentSession;

    if (_devForceSignIn || session == null) {
      _safeNavigate(Routes.signIn);
      return;
    }

    // Session exists — check onboarding via server RPC
    bool isOnboardingComplete = false;
    if (!_devForceOnboarding) {
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
    final isLoggedIn = _devForceSignIn ? false : _storage.isLoggedIn;
    final isOnboardingComplete = _devForceOnboarding
        ? false
        : _storage.isOnboardingComplete;

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
