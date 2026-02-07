import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:coflanet/core/base/base_controller.dart';
import 'package:coflanet/core/storage/local_storage.dart';
import 'package:coflanet/routes/app_pages.dart';

class SplashController extends BaseController {
  // Use singleton directly instead of Get.find() to avoid timing issues
  final LocalStorage _storage = LocalStorage();

  @override
  void onInit() {
    super.onInit();
    debugPrint('[SplashController] onInit called');
    _initializeApp();
  }

  @override
  void onReady() {
    super.onReady();
    debugPrint('[SplashController] onReady called');
  }

  Future<void> _initializeApp() async {
    try {
      debugPrint('[SplashController] _initializeApp started');

      // Wait for 2 seconds to show splash screen
      await Future.delayed(const Duration(seconds: 2));
      debugPrint('[SplashController] Delay completed, navigating...');

      // Navigate based on login and onboarding status
      _navigateToNextScreen();
    } catch (e, stackTrace) {
      debugPrint('[SplashController] Error: $e');
      debugPrint('[SplashController] StackTrace: $stackTrace');
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

  void _navigateToNextScreen() {
    // [DEV] Direct navigation to survey result for UI testing
    if (_devForceSurveyResult) {
      debugPrint('[SplashController] DEV: Forcing SurveyResult');
      _safeNavigate(Routes.surveyResult);
      return;
    }

    final isLoggedIn = _devForceSignIn ? false : _storage.isLoggedIn;
    final isOnboardingComplete = _devForceOnboarding
        ? false
        : _storage.isOnboardingComplete;

    debugPrint('[SplashController] isLoggedIn: $isLoggedIn');
    debugPrint(
      '[SplashController] isOnboardingComplete: $isOnboardingComplete (devForce: $_devForceOnboarding)',
    );

    if (!isLoggedIn) {
      // Not logged in -> go to sign in
      debugPrint('[SplashController] Navigating to SignIn');
      _safeNavigate(Routes.signIn);
    } else if (!isOnboardingComplete) {
      // Logged in but onboarding not complete -> go to survey intro
      debugPrint('[SplashController] Navigating to SurveyIntro');
      _safeNavigate(Routes.surveyIntro);
    } else {
      // Logged in and onboarding complete -> go to home
      debugPrint('[SplashController] Navigating to Home');
      _safeNavigate(Routes.home);
    }
  }

  void _safeNavigate(String route) {
    // Navigate directly - the 2 second delay ensures the UI is ready
    debugPrint('[SplashController] Executing navigation to: $route');
    Get.offAllNamed(route);
  }
}
