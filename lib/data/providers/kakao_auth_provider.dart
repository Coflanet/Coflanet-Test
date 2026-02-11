import 'package:coflanet/data/models/user_model.dart';
import 'package:coflanet/data/providers/auth_provider.dart';

/// Kakao authentication provider
///
/// ## Setup Requirements
///
/// ### 1. Package Installation
/// Add to pubspec.yaml:
/// ```yaml
/// dependencies:
///   kakao_flutter_sdk_user: ^1.6.1
/// ```
///
/// ### 2. Kakao Developers Console
/// 1. Go to https://developers.kakao.com
/// 2. Create application
/// 3. Get Native App Key
/// 4. Add platforms (Android/iOS)
/// 5. Enable Kakao Login
///
/// ### 3. Android Configuration
/// android/app/src/main/AndroidManifest.xml:
/// ```xml
/// <activity
///     android:name="com.kakao.sdk.flutter.AuthCodeCustomTabsActivity"
///     android:exported="true">
///     <intent-filter android:label="flutter_web_auth">
///         <action android:name="android.intent.action.VIEW" />
///         <category android:name="android.intent.category.DEFAULT" />
///         <category android:name="android.intent.category.BROWSABLE" />
///         <data android:scheme="kakao{NATIVE_APP_KEY}" android:host="oauth"/>
///     </intent-filter>
/// </activity>
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
///             <string>kakao{NATIVE_APP_KEY}</string>
///         </array>
///     </dict>
/// </array>
/// <key>LSApplicationQueriesSchemes</key>
/// <array>
///     <string>kakaokompassauth</string>
///     <string>kakaolink</string>
/// </array>
/// ```
///
/// ### 5. Initialize SDK in main.dart
/// ```dart
/// import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
///
/// void main() {
///   KakaoSdk.init(nativeAppKey: '{NATIVE_APP_KEY}');
///   runApp(MyApp());
/// }
/// ```
class KakaoAuthProvider implements AuthProvider {
  @override
  SocialLoginType get type => SocialLoginType.kakao;

  @override
  Future<UserModel> signIn() async {
    // TODO: Implement actual Kakao login
    //
    // Example implementation:
    // ```dart
    // import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
    //
    // OAuthToken token;
    // if (await isKakaoTalkInstalled()) {
    //   token = await UserApi.instance.loginWithKakaoTalk();
    // } else {
    //   token = await UserApi.instance.loginWithKakaoAccount();
    // }
    //
    // User user = await UserApi.instance.me();
    //
    // return UserModel(
    //   id: user.id.toString(),
    //   email: user.kakaoAccount?.email,
    //   name: user.kakaoAccount?.profile?.nickname,
    //   profileImageUrl: user.kakaoAccount?.profile?.profileImageUrl,
    //   provider: 'kakao',
    //   accessToken: token.accessToken,
    //   refreshToken: token.refreshToken,
    // );
    // ```

    throw AuthException(
      'Kakao login not implemented. See KakaoAuthProvider documentation.',
      code: 'NOT_IMPLEMENTED',
    );
  }

  @override
  Future<void> signOut() async {
    // TODO: Implement actual Kakao logout
    //
    // Example implementation:
    // ```dart
    // await UserApi.instance.logout();
    // ```

    throw AuthException(
      'Kakao logout not implemented.',
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
    //   await UserApi.instance.accessTokenInfo();
    //   return true;
    // } catch (e) {
    //   return false;
    // }
    // ```

    return false;
  }

  @override
  Future<UserModel?> refreshToken(UserModel currentUser) async {
    // Kakao SDK handles token refresh automatically
    return null;
  }
}
