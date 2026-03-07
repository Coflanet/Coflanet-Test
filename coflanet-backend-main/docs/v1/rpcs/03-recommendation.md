# 03. 추천/매칭 — Edge Function 수정

> Phase 1 | ✅ 완료 (2026-02-28)
>
> 참조: `docs/flows/03-recommendation.md`

## 기존 RPC (2개) — 유지

| RPC | 용도 | 상태 |
|-----|------|------|
| `get_my_taste_profile()` | 최신 맛 프로필 + 플레이버 조회 | ✅ |
| `get_my_recommendations()` | 최신 추천 원두 5개 조회 | ✅ |

## Edge Functions — ✅ 401 수정 완료

| 함수 | 상태 | 수정 내용 |
|------|------|-----------|
| `submit-survey` | ✅ v4 배포 | `getUser()` → `getUser(token)` 수정 |
| `match-coffee` | ✅ v3 배포 | `getUser()` → `getUser(token)` 수정 완료 |
| `delete-account` | ✅ v2 배포 | `getUser()` → `getUser(token)` 수정 |

> **원인**: Deno Edge Function 환경에서 `getUser()` (파라미터 없음) 호출 시 세션 스토리지가 없어 JWT를 찾지 못함.
> **해결**: Authorization 헤더에서 토큰을 추출하여 `getUser(token)`으로 명시적 전달.
> survey_results, recommendations는 service_role INSERT 전용이므로 RPC로 대체 불가.

---

## 401 에러 디버깅 절차

### 1단계: 로그 확인

```sql
-- Edge Function 로그 확인 (Supabase MCP)
-- get_logs('edge-function')
```

### 2단계: Flutter 측 요청 확인

```dart
// 올바른 호출 방식
final response = await supabase.functions.invoke(
  'submit-survey',
  body: {'session_id': sessionId},
  // headers는 supabase client가 자동 첨부
  // Authorization: Bearer <access_token>
);
```

### 3단계: Edge Function 코드 확인 포인트

```typescript
// ✅ 올바른 패턴
const authHeader = req.headers.get('Authorization');
if (!authHeader) {
  return new Response(JSON.stringify({ error: 'UNAUTHORIZED' }), { status: 401 });
}

const token = authHeader.replace('Bearer ', '');
const { data: { user }, error } = await supabaseClient.auth.getUser(token);

// ❌ 흔한 실수: supabaseClient를 anon key로 생성
// → service_role client와 auth 검증 client를 분리해야 함
```

### 4단계: CORS 확인

```typescript
// Edge Function에 CORS 핸들링 필수
if (req.method === 'OPTIONS') {
  return new Response('ok', {
    headers: {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
    },
  });
}
```

---

## 예상 원인 및 수정 방안

### 원인 A: JWT 토큰 추출 오류

```typescript
// 수정 전 (잘못된 예)
const token = req.headers.get('authorization');  // 'Bearer xxx' 전체가 옴

// 수정 후
const authHeader = req.headers.get('Authorization') ?? '';
const token = authHeader.replace('Bearer ', '');
```

### 원인 B: Supabase Client 초기화 문제

```typescript
// 수정 전 (service_role로 auth.getUser 시도 → 실패 가능)
const supabase = createClient(url, serviceRoleKey);
const { data: { user } } = await supabase.auth.getUser(token);

// 수정 후 (anon client로 인증, service_role로 데이터 조작)
const authClient = createClient(url, anonKey, {
  global: { headers: { Authorization: `Bearer ${token}` } }
});
const { data: { user }, error } = await authClient.auth.getUser(token);

const serviceClient = createClient(url, serviceRoleKey);
// serviceClient로 survey_results, recommendations INSERT
```

### 원인 C: verify_jwt 설정과 수동 검증 충돌

```
현재: verify_jwt = true (Supabase가 JWT 자동 검증)
→ Edge Function 내부에서 또 검증하면 중복
→ req.headers에서 직접 user 정보 추출 시 방식 확인 필요

확인: Supabase verify_jwt=true이면 유효하지 않은 JWT는 Edge Function 도달 전 차단됨
→ 401이 Supabase 게이트웨이에서 나오는지, Edge Function 내부에서 나오는지 구분 필요
```

---

## 수정 후 검증

```dart
// Flutter 테스트
try {
  final result = await supabase.functions.invoke(
    'submit-survey',
    body: {'session_id': sessionId},
  );
  print('성공: ${result.data}');
} on FunctionException catch (e) {
  print('상태: ${e.status}');  // 401이면 아직 미해결
  print('바디: ${e.details}');
}
```

---

## 신규 RPC: 없음

이 도메인의 모든 읽기 작업은 기존 RPC로 충분:
- `get_my_taste_profile()` — 맛 프로필
- `get_my_recommendations()` — 추천 원두

쓰기 작업은 Edge Function(service_role)이 필수:
- `submit-survey` — survey_results, survey_result_flavors, recommendations INSERT
- `match-coffee` — recommendations DELETE + INSERT
