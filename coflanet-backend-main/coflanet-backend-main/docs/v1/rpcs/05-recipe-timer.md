# 05. 레시피/타이머 — RPC 정의

> Phase 1 + Phase 4 | ✅ 완료 (2026-02-28)
>
> 참조: `docs/flows/05-recipe-timer.md`

## 기존 RPC (2개)

| RPC | 용도 | 상태 |
|-----|------|------|
| `get_merged_recipe(brew_method_id, bean_id?)` | 3단계 우선순위 병합 레시피 조회 | ✅ |
| `save_custom_recipe(brew_method_id, bean_id, name, values)` | 커스텀 레시피 UPSERT | ⚠️ **서버 존재, 앱 미사용** |

## 핵심 수정 사항

### `save_custom_recipe` — 앱 복원 (서버 작업 없음, Phase 1)

```
⚠️ 중요 발견:
  inapp-issues.md에 "save_custom_recipe RPC는 존재하지 않음" 기록됨
  → 실제로는 서버에 존재하며 정상 동작

현재 앱: recipes + recipe_steps + recipe_aroma_tags 3개 테이블 직접 INSERT
권장: save_custom_recipe RPC 1회 호출로 통합
```

#### 서버 시그니처 (이미 존재)

```sql
-- 이미 존재하는 함수 — 생성 불필요
public.save_custom_recipe(
  p_brew_method_id uuid,
  p_bean_id uuid,       -- NULL 가능 (범용 레시피)
  p_name text,
  p_values jsonb DEFAULT '{}'
) → jsonb
```

#### p_values 구조

```json
{
  "cups": 1,
  "strength": "balanced",
  "coffee_amount_g": 18,
  "water_temp_c": 93,
  "grind_size_um": 700,
  "total_water_ml": 210,
  "total_yield_g": null,
  "total_duration_seconds": 150,
  "aroma_description": "고소하고 달콤한 향",
  "yield_g": null,
  "extraction_time_seconds": null,
  "steps": [
    {
      "step_number": 1,
      "title": "뜸 들이기",
      "description": "원두 위에 물을 천천히 부어주세요",
      "step_type": "brewing",
      "water_amount_ml": 30,
      "duration_seconds": 30,
      "action_text": "30ml 물 투입",
      "illustration_emoji": "💧"
    },
    {
      "step_number": 2,
      "title": "1차 추출",
      "step_type": "brewing",
      "water_amount_ml": 100,
      "duration_seconds": 60,
      "action_text": "원을 그리며 추출"
    }
  ],
  "aroma_tags": [
    { "emoji": "🌰", "name": "견과류", "display_order": 1 },
    { "emoji": "🍫", "name": "초콜릿", "display_order": 2 }
  ]
}
```

#### 동작 방식

```
1. 동일 (user_id, brew_method_id, bean_id) 조합 검색
2. 있으면 → UPDATE (COALESCE로 변경 필드만)
3. 없으면 → INSERT
4. steps: DELETE 기존 → INSERT 새 것
5. aroma_tags: DELETE 기존 → INSERT 새 것
6. 반환: { recipe_id, is_new }
```

#### 앱 측 수정 (Flutter)

```dart
// 수정 전 (3번 INSERT)
await supabase.from('recipes').insert({...});
await supabase.from('recipe_steps').insert([...]);
await supabase.from('recipe_aroma_tags').insert([...]);

// 수정 후 (RPC 1회)
final result = await supabase.rpc('save_custom_recipe', params: {
  'p_brew_method_id': brewMethodId,
  'p_bean_id': beanId,  // nullable
  'p_name': '내 레시피',
  'p_values': {
    'cups': 1,
    'strength': 'balanced',
    'coffee_amount_g': 18,
    'steps': [...],
    'aroma_tags': [...],
  },
});
// result = { recipe_id: 'uuid', is_new: true }
```

---

## 신규 RPC (1개) — ✅ 적용 완료

### 5-1. `delete_custom_recipe(p_recipe_id uuid)` → jsonb — ✅ 완료

**목적**: 사용자 커스텀 레시피 삭제. 자식 테이블(steps, aroma_tags) 정리 + 관련 brew_logs 참조 해제.

**대체 대상**: `DELETE recipes WHERE id = ?` (자식 테이블 정리 안됨)

#### SQL

```sql
-- 마이그레이션: create_rpc_delete_custom_recipe
CREATE OR REPLACE FUNCTION public.delete_custom_recipe(p_recipe_id uuid)
  RETURNS jsonb
  LANGUAGE plpgsql
  SET search_path TO ''
AS $function$
DECLARE
  v_uid uuid := (SELECT auth.uid());
  v_recipe RECORD;
  v_deleted_steps integer;
  v_deleted_tags integer;
BEGIN
  IF v_uid IS NULL THEN
    RAISE EXCEPTION 'UNAUTHORIZED';
  END IF;

  -- 레시피 소유권 확인
  SELECT r.id, r.user_id, r.is_default
  INTO v_recipe
  FROM public.recipes r
  WHERE r.id = p_recipe_id;

  IF v_recipe.id IS NULL THEN
    RAISE EXCEPTION 'RECIPE_NOT_FOUND';
  END IF;

  IF v_recipe.user_id IS NULL OR v_recipe.user_id <> v_uid THEN
    RAISE EXCEPTION 'FORBIDDEN';
  END IF;

  IF v_recipe.is_default THEN
    RAISE EXCEPTION 'CANNOT_DELETE_DEFAULT';
  END IF;

  -- 관련 brew_logs의 recipe_id → NULL (기록은 유지)
  UPDATE public.brew_logs
  SET recipe_id = NULL, updated_at = now()
  WHERE recipe_id = p_recipe_id
    AND user_id = v_uid;

  -- 자식 테이블 삭제
  DELETE FROM public.recipe_aroma_tags WHERE recipe_id = p_recipe_id;
  GET DIAGNOSTICS v_deleted_tags = ROW_COUNT;

  DELETE FROM public.recipe_steps WHERE recipe_id = p_recipe_id;
  GET DIAGNOSTICS v_deleted_steps = ROW_COUNT;

  -- 레시피 삭제
  DELETE FROM public.recipes WHERE id = p_recipe_id;

  RETURN jsonb_build_object(
    'deleted', true,
    'deleted_steps', v_deleted_steps,
    'deleted_tags', v_deleted_tags
  );
END;
$function$;
```

#### 클라이언트 호출

```dart
final result = await supabase.rpc('delete_custom_recipe', params: {
  'p_recipe_id': recipeId,
});
// result = { deleted: true, deleted_steps: 3, deleted_tags: 2 }
```

---

## 추가 참고: `get_brew_methods()` (선택)

추출 기구 목록은 현재 직접 SELECT로 충분히 동작 (공개 읽기, 5행 고정).
통일성을 위해 RPC를 만들 수 있으나 우선순위 낮음.

```dart
// 현재 (정상 동작)
final methods = await supabase.from('brew_methods').select().order('name');

// RPC로 전환 시 (선택)
final methods = await supabase.rpc('get_brew_methods');
```
