# 서버-앱 통합 이슈 및 RPC 전환 계획

> 도메인별 데이터 플로우(`docs/flows/`)를 기반으로, 모든 클라이언트 API를 RPC로 통합하기 위한 현황 분석 및 작업 목록.
>
> _마지막 업데이트: 2026-02-28_

---

## 0. 서버 현황 요약

### 서버에 존재하는 RPC (15개)

| RPC | 파라미터 | 보안 | 상태 |
|-----|----------|------|------|
| `get_onboarding_status` | 없음 | INVOKER | ✅ 정상 |
| `get_onboarding_options` | 없음 | INVOKER | ✅ 정상 |
| `save_display_name` | `display_name text` | INVOKER | ✅ 정상 |
| `save_onboarding_reasons` | `reasons text[]` | INVOKER | ✅ 정상 |
| `get_my_taste_profile` | 없음 | INVOKER | ✅ 정상 |
| `get_my_recommendations` | 없음 | INVOKER | ✅ 정상 |
| `retake_survey` | 없음 | INVOKER | ✅ 정상 |
| `get_my_bean_list` | 없음 | INVOKER | ✅ 정상 |
| `remove_from_coffee_list` | `p_bean_id uuid` | INVOKER | ✅ 정상 |
| `reorder_coffee_list` | `p_bean_ids uuid[]` | INVOKER | ✅ 정상 |
| `get_merged_recipe` | `p_brew_method_id uuid, p_bean_id uuid?` | INVOKER | ✅ 정상 |
| `save_custom_recipe` | `p_brew_method_id uuid, p_bean_id uuid, p_name text, p_values jsonb` | INVOKER | ⚠️ **존재하지만 앱 미사용** |
| `get_my_brew_stats` | 없음 | INVOKER | ✅ 정상 |
| `get_my_dashboard` | 없음 | INVOKER | ✅ 정상 |
| `delete_user_data` | `p_user_id uuid` | SECURITY DEFINER | ✅ 정상 |

### Edge Functions (4개)

| 함수 | verify_jwt | 상태 |
|------|-----------|------|
| `naver-auth` | false | ✅ 정상 |
| `submit-survey` | true | ❌ **401 에러** |
| `match-coffee` | true | ⚠️ 미확인 |
| `delete-account` | true | ❌ **401 에러** |

### 핵심 불일치 발견

| 항목 | 앱 측 인식 | 서버 실제 | 조치 |
|------|-----------|-----------|------|
| `save_custom_recipe` RPC | "존재하지 않음" (직접 INSERT로 수정) | **존재함** | 앱에서 RPC 호출로 복원 |
| `profiles.is_dark_mode` | "확인 필요" | **존재함** | 앱에서 정상 사용 가능 |
| `coffee_beans` INSERT | 직접 INSERT 시도 → RLS 차단 | INSERT RLS 정책 없음 | `add_custom_bean` RPC 생성 |
| `recipes` 직접 INSERT | "RLS 확인 필요" | INSERT RLS 정책 **있음** (`user_id = auth.uid()`) | `save_custom_recipe` RPC 사용 권장 |

---

## 1. 인증/온보딩 도메인

> 참조: `docs/flows/01-auth-onboarding.md`

### 현재 RPC (4개) — 모두 정상

| 작업 | 현재 방식 | 상태 |
|------|-----------|------|
| 온보딩 상태 확인 | `get_onboarding_status()` RPC | ✅ |
| 온보딩 선택지 조회 | `get_onboarding_options()` RPC | ✅ |
| 닉네임 저장 | `save_display_name(text)` RPC | ✅ |
| 가입 이유 저장 | `save_onboarding_reasons(text[])` RPC | ✅ |

### 신규 RPC 필요 (1개)

| RPC 이름 | 용도 | 우선순위 |
|----------|------|----------|
| `update_profile` | 프로필 통합 수정 (dark_mode, avatar_url, coffee_level) | 중간 |

