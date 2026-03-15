# 04. 원두 카탈로그/찜 — RPC 정의

> Phase 1 + Phase 3 | ✅ 완료 (2026-02-28)
>
> 참조: `docs/flows/04-coffee-beans.md`

## 기존 RPC (3개) — 유지

| RPC | 용도 | 상태 |
|-----|------|------|
| `get_my_bean_list()` | 찜 목록 조회 (원두 상세 + 플레이버) | ✅ |
| `remove_from_coffee_list(bean_id)` | 찜 해제 + 순서 재정렬 | ✅ |
| `reorder_coffee_list(bean_ids[])` | 찜 순서 변경 | ✅ |

## 신규 RPC (4개) — ✅ 전체 적용 완료

| RPC | Phase | 보안 | 상태 |
|-----|-------|------|------|
| `add_custom_bean` | 1 | SECURITY DEFINER | ✅ 마이그레이션 #19 |
| `add_to_coffee_list` | 3 | INVOKER | ✅ 마이그레이션 #22 |
| `update_custom_bean` | 3 | SECURITY DEFINER | ✅ 마이그레이션 #23 |
| `get_coffee_catalog` | 3 | INVOKER (STABLE) | ✅ 마이그레이션 #24 |

---

### 4-1. `add_custom_bean(p_values jsonb)` → jsonb — **Phase 1, 긴급**

**목적**: 사용자 커스텀 원두 추가. `coffee_beans`에 INSERT RLS 정책이 없어 직접 INSERT 불가 → SECURITY DEFINER로 해결.

**대체 대상**: `INSERT coffee_beans` (RLS 차단됨)

#### SQL

```sql
-- 마이그레이션: create_rpc_add_custom_bean
CREATE OR REPLACE FUNCTION public.add_custom_bean(p_values jsonb)
  RETURNS jsonb
  LANGUAGE plpgsql
  SECURITY DEFINER
  SET search_path TO ''
AS $function$
DECLARE
  v_uid uuid := (SELECT auth.uid());
  v_bean_id uuid;
  v_list_id uuid;
  v_name text;
BEGIN
  IF v_uid IS NULL THEN
    RAISE EXCEPTION 'UNAUTHORIZED';
  END IF;

  -- 필수 필드 검증
  v_name := btrim(p_values->>'name');
  IF v_name IS NULL OR v_name = '' THEN
    RAISE EXCEPTION 'INVALID_BEAN_NAME';
  END IF;

  -- 원두 생성
  INSERT INTO public.coffee_beans (
    name,
    origin,
    roast_level,
    roast_point,
    description,
    image_url,
    variety,
    processing,
    acidity,
    sweetness,
    bitterness,
    body,
    aroma,
    is_available
  )
  VALUES (
    v_name,
    CASE
      WHEN jsonb_typeof(p_values->'origin') = 'array'
      THEN ARRAY(SELECT jsonb_array_elements_text(p_values->'origin'))
      ELSE '{}'::text[]
    END,
    p_values->>'roast_level',
    NULLIF(p_values->>'roast_point', '')::smallint,
    p_values->>'description',
    p_values->>'image_url',
    p_values->>'variety',
    p_values->>'processing',
    COALESCE(NULLIF(p_values->>'acidity', '')::smallint, 0),
    COALESCE(NULLIF(p_values->>'sweetness', '')::smallint, 0),
    COALESCE(NULLIF(p_values->>'bitterness', '')::smallint, 0),
    COALESCE(NULLIF(p_values->>'body', '')::smallint, 0),
    COALESCE(NULLIF(p_values->>'aroma', '')::smallint, 0),
    true
  )
  RETURNING id INTO v_bean_id;

  -- 찜 목록에 자동 추가
  INSERT INTO public.user_bean_lists (
    user_id,
    bean_id,
    added_from,
    sort_order
  )
  VALUES (
    v_uid,
    v_bean_id,
    'manual',
    COALESCE(
      (SELECT MAX(sort_order) + 1 FROM public.user_bean_lists WHERE user_id = v_uid),
      1
    )
  )
  RETURNING id INTO v_list_id;

  -- 플레이버 태그 추가 (선택)
  IF jsonb_typeof(p_values->'flavor_tags') = 'array' THEN
    INSERT INTO public.bean_flavor_tags (bean_id, category, sub_category, descriptor, descriptor_ko, display_order)
    SELECT
      v_bean_id,
      tag->>'category',
      tag->>'sub_category',
      tag->>'descriptor',
      tag->>'descriptor_ko',
      COALESCE(NULLIF(tag->>'display_order', '')::smallint, row_number() OVER ()::smallint)
    FROM jsonb_array_elements(p_values->'flavor_tags') AS tag;
  END IF;

  RETURN jsonb_build_object(
    'bean_id', v_bean_id,
    'list_item_id', v_list_id
  );
END;
$function$;
```

