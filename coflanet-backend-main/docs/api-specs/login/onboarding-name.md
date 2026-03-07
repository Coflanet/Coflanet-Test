# 온보딩 - 이름 입력 API 연동 가이드

> Figma: `figma/login/Onboarding_Survey.png`, `Onboarding_Survey-1.png`, `Onboarding_Survey-2.png`

## 화면 개요

| 항목 | 값 |
|------|-----|
| 화면명 | 온보딩 - 이름 입력 |
| 경로 | `/onboarding/name` |
| 인증 필수 | ✅ |
| 설문 완료 필수 | ❌ |
| 진입 경로 | 로그인 → `get_onboarding_status()` → `next_screen: 'onboarding'` |

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
| 1 | `save_display_name()` | RPC | "확인" 버튼 탭 | 닉네임 저장 |

## API 상세

### API 1: 닉네임 저장

**호출 코드**:
```dart
final profile = await supabase.rpc(
  'save_display_name',
  params: {'display_name': nameController.text.trim()},
);
```

**파라미터**:
| 파라미터 | 타입 | 필수 | 설명 |
|----------|------|:----:|------|
| display_name | TEXT | ✅ | 사용자 닉네임 (공백 자동 trim) |

**서버 사이드 검증**:
- `btrim()` 후 빈 문자열이면 `INVALID_DISPLAY_NAME` 예외
- 프로필 미존재 시 `PROFILE_NOT_FOUND` 예외

**Response JSON 예시**:
```json
{
  "id": "uuid-프로필-id",
  "user_id": "uuid-사용자-id",
  "display_name": "김택림",
  "onboarding_reasons": [],
  "is_dark_mode": false,
  "avatar_url": null,
  "coffee_level": null,
  "survey_completed": false,
  "created_at": "2026-02-16T12:00:00Z",
  "updated_at": "2026-02-16T12:00:05Z"
}
```

**에러 케이스**:
| 에러 코드 | 원인 | 프론트 처리 |
|-----------|------|------------|
| UNAUTHORIZED | 미인증 | 로그인 화면으로 리다이렉트 |
| INVALID_DISPLAY_NAME | 빈 문자열 | "닉네임을 입력해주세요" 안내 |
| PROFILE_NOT_FOUND | profiles 행 없음 | 로그아웃 → 재가입 안내 |

## 사용자 액션 매핑

| # | 사용자 액션 | API 호출 | 성공 시 UI 변경 | 실패 시 처리 |
|---|------------|----------|----------------|-------------|
| 1 | 이름 입력 | 없음 (로컬 상태) | "확인" 버튼 활성화 | - |
| 2 | "확인" 버튼 탭 | `save_display_name()` | 가입 이유 선택 화면으로 이동 | "저장에 실패했습니다" 토스트 |
| 3 | 뒤로가기 | 없음 | 로그인 화면으로 이동 | - |

## 네비게이션 파라미터

### 이 화면으로 진입 시 필요한 파라미터
| 파라미터 | 타입 | 필수 | 출처 화면 | 설명 |
|----------|------|:----:|-----------|------|
| - | - | - | - | 파라미터 없음 |

### 이 화면에서 다른 화면으로 전달하는 파라미터
| 대상 화면 | 파라미터 | 타입 | 설명 |
|-----------|----------|------|------|
| 가입 이유 선택 | displayName | String | `save_display_name()` 응답의 `display_name` 전달 (완료 화면에서 사용) |

## 참고사항

- 입력값이 빈 문자열이면 "확인" 버튼 비활성화 (프론트 검증)
- 서버에서도 `btrim()` 후 빈 문자열 검증 (이중 검증)
- `display_name`은 `VARCHAR` 타입 — 길이 제한은 프론트에서 적용 권장
- 프로그레스 바: 온보딩 2단계 중 1단계 (50%)
