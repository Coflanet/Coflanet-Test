# Social Login Integration Guide

이 문서는 Coflanet 앱에 소셜 로그인(카카오, 네이버, Apple)을 연동하는 방법을 설명합니다.

---

## 아키텍처 개요

```
┌─────────────────────────────────────────────────────────────────┐
│  SignInController                                               │
│  └─ signInWithSocial(SocialLoginType.kakao)                    │
├─────────────────────────────────────────────────────────────────┤
│  AuthService (lib/core/services/auth_service.dart)             │
│  ├─ useDummyProviders: true/false                              │
│  └─ providers: Map<SocialLoginType, AuthProvider>              │
├─────────────────────────────────────────────────────────────────┤
│  AuthProvider (interface)                                       │
│  ├─ DummyAuthProvider (개발용)                                  │
│  ├─ KakaoAuthProvider (카카오 SDK)                              │
│  ├─ NaverAuthProvider (네이버 SDK)                              │
│  └─ AppleAuthProvider (Apple SDK)                              │
├─────────────────────────────────────────────────────────────────┤
│  LocalStorage                                                   │
│  └─ UserModel (id, email, name, provider, tokens)              │
└─────────────────────────────────────────────────────────────────┘
```

---

## 현재 상태

| 항목 | 상태 | 설명 |
|------|------|------|
| AuthService | ✅ 완료 | Provider 패턴 기반 인증 서비스 |
| DummyAuthProvider | ✅ 완료 | 개발/테스트용 더미 로그인 |
| KakaoAuthProvider | ⚠️ Placeholder | SDK 연동 필요 |
| NaverAuthProvider | ⚠️ Placeholder | SDK 연동 필요 |
| AppleAuthProvider | ⚠️ Placeholder | SDK 연동 필요 |

---

## Quick Start: 개발 모드 → 프로덕션 모드 전환

### 1단계: pubspec.yaml에서 패키지 활성화

```yaml
dependencies:
  # Social Login (주석 해제)
  kakao_flutter_sdk_user: ^1.6.1
  flutter_naver_login: ^1.8.0
  sign_in_with_apple: ^5.0.0
```

```bash
flutter pub get
```

### 2단계: app_binding.dart 수정

```dart
// lib/app_binding.dart
Get.put<AuthService>(
  AuthService(
    config: AuthServiceConfig(
      useDummyProviders: false,  // ← 여기를 false로 변경
    ),
  ),
  permanent: true,
);
```

### 3단계: 플랫폼별 설정 (아래 섹션 참조)

---

## 카카오 로그인 연동

### Console 설정

1. [Kakao Developers](https://developers.kakao.com) 접속
2. **내 애플리케이션** → **애플리케이션 추가하기**
3. 앱 이름: `Coflanet`, 사업자명 입력
4. **앱 키** 섹션에서 **네이티브 앱 키** 복사

### Android 설정

**android/app/src/main/AndroidManifest.xml**

```xml
<manifest>
    <application>
        <!-- 기존 내용 아래에 추가 -->
        <activity
            android:name="com.kakao.sdk.flutter.AuthCodeCustomTabsActivity"
            android:exported="true">
            <intent-filter android:label="flutter_web_auth">
                <action android:name="android.intent.action.VIEW" />
                <category android:name="android.intent.category.DEFAULT" />
                <category android:name="android.intent.category.BROWSABLE" />
                <data android:scheme="kakao{YOUR_NATIVE_APP_KEY}" android:host="oauth"/>
            </intent-filter>
        </activity>
    </application>
</manifest>
```

**android/app/build.gradle** - minSdkVersion 확인

```gradle
android {
    defaultConfig {
        minSdkVersion 21  // 최소 21 이상
    }
}
```

### iOS 설정

**ios/Runner/Info.plist**

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>kakao{YOUR_NATIVE_APP_KEY}</string>
        </array>
    </dict>
</array>
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>kakaokompassauth</string>
    <string>kakaolink</string>
</array>
```

### SDK 초기화 (main.dart)

```dart
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Kakao SDK 초기화
  KakaoSdk.init(nativeAppKey: '{YOUR_NATIVE_APP_KEY}');
  
  // ... 기존 코드
  runApp(const MyApp());
}
```

### Provider 구현

`lib/data/providers/kakao_auth_provider.dart` 수정:

```dart
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:coflanet/data/models/user_model.dart';
import 'package:coflanet/data/providers/auth_provider.dart';

class KakaoAuthProvider implements AuthProvider {
  @override
  SocialLoginType get type => SocialLoginType.kakao;

