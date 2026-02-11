import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:coflanet/core/storage/local_storage.dart';
import 'package:coflanet/core/network/api_client.dart';
import 'package:coflanet/core/theme/theme_controller.dart';
import 'package:coflanet/core/services/survey_service.dart';
import 'package:coflanet/core/services/auth_service.dart';

/// Global app bindings for dependency injection
class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Core services
    Get.put<LocalStorage>(LocalStorage(), permanent: true);
    Get.put<ApiClient>(ApiClient(), permanent: true);
    Get.put<ThemeController>(ThemeController(), permanent: true);

    // Auth service - uses dummy providers in debug mode, real SDKs in release
    // To enable real social login SDKs, set useDummyProviders to false
    // and configure the platform-specific settings (see SOCIAL_LOGIN_GUIDE.md)
    Get.put<AuthService>(
      AuthService(
        config: AuthServiceConfig(
          useDummyProviders: kDebugMode, // false for production
        ),
      ),
      permanent: true,
    );

    // Domain services
    Get.put<SurveyService>(SurveyService(), permanent: true);

    // Initialize API client
    Get.find<ApiClient>().init();
  }
}