#### 클라이언트 호출

```dart
final result = await supabase.rpc('add_custom_bean', params: {
  'p_values': {
    'name': '내 원두',
    'origin': ['Colombia', 'Brazil'],
    'roast_level': 'medium',
    'description': '직접 로스팅한 블렌드',
    'acidity': 50,
    'sweetness': 70,
    'bitterness': 40,
    'body': 60,
    'aroma': 65,
    'flavor_tags': [
      {'category': 'Nutty_Cocoa', 'descriptor': 'Chocolate', 'descriptor_ko': '초콜릿'},
    ],
  },
});
// result = { bean_id: 'uuid', list_item_id: 'uuid' }
```

---

### 4-2. `add_to_coffee_list(p_bean_id uuid, p_added_from text)` → jsonb — **Phase 3**

**목적**: 기존 원두를 찜 목록에 추가. 중복 체크 포함.

**대체 대상**: `INSERT user_bean_lists` (직접)

#### SQL

```sql
-- 마이그레이션: create_rpc_add_to_coffee_list
CREATE OR REPLACE FUNCTION public.add_to_coffee_list(
  p_bean_id uuid,
  p_added_from text DEFAULT 'manual'
)
  RETURNS jsonb
  LANGUAGE plpgsql
  SET search_path TO ''
AS $function$
DECLARE
  v_uid uuid := (SELECT auth.uid());
  v_existing RECORD;
  v_list_id uuid;
  v_new_order smallint;
BEGIN
  IF v_uid IS NULL THEN
    RAISE EXCEPTION 'UNAUTHORIZED';
  END IF;

  -- added_from 유효성 검증
  IF p_added_from NOT IN ('recommendation', 'search', 'manual') THEN
    p_added_from := 'manual';
  END IF;

  -- 원두 존재 확인
  IF NOT EXISTS (SELECT 1 FROM public.coffee_beans WHERE id = p_bean_id) THEN
    RAISE EXCEPTION 'BEAN_NOT_FOUND';
  END IF;

  -- 중복 확인
  SELECT ubl.id, ubl.sort_order
  INTO v_existing
  FROM public.user_bean_lists ubl
  WHERE ubl.user_id = v_uid AND ubl.bean_id = p_bean_id;

  IF v_existing.id IS NOT NULL THEN
    RETURN jsonb_build_object(
      'id', v_existing.id,
      'is_new', false,
      'sort_order', v_existing.sort_order,
      'message', 'ALREADY_IN_LIST'
    );
  END IF;

  -- 새 순서 번호
  SELECT COALESCE(MAX(sort_order), 0) + 1 INTO v_new_order
  FROM public.user_bean_lists
  WHERE user_id = v_uid;

  -- 추가
  INSERT INTO public.user_bean_lists (user_id, bean_id, added_from, sort_order)
  VALUES (v_uid, p_bean_id, p_added_from, v_new_order)
  RETURNING id INTO v_list_id;

  RETURN jsonb_build_object(
    'id', v_list_id,
    'is_new', true,
    'sort_order', v_new_order
  );
END;
$function$;
```

#### 클라이언트 호출

```dart
// 추천 결과에서 찜
final result = await supabase.rpc('add_to_coffee_list', params: {
  'p_bean_id': beanId,
  'p_added_from': 'recommendation',
});
// 신규: { id, is_new: true, sort_order: 6 }
// 중복: { id, is_new: false, message: 'ALREADY_IN_LIST' }
```

---