#### `update_profile(p_values jsonb)` 상세

```
현재: 앱에서 profiles 테이블 직접 UPDATE
문제: UPDATE RLS 정책은 있으나, 필드 검증 없이 직접 수정
개선: RPC로 통합하여 값 검증 + 일관된 응답 반환
```

**입력:**
```json
{
  "is_dark_mode": true,
  "avatar_url": "https://...",
  "coffee_level": "enthusiast"
}
```

**동작:**
- `coffee_level` CHECK 검증 (beginner/enthusiast/home_barista/professional)
- 변경된 필드만 UPDATE (COALESCE)
- 전체 profile 반환

---

## 2. 설문 도메인

> 참조: `docs/flows/02-survey.md`

### 현재 RPC (1개) — 정상

| 작업 | 현재 방식 | 상태 |
|------|-----------|------|
| 설문 재시도 | `retake_survey()` RPC | ✅ |

### 직접 테이블 접근 → RPC 전환 필요 (3개)

| 작업 | 현재 방식 | 문제 | RLS 정책 |
|------|-----------|------|----------|
| 설문 시작 | `survey_sessions` 직접 INSERT | 비즈니스 로직 분산 | INSERT ✅ |
| 답변 저장 | `survey_answers` 직접 INSERT + `survey_sessions` UPDATE | 트랜잭션 미보장 | INSERT ✅ |
| 설문 완료 | `survey_sessions` 직접 UPDATE | 상태 전이 검증 없음 | UPDATE ✅ |

### 신규 RPC 설계

#### 2-1. `start_survey(p_survey_type text)` → jsonb

```
동작:
  1. p_survey_type CHECK ('preference', 'lifestyle')
  2. 기존 in_progress 세션 있으면 → 해당 세션 반환 (중복 방지)
  3. INSERT survey_sessions { user_id, survey_type, status: 'in_progress', current_step: 1 }
  4. 해당 survey_type의 질문+선택지도 함께 반환 (조회 1회로 통합)

반환:
  {
    "session_id": "uuid",
    "survey_type": "preference",
    "current_step": 1,
    "is_resumed": false,
    "questions": [
      {
        "id": "uuid",
        "question_key": "taste_acidity",
        "question_text": "산미가 있는 커피를 좋아하시나요?",
        "answer_type": "scale_3",
        "step": 3,
        "options": [...]
      }
    ]
  }
```

#### 2-2. `save_survey_answers(p_session_id uuid, p_answers jsonb)` → jsonb

```
동작:
  1. session 소유권 확인 (user_id = auth.uid())
  2. session.status = 'in_progress' 확인
  3. p_answers 배열 순회 → UPSERT survey_answers (question_id 기준)
  4. current_step 자동 계산 (저장된 답변의 max step + 1)
  5. UPDATE survey_sessions.current_step

입력:
  {
    "session_id": "uuid",
    "answers": [
      { "question_id": "uuid", "selected_options": ["acidic", "sweet"] },
      { "question_id": "uuid", "score_value": 3 }
    ]
  }

반환:
  {
    "saved_count": 5,
    "current_step": 3,
    "total_steps": 5,
    "is_last_step": false
  }
```

#### 2-3. `complete_survey(p_session_id uuid)` → jsonb

```
동작:
  1. session 소유권 + status = 'in_progress' 확인
  2. 모든 필수 질문에 답변이 있는지 검증
  3. UPDATE survey_sessions SET status = 'completed', completed_at = now()

반환:
  {
    "session_id": "uuid",
    "status": "completed",
    "ready_for_analysis": true,
    "answer_count": 20
  }
```

---

## 3. 추천/매칭 도메인

> 참조: `docs/flows/03-recommendation.md`

### 현재 RPC (2개) — 정상

| 작업 | 현재 방식 | 상태 |
|------|-----------|------|
| 맛 프로필 조회 | `get_my_taste_profile()` RPC | ✅ |
| 추천 원두 조회 | `get_my_recommendations()` RPC | ✅ |

