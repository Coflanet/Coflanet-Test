import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide LocalStorage;
import 'package:coflanet/app_binding.dart';
import 'package:coflanet/routes/app_pages.dart';
import 'package:coflanet/core/theme/app_theme.dart';
import 'package:coflanet/core/storage/local_storage.dart';
import 'package:coflanet/core/services/survey_service.dart';
import 'package:coflanet/core/services/auth_service.dart';
import 'package:coflanet/core/services/app_config_service.dart';
import 'package:coflanet/core/api/api_client.dart';
import 'package:coflanet/core/theme/theme_controller.dart';
import 'package:coflanet/core/config/social_login_config.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/data/repositories/repository_config.dart';
import 'package:coflanet/data/repositories/supabase/supabase_repository_base.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize local storage
  await LocalStorage().init();

  // Load .env and configure social login keys
  await dotenv.load(fileName: ".env");
  SocialLoginConfig.loadFromDotenv();

  // Initialize Social Login SDKs
  _initSocialLoginSdks();

  // Initialize Supabase (always — some controllers reference Supabase.instance directly)
  final supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
  final supabaseKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';
  if (supabaseUrl.isNotEmpty && supabaseKey.isNotEmpty) {
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);

    // Sync existing session to LocalStorage (supabase mode only)
    if (RepositoryConfig.dataSource == DataSource.supabase) {
      final session = Supabase.instance.client.auth.currentSession;
      if (session != null) {
        final localStorage = LocalStorage();
        await localStorage.saveAccessToken(session.accessToken);
        await localStorage.saveUserId(session.user.id);
        final meta = session.user.userMetadata;
        final displayName =
            meta?['display_name'] as String? ??
            meta?['full_name'] as String? ??
            meta?['name'] as String? ??
            meta?['preferred_username'] as String?;
        if (displayName != null && displayName.isNotEmpty) {
          await localStorage.saveUserName(displayName);
        }
      }
    }
  }

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

  // GetX 의 initialBinding 은 putAsync 를 await 하지 않아 SplashController 가
  // SurveyService 등록 전에 onInit 을 실행하면 "not found" 에러 발생.
  // runApp 전에 글로벌 의존성을 동기/await 로 명시 등록하여 타이밍 보장.
  Get.put<LocalStorage>(LocalStorage(), permanent: true);
  Get.put<ThemeController>(ThemeController(), permanent: true);
  Get.put<AuthService>(
    AuthService(
      config: AuthServiceConfig(
        useDummyProviders: SocialLoginConfig.useDummyProviders,
      ),
    ),
    permanent: true,
  );

  // Supabase repository 가 인증 만료(UNAUTHORIZED)를 감지하면 전역 재인증을
  // 트리거하도록 콜백 주입. 호출 시점에 find 하여 등록 순서와 무관하게 안전.
  SupabaseRepositoryBase.onAuthExpired = () async {
    if (Get.isRegistered<AuthService>()) {
      await Get.find<AuthService>().handleSessionExpired();
    }
  };
  await Get.putAsync<SurveyService>(
    () => SurveyService().init(),
    permanent: true,
  );
  await Get.putAsync<ApiClient>(() => ApiClient().init(), permanent: true);

  // AppConfigService 는 동기 등록만 한다. 실제 서버 로드(loadAll)는
  // SplashController 에서 await 한다 — runApp 이전(putAsync)에 로드하면
  // 네트워크 실패 시 재시도 UI 를 띄울 화면이 없기 때문.
  Get.put<AppConfigService>(AppConfigService(), permanent: true);

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
