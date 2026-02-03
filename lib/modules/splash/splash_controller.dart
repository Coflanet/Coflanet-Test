import 'package:get/get.dart';
import 'package:coflanet/core/base/base_controller.dart';
import 'package:coflanet/core/storage/local_storage.dart';
import 'package:coflanet/routes/app_pages.dart';

class SplashController extends BaseController {
  final LocalStorage _storage = Get.find<LocalStorage>();

  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Wait for 2 seconds to show splash screen
    await Future.delayed(const Duration(seconds: 2));

    // Navigate based on login and onboarding status
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    if (!_storage.isLoggedIn) {
      // Not logged in -> go to sign in
      Get.offAllNamed(Routes.signIn);
    } else if (!_storage.isOnboardingComplete) {
      // Logged in but onboarding not complete -> go to survey intro
      Get.offAllNamed(Routes.surveyIntro);
    } else {
      // Logged in and onboarding complete -> go to home
      Get.offAllNamed(Routes.home);
    }
  }
}