### Edge Functions — 수정 필요

| 작업 | 현재 방식 | 상태 | 문제 |
|------|-----------|------|------|
| 설문 분석+추천 | `submit-survey` Edge Function | ❌ **401** | JWT 검증 또는 CORS |
| 재매칭 | `match-coffee` Edge Function | ⚠️ 미확인 | 앱에서 호출 테스트 필요 |

### Edge Function 401 수정 방안

```
가능한 원인 (우선순위 순):
1. Flutter에서 Authorization 헤더를 올바르게 전송하지 않음
   → 확인: Headers에 'Authorization': 'Bearer ${session.access_token}' 포함 여부
2. Edge Function 내부 JWT 파싱 오류
   → 확인: supabaseClient.auth.getUser(token) 호출 방식
3. CORS preflight (OPTIONS) 요청에 대한 처리 누락
   → 확인: OPTIONS 메서드 핸들링

디버깅 순서:
1. get_logs('edge-function')으로 에러 로그 확인
2. Edge Function 코드에서 JWT 검증 로직 확인
3. Flutter 측 요청 헤더 확인
```

> **이 도메인은 Edge Function이 필수** (service_role로 survey_results, recommendations INSERT). RPC로 대체 불가.

---

## 4. 원두 카탈로그/찜 도메인

> 참조: `docs/flows/04-coffee-beans.md`

### 현재 RPC (3개) — 정상

| 작업 | 현재 방식 | 상태 |
|------|-----------|------|
| 찜 목록 조회 | `get_my_bean_list()` RPC | ✅ |
| 찜 해제 | `remove_from_coffee_list(bean_id)` RPC | ✅ |
| 찜 순서 변경 | `reorder_coffee_list(bean_ids[])` RPC | ✅ |

### 직접 테이블 접근 → RPC 전환 필요 (4개)

| 작업 | 현재 방식 | 문제 | RLS 정책 |
|------|-----------|------|----------|
| 원두 카탈로그 조회 | `coffee_beans` 직접 SELECT | 플레이버 태그 별도 쿼리 필요 | SELECT ✅ |
| 원두 추가 (커스텀) | `coffee_beans` 직접 INSERT | **RLS INSERT 정책 없음 → 차단** | INSERT ❌ |
| 원두 편집 (커스텀) | `coffee_beans` 직접 UPDATE | **RLS UPDATE 정책 없음 → 차단** | UPDATE ❌ |
| 찜하기 | `user_bean_lists` 직접 INSERT | 중복 체크 없음 | INSERT ✅ |

### 신규 RPC 설계

#### 4-1. `get_coffee_catalog(p_filters jsonb DEFAULT '{}')` → jsonb

```
동작:
  1. coffee_beans + bean_flavor_tags JOIN
  2. 필터 적용 (roast_level, origin, is_available 등)
  3. 각 원두의 찜 여부도 함께 반환 (user_bean_lists LEFT JOIN)

입력 (모두 선택):
  {
    "roast_level": "light",
    "origin": "Ethiopia",
    "is_available": true,
    "search": "예가",
    "limit": 20,
    "offset": 0
  }

반환:
  {
    "beans": [
      {
        "id": "uuid",
        "name": "에티오피아 예가체프",
        "origin": ["Ethiopia"],
        "roast_level": "light",
        "acidity": 90, "sweetness": 65, ...
        "flavor_tags": [...],
        "is_in_my_list": true
      }
    ],
    "total_count": 97
  }
```

#### 4-2. `add_custom_bean(p_values jsonb)` → jsonb — **SECURITY DEFINER**

