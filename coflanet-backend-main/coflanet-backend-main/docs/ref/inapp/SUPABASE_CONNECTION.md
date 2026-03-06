# Coflanet — Flutter Supabase 연동 가이드

## 1. 연결 정보

| 항목 | 값 |
|------|-----|
| API URL | `https://npaugqqpzvponcsvkehs.supabase.co` |
| Anon Key | `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5wYXVncXFwenZwb25jc3ZrZWhzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzA2NDU1MjMsImV4cCI6MjA4NjIyMTUyM30.0mtCZaEiEY6hLrETq3nx1_SgwJ1hfoAqdcwkCDRckS4` |
| 딥링크 콜백 | `com.coflanet.app://callback` |

## 2. 패키지 & 초기화

```yaml
# pubspec.yaml
dependencies:
  supabase_flutter: ^2.8.0
```

```dart
// lib/main.dart
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://npaugqqpzvponcsvkehs.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIs...',  // 위 Anon Key 전체
  );
  runApp(const CoflanetApp());
}

final supabase = Supabase.instance.client;
```

## 3. 통신 방식

Coflanet 백엔드는 **3가지 통신 방식**을 사용합니다.

### 3-1. RPC 호출 (서버 함수)

비즈니스 로직이 포함된 PostgreSQL 함수를 호출합니다. 대부분의 화면에서 이 방식을 사용합니다.

```dart
// 파라미터 없는 경우
final result = await supabase.rpc('get_onboarding_status');

// 파라미터 있는 경우
final result = await supabase.rpc('save_display_name', params: {
  'display_name': '김택림',
});
```

**사용 가능한 RPC 함수:**

| 함수 | 파라미터 | 용도 |
|------|----------|------|
| `get_onboarding_status` | — | 로그인 후 다음 화면 분기 |
| `get_onboarding_options` | — | 가입 이유 선택지 목록 |
| `save_display_name` | `display_name: text` | 닉네임 저장 |
| `save_onboarding_reasons` | `reasons: text[]` | 가입 이유 저장 |
| `retake_survey` | — | 설문 재실행 (새 세션 생성) |
| `get_my_recommendations` | — | 추천 원두 목록 (상위 5개) |
| `get_my_taste_profile` | — | 맛 프로필 + 플레이버 조회 |
| `get_my_bean_list` | — | 찜한 원두 리스트 |
| `remove_from_coffee_list` | `p_bean_id: uuid` | 원두 찜 제거 |
| `reorder_coffee_list` | `p_bean_ids: uuid[]` | 리스트 순서 변경 |
| `get_merged_recipe` | `p_brew_method_id: uuid`, `p_bean_id?: uuid` | 병합 레시피 조회 |
| `save_custom_recipe` | `p_brew_method_id`, `p_bean_id`, `p_name`, `p_values?` | 커스텀 레시피 저장 |
| `get_my_dashboard` | — | 마이페이지 대시보드 집계 |
| `get_my_brew_stats` | — | 브루잉 통계 |

### 3-2. 테이블 직접 쿼리 (CRUD)

Supabase PostgREST API로 테이블을 직접 조회/수정합니다. RLS가 적용되어 본인 데이터만 접근됩니다.

```dart
// SELECT
final beans = await supabase
    .from('coffee_beans')
    .select('*, bean_flavor_tags(*)')
    .eq('is_available', true);

// INSERT
await supabase.from('brew_logs').insert({
  'user_id': supabase.auth.currentUser!.id,
  'bean_id': beanId,
  'rating': 4,
});

// UPDATE
await supabase
    .from('profiles')
    .update({'is_dark_mode': true})
    .eq('user_id', supabase.auth.currentUser!.id);

// DELETE
await supabase
    .from('user_bean_lists')
    .delete()
    .eq('id', itemId);
```

### 3-3. Edge Function 호출

복잡한 서버 로직은 Edge Function으로 처리합니다.

```dart
final response = await supabase.functions.invoke(
  'submit-survey',
  body: {'session_id': sessionId},
);
final data = response.data as Map<String, dynamic>;
```

**배포된 Edge Functions:**

| 함수 | 인증 필수 | 용도 |
|------|:---------:|------|
| `submit-survey` | ✅ | 설문 완료 → 맛 프로필 산출 → 원두 추천 |
| `match-coffee` | ✅ | 기존 설문 결과로 원두 재매칭 |
| `delete-account` | ✅ | 회원 탈퇴 (전체 데이터 삭제) |
| `naver-auth` | ❌ | 네이버 로그인 처리 |

## 4. 인증

```dart
// 카카오
await supabase.auth.signInWithOAuth(OAuthProvider.kakao,
    redirectTo: 'com.coflanet.app://callback');

// 애플
await supabase.auth.signInWithOAuth(OAuthProvider.apple,
    redirectTo: 'com.coflanet.app://callback');

// 게스트
await supabase.auth.signInAnonymously();

// 네이버 (Edge Function)
final res = await supabase.functions.invoke('naver-auth', body: {'code': naverCode});

// 로그아웃
await supabase.auth.signOut();

// 현재 사용자
final user = supabase.auth.currentUser;
final session = supabase.auth.currentSession;

// 인증 상태 변화 리스너
supabase.auth.onAuthStateChange.listen((data) {
  // data.event: signedIn, signedOut, tokenRefreshed 등
  // data.session: 현재 세션
});
```
