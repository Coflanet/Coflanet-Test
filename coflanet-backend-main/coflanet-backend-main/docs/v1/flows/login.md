# 로그인 / 인증 플로우

## 개요

Coflanet은 **Supabase Auth**를 사용하며, 4가지 인증 방식을 지원한다:

| 방식 | 프로바이더 유형 | 구현 방식 |
|------|----------------|-----------|
| 카카오 로그인 | 빌트인 OAuth | `signInWithOAuth()` |
| 애플 로그인 | 빌트인 OAuth | `signInWithOAuth()` |
| 네이버 로그인 | 커스텀 | Edge Function `naver-auth` |
| 게스트 로그인 | 익명 인증 | `signInAnonymously()` |

---

## Supabase Auth 테이블 구조

모든 소셜 로그인은 **동일한 테이블을 공유**한다.

### auth.users — 사용자 1행

어떤 프로바이더로 가입하든 `auth.users`에 1행이 생성되고, 이 `id`가 앱 전체에서 사용자를 식별하는 유일한 키다.

| 컬럼 | 타입 | 역할 |
|------|------|------|
| `id` | UUID | **앱 전체 사용자 ID** — profiles, brew_logs 등 모든 FK가 참조 |
| `email` | VARCHAR | 프로바이더가 제공한 이메일 (없을 수 있음) |
| `is_anonymous` | BOOLEAN | 게스트 사용자 여부 (`signInAnonymously` 시 true) |
| `raw_app_meta_data` | JSONB | `{ "provider": "kakao", "providers": ["kakao"] }` |
| `raw_user_meta_data` | JSONB | `{ "name": "홍길동", "avatar_url": "..." }` — 프로바이더 제공 정보 |
| `last_sign_in_at` | TIMESTAMPTZ | 마지막 로그인 시각 |
| `created_at` | TIMESTAMPTZ | 가입 일시 |

### auth.identities — 프로바이더별 1행

한 사용자가 여러 소셜 계정을 연결할 수 있다 (1:N 관계).

| 컬럼 | 타입 | 역할 |
|------|------|------|
| `id` | UUID | identity 고유 ID |
| `user_id` | UUID | → auth.users.id 참조 |
| `provider` | TEXT | `"kakao"`, `"apple"`, `"naver"`, `"email"` 등 |
| `provider_id` | TEXT | 해당 프로바이더에서의 사용자 고유 ID |
| `identity_data` | JSONB | 프로바이더가 제공한 상세 사용자 정보 |
| `email` | TEXT | 해당 프로바이더의 이메일 |

### 관계도

```
auth.users (Supabase 관리)
  │ id (UUID)
  │
  ├── auth.identities (Supabase 관리)
  │     카카오, 애플, 네이버 등 프로바이더 정보
  │
  └── public.profiles (앱에서 관리)
        │ user_id → auth.users.id
        │
        ├── survey_sessions     (설문)
        ├── survey_results      (설문 결과)
        ├── recommendations     (추천)
        ├── user_bean_lists     (찜 목록)
        ├── recipes             (커스텀 레시피)
        └── brew_logs           (추출 기록)
```

---

## 최초 가입 시 자동 처리

`auth.users`에 INSERT가 발생하면 `on_auth_user_created` 트리거가 `handle_new_user()` 함수를 실행한다.

```sql
-- 트리거 함수
BEGIN
  INSERT INTO public.profiles (user_id)
  VALUES (NEW.id);
  RETURN NEW;
END;
```

**결과**: 어떤 방식으로 가입하든 `profiles` 행이 자동 생성된다.
- `display_name`: NULL (온보딩에서 입력)
- `onboarding_reasons`: '{}' (온보딩에서 선택)
- `survey_completed`: false

---

## 프로바이더별 플로우

### 1. 카카오 로그인 (빌트인)

```
Flutter                          Supabase Auth                    Kakao
  │                                   │                             │
  │ signInWithOAuth(kakao)            │                             │
  │──────────────────────────────────>│                             │
  │                                   │ 카카오 인증 페이지 리다이렉트   │
  │                                   │────────────────────────────>│
  │                                   │                             │
  │                                   │    사용자가 카카오 로그인      │
  │                                   │                             │
  │                                   │   authorization_code 반환    │
  │                                   │<────────────────────────────│
  │                                   │                             │
  │                                   │ code → access_token 교환 (자동)
  │                                   │ 사용자 정보 조회 (자동)
  │                                   │ auth.users 생성/업데이트 (자동)
  │                                   │ auth.identities 생성 (자동)
  │                                   │ handle_new_user 트리거 (최초 시)
  │                                   │                             │
  │   session (JWT) 반환              │                             │
  │<──────────────────────────────────│                             │
  │                                   │                             │
  │ 로그인 후 분기 시퀀스 실행         │                             │
```

