import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:coflanet/data/models/user_model.dart';
import 'package:coflanet/data/providers/auth_provider.dart';
import 'package:coflanet/core/config/social_login_config.dart';

class AppleAuthProvider implements AuthProvider {
  @override
  SocialLoginType get type => SocialLoginType.apple;

  @override
  Future<UserModel> signIn() async {
    _logDebug('Apple signIn 시작');

    try {
      final AuthorizationCredentialAppleID credential;

      if (Platform.isIOS || Platform.isMacOS) {
        credential = await _signInNative();
      } else if (Platform.isAndroid) {
        credential = await _signInWithWebAuth();
      } else {
        throw AuthException(
          '이 플랫폼에서는 Apple 로그인을 지원하지 않습니다.',
          code: 'UNSUPPORTED_PLATFORM',
        );
      }

      _logDebug('Apple 로그인 성공: ${credential.userIdentifier}');

      final name = _buildName(credential.givenName, credential.familyName);

      return UserModel(
        id: credential.userIdentifier ?? '',
        email: credential.email,
        name: name,
        profileImageUrl: null,
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
    } catch (error) {
      _logDebug('Apple 로그인 오류: $error');
      throw AuthException(
        'Apple 로그인에 실패했습니다.',
        code: 'APPLE_LOGIN_ERROR',
        originalError: error,
      );
    }
  }

  Future<AuthorizationCredentialAppleID> _signInNative() async {
    return await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
  }

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
    _logDebug('Apple 로그아웃');
  }

  @override
  Future<bool> isSignedIn() async {
    return false;
  }

  @override
  Future<UserModel?> refreshToken(UserModel currentUser) async {
    return null;
  }

  @override
  Future<void> unlink() async {
    _logDebug('Apple 연결 해제');
  }

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
      debugPrint('[AppleAuthProvider] $message');
    }
  }
}