```
동작:
  1. 인증 확인 (auth.uid() NOT NULL)
  2. 필수 필드 검증 (name)
  3. INSERT coffee_beans
  4. INSERT user_bean_lists { user_id, bean_id, added_from: 'manual' }
  5. bean_id 반환

보안: SECURITY DEFINER (coffee_beans에 INSERT RLS 없으므로)

입력:
  {
    "name": "내 원두",
    "origin": ["Colombia"],
    "roast_level": "medium",
    "description": "..."
  }

반환:
  {
    "bean_id": "uuid",
    "list_item_id": "uuid"
  }
```

#### 4-3. `update_custom_bean(p_bean_id uuid, p_values jsonb)` → jsonb — **SECURITY DEFINER**

```
동작:
  1. 인증 확인
  2. 해당 원두가 user_bean_lists에서 added_from='manual'로 본인 것인지 확인
  3. 변경 필드만 UPDATE (COALESCE)

보안: SECURITY DEFINER + 소유권 검증 (user_bean_lists 경유)

반환:
  { "updated": true }
```

#### 4-4. `add_to_coffee_list(p_bean_id uuid, p_added_from text DEFAULT 'manual')` → jsonb

```
동작:
  1. 인증 확인
  2. 중복 체크 (이미 찜한 원두면 에러 대신 기존 항목 반환)
  3. sort_order = 현재 최대값 + 1
  4. INSERT user_bean_lists

반환:
  {
    "id": "uuid",
    "is_new": true,
    "sort_order": 6
  }
```

---

## 5. 레시피/타이머 도메인

> 참조: `docs/flows/05-recipe-timer.md`

### 현재 RPC (2개)

| 작업 | 현재 방식 | 상태 |
|------|-----------|------|
| 병합 레시피 조회 | `get_merged_recipe(brew_method_id, bean_id?)` RPC | ✅ |
| 커스텀 레시피 저장 | `save_custom_recipe(...)` RPC | ⚠️ **서버에 존재하지만 앱 미사용** |

### 직접 테이블 접근 → RPC 전환 필요 (3개)

| 작업 | 현재 방식 | 문제 | RLS 정책 |
|------|-----------|------|----------|
| 레시피 직접 저장 | `recipes` + `recipe_steps` + `recipe_aroma_tags` 직접 INSERT | 3번 INSERT 비효율, 트랜잭션 미보장 | INSERT ✅ |
| 레시피 삭제 | `recipes` 직접 DELETE | 자식 테이블 정리 안됨 | DELETE ✅ |
| 추출 기구 조회 | `brew_methods` 직접 SELECT | 단순 참조 | SELECT ✅ |

### 조치 사항

#### 5-1. `save_custom_recipe` — 앱에서 RPC 호출로 복원 (서버 작업 불필요)

```
⚠️ 이 RPC는 서버에 이미 존재합니다!

서버 시그니처:
  save_custom_recipe(
    p_brew_method_id uuid,
    p_bean_id uuid,
    p_name text,
    p_values jsonb DEFAULT '{}'
  ) → jsonb

p_values 예시:
  {
    "cups": 1,
    "strength": "balanced",
    "coffee_amount_g": 18,
    "water_temp_c": 93,
    "steps": [
      { "step_number": 1, "title": "뜸 들이기", "step_type": "brewing", "duration_seconds": 30 }
    ],
    "aroma_tags": [
      { "emoji": "🌰", "name": "견과류", "display_order": 1 }
    ]
  }

반환:
  { "recipe_id": "uuid", "is_new": true/false }

기능:
  - 동일 (user_id, brew_method_id, bean_id) 조합이면 UPDATE, 아니면 INSERT
  - steps, aroma_tags는 전체 교체 (DELETE → INSERT)
  - 앱에서 직접 INSERT 3회 → RPC 1회로 통합 가능
```

> **앱 측 수정**: `recipes` + `recipe_steps` + `recipe_aroma_tags` 직접 INSERT 코드를 `save_custom_recipe` RPC 호출로 복원하면 됨. 서버 작업 불필요.

#### 5-2. `delete_custom_recipe(p_recipe_id uuid)` → jsonb (신규)

