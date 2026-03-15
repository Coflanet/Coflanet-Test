# 마이페이지 플로우

## 개요

마이페이지(My 행성)는 사용자의 **커피 취향 프로필**과 **계정 관리** 기능을 제공하는 화면이다.
설문 완료 여부에 따라 두 가지 상태로 분기된다.

| 상태 | 조건 | 화면 |
|------|------|------|
| 설문 완료 | `get_my_taste_profile()` != null | 맛 프로필 + 플레이버 표시 |
| 설문 미완료 | `get_my_taste_profile()` == null | 설문 유도 CTA 표시 |

---

## 화면 진입 플로우

```
탭바 "My 행성" 탭
  │
  ▼
AuthGuard 확인
  │
  ├── 미인증 → /login 리다이렉트
  │
  └── 인증됨
        │
        ▼
      get_my_taste_profile() RPC 호출
        │
        ├── 결과 != null (설문 완료)
        │     → My Planet 렌더링
        │     • 닉네임 (profiles.display_name)
        │     • 맛 프로필 태그 (acidity, body, sweetness, bitterness)
        │     • 플레이버 목록 (survey_result_flavors)
        │     • "취향 설문 다시 하기" 버튼
        │
        └── 결과 == null (설문 미완료)
              → My Planet Empty 렌더링
              • 닉네임
              • "내 커피 취향을 찾아볼까요?" CTA
              • "취향 설문 하기" 버튼
```

---

## 데이터 구조

### 맛 프로필 (survey_results)

설문 분석 결과로 산출된 사용자의 맛 선호 점수. `get_my_taste_profile()` RPC가 최신 결과를 반환한다.

| 필드 | 타입 | 범위 | UI 표시 |
|------|------|------|---------|
| `acidity` | smallint | 0-100 | 산미: 좋음/보통/싫음 (클라이언트 변환) |
| `sweetness` | smallint | 0-100 | 단맛: 좋음/보통/싫음 |
| `bitterness` | smallint | 0-100 | 쓴맛: 좋음/보통/싫음 |
| `body` | smallint | 0-100 | 바디감: 좋음/보통/싫음 |
| `aroma` | smallint | 0-100 | (UI 미표시, 내부 매칭용) |

> 점수→라벨 변환은 클라이언트에서 처리한다. 예: 0-33 → "싫음", 34-66 → "보통", 67-100 → "좋음"

### 플레이버 태그 (survey_result_flavors)

설문 결과에 매칭된 풍미 키워드. `get_my_taste_profile()`의 `flavors` 배열로 함께 반환된다.

| 필드 | 용도 | UI 매핑 |
|------|------|---------|
| `name` | 플레이버 이름 | "과일 향", "꽃 향" 등 제목 |
| `description` | 상세 설명 | "베리, 사과, 감귤 같은 상큼한 향" 등 부제 |
| `emoji` | 아이콘 | 플레이버 앞 아이콘 (nullable) |
| `display_order` | 정렬 순서 | 목록 렌더링 순서 |

---

## 설문 재실행 플로우

```
"취향 설문 다시 하기" 버튼 탭
  │
  ▼
retake_survey() RPC 호출
  │
  ├── 내부 처리:
  │     1. 기존 in_progress/analyzing 세션 → completed 상태로 변경
  │     2. 새 survey_session 생성 (status: in_progress, step: 1)
  │     3. 기존 survey_results는 보존됨 (덮어쓰기 아님)
  │
  └── 반환: { new_session_id, ready_for_new_survey: true }
        │
        ▼
      /survey 화면으로 이동 (새 세션으로 설문 시작)
```

**참고**: 설문을 다시 해도 이전 결과(`survey_results`)는 삭제되지 않는다. 새 설문 완료 시 새로운 `survey_results`가 생성되며, `get_my_taste_profile()`은 항상 **가장 최신 결과**를 반환한다.

---

## 로그아웃 플로우

```
"로그아웃" 탭
  │
  ▼
확인 다이얼로그 (선택적)
  │
  ▼
supabase.auth.signOut()
  │
  ├── 성공 → /login 화면으로 이동
  │     • 로컬 세션/토큰 제거
  │     • 앱 상태 초기화
  │
  └── 실패 → 재시도 안내 토스트
```

---

## 회원탈퇴 플로우

```
"회원탈퇴" 탭
  │
  ▼
확인 다이얼로그 ("정말 탈퇴하시겠습니까?")
  │
  ├── 취소 → 닫기
  │
  └── 확인
        │
        ▼
      delete-account Edge Function 호출
        │
        body: { "confirm": "DELETE" }
        │
        ├── Step 1: 사용자 인증 확인 (Authorization 헤더)
        │
        ├── Step 2: delete_user_data(user_id) RPC 실행
        │     • recommendations 삭제
        │     • survey_result_flavors 삭제
        │     • survey_results 삭제
        │     • survey_answers 삭제
        │     • survey_sessions 삭제
        │     • user_bean_lists 삭제
        │     • recipe_steps 삭제
        │     • recipe_aroma_tags 삭제
        │     • recipes (사용자 커스텀만) 삭제
        │     • brew_logs 삭제
        │     • profiles 삭제
        │
        ├── Step 3: Storage avatars 정리 (best effort)
        │
        └── Step 4: admin.auth.admin.deleteUser() — auth.users 삭제
              │
              ▼
            /login 화면으로 이동 (세션 만료)
```

**주의사항**:
- `delete_user_data()`는 `SECURITY DEFINER`로 실행 — RLS 우회하여 모든 관련 데이터 삭제
- Edge Function은 `verify_jwt: true` — 인증된 사용자만 호출 가능
- `confirm: "DELETE"` 텍스트 검증 필수 — 실수 방지
- auth.users 삭제 후 세션이 자동 무효화됨

---

## 사용 테이블/함수 요약

### RPC 함수

| 함수 | 용도 | 호출 시점 |
|------|------|-----------|
| `get_my_taste_profile()` | 최신 맛 프로필 + 플레이버 조회 | 화면 진입 |
| `get_my_dashboard()` | 프로필 + 집계 (bean_count 등) | 보조 데이터 필요 시 |
| `retake_survey()` | 새 설문 세션 생성 | "취향 설문 다시 하기" 탭 |
| `delete_user_data(uuid)` | public 데이터 전체 삭제 | 회원탈퇴 (Edge Function 내부) |

### Edge Function

| 함수 | 용도 | verify_jwt |
|------|------|:----------:|
| `delete-account` | 회원탈퇴 (데이터 삭제 + auth 삭제) | ✅ true |

### 테이블 (읽기)

| 테이블 | 접근 방식 | RLS 정책 |
|--------|-----------|----------|
| `profiles` | RPC 내부 조회 | `profiles_select_own` |
| `survey_results` | RPC 내부 조회 | `survey_results_select_own` |
| `survey_result_flavors` | RPC 내부 조회 | `survey_result_flavors_select_own` |

---

## 하단 탭바 네비게이션

마이페이지는 앱의 4개 메인 탭 중 하나이다:

| 탭 | 라벨 | 경로 |
|----|------|------|
| 1 | 원두 | `/home` (추천 원두 목록) |
| 2 | 추출 목록 | `/brew-list` (추출 기록) |
| 3 | 시음 기록 | `/tasting` (시음 노트) |
| 4 | **My 행성** | **`/my-page`** (현재 화면) |