### 4-3. `update_custom_bean(p_bean_id uuid, p_values jsonb)` → jsonb — **Phase 3**

**목적**: 사용자가 추가한 커스텀 원두 수정. user_bean_lists 경유 소유권 확인.

**대체 대상**: `UPDATE coffee_beans` (RLS 차단됨)

#### SQL

```sql
-- 마이그레이션: create_rpc_update_custom_bean
CREATE OR REPLACE FUNCTION public.update_custom_bean(
  p_bean_id uuid,
  p_values jsonb
)
  RETURNS jsonb
  LANGUAGE plpgsql
  SECURITY DEFINER
  SET search_path TO ''
AS $function$
DECLARE
  v_uid uuid := (SELECT auth.uid());
BEGIN
  IF v_uid IS NULL THEN
    RAISE EXCEPTION 'UNAUTHORIZED';
  END IF;

  -- 소유권 확인: user_bean_lists에서 manual로 추가한 원두만 수정 가능
  IF NOT EXISTS (
    SELECT 1 FROM public.user_bean_lists
    WHERE user_id = v_uid
      AND bean_id = p_bean_id
      AND added_from = 'manual'
  ) THEN
    RAISE EXCEPTION 'FORBIDDEN';
  END IF;

  UPDATE public.coffee_beans cb
  SET
    name          = COALESCE(NULLIF(btrim(p_values->>'name'), ''), cb.name),
    origin        = CASE
                      WHEN p_values ? 'origin' AND jsonb_typeof(p_values->'origin') = 'array'
                      THEN ARRAY(SELECT jsonb_array_elements_text(p_values->'origin'))
                      ELSE cb.origin
                    END,
    roast_level   = COALESCE(p_values->>'roast_level', cb.roast_level),
    roast_point   = COALESCE(NULLIF(p_values->>'roast_point', '')::smallint, cb.roast_point),
    description   = COALESCE(p_values->>'description', cb.description),
    image_url     = COALESCE(p_values->>'image_url', cb.image_url),
    variety       = COALESCE(p_values->>'variety', cb.variety),
    processing    = COALESCE(p_values->>'processing', cb.processing),
    acidity       = COALESCE(NULLIF(p_values->>'acidity', '')::smallint, cb.acidity),
    sweetness     = COALESCE(NULLIF(p_values->>'sweetness', '')::smallint, cb.sweetness),
    bitterness    = COALESCE(NULLIF(p_values->>'bitterness', '')::smallint, cb.bitterness),
    body          = COALESCE(NULLIF(p_values->>'body', '')::smallint, cb.body),
    aroma         = COALESCE(NULLIF(p_values->>'aroma', '')::smallint, cb.aroma),
    updated_at    = now()
  WHERE cb.id = p_bean_id;

  -- 플레이버 태그 교체 (전달된 경우)
  IF jsonb_typeof(p_values->'flavor_tags') = 'array' THEN
    DELETE FROM public.bean_flavor_tags WHERE bean_id = p_bean_id;

    INSERT INTO public.bean_flavor_tags (bean_id, category, sub_category, descriptor, descriptor_ko, display_order)
    SELECT
      p_bean_id,
      tag->>'category',
      tag->>'sub_category',
      tag->>'descriptor',
      tag->>'descriptor_ko',
      COALESCE(NULLIF(tag->>'display_order', '')::smallint, row_number() OVER ()::smallint)
    FROM jsonb_array_elements(p_values->'flavor_tags') AS tag;
  END IF;

  RETURN jsonb_build_object('updated', true);
END;
$function$;
```

#### 클라이언트 호출

```dart
final result = await supabase.rpc('update_custom_bean', params: {
  'p_bean_id': beanId,
  'p_values': {
    'name': '수정된 원두 이름',
    'roast_level': 'dark',
    'acidity': 30,
  },
});
```

---

### 4-4. `get_coffee_catalog(p_filters jsonb)` → jsonb — **Phase 3**

**목적**: 원두 카탈로그 조회. 필터링 + 플레이버 태그 + 찜 여부를 한 번에 반환.

**대체 대상**: `SELECT coffee_beans` + `SELECT bean_flavor_tags` (분리 쿼리)

#### SQL