```
동작:
  1. 소유권 확인 (recipes.user_id = auth.uid())
  2. DELETE recipe_aroma_tags WHERE recipe_id
  3. DELETE recipe_steps WHERE recipe_id
  4. DELETE recipes WHERE id
  5. 관련 brew_logs의 recipe_id → NULL 처리

반환:
  { "deleted": true }
```

#### 5-3. `get_brew_methods()` → jsonb (신규, 선택)

```
동작:
  SELECT brew_methods ORDER BY name

반환:
  [
    { "id": "uuid", "slug": "hario-v60", "name": "하리오 V60", "category": "handdrip", "equipment": [...] }
  ]

비고: 단순 SELECT이므로 직접 테이블 접근도 문제 없음. 통일성을 위해 RPC 생성 권장.
```

---

## 6. 추출 기록 도메인

> 참조: `docs/flows/06-brew-logs.md`

### 현재 RPC (1개)

| 작업 | 현재 방식 | 상태 |
|------|-----------|------|
| 추출 통계 | `get_my_brew_stats()` RPC | ✅ |

### 직접 테이블 접근 → RPC 전환 필요 (4개)

| 작업 | 현재 방식 | 문제 | RLS 정책 |
|------|-----------|------|----------|
| 기록 저장 | `brew_logs` 직접 INSERT | 입력 검증 없음 | INSERT ✅ |
| 기록 수정 | `brew_logs` 직접 UPDATE | 입력 검증 없음 | UPDATE ✅ |
| 기록 삭제 | `brew_logs` 직접 DELETE | — | DELETE ✅ |
| 기록 목록 | `brew_logs` 직접 SELECT + JOIN | JOIN 로직 클라이언트 부담 | SELECT ✅ |

### 신규 RPC 설계

#### 6-1. `save_brew_log(p_values jsonb)` → jsonb

```
동작:
  1. 인증 확인
  2. 입력 검증 (rating 1-5, cups 1-4 등)
  3. bean_id, brew_method_id, recipe_id 존재 여부 확인
  4. INSERT brew_logs
  5. 저장된 기록 반환

입력:
  {
    "bean_id": "uuid | null",
    "brew_method_id": "uuid | null",
    "recipe_id": "uuid | null",
    "coffee_amount_g": 18,
    "water_temp_c": 93,
    "total_water_ml": 210,
    "total_duration_seconds": 150,
    "cups": 1,
    "strength": "balanced",
    "rating": 4,
    "notes": "산미가 좋았다"
  }

반환:
  { "id": "uuid", "brewed_at": "2026-02-28T..." }
```

#### 6-2. `update_brew_log(p_log_id uuid, p_values jsonb)` → jsonb

```
동작:
  1. 소유권 확인
  2. 입력 검증
  3. 변경 필드만 UPDATE (COALESCE)

반환:
  { "updated": true }
```

#### 6-3. `delete_brew_log(p_log_id uuid)` → jsonb

```
동작:
  1. 소유권 확인
  2. DELETE brew_logs WHERE id = p_log_id AND user_id = auth.uid()

반환:
  { "deleted": true }
```

#### 6-4. `get_my_brew_logs(p_limit int DEFAULT 20, p_offset int DEFAULT 0)` → jsonb

```
동작:
  1. SELECT brew_logs WHERE user_id = auth.uid()
  2. JOIN coffee_beans (원두명), brew_methods (기구명), recipes (레시피명)
  3. ORDER BY brewed_at DESC
  4. LIMIT/OFFSET 페이지네이션

반환:
  {
    "logs": [
      {
        "id": "uuid",
        "brewed_at": "2026-02-28T...",
        "rating": 4,
        "cups": 1,
        "notes": "...",
        "bean_name": "에티오피아 예가체프",
        "brew_method_name": "하리오 V60",
        "recipe_name": "기본 레시피"
      }
    ],
    "total_count": 15,
    "has_more": false
  }
```

---

