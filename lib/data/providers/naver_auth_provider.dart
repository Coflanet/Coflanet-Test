import 'package:flutter/foundation.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_naver_login/interface/types/naver_login_result.dart';
import 'package:flutter_naver_login/interface/types/naver_login_status.dart';
import 'package:flutter_naver_login/interface/types/naver_token.dart';
import 'package:flutter_naver_login/interface/types/naver_account_result.dart';
import 'package:coflanet/data/models/user_model.dart';
import 'package:coflanet/data/providers/auth_provider.dart';
import 'package:coflanet/core/config/social_login_config.dart';

/// Naver authentication provider
///
/// 자세한 설정은 docs/SOCIAL_LOGIN_SETUP.md 참조.
class NaverAuthProvider implements AuthProvider {
  @override
  SocialLoginType get type => SocialLoginType.naver;

  @override
  Future<UserModel> signIn() async {
    try {
      final NaverLoginResult result = await FlutterNaverLogin.logIn();

      if (result.status == NaverLoginStatus.loggedIn) {
        _logDebug('네이버 로그인 성공');

        final account = result.account;
        if (account == null) {
          throw AuthException(
            '네이버 계정 정보를 가져올 수 없습니다.',
            code: 'NAVER_ACCOUNT_NULL',
          );
        }

        final NaverToken tokenResult =
            await FlutterNaverLogin.getCurrentAccessToken();

        return UserModel(
          id: account.id ?? '',
          email: account.email,
          name: account.name,
          profileImageUrl: account.profileImage,
          provider: 'naver',
          accessToken: tokenResult.accessToken,
          refreshToken: tokenResult.refreshToken,
        );
      } else if (result.status == NaverLoginStatus.loggedOut) {
        throw AuthException('로그인이 취소되었습니다.', code: 'CANCELED');
      } else {
        throw AuthException('네이버 로그인에 실패했습니다.', code: 'NAVER_LOGIN_FAILED');
      }
    } on AuthException {
      rethrow;
    } catch (error) {
      _logDebug('네이버 로그인 오류: $error');
      throw AuthException(
        '네이버 로그인에 실패했습니다.',
        code: 'NAVER_LOGIN_ERROR',
        originalError: error,
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await FlutterNaverLogin.logOut();
      _logDebug('네이버 로그아웃 성공');
    } catch (error) {
      _logDebug('네이버 로그아웃 실패: $error');
    }
  }

  @override
  Future<bool> isSignedIn() async {
    try {
      final NaverToken token = await FlutterNaverLogin.getCurrentAccessToken();
      final isValid = token.isValid();
      _logDebug('토큰 유효성: $isValid');
      return isValid;
    } catch (error) {
      _logDebug('토큰 확인 실패: $error');
      return false;
    }
  }

  @override
  Future<UserModel?> refreshToken(UserModel currentUser) async {
    try {
      final NaverToken token = await FlutterNaverLogin.getCurrentAccessToken();

      if (token.isValid()) {
        final NaverAccountResult account =
            await FlutterNaverLogin.getCurrentAccount();

        return currentUser.copyWith(
          name: account.name,
          profileImageUrl: account.profileImage,
          accessToken: token.accessToken,
          refreshToken: token.refreshToken,
        );
      }
    } catch (error) {
      _logDebug('토큰 갱신 실패: $error');
    }
    return null;
  }

  @override
  Future<void> unlink() async {
    try {
      await FlutterNaverLogin.logOutAndDeleteToken();
      _logDebug('네이버 연결 해제 성공');
    } catch (error) {
      _logDebug('네이버 연결 해제 실패: $error');
      throw AuthException(
        '네이버 연결 해제에 실패했습니다.',
        code: 'NAVER_UNLINK_FAILED',
        originalError: error,
      );
    }
  }

  void _logDebug(String message) {
    if (SocialLoginConfig.enableDebugLogging) {
      debugPrint('[NaverAuthProvider] $message');
    }
  }
}
