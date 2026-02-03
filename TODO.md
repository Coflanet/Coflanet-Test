# Social Login SDK Integration Guide

## Overview
현재 앱은 더미 로그인으로 구현되어 있습니다. 실제 소셜 로그인을 연동하려면 아래 가이드를 따라주세요.

---

## 1. Kakao Login

### Setup
1. [Kakao Developers](https://developers.kakao.com) 콘솔에서 앱 등록
2. 앱 설정 > 플랫폼 > Android/iOS 추가
3. 카카오 로그인 활성화
4. Redirect URI 설정

### Package Installation
```yaml
# pubspec.yaml
dependencies:
  kakao_flutter_sdk_user: ^1.6.1
```

### Android Configuration

**android/app/src/main/AndroidManifest.xml**
```xml
<manifest>
    <application>
        <!-- Kakao SDK -->
        <activity
            android:name="com.kakao.sdk.flutter.AuthCodeCustomTabsActivity"
            android:exported="true">
            <intent-filter android:label="flutter_web_auth">
                <action android:name="android.intent.action.VIEW" />
                <category android:name="android.intent.category.DEFAULT" />
                <category android:name="android.intent.category.BROWSABLE" />
                <data android:scheme="kakao{NATIVE_APP_KEY}" android:host="oauth"/>
            </intent-filter>
        </activity>
    </application>
</manifest>
```

**android/app/src/main/res/values/strings.xml**
```xml
<resources>
    <string name="kakao_app_key">{NATIVE_APP_KEY}</string>
</resources>
```

### iOS Configuration

**ios/Runner/Info.plist**
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>kakao{NATIVE_APP_KEY}</string>
        </array>
    </dict>
</array>
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>kakaokompassauth</string>
    <string>kakaolink</string>
</array>
```

### Code Implementation
```dart
// lib/data/providers/auth_provider_kakao.dart
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class AuthProviderKakao implements AuthRepository {
  @override
  Future<UserModel?> signIn() async {
    try {
      OAuthToken token;

      if (await isKakaoTalkInstalled()) {
        token = await UserApi.instance.loginWithKakaoTalk();
      } else {
        token = await UserApi.instance.loginWithKakaoAccount();
      }

      // Get user info
      User user = await UserApi.instance.me();

      return UserModel(
        id: user.id.toString(),
        email: user.kakaoAccount?.email,
        name: user.kakaoAccount?.profile?.nickname,
        profileImage: user.kakaoAccount?.profile?.profileImageUrl,
      );
    } catch (e) {
      throw AuthException('Kakao login failed: $e');
    }
  }
}
```

---

## 2. Naver Login

### Setup
1. [Naver Developers](https://developers.naver.com) 콘솔에서 앱 등록
2. 로그인 API 권한 설정 (이름, 이메일, 프로필 사진 등)
3. 플랫폼 추가 (Android/iOS)

### Package Installation
```yaml
# pubspec.yaml
dependencies:
  flutter_naver_login: ^1.8.0
```

### Android Configuration

**android/app/src/main/res/values/strings.xml**
```xml
<resources>
    <string name="naver_client_id">{CLIENT_ID}</string>
    <string name="naver_client_secret">{CLIENT_SECRET}</string>
    <string name="naver_client_name">Coflanet</string>
</resources>
```

### iOS Configuration

**ios/Runner/Info.plist**
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>naver{CLIENT_ID}</string>
        </array>
    </dict>
</array>
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>naversearchapp</string>
    <string>naversearchthirdlogin</string>
</array>
```

### Code Implementation
```dart
// lib/data/providers/auth_provider_naver.dart
import 'package:flutter_naver_login/flutter_naver_login.dart';

class AuthProviderNaver implements AuthRepository {
  @override
  Future<UserModel?> signIn() async {
    try {
      NaverLoginResult result = await FlutterNaverLogin.logIn();

      if (result.status == NaverLoginStatus.loggedIn) {
        NaverAccountResult account = await FlutterNaverLogin.currentAccount();

        return UserModel(
          id: account.id,
          email: account.email,
          name: account.name,
          profileImage: account.profileImage,
        );
      }

      throw AuthException('Naver login cancelled');
    } catch (e) {
      throw AuthException('Naver login failed: $e');
    }
  }
}
```

---

## 3. Apple Login

### Setup
1. [Apple Developer](https://developer.apple.com) 콘솔 접속
2. Certificates, Identifiers & Profiles > Identifiers 에서 App ID 생성
3. Sign in with Apple capability 활성화
4. Service ID 생성 (웹 로그인용)

### Package Installation
```yaml
# pubspec.yaml
dependencies:
  sign_in_with_apple: ^5.0.0
```

### iOS Configuration

**ios/Runner/Runner.entitlements**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>com.apple.developer.applesignin</key>
    <array>
        <string>Default</string>
    </array>
</dict>
</plist>
```

### Android Configuration (웹 기반)
Apple Sign In은 iOS에서만 네이티브로 지원되며, Android에서는 웹 기반으로 구현해야 합니다.

### Code Implementation
```dart
// lib/data/providers/auth_provider_apple.dart
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthProviderApple implements AuthRepository {
  @override
  Future<UserModel?> signIn() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      return UserModel(
        id: credential.userIdentifier,
        email: credential.email,
        name: '${credential.givenName ?? ''} ${credential.familyName ?? ''}'.trim(),
      );
    } catch (e) {
      throw AuthException('Apple login failed: $e');
    }
  }
}
```

---

## Provider 교체 방법

### app_binding.dart 수정

```dart
// lib/app_binding.dart
import 'package:get/get.dart';
import 'package:coflanet/data/repositories/auth_repository.dart';

