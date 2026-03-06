# 06. 추출 기록 — RPC 정의

> Phase 4 | ✅ 완료 (2026-02-28)
>
> 참조: `docs/flows/06-brew-logs.md`

## 기존 RPC (1개) — 유지

| RPC | 용도 | 상태 |
|-----|------|------|
| `get_my_brew_stats()` | 추출 통계 집계 (v_user_brew_stats 뷰) | ✅ |

## 신규 RPC (4개) — ✅ 전체 적용 완료

| RPC | 용도 | 상태 |
|-----|------|------|
| `save_brew_log` | 추출 기록 저장 | ✅ 마이그레이션 #27 |
| `get_my_brew_logs` | 추출 기록 목록 (페이지네이션) | ✅ 마이그레이션 #28 |
| `update_brew_log` | 추출 기록 수정 | ✅ 마이그레이션 #29 |
| `delete_brew_log` | 추출 기록 삭제 | ✅ 마이그레이션 #30 |

---

### 6-1. `save_brew_log(p_values jsonb)` → jsonb

**목적**: 추출 기록 저장. 입력 검증 (rating 1-5, cups 1-4) + FK 존재 확인.

**대체 대상**: `INSERT brew_logs` (직접, 검증 없음)

#### SQL

```sql
-- 마이그레이션: create_rpc_save_brew_log
CREATE OR REPLACE FUNCTION public.save_brew_log(p_values jsonb)
  RETURNS jsonb
  LANGUAGE plpgsql
  SET search_path TO ''
AS $function$
DECLARE
  v_uid uuid := (SELECT auth.uid());
  v_log_id uuid;
  v_bean_id uuid;
  v_brew_method_id uuid;
  v_recipe_id uuid;
  v_rating smallint;
  v_cups smallint;
BEGIN
  IF v_uid IS NULL THEN
    RAISE EXCEPTION 'UNAUTHORIZED';
  END IF;

  -- FK 파싱
  v_bean_id := NULLIF(p_values->>'bean_id', '')::uuid;
  v_brew_method_id := NULLIF(p_values->>'brew_method_id', '')::uuid;
  v_recipe_id := NULLIF(p_values->>'recipe_id', '')::uuid;

  -- FK 존재 확인
  IF v_bean_id IS NOT NULL
     AND NOT EXISTS (SELECT 1 FROM public.coffee_beans WHERE id = v_bean_id)
  THEN
    RAISE EXCEPTION 'BEAN_NOT_FOUND';
  END IF;

  IF v_brew_method_id IS NOT NULL
     AND NOT EXISTS (SELECT 1 FROM public.brew_methods WHERE id = v_brew_method_id)
  THEN
    RAISE EXCEPTION 'BREW_METHOD_NOT_FOUND';
  END IF;

  IF v_recipe_id IS NOT NULL
     AND NOT EXISTS (SELECT 1 FROM public.recipes WHERE id = v_recipe_id)
  THEN
    RAISE EXCEPTION 'RECIPE_NOT_FOUND';
  END IF;

  -- 값 검증
  v_rating := NULLIF(p_values->>'rating', '')::smallint;
  IF v_rating IS NOT NULL AND (v_rating < 1 OR v_rating > 5) THEN
    RAISE EXCEPTION 'INVALID_RATING';
  END IF;

  v_cups := NULLIF(p_values->>'cups', '')::smallint;
  IF v_cups IS NOT NULL AND (v_cups < 1 OR v_cups > 4) THEN
    RAISE EXCEPTION 'INVALID_CUPS';
  END IF;

  -- INSERT
  INSERT INTO public.brew_logs (
    user_id,
    bean_id,
    brew_method_id,
    recipe_id,
    coffee_amount_g,
    water_temp_c,
    grind_size_um,
    total_water_ml,
    total_yield_g,
    total_duration_seconds,
    cups,
    strength,
    rating,
    notes,
    brewed_at
  )
  VALUES (
    v_uid,
    v_bean_id,
    v_brew_method_id,
    v_recipe_id,
    NULLIF(p_values->>'coffee_amount_g', '')::numeric,
    NULLIF(p_values->>'water_temp_c', '')::numeric,
    NULLIF(p_values->>'grind_size_um', '')::numeric,
    NULLIF(p_values->>'total_water_ml', '')::numeric,
    NULLIF(p_values->>'total_yield_g', '')::numeric,
    NULLIF(p_values->>'total_duration_seconds', '')::integer,
    v_cups,
    p_values->>'strength',
    v_rating,
    p_values->>'notes',
    COALESCE(
      NULLIF(p_values->>'brewed_at', '')::timestamptz,
      now()
    )
  )
  RETURNING id INTO v_log_id;

  RETURN jsonb_build_object(
    'id', v_log_id,
    'created', true
  );
END;
$function$;
```

