# 온보딩 - 가입 이유 선택 API 연동 가이드

> Figma: `figma/login/Onboarding_Survey_Reason.png`

## 화면 개요

| 항목 | 값 |
|------|-----|
| 화면명 | 온보딩 - 가입 이유 선택 |
| 경로 | `/onboarding/reason` |
| 인증 필수 | ✅ |
| 설문 완료 필수 | ❌ |
| 진입 경로 | 온보딩 이름 입력 → "확인" |

## 인증 가드

```dart
final guards = [
  AuthGuard(),  // 로그인 필수
];
```

| 가드 | 체크 대상 | 미충족 시 리다이렉트 |
|------|-----------|---------------------|
| AuthGuard | `supabase.auth.currentUser != null` | `/login` |

## API 목록

| # | API | 유형 | 시점 | 설명 |
|---|-----|------|------|------|
| 1 | `get_onboarding_options()` | RPC | 화면 진입 | 선택지 목록 조회 |
| 2 | `save_onboarding_reasons()` | RPC | "완료" 버튼 탭 | 선택한 이유 저장 |

## API 상세

### API 1: 선택지 목록 조회

**호출 코드**:
```dart
final options = await supabase.rpc('get_onboarding_options');
// options: List<Map<String, dynamic>>
```

**파라미터**: 없음

**Response JSON 예시**:
```json
[
  {"option_key": "find_taste", "label": "커피 취향을 찾고 싶어요.", "display_order": 1},
  {"option_key": "subscribe_bean", "label": "원두를 편하게 구독하고 싶어요.", "display_order": 2},
  {"option_key": "try_variety", "label": "다양한 원두를 시도해보고 싶어요.", "display_order": 3},
  {"option_key": "community", "label": "사람들과 커피에 대해 소통하고 싶어요.", "display_order": 4},
  {"option_key": "learn_coffee", "label": "커피에 대한 정보를 알고싶어요.", "display_order": 5}
]
```

**에러 케이스**:
| 에러 코드 | 원인 | 프론트 처리 |
|-----------|------|------------|
| 42501 | RLS 권한 부족 | 로그인 상태 재확인 |

### API 2: 가입 이유 저장

**호출 코드**:
```dart
// selectedKeys: 사용자가 선택한 option_key 배열
final profile = await supabase.rpc(
  'save_onboarding_reasons',
  params: {'reasons': selectedKeys},
);
```

**파라미터**:
| 파라미터 | 타입 | 필수 | 설명 |
|----------|------|:----:|------|
| reasons | TEXT[] | ✅ | 선택한 `option_key` 배열 (최소 1개) |

**서버 사이드 검증**:
- 빈 배열이면 `INVALID_REASONS` 예외
- `onboarding_survey` 테이블에 존재하지 않거나 비활성인 key는 자동 필터링
- 필터링 후 유효한 key가 0개이면 `INVALID_REASONS` 예외

**Response JSON 예시**:
```json
{
  "id": "uuid-프로필-id",
  "user_id": "uuid-사용자-id",
  "display_name": "김택림",
  "onboarding_reasons": ["find_taste", "subscribe_bean"],
  "is_dark_mode": false,
  "avatar_url": null,
  "coffee_level": null,
  "survey_completed": false,
  "created_at": "2026-02-16T12:00:00Z",
  "updated_at": "2026-02-16T12:00:10Z"
}
```

**에러 케이스**:
| 에러 코드 | 원인 | 프론트 처리 |
|-----------|------|------------|
| UNAUTHORIZED | 미인증 | 로그인 화면으로 리다이렉트 |
| INVALID_REASONS | 빈 배열 또는 유효하지 않은 key | "최소 1개를 선택해주세요" 안내 |
| PROFILE_NOT_FOUND | profiles 행 없음 | 로그아웃 → 재가입 안내 |

## 사용자 액션 매핑

| # | 사용자 액션 | API 호출 | 성공 시 UI 변경 | 실패 시 처리 |
|---|------------|----------|----------------|-------------|
| 1 | 화면 진입 | `get_onboarding_options()` | 선택지 렌더링 | 하드코딩 폴백 |
| 2 | 선택지 탭 (토글) | 없음 (로컬 상태) | 체크 표시 토글 | - |
| 3 | "완료" 버튼 탭 | `save_onboarding_reasons()` | 완료 화면으로 이동 | "저장에 실패했습니다" 토스트 |
| 4 | 뒤로가기 | 없음 | 이름 입력 화면으로 이동 | - |

## 네비게이션 파라미터

### 이 화면으로 진입 시 필요한 파라미터
| 파라미터 | 타입 | 필수 | 출처 화면 | 설명 |
|----------|------|:----:|-----------|------|
| displayName | String | ❌ | 이름 입력 화면 | 완료 화면에 전달할 닉네임 |

### 이 화면에서 다른 화면으로 전달하는 파라미터
| 대상 화면 | 파라미터 | 타입 | 설명 |
|-----------|----------|------|------|
| 온보딩 완료 | displayName | String | `save_onboarding_reasons()` 응답의 `display_name` 또는 이전 화면에서 전달받은 값 |

## 참고사항

- **중복 선택 가능** — UI에 "중복 선택 가능해요." 안내 표시
- 최소 1개 이상 선택해야 "완료" 버튼 활성화 (프론트 검증)
- 서버에서도 빈 배열 + 유효 key 검증 (이중 검증)
- 선택지는 `get_onboarding_options()` RPC로 동적 조회 — 관리자가 DB에서 추가/수정/비활성화 가능
- `option_key` 값을 `profiles.onboarding_reasons` 배열에 저장 (label이 아닌 key)
- 프로그레스 바: 온보딩 2단계 중 2단계 (100%)
