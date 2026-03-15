# 온보딩 완료 화면 API 연동 가이드

> Figma: `figma/login/완료페이지.png`

## 화면 개요

| 항목 | 값 |
|------|-----|
| 화면명 | 온보딩 완료 |
| 경로 | `/onboarding/complete` |
| 인증 필수 | ✅ |
| 설문 완료 필수 | ❌ |
| 진입 경로 | 온보딩 가입 이유 → "완료" |

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
| - | 없음 | - | - | 이전 화면에서 전달받은 `displayName` 사용 |

> 이 화면은 **서버 호출이 필요 없습니다**. 이전 화면(`save_onboarding_reasons()`)의 응답에 `display_name`이 포함되어 있으므로, 네비게이션 파라미터로 전달받아 사용합니다.

## 화면 표시 데이터

**닉네임 표시**:
```dart
// 이전 화면에서 전달받은 displayName 사용
final name = widget.displayName ?? '사용자';
// → "{name}님, 환영합니다!" 표시
```

**폴백 (앱 재시작 등으로 직접 진입 시)**:
```dart
// displayName이 없으면 get_onboarding_status()로 분기 재확인
if (widget.displayName == null) {
  final status = await supabase.rpc('get_onboarding_status');
  // next_screen에 따라 적절한 화면으로 리다이렉트
}
```

## 사용자 액션 매핑

| # | 사용자 액션 | API 호출 | 성공 시 UI 변경 | 실패 시 처리 |
|---|------------|----------|----------------|-------------|
| 1 | 화면 진입 | 없음 | "{이름}님, 환영합니다!" 표시 | 기본 환영 메시지 |
| 2 | 일정 시간 후 / 탭 | 없음 (네비게이션) | 설문 화면으로 자동 이동 | - |

## 네비게이션 파라미터

### 이 화면으로 진입 시 필요한 파라미터
| 파라미터 | 타입 | 필수 | 출처 화면 | 설명 |
|----------|------|:----:|-----------|------|
| displayName | String | ❌ | 가입 이유 화면 | `save_onboarding_reasons()` 응답의 `display_name`. 없으면 "사용자" 기본값 |

### 이 화면에서 다른 화면으로 전달하는 파라미터
| 대상 화면 | 파라미터 | 타입 | 설명 |
|-----------|----------|------|------|
| 설문 | - | - | 파라미터 없음 |

## 참고사항

- 이 화면은 순수 표시 화면 — **서버 API 호출 없음**
- 온보딩 완료 판단은 `get_onboarding_status()`가 `display_name` + `onboarding_reasons` 존재 여부로 결정
- 2~3초 후 자동 이동 또는 화면 탭으로 다음 화면(설문)으로 전환 권장
- 뒤로가기 시 온보딩 재진입 방지 — `get_onboarding_status()`로 분기 재확인