## 7. 마이페이지 도메인

> 참조: `docs/flows/07-my-page.md`

### 현재 RPC — 모두 정상

| 작업 | RPC | 상태 |
|------|-----|------|
| 대시보드 | `get_my_dashboard()` | ✅ |
| 맛 프로필 | `get_my_taste_profile()` | ✅ |
| 추천 원두 | `get_my_recommendations()` | ✅ |
| 찜 목록 | `get_my_bean_list()` | ✅ |
| 추출 통계 | `get_my_brew_stats()` | ✅ |

> **추가 작업 없음**. 이 도메인은 다른 도메인의 RPC를 호출하여 구성.

---

## 8. 계정 삭제 도메인

> 참조: `docs/flows/08-account-deletion.md`

### 현재

| 작업 | 현재 방식 | 상태 |
|------|-----------|------|
| 데이터 삭제 | `delete_user_data(p_user_id)` RPC | ✅ (폴백) |
| 계정 삭제 | `delete-account` Edge Function | ❌ **401 에러** |

### 수정 필요

`delete-account` Edge Function 401 문제는 `submit-survey`와 동일 원인일 가능성 높음. 3번 도메인의 401 수정 방안 참조.

---

## 전체 RPC 매트릭스

### 기존 RPC (15개) — 유지

| # | RPC | 도메인 | 서버 | 앱 |
|---|-----|--------|------|-----|
| 1 | `get_onboarding_status` | 인증/온보딩 | ✅ | ✅ |
| 2 | `get_onboarding_options` | 인증/온보딩 | ✅ | ✅ |
| 3 | `save_display_name` | 인증/온보딩 | ✅ | ✅ |
| 4 | `save_onboarding_reasons` | 인증/온보딩 | ✅ | ✅ |
| 5 | `get_my_taste_profile` | 추천/매칭 | ✅ | ✅ |
| 6 | `get_my_recommendations` | 추천/매칭 | ✅ | ✅ |
| 7 | `retake_survey` | 설문 | ✅ | ✅ |
| 8 | `get_my_bean_list` | 원두/찜 | ✅ | ✅ |
| 9 | `remove_from_coffee_list` | 원두/찜 | ✅ | ✅ |
| 10 | `reorder_coffee_list` | 원두/찜 | ✅ | ✅ |
| 11 | `get_merged_recipe` | 레시피 | ✅ | ✅ |
| 12 | `save_custom_recipe` | 레시피 | ✅ | ❌ **미사용 → 복원** |
| 13 | `get_my_brew_stats` | 추출 기록 | ✅ | ✅ |
| 14 | `get_my_dashboard` | 마이페이지 | ✅ | ✅ |
| 15 | `delete_user_data` | 계정 삭제 | ✅ | ✅ (폴백) |

### 신규 RPC (13개) — 생성 필요

| # | RPC | 도메인 | 보안 | 우선순위 |
|---|-----|--------|------|----------|
| 1 | `add_custom_bean` | 원두 | SECURITY DEFINER | 🔴 긴급 |
| 2 | `start_survey` | 설문 | INVOKER | 🟡 중요 |
| 3 | `save_survey_answers` | 설문 | INVOKER | 🟡 중요 |
| 4 | `complete_survey` | 설문 | INVOKER | 🟡 중요 |
| 5 | `add_to_coffee_list` | 원두 | INVOKER | 🟡 중요 |
| 6 | `update_custom_bean` | 원두 | SECURITY DEFINER | 🟡 중요 |
| 7 | `get_coffee_catalog` | 원두 | INVOKER | 🟡 중요 |
| 8 | `save_brew_log` | 추출 기록 | INVOKER | 🟡 중요 |
| 9 | `update_brew_log` | 추출 기록 | INVOKER | 🟢 낮음 |
| 10 | `delete_brew_log` | 추출 기록 | INVOKER | 🟢 낮음 |
| 11 | `get_my_brew_logs` | 추출 기록 | INVOKER | 🟡 중요 |
| 12 | `delete_custom_recipe` | 레시피 | INVOKER | 🟢 낮음 |
| 13 | `update_profile` | 인증/온보딩 | INVOKER | 🟢 낮음 |