```sql
-- 마이그레이션: create_rpc_get_coffee_catalog
CREATE OR REPLACE FUNCTION public.get_coffee_catalog(
  p_filters jsonb DEFAULT '{}'::jsonb
)
  RETURNS jsonb
  LANGUAGE plpgsql
  STABLE
  SET search_path TO ''
AS $function$
DECLARE
  v_uid uuid := (SELECT auth.uid());
  v_roast_level text := p_filters->>'roast_level';
  v_origin text := p_filters->>'origin';
  v_search text := p_filters->>'search';
  v_available_only boolean := COALESCE((p_filters->>'is_available')::boolean, true);
  v_limit integer := COALESCE(NULLIF(p_filters->>'limit', '')::integer, 50);
  v_offset integer := COALESCE(NULLIF(p_filters->>'offset', '')::integer, 0);
  v_beans jsonb;
  v_total integer;
BEGIN
  -- 총 개수 (필터 적용)
  SELECT COUNT(*)::int INTO v_total
  FROM public.coffee_beans cb
  WHERE (NOT v_available_only OR cb.is_available = true)
    AND (v_roast_level IS NULL OR cb.roast_level = v_roast_level)
    AND (v_origin IS NULL OR v_origin = ANY(cb.origin))
    AND (v_search IS NULL OR cb.name ILIKE '%' || v_search || '%');

  -- 원두 목록 (플레이버 + 찜 여부 포함)
  SELECT COALESCE(
    jsonb_agg(bean_row ORDER BY bean_row->>'name'),
    '[]'::jsonb
  )
  INTO v_beans
  FROM (
    SELECT jsonb_build_object(
      'id', cb.id,
      'name', cb.name,
      'origin', cb.origin,
      'roast_level', cb.roast_level,
      'roast_point', cb.roast_point,
      'description', cb.description,
      'image_url', cb.image_url,
      'original_price', cb.original_price,
      'discount_price', cb.discount_price,
      'discount_percent', cb.discount_percent,
      'weight', cb.weight,
      'purchase_url', cb.purchase_url,
      'acidity', cb.acidity,
      'sweetness', cb.sweetness,
      'bitterness', cb.bitterness,
      'body', cb.body,
      'aroma', cb.aroma,
      'is_available', cb.is_available,
      'variety', cb.variety,
      'processing', cb.processing,
      'flavor_tags', (
        SELECT COALESCE(
          jsonb_agg(
            jsonb_build_object(
              'category', bft.category,
              'sub_category', bft.sub_category,
              'descriptor', bft.descriptor,
              'descriptor_ko', bft.descriptor_ko
            )
            ORDER BY bft.display_order
          ) FILTER (WHERE bft.id IS NOT NULL),
          '[]'::jsonb
        )
        FROM public.bean_flavor_tags bft
        WHERE bft.bean_id = cb.id
      ),
      'is_in_my_list', (
        v_uid IS NOT NULL AND EXISTS (
          SELECT 1 FROM public.user_bean_lists ubl
          WHERE ubl.user_id = v_uid AND ubl.bean_id = cb.id
        )
      )
    ) AS bean_row
    FROM public.coffee_beans cb
    WHERE (NOT v_available_only OR cb.is_available = true)
      AND (v_roast_level IS NULL OR cb.roast_level = v_roast_level)
      AND (v_origin IS NULL OR v_origin = ANY(cb.origin))
      AND (v_search IS NULL OR cb.name ILIKE '%' || v_search || '%')
    ORDER BY cb.name
    LIMIT v_limit
    OFFSET v_offset
  ) sub;

  RETURN jsonb_build_object(
    'beans', v_beans,
    'total_count', v_total,
    'limit', v_limit,
    'offset', v_offset,
    'has_more', (v_offset + v_limit) < v_total
  );
END;
$function$;
```

#### 클라이언트 호출

```dart
// 전체 조회
final result = await supabase.rpc('get_coffee_catalog');

// 필터링
final result = await supabase.rpc('get_coffee_catalog', params: {
  'p_filters': {
    'roast_level': 'light',
    'search': '에티오피아',
    'limit': 20,
    'offset': 0,
  },
});
// result = { beans: [...], total_count: 12, has_more: false }
```
