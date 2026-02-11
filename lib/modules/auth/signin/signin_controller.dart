import 'package:get/get.dart';
import 'package:coflanet/core/base/base_controller.dart';
import 'package:coflanet/core/services/auth_service.dart';
import 'package:coflanet/data/models/user_model.dart';
import 'package:coflanet/data/providers/auth_provider.dart';
import 'package:coflanet/routes/app_pages.dart';

class SignInController extends BaseController {
  final AuthService _authService = Get.find<AuthService>();

  /// Handle social login
  Future<void> signInWithSocial(SocialLoginType type) async {
    await executeWithLoading(() async {
      await _authService.signIn(type);
      // Navigate to profile setup for name input
      Get.offAllNamed(Routes.profileSetup);
    });
  }

  /// Continue as guest
  Future<void> continueAsGuest() async {
    await executeWithLoading(() async {
      await _authService.continueAsGuest();
      // Navigate to profile setup for name input
      Get.offAllNamed(Routes.profileSetup);
    });
  }
}
