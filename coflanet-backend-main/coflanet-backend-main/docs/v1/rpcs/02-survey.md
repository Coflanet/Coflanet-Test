# 02. 설문 — RPC 정의

> Phase 2 | ✅ 완료 (2026-02-28)
>
> 참조: `docs/flows/02-survey.md`

## 기존 RPC (1개) — 유지

| RPC | 용도 | 상태 |
|-----|------|------|
| `retake_survey()` | 설문 재시도 (기존 세션 종료 + 새 세션 생성) | ✅ |

## 신규 RPC (3개) — ✅ 전체 적용 완료

### 설문 전체 플로우

```
start_survey(survey_type)      → 세션 생성 + 질문/선택지 반환
  ↓
save_survey_answers(session_id, answers)   → 답변 일괄 저장 (단계별 호출)
  ↓
complete_survey(session_id)    → 상태 completed로 변경
  ↓
submit-survey Edge Function    → 분석 + 추천 생성 (기존)
```

---

### 2-1. `start_survey(p_survey_type text)` → jsonb

**목적**: 설문 세션 생성 + 해당 유형 질문/선택지를 한 번에 반환. 현재 앱에서 `survey_sessions` INSERT + `survey_questions` SELECT를 분리 호출하는 것을 통합.

**대체 대상**: `INSERT survey_sessions` + `SELECT survey_questions` + `SELECT survey_options`

#### SQL

```sql
-- 마이그레이션: create_rpc_start_survey
CREATE OR REPLACE FUNCTION public.start_survey(p_survey_type text DEFAULT 'preference')
  RETURNS jsonb
  LANGUAGE plpgsql
  SET search_path TO ''
AS $function$
DECLARE
  v_uid uuid := (SELECT auth.uid());
  v_session_id uuid;
  v_is_resumed boolean := false;
  v_questions jsonb;
BEGIN
  IF v_uid IS NULL THEN
    RAISE EXCEPTION 'UNAUTHORIZED';
  END IF;

  -- survey_type 유효성 검증
  IF p_survey_type NOT IN ('preference', 'lifestyle') THEN
    RAISE EXCEPTION 'INVALID_SURVEY_TYPE';
  END IF;

  -- 진행 중인 세션이 있으면 재개
  SELECT s.id INTO v_session_id
  FROM public.survey_sessions s
  WHERE s.user_id = v_uid
    AND s.survey_type = p_survey_type
    AND s.status = 'in_progress'
  ORDER BY s.created_at DESC
  LIMIT 1;

  IF v_session_id IS NOT NULL THEN
    v_is_resumed := true;
  ELSE
    -- 신규 세션 생성
    INSERT INTO public.survey_sessions (
      user_id, survey_type, status, current_step, started_at
    )
    VALUES (
      v_uid, p_survey_type, 'in_progress', 1, now()
    )
    RETURNING id INTO v_session_id;
  END IF;

  -- 해당 유형의 질문 + 선택지 한 번에 조회
  -- common 질문은 항상 포함
  SELECT COALESCE(
    jsonb_agg(
      jsonb_build_object(
        'id', q.id,
        'question_key', q.question_key,
        'question_text', q.question_text,
        'description', q.description,
        'survey_type', q.survey_type,
        'step', q.step,
        'question_order', q.question_order,
        'category', q.category,
        'answer_type', q.answer_type,
        'allow_multiple', q.allow_multiple,
        'options', (
          SELECT COALESCE(
            jsonb_agg(
              jsonb_build_object(
                'id', o.id,
                'option_key', o.option_key,
                'label', o.label,
                'description', o.description,
                'icon', o.icon,
                'display_order', o.display_order,
                'score_value', o.score_value
              )
              ORDER BY o.display_order
            ) FILTER (WHERE o.id IS NOT NULL),
            '[]'::jsonb
          )
          FROM public.survey_options o
          WHERE o.question_id = q.id
        )
      )
      ORDER BY q.step, q.question_order
    ),
    '[]'::jsonb
  )
  INTO v_questions
  FROM public.survey_questions q
  WHERE q.survey_type IN ('common', p_survey_type);

  RETURN jsonb_build_object(
    'session_id', v_session_id,
    'survey_type', p_survey_type,
    'is_resumed', v_is_resumed,
    'current_step', (
      SELECT s.current_step
      FROM public.survey_sessions s
      WHERE s.id = v_session_id
    ),
    'questions', v_questions
  );
END;
$function$;
```