**Flutter 코드**:
```dart
await supabase.auth.signInWithOAuth(
  OAuthProvider.kakao,
  redirectTo: 'com.coflanet.app://callback',
);
```

**사전 설정**: Supabase Dashboard → Authentication → Providers → Kakao → Client ID/Secret 입력

### 2. Apple 로그인 (빌트인)

카카오와 동일한 흐름. `OAuthProvider.apple`로 변경만 하면 된다.

```dart
await supabase.auth.signInWithOAuth(
  OAuthProvider.apple,
  redirectTo: 'com.coflanet.app://callback',
);
```

**사전 설정**: Supabase Dashboard → Authentication → Providers → Apple → Service ID/Secret 입력

### 3. 네이버 로그인 (커스텀 Edge Function)

Supabase가 네이버를 빌트인 지원하지 않으므로 Edge Function으로 수동 구현.

```
Flutter (Naver SDK)              Edge Function                   Naver API
  │                              naver-auth                        │
  │ Naver SDK로 로그인             │                                │
  │─────────────────────────────>│                                 │
  │                              │                                 │
  │ authorization_code 획득       │                                │
  │                              │                                 │
  │ code를 Edge Function에 전달   │                                │
  │─────────────────────────────>│                                 │
  │                              │                                 │
  │                              │ Step 1: code → access_token     │
  │                              │ POST /oauth2.0/token             │
  │                              │────────────────────────────────>│
  │                              │<────────────────────────────────│
  │                              │                                 │
  │                              │ Step 2: 사용자 정보 조회          │
  │                              │ GET /v1/nid/me                   │
  │                              │────────────────────────────────>│
  │                              │<────────────────────────────────│
  │                              │                                 │
  │                              │ Step 3: Supabase Admin API로
  │                              │   사용자 조회/생성
  │                              │   (handle_new_user 트리거 발동)
  │                              │
  │                              │ Step 4: 세션 생성
  │                              │
  │ session (JWT) 반환            │
  │<─────────────────────────────│
  │                              │
  │ supabase.auth.setSession()   │
  │ 로그인 후 분기 시퀀스 실행     │
```

**Flutter 코드**:
```dart
// 1. Naver SDK로 로그인하여 code 획득
final naverCode = await NaverLoginSDK.authenticate();

// 2. Edge Function 호출
final response = await supabase.functions.invoke(
  'naver-auth',
  body: { 'code': naverCode },
);

// 3. 반환된 세션 설정
final session = response.data['session'];
await supabase.auth.setSession(session);
```

**사전 설정**:
- 네이버 개발자센터에서 앱 등록 + Client ID/Secret 발급
- Supabase Dashboard → Edge Function Secrets에 `NAVER_CLIENT_ID`, `NAVER_CLIENT_SECRET`, `NAVER_REDIRECT_URI` 설정

**Edge Function**: `supabase/functions/naver-auth/index.ts` (Mock 버전 배포 완료, `verify_jwt: false`)

### 4. 게스트 로그인 (익명 인증)

```
Flutter                          Supabase Auth
  │                                   │
  │ signInAnonymously()               │
  │──────────────────────────────────>│
  │                                   │
  │                                   │ auth.users 생성
  │                                   │   email: null
  │                                   │   is_anonymous: true
  │                                   │ handle_new_user 트리거 발동
  │                                   │   → profiles 자동 생성
  │                                   │
  │   session (JWT) 반환              │
  │<──────────────────────────────────│
  │                                   │
  │ 온보딩 화면으로 이동               │
```

**Flutter 코드**:
```dart
await supabase.auth.signInAnonymously();
```

**사전 설정**: Supabase Dashboard → Authentication → Providers → Anonymous Sign-ins → Enable

---

## 게스트 → 소셜 로그인 전환

### 빌트인 프로바이더 (카카오, 애플)

Supabase의 `linkIdentity()`로 한 줄 처리:

```dart
await supabase.auth.linkIdentity(OAuthProvider.kakao);
```

**내부 동작**:

```
[전환 전]
auth.users:      { id: "uuid-A", email: null, is_anonymous: true }
auth.identities: []
public.profiles: { user_id: "uuid-A", display_name: "커피초보", survey_completed: true }
public.brew_logs: [3건]
public.user_bean_lists: [5건]

          │ linkIdentity(kakao) 호출
          ▼

[Supabase Auth 자동 처리]
1. 카카오 OAuth 플로우 실행
2. auth.users UPDATE:
   - email: null → "hong@kakao.com"
   - is_anonymous: true → false
   - raw_user_meta_data 업데이트
3. auth.identities INSERT:
   - { user_id: "uuid-A", provider: "kakao", provider_id: "kakao_12345" }

          ▼

[전환 후]
auth.users:      { id: "uuid-A", email: "hong@kakao.com", is_anonymous: false }
auth.identities: [{ provider: "kakao" }]
public.profiles: { user_id: "uuid-A", ... }  ← 변경 없음, 데이터 보존
public.brew_logs: [3건 그대로]
public.user_bean_lists: [5건 그대로]
```

