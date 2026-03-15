# Coflanet 목업 분석 종합 결과

> 분석 일자: 2026-02-11
> 분석 대상: figma/ 48개 PNG (login 6, survey 24, main 1, coffee 15, my-page 2)

---

## 1. 전체 엔티티 목록

### 1.1 사용자/인증

| 엔티티 | 설명 | 소스 화면 |
|--------|------|-----------|
| `auth.users` | Supabase Auth 내장 | login/Signin |
| `profiles` | 사용자 확장 프로필 | login/Onboarding, my-page |

### 1.2 설문

| 엔티티 | 설명 | 소스 화면 |
|--------|------|-----------|
| `survey_questions` | 설문 질문 (참조) | survey/Survey01~10 |
| `survey_options` | 설문 선택지 (참조) | survey/Survey01~10 |
| `survey_sessions` | 설문 세션 | survey/Survey_index |
| `survey_answers` | 설문 응답 | survey/Survey01~10 |
| `survey_results` | 설문 결과 (맛 프로필) | survey/Survey_Result |
| `survey_result_flavors` | 결과 플레이버 설명 | survey/Survey_Result |

### 1.3 커피/원두

| 엔티티 | 설명 | 소스 화면 |
|--------|------|-----------|
| `coffee_beans` | 커피 원두 카탈로그 | survey/Survey_Result, coffee/ |
| `bean_flavor_tags` | 원두 플레이버 태그 | survey/Survey_Result |
| `recommendations` | 추천 결과 | survey/Survey_Result |
| `user_bean_lists` | 사용자 원두 목록 | coffee/Select Coffee Section |

### 1.4 레시피/타이머

| 엔티티 | 설명 | 소스 화면 |
|--------|------|-----------|
| `brew_methods` | 추출 기구 마스터 (참조) | coffee/Selection Modal |
| `recipes` | 사용자 레시피 | coffee/Recipe Setting |
| `recipe_steps` | 레시피 추출 단계 | coffee/Recipe Setting_Detail |

---

## 2. 설문 경로 구조 (목업 기준, 최신)

### Preference (직접 취향) - 3단계
```
1단계 공통: 추출 방식(중복선택) + 숙련도(단일선택)
2단계: 산미/바디감/단맛/쓴맛 (각각 3지선다: 싫어요/보통/좋아요)
3단계: 과일향/꽃향/견과류초콜릿향/로스팅향 (각각 2지선다)
```

### Lifestyle (간접 라이프스타일) - 4단계
```
1단계 공통: 추출 방식 + 숙련도
2단계: 라이프스타일 4문항 (각각 5지선다) - lifestyle.js Q1~Q4
3단계: 맛 취향 3문항 (각각 5지선다) - lifestyle.js Q5~Q7
4단계: 감각/성향 3문항 (각각 5지선다) - lifestyle.js Q8~Q10
```

---

## 3. 핸드드립 vs 머신 레시피 차이

| 항목 | 핸드드립 | 머신 (에스프레소) |
|------|---------|-------------------|
| 진하기 옵션 | 가벼운맛/균형잡힌맛/진한맛 | 룽고(1:3)/에스프레소(1:2)/리스트레토(1:1.5) |
| 분쇄도 | 600~1600um | 200~300um |
| 결과 단위 | 물의 양 (ml) | 추출량 (g) |
| 단계 | 뜸+다회차추출 | 본추출(단일/소수) |
| 총 시간 | ~2:30 | ~0:30 |

---

## 4. 기존 스펙(DATA.md) 대비 주요 변경점

| 항목 | 기존 | 목업(최신) |
|------|------|-----------|
| 설문 경로 | 단일 6단계 | 2경로 (Preference 3단계 / Lifestyle 4단계) |
| 맛 취향 형태 | 복수선택 | 개별 질문 x 4 (3지선다) |
| 향미 취향 | 과일향만 | 4개향 각각 2지선다 |
| 라이프스타일 | 별도 JS | Lifestyle 경로로 통합 |
| 원두 목록 추가 | 없음 | 결과에서 원두 선택 → 목록 추가 |
| 판매링크 | 없음 | coffee_beans.purchase_url |
| 일치율 | 없음 | recommendations.match_score |
| 설문 재실행 | 없음 | 세션 기반 재설문 |
| 가입 이유 | 없음 | profiles.onboarding_reasons |
| 게스트 로그인 | 없음 | Supabase anonymous auth |