// 개발 환경
import 'package:coflanet/data/providers/auth_provider_dummy.dart';

// 운영 환경 (주석 해제하여 사용)
// import 'package:coflanet/data/providers/auth_provider_kakao.dart';
// import 'package:coflanet/data/providers/auth_provider_naver.dart';
// import 'package:coflanet/data/providers/auth_provider_apple.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // 개발 환경 - 더미 Provider
    Get.lazyPut<AuthRepository>(() => AuthProviderDummy());

    // 운영 환경 - 실제 Provider로 교체
    // Get.lazyPut<AuthRepository>(() => AuthProviderKakao());
  }
}
```

---

## 체크리스트

### 카카오 로그인
- [ ] Kakao Developers 앱 등록
- [ ] Native App Key 발급
- [ ] Android/iOS 플랫폼 설정
- [ ] kakao_flutter_sdk_user 패키지 설치
- [ ] AndroidManifest.xml 설정
- [ ] Info.plist 설정
- [ ] AuthProviderKakao 구현
- [ ] AppBinding에서 Provider 교체
- [ ] 테스트

### 네이버 로그인
- [ ] Naver Developers 앱 등록
- [ ] Client ID/Secret 발급
- [ ] API 권한 설정
- [ ] flutter_naver_login 패키지 설치
- [ ] strings.xml 설정
- [ ] Info.plist 설정
- [ ] AuthProviderNaver 구현
- [ ] AppBinding에서 Provider 교체
- [ ] 테스트

### Apple 로그인
- [ ] Apple Developer 설정
- [ ] App ID에 Sign in with Apple 추가
- [ ] sign_in_with_apple 패키지 설치
- [ ] Runner.entitlements 설정
- [ ] AuthProviderApple 구현
- [ ] AppBinding에서 Provider 교체
- [ ] 테스트

---

## 주의사항

1. **API 키 보안**: 민감한 키는 `.env` 파일이나 환경 변수로 관리하세요.
2. **테스트 계정**: 각 플랫폼에서 제공하는 테스트 계정으로 먼저 테스트하세요.
3. **iOS 심사**: Apple 로그인은 다른 소셜 로그인이 있으면 필수입니다.
4. **Android 해시키**: 카카오/네이버는 Android에서 키 해시 등록이 필요합니다.

```bash
# Android 키 해시 확인 (디버그)
keytool -exportcert -alias androiddebugkey -keystore ~/.android/debug.keystore -storepass android -keypass android | openssl sha1 -binary | openssl base64
```
