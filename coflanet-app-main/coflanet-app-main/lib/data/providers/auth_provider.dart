import 'package:coflanet/data/models/user_model.dart';

/// Social login provider type
enum SocialLoginType { kakao, naver, apple, guest }

/// Abstract interface for authentication providers
///
/// Implement this interface for each social login provider:
/// - [DummyAuthProvider] for development/testing
/// - [KakaoAuthProvider] for Kakao login
/// - [NaverAuthProvider] for Naver login
/// - [AppleAuthProvider] for Apple login
abstract class AuthProvider {
  /// Provider type identifier
  SocialLoginType get type;

  /// Sign in with this provider
  ///
  /// Returns [UserModel] on success
  /// Throws [AuthException] on failure
  Future<UserModel> signIn();

  /// Sign out from this provider
  Future<void> signOut();

  /// Check if user is currently signed in with this provider
  Future<bool> isSignedIn();

  /// Refresh access token if supported
  ///
  /// Returns new [UserModel] with updated tokens
  /// Throws [AuthException] if refresh fails
  Future<UserModel?> refreshToken(UserModel currentUser) async {
    // Default implementation: not supported
    return null;
  }

  /// Unlink (disconnect) the social account
  ///
  /// Revokes tokens and removes the app connection from the social provider.
  /// Used for account withdrawal (회원탈퇴).
  Future<void> unlink() async {
    // Default: same as signOut
    await signOut();
  }
}
