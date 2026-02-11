import 'package:coflanet/data/models/user_model.dart';
import 'package:coflanet/data/providers/auth_provider.dart';

/// Naver authentication provider
///
/// ## Setup Requirements
///
/// ### 1. Package Installation
/// Add to pubspec.yaml:
/// ```yaml
/// dependencies:
///   flutter_naver_login: ^1.8.0
/// ```
///
/// ### 2. Naver Developers Console
/// 1. Go to https://developers.naver.com
/// 2. Create application
/// 3. Get Client ID and Client Secret
/// 4. Set API permissions (name, email, profile image)
/// 5. Add platforms (Android/iOS)
///
/// ### 3. Android Configuration
/// android/app/src/main/res/values/strings.xml:
/// ```xml
/// <resources>
///     <string name="naver_client_id">{CLIENT_ID}</string>
///     <string name="naver_client_secret">{CLIENT_SECRET}</string>
///     <string name="naver_client_name">Coflanet</string>
/// </resources>
/// ```
///
/// ### 4. iOS Configuration
/// ios/Runner/Info.plist:
/// ```xml
/// <key>CFBundleURLTypes</key>
/// <array>
///     <dict>
///         <key>CFBundleTypeRole</key>
///         <string>Editor</string>
///         <key>CFBundleURLSchemes</key>
///         <array>
///             <string>naver{CLIENT_ID}</string>
///         </array>
///     </dict>
/// </array>
/// <key>LSApplicationQueriesSchemes</key>
/// <array>
///     <string>naversearchapp</string>
///     <string>naversearchthirdlogin</string>
/// </array>
/// <key>naverServiceAppUrlScheme</key>
/// <string>naver{CLIENT_ID}</string>
/// <key>naverConsumerKey</key>
/// <string>{CLIENT_ID}</string>
/// <key>naverConsumerSecret</key>
/// <string>{CLIENT_SECRET}</string>
/// <key>naverServiceAppName</key>
/// <string>Coflanet</string>
/// ```
class NaverAuthProvider implements AuthProvider {
  @override
  SocialLoginType get type => SocialLoginType.naver;

  @override
  Future<UserModel> signIn() async {
    // TODO: Implement actual Naver login
    //
    // Example implementation:
    // ```dart
    // import 'package:flutter_naver_login/flutter_naver_login.dart';
    //
    // NaverLoginResult result = await FlutterNaverLogin.logIn();
    //
    // if (result.status == NaverLoginStatus.loggedIn) {
    //   NaverAccountResult account = await FlutterNaverLogin.currentAccount();
    //
    //   return UserModel(
    //     id: account.id,
    //     email: account.email,
    //     name: account.name,
    //     profileImageUrl: account.profileImage,
    //     provider: 'naver',
    //     accessToken: result.accessToken?.accessToken ?? '',
    //     refreshToken: result.accessToken?.refreshToken,
    //   );
    // }
    //
    // throw AuthException('Naver login cancelled');
    // ```

    throw AuthException(
      'Naver login not implemented. See NaverAuthProvider documentation.',
      code: 'NOT_IMPLEMENTED',
    );
  }

  @override
  Future<void> signOut() async {
    // TODO: Implement actual Naver logout
    //
    // Example implementation:
    // ```dart
    // await FlutterNaverLogin.logOut();
    // ```

    throw AuthException(
      'Naver logout not implemented.',
      code: 'NOT_IMPLEMENTED',
    );
  }

  @override
  Future<bool> isSignedIn() async {
    // TODO: Implement actual check
    //
    // Example implementation:
    // ```dart
    // try {
    //   NaverLoginResult result = await FlutterNaverLogin.currentAccessToken();
    //   return result.status == NaverLoginStatus.loggedIn;
    // } catch (e) {
    //   return false;
    // }
    // ```

    return false;
  }

  @override
  Future<UserModel?> refreshToken(UserModel currentUser) async {
    // TODO: Implement token refresh if needed
    return null;
  }
}