#### 클라이언트 호출

```dart
final result = await supabase.rpc('save_brew_log', params: {
  'p_values': {
    'bean_id': beanId,
    'brew_method_id': brewMethodId,
    'recipe_id': recipeId,
    'coffee_amount_g': 18,
    'water_temp_c': 93,
    'total_water_ml': 210,
    'total_duration_seconds': 150,
    'cups': 1,
    'strength': 'balanced',
    'rating': 4,
    'notes': '산미가 좋았다',
  },
});
// result = { id: 'uuid', created: true }
```

---

### 6-2. `get_my_brew_logs(p_limit int, p_offset int)` → jsonb

**목적**: 추출 기록 목록 조회. 원두명/기구명 JOIN + 페이지네이션.

**대체 대상**: `SELECT brew_logs` + JOIN (클라이언트 조합)

#### SQL

```sql
-- 마이그레이션: create_rpc_get_my_brew_logs
CREATE OR REPLACE FUNCTION public.get_my_brew_logs(
  p_limit integer DEFAULT 20,
  p_offset integer DEFAULT 0
)
  RETURNS jsonb
  LANGUAGE sql
  STABLE
  SET search_path TO ''
AS $function$
  WITH total AS (
    SELECT COUNT(*)::int AS cnt
    FROM public.brew_logs bl
    WHERE bl.user_id = (SELECT auth.uid())
  )
  SELECT jsonb_build_object(
    'logs', COALESCE(
      (
        SELECT jsonb_agg(
          jsonb_build_object(
            'id', bl.id,
            'brewed_at', bl.brewed_at,
            'cups', bl.cups,
            'strength', bl.strength,
            'coffee_amount_g', bl.coffee_amount_g,
            'water_temp_c', bl.water_temp_c,
            'grind_size_um', bl.grind_size_um,
            'total_water_ml', bl.total_water_ml,
            'total_yield_g', bl.total_yield_g,
            'total_duration_seconds', bl.total_duration_seconds,
            'rating', bl.rating,
            'notes', bl.notes,
            'bean', CASE
              WHEN cb.id IS NOT NULL THEN jsonb_build_object(
                'id', cb.id,
                'name', cb.name,
                'roast_level', cb.roast_level,
                'image_url', cb.image_url
              )
              ELSE NULL
            END,
            'brew_method', CASE
              WHEN bm.id IS NOT NULL THEN jsonb_build_object(
                'id', bm.id,
                'name', bm.name,
                'slug', bm.slug,
                'category', bm.category
              )
              ELSE NULL
            END,
            'recipe_name', r.name
          )
          ORDER BY bl.brewed_at DESC
        )
        FROM public.brew_logs bl
        LEFT JOIN public.coffee_beans cb ON cb.id = bl.bean_id
        LEFT JOIN public.brew_methods bm ON bm.id = bl.brew_method_id
        LEFT JOIN public.recipes r ON r.id = bl.recipe_id
        WHERE bl.user_id = (SELECT auth.uid())
        ORDER BY bl.brewed_at DESC
        LIMIT p_limit
        OFFSET p_offset
      ),
      '[]'::jsonb
    ),
    'total_count', (SELECT cnt FROM total),
    'has_more', (p_offset + p_limit) < (SELECT cnt FROM total)
  );
$function$;
```

#### 클라이언트 호출

```dart
final result = await supabase.rpc('get_my_brew_logs', params: {
  'p_limit': 20,
  'p_offset': 0,
});
// result = {
//   logs: [
//     { id, brewed_at, rating, bean: { name, roast_level }, brew_method: { name }, ... }
//   ],
//   total_count: 15,
//   has_more: false
// }
```

---

### 6-3. `update_brew_log(p_log_id uuid, p_values jsonb)` → jsonb

**목적**: 추출 기록 수정. 소유권 확인 + 값 검증.

**대체 대상**: `UPDATE brew_logs SET ... WHERE id = ?`

#### SQL

