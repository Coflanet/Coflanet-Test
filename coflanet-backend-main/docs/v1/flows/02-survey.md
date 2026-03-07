# 2. 설문 플로우

## 관련 리소스

| 구분 | 이름 | 역할 |
|------|------|------|
| **테이블** | `survey_questions` | 설문 질문 정의 (20개, 참조 데이터) |
| **테이블** | `survey_options` | 질문별 선택지 (80개, 참조 데이터) |
| **테이블** | `survey_sessions` | 설문 진행 상태 추적 |
| **테이블** | `survey_answers` | 질문별 사용자 응답 |
| **RPC** | `start_survey(p_survey_type)` | 새 설문 세션 생성 |
| **RPC** | `save_survey_answers(p_session_id, p_answers)` | 질문별 응답 일괄 저장 |
| **RPC** | `complete_survey(p_session_id)` | 설문 상태 → completed |
| **RPC** | `retake_survey()` | 기존 세션 종료 + 새 세션 생성 |
| **Edge Function** | `submit-survey` | 설문 완료 → 맛 프로필 → 추천 생성 |

## RLS 정책

| 테이블 | 정책 | 조건 |
|--------|------|------|
| `survey_questions` | `survey_questions_select_all` (SELECT) | `true` (authenticated 읽기) |
| `survey_options` | `survey_options_select_all` (SELECT) | `true` (authenticated 읽기) |
| `survey_sessions` | `survey_sessions_select_own` (SELECT) | `user_id = (select auth.uid())` |
| `survey_sessions` | `survey_sessions_insert_authenticated` (INSERT) | `user_id = (select auth.uid())` |
| `survey_sessions` | `survey_sessions_update_own` (UPDATE) | `user_id = (select auth.uid())` |
| `survey_answers` | `survey_answers_select_own` (SELECT) | `session_id` → survey_sessions 소유자 확인 |
| `survey_answers` | `survey_answers_insert_authenticated` (INSERT) | `session_id` → survey_sessions 소유자 확인 |
| `survey_answers` | `survey_answers_update_own` (UPDATE) | `session_id` → survey_sessions 소유자 확인 |

> **역할**: 모든 RLS 정책은 `authenticated` 역할에만 적용. 미인증 사용자는 참조 데이터 포함 접근 불가.

---

## 2-1. 설문 질문/선택지 조회

```mermaid
sequenceDiagram
    participant C as Flutter Client
    participant DB as PostgreSQL

    C->>DB: SELECT survey_questions<br/>WHERE survey_type IN ('common','preference','lifestyle')<br/>ORDER BY step, question_order
    DB-->>C: 20개 질문 (3 유형)

    C->>DB: SELECT survey_options<br/>WHERE question_id IN (...)<br/>ORDER BY display_order
    DB-->>C: 80개 선택지
```

### 설문 유형/구조

| survey_type | 단계 (step) | 질문 수 | 카테고리 |
|-------------|-------------|---------|----------|
| `common` | 1 | 2개 | coffee_experience |
| `preference` | 2 | 4개 | taste_basic |
| `preference` | 3 | 4개 | taste_aroma |
| `lifestyle` | 2 | 4개 | lifestyle |
| `lifestyle` | 3 | 3개 | taste_basic |
| `lifestyle` | 4 | 3개 | sensory |

> **구조**: step 1은 공통(common), step 2 이후는 survey_type에 따라 분기. preference는 총 8문항(step 2-3), lifestyle은 총 10문항(step 2-4).

### 응답 형식 (answer_type)

| 타입 | 설명 | 저장 방식 |
|------|------|-----------|
| `single_select` | 단일 선택 | `selected_options = ['key']` |
| `multi_select` | 복수 선택 | `selected_options = ['key1','key2']` |
| `scale_3` | 3점 척도 | `score_value = 1\|2\|3` |
| `scale_5` | 5점 척도 | `score_value = 1~5` |
| `binary` | 이진 선택 | `selected_options = ['yes'\|'no']` |

## 2-2. 설문 세션 생성 및 응답 저장

```mermaid
sequenceDiagram
    participant C as Flutter Client
    participant DB as PostgreSQL

    Note over C: 온보딩 완료 후 설문 시작

    C->>DB: RPC start_survey('preference')
    DB->>DB: INSERT survey_sessions<br/>{ user_id, survey_type, status: 'in_progress' }
    DB-->>C: { session_id, survey_type, status }

    loop 각 단계 (step 1 → N)
        Note over C: 사용자 응답 입력

        C->>DB: RPC save_survey_answers(session_id, [<br/>  { question_id, selected_options, score_value },<br/>  ...<br/>])
        DB->>DB: 세션 소유자 확인 + UPSERT survey_answers
        DB-->>C: { saved_count }
    end

    Note over C: 마지막 단계 완료
    C->>DB: RPC complete_survey(session_id)
    DB->>DB: UPDATE survey_sessions<br/>SET status = 'completed', completed_at = now()
    DB-->>C: { session_id, status: 'completed' }
```

