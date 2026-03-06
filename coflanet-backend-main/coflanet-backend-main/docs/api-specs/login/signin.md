# 로그인 화면 API 연동 가이드

> Figma: `figma/login/Signin.png`

## 화면 개요

| 항목 | 값 |
|------|-----|
| 화면명 | 로그인 |
| 경로 | `/login` |
| 인증 필수 | ❌ (비인증 상태에서 접근) |
| 설문 완료 필수 | ❌ |
| 진입 경로 | 앱 최초 실행 / 로그아웃 후 |

## 인증 가드

```dart
// 역방향 가드: 이미 로그인 상태이면 분기 실행
if (supabase.auth.currentUser != null) {
  final status = await supabase.rpc('get_onboarding_status');
  // status['next_screen']에 따라 리다이렉트
}
```

| 가드 | 체크 대상 | 동작 |
|------|-----------|------|
| ReverseAuthGuard | `supabase.auth.currentUser != null` | `get_onboarding_status()` → `next_screen`으로 리다이렉트 |

## API 목록

| # | API | 유형 | 시점 | 설명 |
|---|-----|------|------|------|
| 1 | `signInWithOAuth(kakao)` | Auth | 카카오 버튼 탭 | 카카오 OAuth 로그인 |
| 2 | `naver-auth` | Edge Function | 네이버 버튼 탭 | 네이버 커스텀 로그인 |
| 3 | `signInWithOAuth(apple)` | Auth | Apple 버튼 탭 | Apple OAuth 로그인 |
| 4 | `signInAnonymously()` | Auth | 게스트 로그인 탭 | 익명 로그인 |
| 5 | `get_onboarding_status()` | RPC | 로그인 성공 후 | 다음 화면 분기 판단 |

## API 상세

### API 1: 카카오 로그인

**호출 코드**:
```dart
await supabase.auth.signInWithOAuth(
  OAuthProvider.kakao,
  redirectTo: 'com.coflanet.app://callback',
);
```

**결과**: 세션(JWT) 자동 설정. `supabase.auth.currentUser`에서 사용자 정보 접근 가능.

**내부 자동 처리**:
- `auth.users` 생성 (최초 로그인 시)
- `auth.identities` 생성 (provider: kakao)
- `handle_new_user` 트리거 → `profiles` 자동 생성 (최초 시)

### API 2: 네이버 로그인 (Edge Function)

**호출 코드**:
```dart
// 1. Naver SDK로 authorization_code 획득
final naverCode = await NaverLoginSDK.authenticate();

// 2. Edge Function 호출
final response = await supabase.functions.invoke(
  'naver-auth',
  body: {'code': naverCode},
);

// 3. 반환된 세션 설정
final data = response.data as Map<String, dynamic>;
final session = data['data']['session'];
await supabase.auth.setSession(
  session['access_token'],
  refreshToken: session['refresh_token'],
);
```

**Request Body**:
```json
{
  "code": "네이버_authorization_code"
}
```

**Response JSON 예시**:
```json
{
  "success": true,
  "data": {
    "session": {
      "access_token": "eyJhbGciOiJIUzI1NiIs...",
      "refresh_token": "v1.MjQ5ZjVm...",
      "expires_in": 3600,
      "token_type": "bearer",
      "user": {
        "id": "uuid-사용자-id",
        "email": "user@naver.com",
        "user_metadata": {
          "name": "홍길동",
          "avatar_url": "https://...",
          "provider": "naver",
          "naver_id": "naver_12345"
        }
      }
    }
  }
}
```

**에러 케이스**:
| 코드 | HTTP | 원인 | 프론트 처리 |
|------|------|------|------------|
| MISSING_CODE | 400 | code 누락 | 재시도 안내 |
| CREATE_USER_FAILED | 400 | 사용자 생성 실패 | 에러 토스트 |
| SESSION_FAILED | 500 | 세션 생성 실패 | 재시도 안내 |
| VERIFY_FAILED | 500 | 세션 검증 실패 | 재시도 안내 |

