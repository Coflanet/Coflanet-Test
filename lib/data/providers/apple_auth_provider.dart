import 'dart:io';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:coflanet/data/models/user_model.dart';
import 'package:coflanet/data/providers/auth_provider.dart';
import 'package:coflanet/core/config/social_login_config.dart';

/// Apple authentication provider
///
/// Apple Sign In SDK를 사용한 실제 소셜 로그인 구현.
///
/// ## 플랫폼별 특이사항
///
/// ### iOS
/// - 네이티브 Apple Sign In 사용 (추가 설정 최소화)
/// - Xcode에서 "Sign in with Apple" capability 추가 필요
///
/// ### Android
/// - 웹 기반 OAuth 플로우 사용
/// - Apple Developer에서 Service ID 및 Return URL 설정 필요
/// - 서버에서 인증 코드 검증 필요
///
/// ## 사전 요구사항
///
/// 1. pubspec.yaml에 패키지 추가:
///    ```yaml
///    dependencies:
///      sign_in_with_apple: ^7.0.1
///    ```
///
/// 2. Apple Developer 설정:
///    - App ID에 Sign in with Apple capability 추가
///    - Service ID 생성 (Android/Web용)
///
/// 3. iOS 설정:
///    - Xcode > Runner > Signing & Capabilities > + Sign in with Apple
///
/// 4. Android 설정:
///    - AndroidManifest.xml에 callback activity 추가
///
/// 자세한 설정은 docs/SOCIAL_LOGIN_SETUP.md 참조.
///
/// ## 중요 주의사항
/// - Apple은 이름/이메일을 **최초 로그인 시에만** 제공합니다.
/// - 이후 로그인에서는 userIdentifier만 제공됩니다.
/// - 따라서 최초 로그인 시 이름/이메일을 반드시 저장해야 합니다.
class AppleAuthProvider implements AuthProvider {
  @override
  SocialLoginType get type => SocialLoginType.apple;

  @override
  Future<UserModel> signIn() async {
    try {
      final AuthorizationCredentialAppleID credential;

      if (Platform.isIOS || Platform.isMacOS) {
        // iOS/macOS: 네이티브 Apple Sign In
        credential = await _signInNative();
      } else if (Platform.isAndroid) {
        // Android: 웹 기반 Apple Sign In
        credential = await _signInWithWebAuth();
      } else {
        throw AuthException(
          '이 플랫폼에서는 Apple 로그인을 지원하지 않습니다.',
          code: 'UNSUPPORTED_PLATFORM',
        );
      }

      _logDebug('Apple 로그인 성공: ${credential.userIdentifier}');

      // 이름 조합 (Apple은 최초 로그인 시에만 이름 제공)
      final name = _buildName(credential.givenName, credential.familyName);

      return UserModel(
        id: credential.userIdentifier ?? '',
        email: credential.email,
        name: name,
        profileImageUrl: null, // Apple은 프로필 이미지를 제공하지 않음
        provider: 'apple',
        accessToken: credential.identityToken ?? '',
        refreshToken: credential.authorizationCode,
      );
    } on SignInWithAppleAuthorizationException catch (error) {
      _logDebug('Apple 로그인 예외: ${error.code} - ${error.message}');

      if (error.code == AuthorizationErrorCode.canceled) {
        throw AuthException(
          '로그인이 취소되었습니다.',
          code: 'CANCELED',
          originalError: error,
        );
      }

      throw AuthException(
        'Apple 로그인에 실패했습니다: ${error.message}',
        code: error.code.toString(),
        originalError: error,
      );
    } on AuthException {
      rethrow;
    } catch (error) {
      _logDebug('Apple 로그인 오류: $error');
      throw AuthException(
        'Apple 로그인에 실패했습니다.',
        code: 'APPLE_LOGIN_ERROR',
        originalError: error,
      );
    }
  }

  /// iOS 네이티브 Apple Sign In
  Future<AuthorizationCredentialAppleID> _signInNative() async {
    return await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
  }

  /// Android 웹 기반 Apple Sign In
  Future<AuthorizationCredentialAppleID> _signInWithWebAuth() async {
    if (!SocialLoginConfig.isAppleConfiguredForAndroid) {
      throw AuthException(
        'Android용 Apple Sign In 설정이 필요합니다.',
        code: 'APPLE_CONFIG_MISSING',
      );
    }

    return await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      webAuthenticationOptions: WebAuthenticationOptions(
        clientId: SocialLoginConfig.appleServiceId,
        redirectUri: Uri.parse(SocialLoginConfig.appleRedirectUri),
      ),
    );
  }

  /// 이름 조합 (givenName + familyName)
  String? _buildName(String? givenName, String? familyName) {
    final parts = [
      givenName,
      familyName,
    ].where((s) => s != null && s.isNotEmpty).toList();

    if (parts.isEmpty) return null;
    return parts.join(' ').trim();
  }

  @override
  Future<void> signOut() async {
    // Apple Sign In은 전통적인 "로그아웃" API가 없음
    // 사용자는 Settings > Apple ID > Password & Security에서 연결 해제 가능
    // 앱에서는 로컬 세션만 정리
    _logDebug('Apple 로그아웃 (로컬 세션 정리)');
  }

  @override
  Future<bool> isSignedIn() async {
    // Apple은 세션 상태를 직접 확인하는 API를 제공하지 않음
    // 로컬 저장소의 토큰 유무로 판단해야 함
    return false;
  }

  @override
  Future<UserModel?> refreshToken(UserModel currentUser) async {
    // Apple 토큰은 JWT 형식이며 서버에서 검증해야 함
    // 클라이언트에서는 토큰 갱신 불가
    return null;
  }

  /// Apple 자격 증명 상태 확인
  ///
  /// Apple이 제공하는 API로 사용자의 자격 증명 상태를 확인합니다.
  /// - authorized: 정상
  /// - revoked: 사용자가 연결 해제함
  /// - notFound: 이전에 로그인한 적 없음
  /// - transferred: 계정 이전됨
  Future<CredentialState?> getCredentialState(String userId) async {
    try {
      final state = await SignInWithApple.getCredentialState(userId);
      _logDebug('Apple 자격 증명 상태: $state');
      return state;
    } catch (error) {
      _logDebug('자격 증명 상태 확인 실패: $error');
      return null;
    }
  }

  void _logDebug(String message) {
    if (SocialLoginConfig.enableDebugLogging) {
      print('[AppleAuthProvider] $message');
    }
  }
}
