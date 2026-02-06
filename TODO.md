# Coflanet App TODO

## Asset Tasks

### High Priority - 플레이스홀더 이미지 교체 필요

Figma에서 실제 에셋을 export하여 교체해야 합니다.

#### 온보딩 이미지 (assets/images/)
- [ ] `onboarding_welcome.png` - 현재 보라색 사각형 플레이스홀더
- [ ] `onboarding_complete.png` - 현재 보라색 사각형 플레이스홀더
- [ ] `onboarding_analyzing.png` - 현재 보라색 사각형 플레이스홀더

#### 커피 추출 방식 이미지 (assets/images/)
- [ ] `coffee_hand_drip.png` - 현재 단순 기하학적 모양 (846 bytes)
- [ ] `coffee_espresso.png` - 현재 단순 기하학적 모양 (823 bytes)
- [ ] `coffee_mokapot.png` - 현재 단순 기하학적 모양 (810 bytes)

#### 배경 이미지 (assets/images/)
- [ ] `survey_result_bg.png` - 현재 단색 배경 (그라데이션/패턴 필요)

#### 커피 타입 이미지 (assets/images/)
- [ ] `coffee_type_acidic.png` - 현재 단순 오렌지 컵 아이콘 (1.2KB)
- [ ] `coffee_type_balance.png` - 현재 단순 아이콘 (1.2KB)
- [ ] `coffee_type_bitter.png` - 현재 단순 아이콘 (1.2KB)
- [ ] `coffee_type_sweet.png` - 현재 단순 아이콘 (1.2KB)

#### 로고 이미지 (assets/images/) - 선택사항
- [ ] `logo_main.png` - 현재 저해상도 (1.8KB), 고해상도 버전 필요시 교체
- [ ] `logo_white.png` - 현재 저해상도 (1.8KB), 고해상도 버전 필요시 교체

### Medium Priority - 새 아이콘 추가

#### 탭바/네비게이션 아이콘 (assets/icons/)
- [ ] `ic_play.svg` - 타이머 재생 버튼
- [ ] `ic_pause.svg` - 타이머 일시정지 버튼
- [ ] `ic_plus.svg` - 추가 버튼
- [ ] `ic_list.svg` - 목록 아이콘 (추출 목록용)
- [ ] `ic_clock.svg` - 시계/타이머 아이콘

#### Figma Library Node IDs (export시 사용)
```
ic_coffee: 2411:24135
ic_home: 2411:23598
ic_profile: 2411:23751
ic_settings: 2411:24581
ic_play: 2411:24560
ic_pause: 2411:24553
ic_clock: 2411:24690
ic_plus: 2411:23886
ic_list: 2411:24422
ic_arrow_back: 2411:22915
ic_arrow_forward: 2411:22964
ic_close: 2411:23248
ic_check: 2411:23141
ic_check_circle: 2411:23174
ic_naver: 2411:24501
ic_kakao: 2411:24824
ic_apple: 2411:24788
```

### Low Priority - 폰트 번들링

- [ ] Pretendard 폰트 파일 추가 (`assets/fonts/`)
  - Pretendard-Regular.otf (400)
  - Pretendard-Medium.otf (500)
  - Pretendard-SemiBold.otf (600)
  - Pretendard-Bold.otf (700)
- [ ] `pubspec.yaml`에서 폰트 설정 주석 해제

### Asset Export 방법

#### 방법 1: Figma 수동 Export (권장)

Figma API rate limit (약 4일 대기 필요)으로 인해 수동 export를 권장합니다:

1. **Figma 열기**: https://www.figma.com/design/q7yBPcHrid1CGQqFWEPwnR/
2. **Icon 페이지로 이동**: 🔘 Icon 페이지
3. **아이콘 선택 후 Export**:
   - 우측 패널 하단 "Export" 섹션
   - Format: SVG 선택
   - Export 클릭

**필요한 아이콘 (우선순위):**
- play, pause (타이머용)
- plus (추가 버튼)
- list (목록)
- clock (시계)

