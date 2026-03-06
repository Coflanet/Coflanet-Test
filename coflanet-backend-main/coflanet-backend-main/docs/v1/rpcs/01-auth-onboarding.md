# 01. 인증/온보딩 — RPC 정의

> Phase 4 | ✅ 완료 (2026-02-28)
>
> 참조: `docs/flows/01-auth-onboarding.md`

## 기존 RPC (4개) — 유지

| RPC | 파라미터 | 상태 |
|-----|----------|------|
| `get_onboarding_status()` | 없음 | ✅ |
| `get_onboarding_options()` | 없음 | ✅ |
| `save_display_name(text)` | `display_name` | ✅ |
| `save_onboarding_reasons(text[])` | `reasons` | ✅ |

## 신규 RPC (1개) — ✅ 적용 완료

---

### `update_profile(p_values jsonb)` → jsonb — ✅ 완료

**목적**: 프로필 필드 통합 수정. 현재 앱에서 `profiles` 테이블 직접 UPDATE를 RPC로 전환.

**대체 대상**: `UPDATE profiles SET is_dark_mode = ... WHERE user_id = auth.uid()`

#### SQL

```sql
-- 마이그레이션: create_rpc_update_profile
CREATE OR REPLACE FUNCTION public.update_profile(p_values jsonb DEFAULT '{}'::jsonb)
  RETURNS jsonb
  LANGUAGE plpgsql
  SET search_path TO ''
AS $function$
DECLARE
  v_uid uuid := (SELECT auth.uid());
  v_profile RECORD;
  v_coffee_level text;
BEGIN
  IF v_uid IS NULL THEN
    RAISE EXCEPTION 'UNAUTHORIZED';
  END IF;

  -- coffee_level 유효성 검증
  v_coffee_level := p_values->>'coffee_level';
  IF v_coffee_level IS NOT NULL
     AND v_coffee_level NOT IN ('beginner', 'enthusiast', 'home_barista', 'professional')
  THEN
    RAISE EXCEPTION 'INVALID_COFFEE_LEVEL';
  END IF;

  UPDATE public.profiles p
  SET
    is_dark_mode    = COALESCE((p_values->>'is_dark_mode')::boolean, p.is_dark_mode),
    avatar_url      = COALESCE(p_values->>'avatar_url', p.avatar_url),
    coffee_level    = COALESCE(v_coffee_level, p.coffee_level),
    updated_at      = now()
  WHERE p.user_id = v_uid
  RETURNING
    p.id, p.user_id, p.display_name, p.onboarding_reasons,
    p.is_dark_mode, p.avatar_url, p.coffee_level, p.survey_completed,
    p.created_at, p.updated_at
  INTO v_profile;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'PROFILE_NOT_FOUND';
  END IF;

  RETURN jsonb_build_object(
    'id', v_profile.id,
    'user_id', v_profile.user_id,
    'display_name', v_profile.display_name,
    'onboarding_reasons', v_profile.onboarding_reasons,
    'is_dark_mode', v_profile.is_dark_mode,
    'avatar_url', v_profile.avatar_url,
    'coffee_level', v_profile.coffee_level,
    'survey_completed', v_profile.survey_completed,
    'created_at', v_profile.created_at,
    'updated_at', v_profile.updated_at
  );
END;
$function$;
```

#### 클라이언트 호출

```dart
// 다크모드 토글
final result = await supabase.rpc('update_profile', params: {
  'p_values': {'is_dark_mode': true},
});

// 커피 레벨 변경
final result = await supabase.rpc('update_profile', params: {
  'p_values': {'coffee_level': 'enthusiast'},
});

// 복합 수정
final result = await supabase.rpc('update_profile', params: {
  'p_values': {
    'is_dark_mode': false,
    'avatar_url': 'https://...',
    'coffee_level': 'home_barista',
  },
});
```

#### 검증 쿼리

```sql
-- RPC 호출 테스트 (인증 필요)
SELECT public.update_profile('{"is_dark_mode": true}'::jsonb);
```
