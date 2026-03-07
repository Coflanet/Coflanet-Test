import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Social Login SDK Configuration
///
/// API 키와 설정을 중앙에서 관리합니다.
/// .env 파일에서 런타임에 키를 로드합니다.
///
/// ## 보안 주의사항
/// - 이 파일에 실제 API 키를 하드코딩하지 마세요.
/// - .env 파일이나 --dart-define을 사용하여 키를 주입하세요.
/// - 이 파일은 git에 커밋되어도 안전하도록 플레이스홀더만 포함합니다.
class SocialLoginConfig {
  SocialLoginConfig._();

  // ============================================================
  // 전역 설정
  // ============================================================

  /// 더미 프로바이더 사용 여부
  /// true: 개발용 더미 로그인 (SDK 없이 테스트)
  /// false: 실제 소셜 로그인 SDK 사용
  static bool useDummyProviders = true;

  // ============================================================
  // Kakao SDK 설정
  // ============================================================

  /// Kakao Native App Key
  /// Kakao Developers > 내 애플리케이션 > 앱 키 > 네이티브 앱 키
  /// https://developers.kakao.com/console/app
  static String kakaoNativeAppKey = const String.fromEnvironment(
    'KAKAO_NATIVE_APP_KEY',
    defaultValue: '',
  );

  /// Kakao JavaScript App Key (웹에서 사용 시)
  static String kakaoJavaScriptAppKey = const String.fromEnvironment(
    'KAKAO_JAVASCRIPT_APP_KEY',
    defaultValue: '',
  );

  /// Kakao SDK 초기화 여부 확인
  static bool get isKakaoConfigured => kakaoNativeAppKey.isNotEmpty;

  // ============================================================
  // Naver SDK 설정
  // ============================================================

  /// Naver Client ID
  /// Naver Developers > 내 애플리케이션 > Client ID
  /// https://developers.naver.com/apps
  static String naverClientId = const String.fromEnvironment(
    'NAVER_CLIENT_ID',
    defaultValue: '',
  );

  /// Naver Client Secret
  static String naverClientSecret = const String.fromEnvironment(
    'NAVER_CLIENT_SECRET',
    defaultValue: '',
  );

  /// Naver Client Name (앱 이름)
  static String naverClientName = const String.fromEnvironment(
    'NAVER_CLIENT_NAME',
    defaultValue: 'Coflanet',
  );

  /// Naver SDK 초기화 여부 확인
  static bool get isNaverConfigured =>
      naverClientId.isNotEmpty && naverClientSecret.isNotEmpty;

  // ============================================================
  // Apple Sign In 설정
  // ============================================================

  /// Apple Service ID (Android용 웹 기반 로그인)
  /// Apple Developer > Identifiers > Service IDs
  static String appleServiceId = const String.fromEnvironment(
    'APPLE_SERVICE_ID',
    defaultValue: '',
  );

  /// Apple 로그인 리다이렉트 URI (Android용)
  /// Apple Developer > Service ID > Configure > Return URLs
  static String appleRedirectUri = const String.fromEnvironment(
    'APPLE_REDIRECT_URI',
    defaultValue: '',
  );

  /// Apple Sign In 설정 여부 확인 (iOS는 항상 가능)
  static bool get isAppleConfiguredForAndroid =>
      appleServiceId.isNotEmpty && appleRedirectUri.isNotEmpty;

  // ============================================================
  // .env 로딩
  // ============================================================

  /// .env 파일에서 키를 로드하여 static 변수에 설정
  /// 기존 --dart-define 값이 있으면 유지, 없으면 dotenv에서 로드
  static void loadFromDotenv() {
    if (kakaoNativeAppKey.isEmpty) {
      kakaoNativeAppKey = dotenv.env['KAKAO_NATIVE_APP_KEY'] ?? '';
    }
    if (kakaoJavaScriptAppKey.isEmpty) {
      kakaoJavaScriptAppKey = dotenv.env['KAKAO_JAVASCRIPT_APP_KEY'] ?? '';
    }
    if (naverClientId.isEmpty) {
      naverClientId = dotenv.env['NAVER_CLIENT_ID'] ?? '';
    }
    if (naverClientSecret.isEmpty) {
      naverClientSecret = dotenv.env['NAVER_CLIENT_SECRET'] ?? '';
    }
    final envClientName = dotenv.env['NAVER_CLIENT_NAME'];
    if (envClientName != null && envClientName.isNotEmpty) {
      naverClientName = envClientName;
    }
    if (appleServiceId.isEmpty) {
      appleServiceId = dotenv.env['APPLE_SERVICE_ID'] ?? '';
    }
    if (appleRedirectUri.isEmpty) {
      appleRedirectUri = dotenv.env['APPLE_REDIRECT_URI'] ?? '';
    }
  }

  // ============================================================
  // 디버그 설정
  // ============================================================

  /// 소셜 로그인 디버그 로깅 활성화
  static bool enableDebugLogging = true;

  /// 설정 상태 출력 (디버그용)
  static void printConfigStatus() {
    if (!enableDebugLogging) return;

    debugPrint('=== Social Login Config Status ===');
    debugPrint('useDummyProviders: $useDummyProviders');
    debugPrint('Kakao configured: $isKakaoConfigured');
    debugPrint('Naver configured: $isNaverConfigured');
    debugPrint('Apple (Android) configured: $isAppleConfiguredForAndroid');
    debugPrint('================================');
  }

  // ============================================================
  // 수동 설정 메서드 (테스트용)
  // ============================================================

  /// 카카오 설정을 수동으로 지정
  static void configureKakao({
    required String nativeAppKey,
    String? javaScriptAppKey,
  }) {
    kakaoNativeAppKey = nativeAppKey;
    if (javaScriptAppKey != null) {
      kakaoJavaScriptAppKey = javaScriptAppKey;
    }
  }

  /// 네이버 설정을 수동으로 지정
  static void configureNaver({
    required String clientId,
    required String clientSecret,
    String clientName = 'Coflanet',
  }) {
    naverClientId = clientId;
    naverClientSecret = clientSecret;
    naverClientName = clientName;
  }

  /// Apple 설정을 수동으로 지정 (Android용)
  static void configureApple({
    required String serviceId,
    required String redirectUri,
  }) {
    appleServiceId = serviceId;
    appleRedirectUri = redirectUri;
  }

  /// 모든 설정 초기화 (테스트용)
  static void reset() {
    useDummyProviders = true;
    kakaoNativeAppKey = '';
    kakaoJavaScriptAppKey = '';
    naverClientId = '';
    naverClientSecret = '';
    naverClientName = 'Coflanet';
    appleServiceId = '';
    appleRedirectUri = '';
  }
}