4. **이미지 Export**: POC 파일에서 필요한 이미지 export
   - https://www.figma.com/design/EkpVnNrqyq9Agpy4aymv0j/
   - 온보딩 일러스트
   - 커피 추출 방식 일러스트

#### 방법 2: API 스크립트 (rate limit 해제 후)

약 4일 후 (retry-after: ~96시간) 스크립트 실행 가능:
```bash
./scripts/fetch_figma_assets.sh
```

### Figma 파일 정보
- **Library (아이콘/컴포넌트)**: https://www.figma.com/design/q7yBPcHrid1CGQqFWEPwnR/
- **POC (메인 디자인)**: https://www.figma.com/design/EkpVnNrqyq9Agpy4aymv0j/

### 현재 상태 요약

| 카테고리 | 파일 수 | 상태 | 비고 |
|----------|---------|------|------|
| 기본 아이콘 | 13개 | ✅ 구현됨 | SVG, stroke 스타일 |
| 추가 필요 아이콘 | 5개 | ❌ 미구현 | play, pause, plus, list, clock |
| 로고 | 3개 | ⚠️ 저해상도 | SVG는 정상, PNG 개선 필요 |
| 온보딩 이미지 | 3개 | ❌ 플레이스홀더 | Figma export 필요 |
| 커피 추출 이미지 | 3개 | ❌ 플레이스홀더 | Figma export 필요 |
| 커피 타입 이미지 | 4개 | ⚠️ 단순 아이콘 | 개선 권장 |
| 배경 이미지 | 1개 | ❌ 플레이스홀더 | Figma export 필요 |
| 폰트 | 4개 | ❌ 미포함 | Pretendard 필요 |

**총 미완료 에셋: 이미지 13개 + 아이콘 5개 + 폰트 4개 = 22개**

---

# Widget Library Improvements (Figma 디자인 라이브러리 기반)

## 분석 결과 요약

**전체 평가: 85/100** - 잘 구현됨

### ✅ 잘 구현된 부분
| 영역 | Figma 페이지 | 코드 파일 | 상태 |
|------|-------------|----------|------|
| Colors | 🎨 Colors | `color_constant.dart` | ✅ 완벽 |
| Typography | 🔠 Typography | `style_constant.dart` | ✅ 완벽 |
| Spacing | 📐 Space | `spacing_constant.dart` | ✅ 완벽 |
| Radius | Foundation | `radius_constant.dart` | ✅ 완벽 |
| Shadows | 💅 Decorate | `style_constant.dart` | ✅ 완벽 |
| Buttons | ⏹️ Button | `widgets/buttons/` | ✅ 완벽 |
| Chips | 🍪 Chip | `widgets/chips/` | ✅ 완벽 |
| Feedback | 🪞 Feedback | `widgets/feedback/` | ✅ 완벽 |
| Forms | ☑️ Selection/Input | `widgets/forms/` | ✅ 완벽 |

---

## High Priority - 필수 위젯 추가

Figma 디자인 라이브러리에 정의되어 있으나 코드에 미구현된 컴포넌트들

### Progress Indicators (⏳ Progress Indicators 페이지)
- [ ] `widgets/indicators/app_linear_progress.dart` - 선형 진행 표시기
  - Props: `value`, `color`, `backgroundColor`, `height`
  - AppColor.primaryNormal 사용
- [ ] `widgets/indicators/app_circular_progress.dart` - 원형 로딩 스피너
  - Props: `size`, `strokeWidth`, `color`
  - 기존 CircularProgressIndicator 래핑
- [ ] `widgets/indicators/app_step_indicator.dart` - 단계 표시기
  - Props: `totalSteps`, `currentStep`, `completedColor`, `activeColor`
  - 온보딩 서베이에서 사용 중인 코드 추출하여 위젯화

### Navigation (🧭 Navigation 페이지)
- [ ] `widgets/navigation/app_bottom_nav.dart` - 하단 네비게이션 바
  - Props: `items`, `currentIndex`, `onTap`
  - AppColor, AppTextStyles 적용
