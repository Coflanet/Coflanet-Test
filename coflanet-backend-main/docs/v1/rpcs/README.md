# v1 — RPC 전환 계획

> 모든 클라이언트 API를 RPC로 통합하기 위한 도메인별 마이그레이션 정의.
>
> 참조: `docs/inapp/inapp-issues.md`, `docs/flows/`

## 현황 — ✅ 전체 완료 (2026-02-28)

- 기존 RPC: 15개 (정상 동작)
- 신규 RPC: **13개 (전체 적용 완료)**
- Edge Function 수정: **2개 (submit-survey v4, delete-account v2 배포 완료)**
- 현재: **28개 RPC + 4개 Edge Function**, 클라이언트 직접 테이블 접근 0개

## 도메인별 문서

| 파일 | 도메인 | Phase | 신규 RPC | 상태 |
|------|--------|-------|---------|------|
| [01-auth-onboarding.md](./01-auth-onboarding.md) | 인증/온보딩 | 4 | 1개 | ✅ 완료 |
| [02-survey.md](./02-survey.md) | 설문 | 2 | 3개 | ✅ 완료 |
| [03-recommendation.md](./03-recommendation.md) | 추천/매칭 | 1 | 0개 (EF 수정) | ✅ 완료 |
| [04-coffee-beans.md](./04-coffee-beans.md) | 원두/찜 | 1+3 | 4개 | ✅ 완료 |
| [05-recipe-timer.md](./05-recipe-timer.md) | 레시피/타이머 | 1+4 | 1개 | ✅ 완료 |
| [06-brew-logs.md](./06-brew-logs.md) | 추출 기록 | 4 | 4개 | ✅ 완료 |

## 적용 순서

```
Phase 1 (긴급 — 앱 기능 차단 해소) ✅ 완료
  ├── 03-recommendation: submit-survey / delete-account 401 수정 → getUser(token) 패치 배포
  ├── 04-coffee-beans: add_custom_bean RPC 생성 (SECURITY DEFINER)
  └── 05-recipe-timer: save_custom_recipe 앱 복원 (서버 작업 없음)

Phase 2 (설문 RPC 통합) ✅ 완료
  └── 02-survey: start_survey, save_survey_answers, complete_survey

Phase 3 (원두/찜 RPC 통합) ✅ 완료
  └── 04-coffee-beans: add_to_coffee_list, update_custom_bean (SECURITY DEFINER), get_coffee_catalog

Phase 4 (추출 기록/기타) ✅ 완료
  ├── 06-brew-logs: save_brew_log, get_my_brew_logs, update_brew_log, delete_brew_log
  ├── 05-recipe-timer: delete_custom_recipe
  └── 01-auth-onboarding: update_profile
```

## rpcs/ 미포함 RPC (flows/ 문서에 기재)

| RPC | 도메인 | 참조 문서 | 비고 |
|-----|--------|-----------|------|
| `get_my_dashboard()` | 마이페이지 | `docs/v1/flows/07-my-page.md` | 기존 RPC, STABLE |
| `delete_user_data(p_user_id)` | 계정 삭제 | `docs/v1/flows/08-account-deletion.md` | 기존 RPC, SECURITY DEFINER |

> 위 2개 RPC는 rpcs/ 전환 작업 범위 외 기존 함수이며, flows/ 문서에서 상세히 다룬다.

---

## 공통 패턴

모든 RPC는 아래 패턴을 따른다:

```sql
CREATE OR REPLACE FUNCTION public.<function_name>(...)
  RETURNS jsonb
  LANGUAGE plpgsql
  [STABLE]                          -- 읽기 전용이면 STABLE
  [SECURITY DEFINER]                -- RLS 우회 필요 시
  SET search_path TO ''
AS $function$
DECLARE
  v_uid uuid := (SELECT auth.uid());
BEGIN
  IF v_uid IS NULL THEN
    RAISE EXCEPTION 'UNAUTHORIZED';
  END IF;
  -- ...
END;
$function$;
```