#### 클라이언트 호출

```dart
final result = await supabase.rpc('start_survey', params: {
  'p_survey_type': 'preference',
});
// result = { session_id, survey_type, is_resumed, current_step, questions: [...] }
```

---

### 2-2. `save_survey_answers(p_session_id uuid, p_answers jsonb)` → jsonb

**목적**: 단계별 답변 일괄 저장. 현재 앱에서 `survey_answers` INSERT + `survey_sessions` UPDATE를 개별 호출하는 것을 트랜잭션으로 통합.

**대체 대상**: 각 질문별 `INSERT survey_answers` + `UPDATE survey_sessions SET current_step`

#### SQL

```sql
-- 마이그레이션: create_rpc_save_survey_answers
CREATE OR REPLACE FUNCTION public.save_survey_answers(
  p_session_id uuid,
  p_answers jsonb
)
  RETURNS jsonb
  LANGUAGE plpgsql
  SET search_path TO ''
AS $function$
DECLARE
  v_uid uuid := (SELECT auth.uid());
  v_session RECORD;
  v_answer jsonb;
  v_saved_count integer := 0;
  v_max_step smallint;
  v_total_steps smallint;
BEGIN
  IF v_uid IS NULL THEN
    RAISE EXCEPTION 'UNAUTHORIZED';
  END IF;

  -- 세션 소유권 + 상태 확인
  SELECT s.id, s.user_id, s.status, s.survey_type
  INTO v_session
  FROM public.survey_sessions s
  WHERE s.id = p_session_id;

  IF v_session.id IS NULL THEN
    RAISE EXCEPTION 'SESSION_NOT_FOUND';
  END IF;

  IF v_session.user_id <> v_uid THEN
    RAISE EXCEPTION 'FORBIDDEN';
  END IF;

  IF v_session.status <> 'in_progress' THEN
    RAISE EXCEPTION 'SESSION_NOT_IN_PROGRESS';
  END IF;

  -- 답변 배열 순회 → UPSERT
  FOR v_answer IN SELECT * FROM jsonb_array_elements(p_answers)
  LOOP
    INSERT INTO public.survey_answers (
      session_id,
      question_id,
      selected_options,
      score_value
    )
    VALUES (
      p_session_id,
      (v_answer->>'question_id')::uuid,
      CASE
        WHEN jsonb_typeof(v_answer->'selected_options') = 'array'
        THEN ARRAY(SELECT jsonb_array_elements_text(v_answer->'selected_options'))
        ELSE '{}'::text[]
      END,
      NULLIF(v_answer->>'score_value', '')::smallint
    )
    ON CONFLICT (session_id, question_id) DO UPDATE SET
      selected_options = EXCLUDED.selected_options,
      score_value = EXCLUDED.score_value,
      updated_at = now();

    v_saved_count := v_saved_count + 1;
  END LOOP;

  -- current_step 계산: 저장된 답변의 최대 step + 1
  SELECT MAX(q.step) INTO v_max_step
  FROM public.survey_answers sa
  JOIN public.survey_questions q ON q.id = sa.question_id
  WHERE sa.session_id = p_session_id;

  -- 해당 설문의 총 step 수
  SELECT MAX(q.step) INTO v_total_steps
  FROM public.survey_questions q
  WHERE q.survey_type IN ('common', v_session.survey_type);

  -- current_step 갱신
  UPDATE public.survey_sessions
  SET
    current_step = LEAST(COALESCE(v_max_step, 0) + 1, v_total_steps),
    updated_at = now()
  WHERE id = p_session_id;

  RETURN jsonb_build_object(
    'saved_count', v_saved_count,
    'current_step', LEAST(COALESCE(v_max_step, 0) + 1, v_total_steps),
    'total_steps', v_total_steps,
    'is_last_step', COALESCE(v_max_step, 0) >= v_total_steps
  );
END;
$function$;
```

#### 클라이언트 호출