- [ ] `widgets/navigation/app_app_bar.dart` - 앱 바
  - Props: `title`, `leading`, `actions`, `centerTitle`
  - 백 버튼, 타이틀 스타일 표준화

### Divider (➗ Divider 페이지)
- [ ] `widgets/divider/app_divider.dart` - 구분선
  - Props: `thickness`, `color`, `indent`, `endIndent`
  - AppColor.lineNormalNormal 기본값

---

## Medium Priority - 권장 위젯 추가

### Gauge (🌡️ Gauge 페이지)
- [ ] `widgets/gauge/app_preference_gauge.dart` - 선호도 게이지
  - Props: `value` (1-5), `labels`, `colors`
  - 맛 설문에서 사용 가능
  - 그라데이션 배경 (빨강 → 노랑 → 초록)

### Tab Bar (📑 Tab 페이지)
- [ ] `widgets/navigation/app_tab_bar.dart` - 탭 바
  - Props: `tabs`, `controller`, `indicatorColor`
  - AppColor.primaryNormal 인디케이터

### Indicators (💡 Indicators 페이지)
- [ ] `widgets/indicators/app_dot_indicator.dart` - 점 인디케이터
  - Props: `count`, `activeIndex`, `activeColor`
  - 페이지 인디케이터용
- [ ] `widgets/indicators/app_status_indicator.dart` - 상태 인디케이터
  - Props: `status` (success/warning/error/info)
  - AppColor.status* 색상 사용

---

## Low Priority - 선택적 위젯 추가

### Scroll (🖱️ Scroll 페이지)
- [ ] `widgets/scroll/app_scroll_indicator.dart` - 커스텀 스크롤바
  - 디자인 시스템 색상 적용

### Ratio (📏 Ratio 페이지)
- [ ] `widgets/containers/app_aspect_ratio.dart` - 비율 컨테이너
  - 이미지 비율 프리셋 (1:1, 4:3, 16:9)

### Pagination (🔢 Pagination 페이지)
- [ ] `widgets/navigation/app_pagination.dart` - 페이지네이션
  - Props: `currentPage`, `totalPages`, `onPageChanged`

---

## 구현 가이드라인

### 필수 규칙
1. **색상**: 반드시 `AppColor.*` 사용 (하드코딩 금지)
2. **텍스트 스타일**: 반드시 `AppTextStyles.*` 사용
3. **스페이싱**: `AppSpacing.*` 또는 `AppRadius.*` 사용
4. **Props 문서화**: 각 위젯에 dartdoc 주석 필수

### 파일 구조 예시
```dart
// widgets/indicators/app_linear_progress.dart
import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';

/// 선형 진행 표시기
///
/// Usage:
/// ```dart
/// AppLinearProgress(
///   value: 0.7,
///   height: 8,
/// )
/// ```
class AppLinearProgress extends StatelessWidget {
  final double value;
  final double height;
  final Color? color;
  final Color? backgroundColor;

  const AppLinearProgress({
    super.key,
    required this.value,
    this.height = 4,
    this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadius.fullBorder,
      child: LinearProgressIndicator(
        value: value,
        minHeight: height,
        valueColor: AlwaysStoppedAnimation(color ?? AppColor.primaryNormal),
        backgroundColor: backgroundColor ?? AppColor.componentFillNormal,
      ),
    );
  }
}
```

---

## 체크리스트

### High Priority
- [ ] AppLinearProgress 구현
- [ ] AppCircularProgress 구현
- [ ] AppStepIndicator 구현
- [ ] AppBottomNav 구현
- [ ] AppAppBar 구현
- [ ] AppDivider 구현

### Medium Priority
- [ ] AppPreferenceGauge 구현
- [ ] AppTabBar 구현
- [ ] AppDotIndicator 구현
- [ ] AppStatusIndicator 구현

### Low Priority
- [ ] AppScrollIndicator 구현
- [ ] AppAspectRatio 구현
- [ ] AppPagination 구현

**총 미구현 위젯: High 6개 + Medium 4개 + Low 3개 = 13개**

---

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
