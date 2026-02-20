import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:coflanet/data/models/user_model.dart';
import 'package:coflanet/data/providers/auth_provider.dart';
import 'package:coflanet/core/config/social_login_config.dart';

/// Kakao authentication provider
///
/// Kakao SDK를 사용한 실제 소셜 로그인 구현.
///
/// ## 사전 요구사항
///
/// 1. pubspec.yaml에 패키지 추가:
///    ```yaml
///    dependencies:
///      kakao_flutter_sdk_user: ^1.10.0
///    ```
///
/// 2. main.dart에서 SDK 초기화:
///    ```dart
///    import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
///
///    void main() {
///      KakaoSdk.init(nativeAppKey: SocialLoginConfig.kakaoNativeAppKey);
///      runApp(MyApp());
///    }
///    ```
///
/// 3. Android 설정: AndroidManifest.xml
/// 4. iOS 설정: Info.plist
///
/// 자세한 설정은 docs/SOCIAL_LOGIN_SETUP.md 참조.
class KakaoAuthProvider implements AuthProvider {
  @override
  SocialLoginType get type => SocialLoginType.kakao;

  @override
  Future<UserModel> signIn() async {
    try {
      OAuthToken token;

      // 카카오톡 설치 여부 확인 후 적절한 로그인 방식 선택
      if (await isKakaoTalkInstalled()) {
        try {
          token = await UserApi.instance.loginWithKakaoTalk();
          _logDebug('카카오톡으로 로그인 성공');
        } catch (error) {
          _logDebug('카카오톡 로그인 실패, 카카오계정으로 전환: $error');

          // 사용자가 카카오톡 로그인을 취소한 경우
          if (error is PlatformException && error.code == 'CANCELED') {
            throw AuthException(
              '로그인이 취소되었습니다.',
              code: 'CANCELED',
              originalError: error,
            );
          }

          // 카카오톡 로그인 실패 시 카카오계정으로 로그인 시도
          token = await _loginWithKakaoAccount();
        }
      } else {
        // 카카오톡 미설치 시 카카오계정으로 로그인
        token = await _loginWithKakaoAccount();
      }

      // 사용자 정보 조회
      final user = await UserApi.instance.me();
      _logDebug('사용자 정보 조회 성공: ${user.id}');

      return UserModel(
        id: user.id.toString(),
        email: user.kakaoAccount?.email,
        name: user.kakaoAccount?.profile?.nickname,
        profileImageUrl: user.kakaoAccount?.profile?.profileImageUrl,
        provider: 'kakao',
        accessToken: token.accessToken,
        refreshToken: token.refreshToken,
      );
    } on AuthException {
      rethrow;
    } catch (error) {
      _logDebug('카카오 로그인 오류: $error');
      throw AuthException(
        '카카오 로그인에 실패했습니다.',
        code: 'KAKAO_LOGIN_FAILED',
        originalError: error,
      );
    }
  }

  /// 카카오계정으로 로그인
  Future<OAuthToken> _loginWithKakaoAccount() async {
    try {
      final token = await UserApi.instance.loginWithKakaoAccount();
      _logDebug('카카오계정으로 로그인 성공');
      return token;
    } catch (error) {
      _logDebug('카카오계정 로그인 실패: $error');

      if (error is PlatformException && error.code == 'CANCELED') {
        throw AuthException(
          '로그인이 취소되었습니다.',
          code: 'CANCELED',
          originalError: error,
        );
      }

      throw AuthException(
        '카카오계정 로그인에 실패했습니다.',
        code: 'KAKAO_ACCOUNT_LOGIN_FAILED',
        originalError: error,
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await UserApi.instance.logout();
      _logDebug('카카오 로그아웃 성공');
    } catch (error) {
      _logDebug('카카오 로그아웃 실패: $error');
      // 로그아웃 실패는 무시하고 로컬 세션만 정리
    }
  }

  @override
  Future<bool> isSignedIn() async {
    try {
      final tokenInfo = await UserApi.instance.accessTokenInfo();
      _logDebug('토큰 유효: ${tokenInfo.id}');
      return true;
    } catch (error) {
      _logDebug('토큰 무효 또는 만료: $error');
      return false;
    }
  }

  @override
  Future<UserModel?> refreshToken(UserModel currentUser) async {
    // Kakao SDK는 토큰 갱신을 자동으로 처리함
    // 필요한 경우 새로운 사용자 정보를 조회하여 반환
    try {
      if (await isSignedIn()) {
        final user = await UserApi.instance.me();
        final token = await TokenManagerProvider.instance.manager.getToken();

        if (token != null) {
          return currentUser.copyWith(
            name: user.kakaoAccount?.profile?.nickname,
            profileImageUrl: user.kakaoAccount?.profile?.profileImageUrl,
            accessToken: token.accessToken,
            refreshToken: token.refreshToken,
          );
        }
      }
    } catch (error) {
      _logDebug('토큰 갱신 실패: $error');
    }
    return null;
  }

  /// 카카오 연결 해제 (회원 탈퇴)
  @override
  Future<void> unlink() async {
    try {
      await UserApi.instance.unlink();
      _logDebug('카카오 연결 해제 성공');
    } catch (error) {
      _logDebug('카카오 연결 해제 실패: $error');
      throw AuthException(
        '카카오 연결 해제에 실패했습니다.',
        code: 'KAKAO_UNLINK_FAILED',
        originalError: error,
      );
    }
  }

  void _logDebug(String message) {
    if (SocialLoginConfig.enableDebugLogging) {
      debugPrint('[KakaoAuthProvider] $message');
    }
  }
}
