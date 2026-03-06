# Coflanet 도메인별 데이터 플로우

Supabase 테이블, RPC, Edge Function 기반의 도메인별 데이터 흐름 정리.

## 도메인 목록

| # | 도메인 | 파일 | 관련 테이블 |
|---|--------|------|-------------|
| 1 | [인증/온보딩](./01-auth-onboarding.md) | `01-auth-onboarding.md` | auth.users, profiles, onboarding_survey |
| 2 | [설문](./02-survey.md) | `02-survey.md` | survey_sessions, survey_answers, survey_questions, survey_options |
| 3 | [추천/매칭](./03-recommendation.md) | `03-recommendation.md` | survey_results, survey_result_flavors, recommendations, coffee_beans |
| 4 | [원두 카탈로그/찜](./04-coffee-beans.md) | `04-coffee-beans.md` | coffee_beans, bean_flavor_tags, user_bean_lists |
| 5 | [레시피/타이머](./05-recipe-timer.md) | `05-recipe-timer.md` | recipes, recipe_steps, recipe_aroma_tags, brew_methods |
| 6 | [추출 기록](./06-brew-logs.md) | `06-brew-logs.md` | brew_logs |
| 7 | [마이페이지](./07-my-page.md) | `07-my-page.md` | 여러 테이블 집계 |
| 8 | [계정 삭제](./08-account-deletion.md) | `08-account-deletion.md` | 전체 테이블 CASCADE |

## 전체 아키텍처

```
Flutter Client
  │
  ├─ Supabase Auth (카카오/애플/네이버/게스트)
  │     └─ auth.users → handle_new_user 트리거 → profiles
  │
  ├─ Supabase Client (RPC 호출, 모든 RPC는 authenticated 역할 필요)
  │     ├─ 인증/온보딩: get_onboarding_status / get_onboarding_options
  │     │              save_display_name / save_onboarding_reasons
  │     ├─ 설문:      start_survey / save_survey_answers / complete_survey
  │     │              retake_survey
  │     ├─ 추천/매칭:  get_my_taste_profile / get_my_recommendations
  │     ├─ 원두/찜:   get_coffee_catalog / get_my_bean_list
  │     │              add_to_coffee_list / remove_from_coffee_list / reorder_coffee_list
  │     │              add_custom_bean / update_custom_bean
  │     ├─ 레시피:    get_merged_recipe / save_custom_recipe / delete_custom_recipe
  │     ├─ 추출 기록: save_brew_log / get_my_brew_logs / update_brew_log / delete_brew_log
  │     │              get_my_brew_stats
  │     └─ 마이페이지: get_my_dashboard / update_profile
  │
  └─ Edge Functions (service_role)
        ├─ naver-auth (네이버 로그인, verify_jwt: false)
        ├─ submit-survey (설문 제출 → 맛 프로필 → 추천, verify_jwt: true)
        ├─ match-coffee (재매칭, verify_jwt: true)
        └─ delete-account (계정 삭제, verify_jwt: true)
```

## 공통 규칙

- 모든 RPC에서 `(select auth.uid())` 기반 사용자 인증
- RLS: 본인 데이터만 접근 (`user_id = (select auth.uid())`)
- **모든 RLS 정책은 `authenticated` 역할 전용** — 미인증 사용자는 참조 데이터 포함 접근 불가
- 참조 데이터(survey_questions, coffee_beans 등)는 인증된 사용자에게 `SELECT true` (읽기 허용)
- service_role INSERT: survey_results, survey_result_flavors, recommendations (Edge Function 전용)
- 모든 테이블에 `updated_at` 자동 갱신 트리거 적용
- RLS 정책 총 **37개**, public 테이블 **15개** + 뷰 **3개** (v_coffee_bean_catalog, v_recipe_overview, v_user_brew_stats)