## 2-3. 설문 제출 (Edge Function)

```mermaid
sequenceDiagram
    participant C as Flutter Client
    participant EF as Edge Function (submit-survey)
    participant DB as PostgreSQL (service_role)

    C->>EF: POST /submit-survey<br/>{ session_id }
    EF->>EF: JWT 검증 → user_id 추출

    EF->>DB: SELECT survey_sessions WHERE id = session_id
    DB-->>EF: { status: 'completed', survey_type }

    EF->>DB: UPDATE survey_sessions SET status = 'analyzing'

    EF->>DB: SELECT survey_answers + survey_questions<br/>JOIN으로 question_key, answer_type 포함
    DB-->>EF: 사용자 응답 전체

    Note over EF: === 맛 프로필 계산 ===
    EF->>EF: Preference: scale_3 → 20/60/100 매핑
    EF->>EF: Lifestyle: Q1-Q10 정규화 → 20-100
    EF->>EF: acidity, sweetness, bitterness, body, aroma 산출
    EF->>EF: 커피 타입 결정 (15점 임계값)
    EF->>EF: 플레이버 태그 생성

    EF->>DB: INSERT survey_results (service_role)<br/>{ session_id, user_id, coffee_type, acidity, ... }
    DB-->>EF: { id: result_id }

    EF->>DB: INSERT survey_result_flavors (service_role)<br/>[{ result_id, name, emoji, description }]

    Note over EF: === 커피 매칭 ===
    EF->>DB: SELECT coffee_beans + bean_flavor_tags (97개)
    DB-->>EF: 원두 카탈로그 전체

    EF->>EF: 유클리디안 거리(60%) + 플레이버 유사도(40%)
    EF->>EF: × quality multiplier → 상위 5개 선택

    EF->>DB: INSERT recommendations (service_role)<br/>[{ result_id, bean_id, match_score, display_order }]

    EF->>DB: UPDATE survey_sessions SET status = 'analyzed'

    EF-->>C: { success, result_id, recommendations: [...] }
```

### 커피 타입 결정 로직

```
max(acidity, sweetness, bitterness, body) - second_max >= 15 이면:
  acidity 최대 → 'acidity' (산미형)
  sweetness 최대 → 'sweet' (달콤형)
  bitterness 최대 → 'strong' (강렬형)
  body 최대 → 'strong' (강렬형)
차이 < 15 → 'balance' (균형형)
```

## 2-4. 설문 재시도

```mermaid
sequenceDiagram
    participant C as Flutter Client
    participant DB as PostgreSQL

    C->>DB: RPC retake_survey()

    DB->>DB: 기존 in_progress/analyzing 세션 → status = 'completed'
    DB->>DB: INSERT 새 survey_sessions<br/>{ user_id, survey_type, status: 'in_progress' }
    DB-->>C: { new_session_id, ready_for_new_survey: true }

    Note over C: 새 세션으로 설문 재시작 (2-2 반복)
```

> **주의**: 이전 survey_results, recommendations는 삭제하지 않는다. 새 설문 완료 시 새 결과가 생성되며, `get_my_taste_profile()`과 `get_my_recommendations()`는 항상 최신 결과(`ORDER BY created_at DESC LIMIT 1`)를 반환한다.

## 세션 상태 머신

```
┌─────────────┐
│ in_progress │ ← 생성 시 초기 상태
└──────┬──────┘
       │ 사용자: 마지막 답변 완료
       ▼
┌─────────────┐
│  completed  │ ← 클라이언트에서 직접 UPDATE
└──────┬──────┘
       │ Edge Function: submit-survey 시작
       ▼
┌─────────────┐
│  analyzing  │ ← Edge Function 처리 중
└──────┬──────┘
       │ Edge Function: 결과 저장 완료
       ▼
┌─────────────┐
│  analyzed   │ ← 최종 완료 상태
└─────────────┘
```

## 테이블 데이터 흐름 요약

```
survey_questions (참조, 20행) ─┐
survey_options (참조, 80행) ───┤ 클라이언트 읽기 전용
                                │
survey_sessions ◄── 클라이언트 INSERT/UPDATE
  │ session_id
  ├── survey_answers ◄── 클라이언트 INSERT
  │     │ question_id → survey_questions
  │
  └── survey_results ◄── Edge Function INSERT (service_role)
        │ result_id
        ├── survey_result_flavors ◄── Edge Function INSERT (service_role)
        └── recommendations ◄── Edge Function INSERT (service_role)
```