  @override
  Future<UserModel> signIn() async {
    try {
      OAuthToken token;

      // 카카오톡 설치 여부에 따라 로그인 방식 선택
      if (await isKakaoTalkInstalled()) {
        token = await UserApi.instance.loginWithKakaoTalk();
      } else {
        token = await UserApi.instance.loginWithKakaoAccount();
      }

      // 사용자 정보 가져오기
      User user = await UserApi.instance.me();

      return UserModel(
        id: user.id.toString(),
        email: user.kakaoAccount?.email,
        name: user.kakaoAccount?.profile?.nickname,
        profileImageUrl: user.kakaoAccount?.profile?.profileImageUrl,
        provider: 'kakao',
        accessToken: token.accessToken,
        refreshToken: token.refreshToken,
      );
    } catch (e) {
      throw AuthException(
        '카카오 로그인 실패: ${e.toString()}',
        code: 'KAKAO_LOGIN_FAILED',
        originalError: e,
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await UserApi.instance.logout();
    } catch (e) {
      // 로그아웃 실패해도 로컬 세션은 정리
    }
  }

  @override
  Future<bool> isSignedIn() async {
    try {
      await UserApi.instance.accessTokenInfo();
      return true;
    } catch (e) {
      return false;
    }
  }
}
```

---

## 네이버 로그인 연동

### Console 설정

1. [Naver Developers](https://developers.naver.com) 접속
2. **Application** → **애플리케이션 등록**
3. 애플리케이션 이름: `Coflanet`
4. **사용 API**: 네아로 (네이버 아이디로 로그인)
5. **제공 정보**: 이름, 이메일, 프로필 사진
6. **Client ID**와 **Client Secret** 저장

### Android 설정

**android/app/src/main/res/values/strings.xml**

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="naver_client_id">{YOUR_CLIENT_ID}</string>
    <string name="naver_client_secret">{YOUR_CLIENT_SECRET}</string>
    <string name="naver_client_name">Coflanet</string>
</resources>
```

### iOS 설정

**ios/Runner/Info.plist**

```xml
<key>CFBundleURLTypes</key>
<array>
    <!-- 기존 카카오 설정 아래에 추가 -->
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>naver{YOUR_CLIENT_ID}</string>
        </array>
    </dict>
</array>
<key>LSApplicationQueriesSchemes</key>
<array>
    <!-- 기존 카카오 항목에 추가 -->
    <string>naversearchapp</string>
    <string>naversearchthirdlogin</string>
</array>
<key>naverServiceAppUrlScheme</key>
<string>naver{YOUR_CLIENT_ID}</string>
<key>naverConsumerKey</key>
<string>{YOUR_CLIENT_ID}</string>
<key>naverConsumerSecret</key>
<string>{YOUR_CLIENT_SECRET}</string>
<key>naverServiceAppName</key>
<string>Coflanet</string>
```

### Provider 구현

`lib/data/providers/naver_auth_provider.dart` 수정:

```dart
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:coflanet/data/models/user_model.dart';
import 'package:coflanet/data/providers/auth_provider.dart';

class NaverAuthProvider implements AuthProvider {
  @override
  SocialLoginType get type => SocialLoginType.naver;

  @override
  Future<UserModel> signIn() async {
    try {
      NaverLoginResult result = await FlutterNaverLogin.logIn();

      if (result.status == NaverLoginStatus.loggedIn) {
        NaverAccountResult account = await FlutterNaverLogin.currentAccount();

        return UserModel(
          id: account.id,
          email: account.email,
          name: account.name,
          profileImageUrl: account.profileImage,
          provider: 'naver',
          accessToken: result.accessToken?.accessToken ?? '',
          refreshToken: result.accessToken?.refreshToken,
        );
      }

      throw AuthException(
        '네이버 로그인이 취소되었습니다.',
        code: 'NAVER_LOGIN_CANCELLED',
      );
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException(
        '네이버 로그인 실패: ${e.toString()}',
        code: 'NAVER_LOGIN_FAILED',
        originalError: e,
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await FlutterNaverLogin.logOut();
    } catch (e) {
      // 로그아웃 실패해도 로컬 세션은 정리
    }
  }

  @override
  Future<bool> isSignedIn() async {
    try {
      var result = await FlutterNaverLogin.currentAccessToken;
      return result.accessToken.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
```

---

## Apple 로그인 연동

> ⚠️ **중요**: App Store 정책상 다른 소셜 로그인이 있으면 Apple 로그인은 **필수**입니다.

### Apple Developer 설정

1. [Apple Developer](https://developer.apple.com) 접속
2. **Certificates, Identifiers & Profiles** → **Identifiers**
3. App ID 선택 (또는 새로 생성)
4. **Capabilities**에서 **Sign in with Apple** 체크
5. **Save**

### iOS 설정

**ios/Runner/Runner.entitlements** (파일 생성)

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

**Xcode에서 Capability 추가**

1. `ios/Runner.xcworkspace` 열기
2. Runner 타겟 선택 → **Signing & Capabilities**
3. **+ Capability** → **Sign in with Apple** 추가

### Provider 구현

`lib/data/providers/apple_auth_provider.dart` 수정:

```dart
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:coflanet/data/models/user_model.dart';
import 'package:coflanet/data/providers/auth_provider.dart';

class AppleAuthProvider implements AuthProvider {
  @override
  SocialLoginType get type => SocialLoginType.apple;

  @override
  Future<UserModel> signIn() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Apple은 첫 로그인 때만 이름/이메일 제공
      // 반드시 저장해야 함!
      final name = [
        credential.givenName,
        credential.familyName,
      ].where((s) => s != null && s.isNotEmpty).join(' ').trim();

      return UserModel(
        id: credential.userIdentifier ?? '',
        email: credential.email,
        name: name.isEmpty ? null : name,
        profileImageUrl: null, // Apple은 프로필 이미지 미제공
        provider: 'apple',
        accessToken: credential.identityToken ?? '',
        refreshToken: credential.authorizationCode,
      );
    } catch (e) {
      throw AuthException(
        'Apple 로그인 실패: ${e.toString()}',
        code: 'APPLE_LOGIN_FAILED',
        originalError: e,
      );
    }
  }

  @override
  Future<void> signOut() async {
    // Apple은 앱에서 로그아웃 API가 없음
    // 사용자가 설정 > Apple ID에서 직접 해제
  }

  @override
  Future<bool> isSignedIn() async {
    // 로컬 세션으로 판단
    return false;
  }
}
```

---

## 키 해시 생성 (Android)

카카오/네이버는 Android에서 키 해시 등록이 필요합니다.

### 디버그 키 해시

```bash
keytool -exportcert -alias androiddebugkey \
  -keystore ~/.android/debug.keystore \
  -storepass android -keypass android | \
  openssl sha1 -binary | openssl base64
```

### 릴리즈 키 해시

```bash
keytool -exportcert -alias {YOUR_ALIAS} \
  -keystore {YOUR_KEYSTORE_PATH} | \
  openssl sha1 -binary | openssl base64
```

생성된 해시를 각 Developer Console에 등록하세요.

---

## 테스트 체크리스트

### 카카오
- [ ] 카카오톡 설치 상태에서 로그인
- [ ] 카카오톡 미설치 상태에서 로그인 (웹뷰)
- [ ] 로그아웃 후 재로그인
- [ ] 사용자 정보 (이름, 이메일, 프로필) 정상 수신

### 네이버
- [ ] 네이버 앱 설치 상태에서 로그인
- [ ] 네이버 앱 미설치 상태에서 로그인
- [ ] 로그아웃 후 재로그인
- [ ] 사용자 정보 정상 수신

### Apple
- [ ] iOS 실기기에서 로그인
- [ ] Face ID/Touch ID 인증
- [ ] 첫 로그인 시 이름/이메일 수신
- [ ] 재로그인 시 정상 동작 (이름/이메일 없을 수 있음)

---

## 트러블슈팅

### 카카오 "KOE101" 에러
- 해시키가 등록되지 않음
- Developer Console에서 해시키 확인

### 네이버 "client_id is wrong" 에러
- `strings.xml`의 client_id 확인
- iOS `Info.plist`의 `naverConsumerKey` 확인

### Apple "Authorization failed" 에러
- Xcode에서 Signing Team 확인
- Entitlements 파일 확인
- Capability 추가 여부 확인

### 공통: 로그인 후 앱이 다시 안 열림
- URL Scheme 설정 확인
- `CFBundleURLSchemes` 오타 확인

---

## 파일 구조

```
lib/
├── core/
│   └── services/
│       └── auth_service.dart       # 인증 서비스 (Provider 관리)
├── data/
│   ├── models/
│   │   └── user_model.dart         # 사용자 모델
│   └── providers/
│       ├── auth_provider.dart      # Provider 인터페이스
│       ├── dummy_auth_provider.dart # 개발용 더미
│       ├── kakao_auth_provider.dart # 카카오
│       ├── naver_auth_provider.dart # 네이버
│       └── apple_auth_provider.dart # Apple
└── modules/
    └── auth/
        └── signin/
            └── signin_controller.dart # AuthService 사용
```

---

## 환경 분리

### 개발 환경 (기본)

```dart
// app_binding.dart
AuthServiceConfig(useDummyProviders: true)
```

### 프로덕션 환경

```dart
// app_binding.dart
AuthServiceConfig(useDummyProviders: false)
```

### 조건부 설정

```dart
import 'package:flutter/foundation.dart';

AuthServiceConfig(
  useDummyProviders: kDebugMode,  // Debug=true, Release=false
)
```

---

## 관련 문서

- [Kakao SDK Documentation](https://developers.kakao.com/docs/latest/ko/kakaologin/flutter)
- [Naver Login SDK](https://github.com/niceplugin/flutter_naver_login)
- [Sign in with Apple](https://pub.dev/packages/sign_in_with_apple)