```sql
-- 마이그레이션: create_rpc_update_brew_log
CREATE OR REPLACE FUNCTION public.update_brew_log(
  p_log_id uuid,
  p_values jsonb
)
  RETURNS jsonb
  LANGUAGE plpgsql
  SET search_path TO ''
AS $function$
DECLARE
  v_uid uuid := (SELECT auth.uid());
  v_rating smallint;
  v_cups smallint;
BEGIN
  IF v_uid IS NULL THEN
    RAISE EXCEPTION 'UNAUTHORIZED';
  END IF;

  -- 소유권 확인
  IF NOT EXISTS (
    SELECT 1 FROM public.brew_logs
    WHERE id = p_log_id AND user_id = v_uid
  ) THEN
    RAISE EXCEPTION 'LOG_NOT_FOUND';
  END IF;

  -- 값 검증
  v_rating := NULLIF(p_values->>'rating', '')::smallint;
  IF v_rating IS NOT NULL AND (v_rating < 1 OR v_rating > 5) THEN
    RAISE EXCEPTION 'INVALID_RATING';
  END IF;

  v_cups := NULLIF(p_values->>'cups', '')::smallint;
  IF v_cups IS NOT NULL AND (v_cups < 1 OR v_cups > 4) THEN
    RAISE EXCEPTION 'INVALID_CUPS';
  END IF;

  UPDATE public.brew_logs bl
  SET
    bean_id                = COALESCE(NULLIF(p_values->>'bean_id', '')::uuid, bl.bean_id),
    brew_method_id         = COALESCE(NULLIF(p_values->>'brew_method_id', '')::uuid, bl.brew_method_id),
    recipe_id              = COALESCE(NULLIF(p_values->>'recipe_id', '')::uuid, bl.recipe_id),
    coffee_amount_g        = COALESCE(NULLIF(p_values->>'coffee_amount_g', '')::numeric, bl.coffee_amount_g),
    water_temp_c           = COALESCE(NULLIF(p_values->>'water_temp_c', '')::numeric, bl.water_temp_c),
    grind_size_um          = COALESCE(NULLIF(p_values->>'grind_size_um', '')::numeric, bl.grind_size_um),
    total_water_ml         = COALESCE(NULLIF(p_values->>'total_water_ml', '')::numeric, bl.total_water_ml),
    total_yield_g          = COALESCE(NULLIF(p_values->>'total_yield_g', '')::numeric, bl.total_yield_g),
    total_duration_seconds = COALESCE(NULLIF(p_values->>'total_duration_seconds', '')::integer, bl.total_duration_seconds),
    cups                   = COALESCE(v_cups, bl.cups),
    strength               = COALESCE(p_values->>'strength', bl.strength),
    rating                 = COALESCE(v_rating, bl.rating),
    notes                  = COALESCE(p_values->>'notes', bl.notes),
    updated_at             = now()
  WHERE bl.id = p_log_id;

  RETURN jsonb_build_object('updated', true);
END;
$function$;
```

#### 클라이언트 호출

```dart
final result = await supabase.rpc('update_brew_log', params: {
  'p_log_id': logId,
  'p_values': {
    'rating': 5,
    'notes': '매우 만족',
  },
});
```

---

### 6-4. `delete_brew_log(p_log_id uuid)` → jsonb

**목적**: 추출 기록 삭제. 소유권 확인.

**대체 대상**: `DELETE brew_logs WHERE id = ?`

#### SQL

```sql
-- 마이그레이션: create_rpc_delete_brew_log
CREATE OR REPLACE FUNCTION public.delete_brew_log(p_log_id uuid)
  RETURNS jsonb
  LANGUAGE plpgsql
  SET search_path TO ''
AS $function$
DECLARE
  v_uid uuid := (SELECT auth.uid());
  v_deleted integer;
BEGIN
  IF v_uid IS NULL THEN
    RAISE EXCEPTION 'UNAUTHORIZED';
  END IF;

  DELETE FROM public.brew_logs
  WHERE id = p_log_id
    AND user_id = v_uid;

  GET DIAGNOSTICS v_deleted = ROW_COUNT;

  IF v_deleted = 0 THEN
    RAISE EXCEPTION 'LOG_NOT_FOUND';
  END IF;

  RETURN jsonb_build_object('deleted', true);
END;
$function$;
```

#### 클라이언트 호출

```dart
final result = await supabase.rpc('delete_brew_log', params: {
  'p_log_id': logId,
});
```

---

## 앱 측 추출 기록 플로우 (RPC 전환 후)

```dart
// 기록 저장 (타이머 완료 후)
final log = await supabase.rpc('save_brew_log', params: {
  'p_values': {
    'bean_id': beanId,
    'brew_method_id': methodId,
    'recipe_id': recipeId,
    'cups': 1,
    'rating': 4,
  },
});

// 기록 목록 조회
final logs = await supabase.rpc('get_my_brew_logs', params: {
  'p_limit': 20,
  'p_offset': 0,
});

// 기록 수정
await supabase.rpc('update_brew_log', params: {
  'p_log_id': logId,
  'p_values': {'rating': 5, 'notes': '최고'},
});

// 기록 삭제
await supabase.rpc('delete_brew_log', params: {
  'p_log_id': logId,
});

// 통계 조회 (기존)
final stats = await supabase.rpc('get_my_brew_stats');
```