**핵심**: `auth.users.id`가 변하지 않으므로 public 테이블 데이터가 전부 보존된다.

**handle_new_user 트리거**: UPDATE이므로 재실행되지 않음 (INSERT 트리거). profiles 중복 생성 없음.

### 네이버 (커스텀 Edge Function)

`linkIdentity()`를 쓸 수 없으므로, `naver-auth` Edge Function에 전환 모드를 추가해야 한다:

```dart
// Flutter에서 현재 세션 + naver code 전달
final response = await supabase.functions.invoke(
  'naver-auth',
  body: {
    'code': naverCode,
    'mode': 'link',  // 전환 모드 명시
  },
);
```

Edge Function 내부:
1. 현재 세션에서 user_id 추출 (Authorization 헤더)
2. Naver API로 사용자 정보 조회
3. `supabaseAdmin.auth.admin.updateUserById(userId, { email, user_metadata, ... })`
4. is_anonymous → false 처리
5. 갱신된 세션 반환

### 전환 시 이메일 충돌 처리

```
게스트 A가 카카오(hong@kakao.com)로 전환 시도
  → hong@kakao.com으로 이미 가입한 사용자 B가 존재

결과: linkIdentity 실패 → 에러 반환
```

**프론트 처리**:
- "이미 가입된 계정이 있습니다. 해당 계정으로 로그인해 주세요." 안내
- 게스트 데이터는 보존되지 않음 (기존 계정으로 전환 불가)
- 사용자가 기존 계정(B)으로 로그인하면 게스트(A) 데이터는 별도

---

## 로그인 후 분기 시퀀스

모든 로그인 방식에서 세션 획득 후 동일한 분기를 실행한다:

```
로그인 성공 (세션 획득)
  │
  ▼
get_onboarding_status() RPC 호출
  │   → next_screen 필드로 분기 결정
  │
  ├── display_name 없음 OR onboarding_reasons 없음
  │     → next_screen: 'onboarding' → /onboarding
  │
  ├── 설문 미완료 (analyzed 세션 없음)
  │     → next_screen: 'survey' → /survey
  │
  ├── 추천 미생성 (설문 완료했으나 추천 없음)
  │     → next_screen: 'survey_result' → /survey-result
  │
  └── 모두 완료
        → next_screen: 'main' → /home
```

**역방향 가드**: 이미 로그인 상태에서 로그인 화면 접근 시 → 홈으로 리다이렉트

---

## 프로바이더별 비교 요약

| | 카카오 | 애플 | 네이버 | 게스트 |
|---|---|---|---|---|
| Supabase 지원 | 빌트인 | 빌트인 | 미지원 | 빌트인 |
| Flutter 호출 | `signInWithOAuth()` | `signInWithOAuth()` | Naver SDK + Edge Function | `signInAnonymously()` |
| 토큰 교환 | 자동 | 자동 | Edge Function 수동 | 없음 |
| 사용자 생성 | 자동 | 자동 | Admin API 수동 | 자동 |
| profiles 생성 | 트리거 자동 | 트리거 자동 | 트리거 자동 | 트리거 자동 |
| 게스트→전환 | `linkIdentity()` | `linkIdentity()` | Edge Function 전환 모드 | - |
| 사전 설정 | Dashboard ID/Secret | Dashboard ID/Secret | Dashboard Secrets + Edge Function 배포 | Dashboard Enable |

---

## 사전 설정 체크리스트

- [ ] Supabase Dashboard → Authentication → Providers → **Kakao** 활성화 (Client ID/Secret)
- [ ] Supabase Dashboard → Authentication → Providers → **Apple** 활성화 (Service ID/Secret)
- [ ] Supabase Dashboard → Authentication → Providers → **Anonymous Sign-ins** 활성화
- [ ] 네이버 개발자센터 → 앱 등록 → Client ID/Secret 발급
- [ ] Supabase Dashboard → Edge Function Secrets → `NAVER_CLIENT_ID`, `NAVER_CLIENT_SECRET`, `NAVER_REDIRECT_URI`
- [ ] Supabase Dashboard → Authentication → URL Configuration → Flutter 딥링크 콜백 URL 등록
- [x] Edge Function `naver-auth` 배포 (verify_jwt: false) — Mock 버전 배포 완료