### API 3: Apple 로그인

**호출 코드**:
```dart
await supabase.auth.signInWithOAuth(
  OAuthProvider.apple,
  redirectTo: 'com.coflanet.app://callback',
);
```

> 카카오와 동일한 흐름. 내부 자동 처리도 동일.

### API 4: 게스트 로그인

**호출 코드**:
```dart
await supabase.auth.signInAnonymously();
```

**결과**: `auth.users` 생성 (`is_anonymous: true`), `profiles` 자동 생성.

> 게스트 사용자도 온보딩/설문 가능. 이후 소셜 계정 전환 시 데이터 보존됨.

### API 5: 로그인 후 분기 (get_onboarding_status)

**호출 코드**:
```dart
final status = await supabase.rpc('get_onboarding_status');
final nextScreen = status['next_screen'] as String;

switch (nextScreen) {
  case 'onboarding':
    // → /onboarding (이름 입력)
    break;
  case 'survey':
    // → /survey (설문)
    break;
  case 'survey_result':
    // → /survey-result (설문 결과 대기)
    break;
  case 'main':
    // → /home (메인)
    break;
}
```

**Response JSON 예시**:
```json
{
  "has_profile": true,
  "has_nickname": false,
  "has_signup_reasons": false,
  "has_completed_survey": false,
  "has_recommendations": false,
  "latest_survey_type": null,
  "next_screen": "onboarding"
}
```

**에러 케이스**:
| HTTP 상태 | 원인 | 프론트 처리 |
|-----------|------|------------|
| 401 | 미인증 (UNAUTHORIZED) | 로그인 화면 유지 |

## 사용자 액션 매핑

| # | 사용자 액션 | API 호출 | 성공 시 UI 변경 | 실패 시 처리 |
|---|------------|----------|----------------|-------------|
| 1 | 카카오 버튼 탭 | `signInWithOAuth(kakao)` | 카카오 웹뷰 → 세션 획득 → 분기 | "로그인에 실패했습니다" 토스트 |
| 2 | 네이버 버튼 탭 | Naver SDK → `naver-auth` | 세션 획득 → 분기 | "로그인에 실패했습니다" 토스트 |
| 3 | Apple 버튼 탭 | `signInWithOAuth(apple)` | Apple 시트 → 세션 획득 → 분기 | "로그인에 실패했습니다" 토스트 |
| 4 | 게스트 로그인 탭 | `signInAnonymously()` | 세션 획득 → 온보딩 화면 | "로그인에 실패했습니다" 토스트 |
| 5 | 로그인 성공 (자동) | `get_onboarding_status()` | `next_screen`에 따라 라우팅 | 온보딩 화면으로 기본 이동 |

## 네비게이션 파라미터

### 이 화면으로 진입 시 필요한 파라미터
| 파라미터 | 타입 | 필수 | 출처 화면 | 설명 |
|----------|------|:----:|-----------|------|
| - | - | - | - | 파라미터 없음 (루트 화면) |

### 이 화면에서 다른 화면으로 전달하는 파라미터
| 대상 화면 | 파라미터 | 타입 | 설명 |
|-----------|----------|------|------|
| 온보딩 (이름 입력) | - | - | `get_onboarding_status()` 결과로 자동 라우팅 |
| 설문 | - | - | `get_onboarding_status()` 결과로 자동 라우팅 |
| 메인 홈 | - | - | `get_onboarding_status()` 결과로 자동 라우팅 |

## 참고사항

- 모든 로그인 방식은 `handle_new_user` 트리거를 통해 `profiles`를 자동 생성
- 게스트 → 소셜 전환은 마이페이지에서 처리 (이 화면에서는 미노출)
- `naver-auth`는 현재 Mock 버전 (고정 테스트 계정 `mock-naver@coflanet.dev`)
- Supabase Dashboard에서 카카오/애플/Anonymous 프로바이더 활성화 필요