---

## 작업 우선순위

### Phase 1 — 긴급 (앱 기능 차단 해소)

| # | 작업 | 유형 | 상세 |
|---|------|------|------|
| 1 | `submit-survey` 401 수정 | Edge Function 수정 | JWT 검증/CORS 디버깅 |
| 2 | `delete-account` 401 수정 | Edge Function 수정 | 위와 동일 원인 추정 |
| 3 | `add_custom_bean` RPC 생성 | 신규 RPC | SECURITY DEFINER, coffee_beans INSERT + user_bean_lists |
| 4 | `save_custom_recipe` 앱 복원 | **앱 측 수정** (서버 작업 없음) | 직접 INSERT → RPC 호출로 복원 |

### Phase 2 — 설문 RPC 통합

| # | 작업 | 유형 |
|---|------|------|
| 5 | `start_survey` RPC 생성 | 신규 RPC |
| 6 | `save_survey_answers` RPC 생성 | 신규 RPC |
| 7 | `complete_survey` RPC 생성 | 신규 RPC |

### Phase 3 — 원두/찜 RPC 통합

| # | 작업 | 유형 |
|---|------|------|
| 8 | `add_to_coffee_list` RPC 생성 | 신규 RPC |
| 9 | `update_custom_bean` RPC 생성 | 신규 RPC (SECURITY DEFINER) |
| 10 | `get_coffee_catalog` RPC 생성 | 신규 RPC |

### Phase 4 — 추출 기록/기타 RPC 통합

| # | 작업 | 유형 |
|---|------|------|
| 11 | `save_brew_log` RPC 생성 | 신규 RPC |
| 12 | `get_my_brew_logs` RPC 생성 | 신규 RPC |
| 13 | `update_brew_log` RPC 생성 | 신규 RPC |
| 14 | `delete_brew_log` RPC 생성 | 신규 RPC |
| 15 | `delete_custom_recipe` RPC 생성 | 신규 RPC |
| 16 | `update_profile` RPC 생성 | 신규 RPC |

---

## 완료 후 목표 상태

### RPC 전체 목록 (28개)

```
인증/온보딩 (5):
  get_onboarding_status, get_onboarding_options,
  save_display_name, save_onboarding_reasons,
  update_profile (신규)

설문 (4):
  retake_survey,
  start_survey (신규), save_survey_answers (신규), complete_survey (신규)

추천/매칭 (2):
  get_my_taste_profile, get_my_recommendations

원두/찜 (7):
  get_my_bean_list, remove_from_coffee_list, reorder_coffee_list,
  add_custom_bean (신규), update_custom_bean (신규),
  add_to_coffee_list (신규), get_coffee_catalog (신규)

레시피 (3):
  get_merged_recipe, save_custom_recipe,
  delete_custom_recipe (신규)

추출 기록 (5):
  get_my_brew_stats,
  save_brew_log (신규), update_brew_log (신규),
  delete_brew_log (신규), get_my_brew_logs (신규)

마이페이지 (1):
  get_my_dashboard

계정 (1):
  delete_user_data
```

### Edge Functions (4개) — 유지

```
naver-auth (네이버 로그인)
submit-survey (설문 분석 + 추천 — service_role 필수)
match-coffee (재매칭 — service_role 필수)
delete-account (계정 삭제 — admin.deleteUser 필수)
```

### 클라이언트 직접 테이블 접근 — 0개 (목표)

```
현재: 약 10개 작업이 직접 테이블 접근
목표: 모든 작업이 RPC 또는 Edge Function 경유
이점: 입력 검증, 트랜잭션, 비즈니스 로직 서버 집중, 클라이언트 코드 단순화
```
