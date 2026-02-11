import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:coflanet/app_binding.dart';
import 'package:coflanet/routes/app_pages.dart';
import 'package:coflanet/core/theme/app_theme.dart';
import 'package:coflanet/core/storage/local_storage.dart';
import 'package:coflanet/core/config/social_login_config.dart';
import 'package:coflanet/constants/color_constant.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize local storage
  await LocalStorage().init();

  // Initialize Social Login SDKs
  _initSocialLoginSdks();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppColor.staticLabelWhiteStrong,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const CoflanetApp());
}

class CoflanetApp extends StatelessWidget {
  const CoflanetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Coflanet',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      initialBinding: AppBinding(),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      defaultTransition: Transition.cupertino,
      locale: const Locale('ko', 'KR'),
      fallbackLocale: const Locale('ko', 'KR'),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(1.0)),
          child: child!,
        );
      },
    );
  }
}

void _initSocialLoginSdks() {
  if (SocialLoginConfig.useDummyProviders) {
    SocialLoginConfig.printConfigStatus();
    return;
  }

  if (SocialLoginConfig.isKakaoConfigured) {
    KakaoSdk.init(
      nativeAppKey: SocialLoginConfig.kakaoNativeAppKey,
      javaScriptAppKey: SocialLoginConfig.kakaoJavaScriptAppKey.isNotEmpty
          ? SocialLoginConfig.kakaoJavaScriptAppKey
          : null,
    );
  }

  SocialLoginConfig.printConfigStatus();
}