```dart
// 한 단계의 답변들을 일괄 저장
final result = await supabase.rpc('save_survey_answers', params: {
  'p_session_id': sessionId,
  'p_answers': [
    {'question_id': 'uuid-1', 'selected_options': ['acidic', 'sweet']},
    {'question_id': 'uuid-2', 'score_value': 3},
  ],
});
// result = { saved_count: 2, current_step: 4, total_steps: 5, is_last_step: false }
```

---

### 2-3. `complete_survey(p_session_id uuid)` → jsonb

**목적**: 설문 상태를 `completed`로 전환. 필수 답변 완료 여부 검증 포함.

**대체 대상**: `UPDATE survey_sessions SET status = 'completed'`

#### SQL

```sql
-- 마이그레이션: create_rpc_complete_survey
CREATE OR REPLACE FUNCTION public.complete_survey(p_session_id uuid)
  RETURNS jsonb
  LANGUAGE plpgsql
  SET search_path TO ''
AS $function$
DECLARE
  v_uid uuid := (SELECT auth.uid());
  v_session RECORD;
  v_answer_count integer;
  v_question_count integer;
BEGIN
  IF v_uid IS NULL THEN
    RAISE EXCEPTION 'UNAUTHORIZED';
  END IF;

  -- 세션 확인
  SELECT s.id, s.user_id, s.status, s.survey_type
  INTO v_session
  FROM public.survey_sessions s
  WHERE s.id = p_session_id;

  IF v_session.id IS NULL THEN
    RAISE EXCEPTION 'SESSION_NOT_FOUND';
  END IF;

  IF v_session.user_id <> v_uid THEN
    RAISE EXCEPTION 'FORBIDDEN';
  END IF;

  IF v_session.status <> 'in_progress' THEN
    RAISE EXCEPTION 'SESSION_NOT_IN_PROGRESS';
  END IF;

  -- 답변 수 확인
  SELECT COUNT(*)::int INTO v_answer_count
  FROM public.survey_answers sa
  WHERE sa.session_id = p_session_id;

  -- 필수 질문 수 확인
  SELECT COUNT(*)::int INTO v_question_count
  FROM public.survey_questions q
  WHERE q.survey_type IN ('common', v_session.survey_type);

  -- 모든 질문에 답변했는지 확인
  IF v_answer_count < v_question_count THEN
    RETURN jsonb_build_object(
      'completed', false,
      'reason', 'INCOMPLETE_ANSWERS',
      'answered', v_answer_count,
      'required', v_question_count
    );
  END IF;

  -- 상태 전환
  UPDATE public.survey_sessions
  SET
    status = 'completed',
    completed_at = now(),
    updated_at = now()
  WHERE id = p_session_id;

  RETURN jsonb_build_object(
    'session_id', p_session_id,
    'completed', true,
    'status', 'completed',
    'answer_count', v_answer_count,
    'ready_for_analysis', true
  );
END;
$function$;
```

#### 클라이언트 호출

```dart
final result = await supabase.rpc('complete_survey', params: {
  'p_session_id': sessionId,
});
// 성공: { session_id, completed: true, ready_for_analysis: true }
// 미완료: { completed: false, reason: 'INCOMPLETE_ANSWERS', answered: 15, required: 20 }

if (result['ready_for_analysis'] == true) {
  // submit-survey Edge Function 호출
  await supabase.functions.invoke('submit-survey', body: {'session_id': sessionId});
}
```

---

## 앱 측 설문 플로우 (RPC 전환 후)

```dart
// 1. 설문 시작 (세션 생성 + 질문 로딩 통합)
final survey = await supabase.rpc('start_survey', params: {
  'p_survey_type': 'preference',
});
final sessionId = survey['session_id'];
final questions = survey['questions'];

// 2. 각 단계별 답변 저장
for (final step in steps) {
  final progress = await supabase.rpc('save_survey_answers', params: {
    'p_session_id': sessionId,
    'p_answers': step.answers,
  });
  // progress.is_last_step 으로 UI 진행
}

// 3. 설문 완료
final completion = await supabase.rpc('complete_survey', params: {
  'p_session_id': sessionId,
});

// 4. 분석 요청 (Edge Function)
if (completion['ready_for_analysis']) {
  await supabase.functions.invoke('submit-survey', body: {
    'session_id': sessionId,
  });
}
```
