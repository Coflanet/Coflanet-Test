import 'package:get/get.dart';
import 'package:coflanet/core/storage/local_storage.dart';
import 'package:coflanet/core/api/api_client.dart';
import 'package:coflanet/core/theme/theme_controller.dart';
import 'package:coflanet/core/services/survey_service.dart';
import 'package:coflanet/core/services/auth_service.dart';
import 'package:coflanet/core/config/social_login_config.dart';

/// Global app bindings for dependency injection
class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Core services - LocalStorage must be initialized first (sync)
    Get.put<LocalStorage>(LocalStorage(), permanent: true);
    Get.put<ThemeController>(ThemeController(), permanent: true);

    // Auth service - uses SocialLoginConfig.useDummyProviders for configuration
    // To enable real social login SDKs:
    // 1. Set SocialLoginConfig.useDummyProviders = false
    // 2. Configure the platform-specific settings (see docs/SOCIAL_LOGIN_SETUP.md)
    Get.put<AuthService>(
      AuthService(
        config: AuthServiceConfig(
          useDummyProviders: SocialLoginConfig.useDummyProviders,
        ),
      ),
      permanent: true,
    );

    // Domain services
    Get.putAsync<SurveyService>(() => SurveyService().init(), permanent: true);

    // API Client - initialized asynchronously via GetxService
    // Must be after LocalStorage since it depends on token storage
    Get.putAsync<ApiClient>(() => ApiClient().init(), permanent: true);
  }
}
