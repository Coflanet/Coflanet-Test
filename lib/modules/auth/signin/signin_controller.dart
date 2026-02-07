import 'package:get/get.dart';
import 'package:coflanet/core/base/base_controller.dart';
import 'package:coflanet/core/storage/local_storage.dart';
import 'package:coflanet/routes/app_pages.dart';

enum SocialLoginType { kakao, naver, apple }

class SignInController extends BaseController {
  final LocalStorage _storage = Get.find<LocalStorage>();

  /// Handle social login
  Future<void> signInWithSocial(SocialLoginType type) async {
    await executeWithLoading(() async {
      // Simulate login delay
      await Future.delayed(const Duration(milliseconds: 1500));

      // TODO: Replace with actual social login implementation
      // For now, just save a dummy token
      switch (type) {
        case SocialLoginType.kakao:
          await _storage.saveAccessToken('kakao_dummy_token');
          await _storage.saveUserName('카카오 사용자');
          break;
        case SocialLoginType.naver:
          await _storage.saveAccessToken('naver_dummy_token');
          await _storage.saveUserName('네이버 사용자');
          break;
        case SocialLoginType.apple:
          await _storage.saveAccessToken('apple_dummy_token');
          await _storage.saveUserName('Apple 사용자');
          break;
      }

      await _storage.saveUserId(
        'user_${DateTime.now().millisecondsSinceEpoch}',
      );

      // Navigate to profile setup for name input
      Get.offAllNamed(Routes.profileSetup);
    });
  }

  /// Continue as guest
  Future<void> continueAsGuest() async {
    await executeWithLoading(() async {
      await Future.delayed(const Duration(milliseconds: 500));

      // Save guest token
      await _storage.saveAccessToken('guest_token');
      await _storage.saveUserName('게스트');
      await _storage.saveUserId(
        'guest_${DateTime.now().millisecondsSinceEpoch}',
      );

      // Navigate to profile setup for name input
      Get.offAllNamed(Routes.profileSetup);
    });
  }
}
