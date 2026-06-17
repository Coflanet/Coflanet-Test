import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide LocalStorage;
import 'package:coflanet/app_binding.dart';
import 'package:coflanet/routes/app_pages.dart';
import 'package:coflanet/core/theme/app_theme.dart';
import 'package:coflanet/core/storage/local_storage.dart';
import 'package:coflanet/core/services/survey_service.dart';
import 'package:coflanet/core/services/auth_service.dart';
import 'package:coflanet/core/services/app_config_service.dart';
import 'package:coflanet/core/services/notification_service.dart';
import 'package:coflanet/core/services/cart_service.dart';
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
  await _initSocialLoginSdks();

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

  // 시스템 UI 오버레이는 테마에 따라 달라지므로 여기서 고정하지 않고
  // CoflanetApp.builder 의 AnnotatedRegion 에서 테마 반응형으로 적용한다.

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

  // 알림/장바구니 전역 서비스 — 헤더 dot/뱃지의 단일 소스. 로컬 영속만 사용.
  Get.put<NotificationService>(NotificationService(), permanent: true);
  Get.put<CartService>(CartService(), permanent: true);

  runApp(const CoflanetApp());
}

class CoflanetApp extends StatelessWidget {
  const CoflanetApp({super.key});

  /// 라이트 테마용 시스템 UI 오버레이 (상태바 어두운 아이콘 + 흰 내비바)
  static const SystemUiOverlayStyle _lightOverlay = SystemUiOverlayStyle(
    statusBarColor: AppColor.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: AppColor.colorGlobalCommon100,
    systemNavigationBarIconBrightness: Brightness.dark,
  );

  /// 다크 테마용 시스템 UI 오버레이 (상태바 밝은 아이콘 + 검정 내비바)
  static const SystemUiOverlayStyle _darkOverlay = SystemUiOverlayStyle(
    statusBarColor: AppColor.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: AppColor.colorGlobalCommon0,
    systemNavigationBarIconBrightness: Brightness.light,
  );

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return GetMaterialApp(
      title: 'Coflanet',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      // 저장된 모드로 시작, 이후 변경은 ThemeController.setMode →
      // Get.changeThemeMode 가 반영 (이전에는 system 고정과 저장값이 충돌)
      themeMode: themeController.themeMode,
      initialBinding: AppBinding(),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      defaultTransition: Transition.cupertino,
      locale: const Locale('ko', 'KR'),
      fallbackLocale: const Locale('ko', 'KR'),
      builder: (context, child) {
        return Obx(() {
          // 모드 + OS 밝기 기준으로 유효 테마를 계산해 시스템 UI 동기화
          final platformBrightness = MediaQuery.platformBrightnessOf(context);
          final isDark = switch (themeController.mode) {
            AppThemeMode.dark => true,
            AppThemeMode.light => false,
            AppThemeMode.system => platformBrightness == Brightness.dark,
          };
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: isDark ? _darkOverlay : _lightOverlay,
            child: MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: const TextScaler.linear(1.0)),
              child: child!,
            ),
          );
        });
      },
    );
  }
}

Future<void> _initSocialLoginSdks() async {
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

  // 네이버 SDK 명시 초기화.
  // flutter_naver_login 2.1.1 의 Dart API(FlutterNaverLogin)는 initSdk 를
  // 노출하지 않으므로 네이티브 메서드 채널로 직접 초기화한다. 네이티브 manifest
  // meta-data 자동 초기화가 비어 있을 때(키 미주입)에도 Dart 설정(.env) 값으로
  // SDK 를 초기화해, 로그인 시 'SDK 초기화 필요' 에러로 막히는 것을 방지한다.
  if (SocialLoginConfig.isNaverConfigured) {
    try {
      await FlutterNaverLogin.channel.invokeMethod('initSdk', {
        'clientId': SocialLoginConfig.naverClientId,
        'clientSecret': SocialLoginConfig.naverClientSecret,
        'clientName': SocialLoginConfig.naverClientName,
      });
    } catch (e) {
      debugPrint('[main] 네이버 SDK 초기화 실패: $e');
    }
  }

  SocialLoginConfig.printConfigStatus();
}
