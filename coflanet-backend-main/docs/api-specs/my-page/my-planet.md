# 마이페이지 (My 행성) API 연동 가이드

> Figma: `figma/my-page/My Planet.png`, `My Planet_Empty.png`

## 화면 개요

| 항목 | 값 |
|------|-----|
| 화면명 | My 행성 (마이페이지) |
| 경로 | `/my-page` |
| 인증 필수 | ✅ |
| 설문 완료 필수 | ❌ (미완료 시 Empty 상태 표시) |
| 진입 경로 | 하단 탭바 "My 행성" |

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
| 1 | `get_my_taste_profile()` | RPC | 화면 진입 | 맛 프로필 + 플레이버 조회 (분기 판단) |
| 2 | `profiles` SELECT | 테이블 | 화면 진입 | 닉네임 조회 |
| 3 | `retake_survey()` | RPC | "취향 설문 다시 하기" 탭 | 새 설문 세션 생성 |
| 4 | `supabase.auth.signOut()` | Auth API | "로그아웃" 탭 | 세션 종료 |
| 5 | `delete-account` | Edge Function | "회원탈퇴" 탭 | 계정 영구 삭제 |

## API 상세

### API 1: 맛 프로필 조회

**호출 코드**:
```dart
final tasteProfile = await supabase.rpc('get_my_taste_profile');

if (tasteProfile == null) {
  // → Empty 상태 렌더링 ("내 커피 취향을 찾아볼까요?")
} else {
  // → 맛 프로필 + 플레이버 렌더링
  final profile = tasteProfile as Map<String, dynamic>;
}
```

**Response JSON 예시 (설문 완료)**:
```json
{
  "id": "uuid-결과-id",
  "coffee_type": "balance",
  "coffee_type_label": "밸런스파",
  "coffee_type_description": "산미와 바디의 균형을 즐기는 타입",
  "acidity": 72,
  "sweetness": 55,
  "bitterness": 30,
  "body": 50,
  "aroma": 65,
  "created_at": "2026-02-16T12:00:00Z",
  "flavors": [
    {
      "name": "과일 향",
      "emoji": "🍎",
      "description": "베리, 사과, 감귤 같은 상큼한 향",
      "display_order": 1
    },
    {
      "name": "꽃 향",
      "emoji": "🌸",
      "description": "자스민처럼 은은하고 화사한 향",
      "display_order": 2
    },
    {
      "name": "견과류/초콜릿 향",
      "emoji": "🍫",
      "description": "고소한 견과나 다크초콜릿 같은 향",
      "display_order": 3
    },
    {
      "name": "로스팅 향",
      "emoji": "🔥",
      "description": "구운 곡물, 시리얼 같은 구수한 향",
      "display_order": 4
    }
  ]
}
```

**Response JSON 예시 (설문 미완료)**:
```json
null
```

**맛 점수 → 라벨 변환 (클라이언트)**:
```dart
String scoreToLabel(int score) {
  if (score >= 67) return '좋음';
  if (score >= 34) return '보통';
  return '싫음';
}
// 예: acidity: 72 → "좋음", bitterness: 30 → "싫음"
```

**에러 케이스**:
| HTTP 상태 | 원인 | 프론트 처리 |
|-----------|------|------------|
| 401 | 미인증 | 로그인 화면으로 리다이렉트 |

### API 2: 닉네임 조회

**호출 코드**:
```dart
final profile = await supabase
  .from('profiles')
  .select('display_name')
  .eq('user_id', supabase.auth.currentUser!.id)
  .single();

final name = profile['display_name'] as String?;
// → 상단에 "{name}" 표시 (null이면 "사용자" 등 기본값)
```

**Response JSON 예시**:
```json
{
  "display_name": "김택림"
}
```

> `get_my_dashboard()` RPC를 사용하면 닉네임 + 집계 데이터를 한 번에 조회 가능:
> ```dart
> final dashboard = await supabase.rpc('get_my_dashboard');
> // → dashboard['display_name'], dashboard['bean_count'] 등
> ```

**에러 케이스**:
| 코드 | 원인 | 프론트 처리 |
|------|------|------------|
| PGRST116 | profiles 행 없음 | "사용자" 기본값 표시 |

### API 3: 설문 재실행

**호출 코드**:
```dart
final result = await supabase.rpc('retake_survey');
final newSessionId = result['new_session_id'] as String;

// → /survey 화면으로 이동
Navigator.pushNamed(context, '/survey');
```

**Response JSON 예시**:
```json
{
  "new_session_id": "uuid-새-세션-id",
  "ready_for_new_survey": true
}
```

> 내부 처리: 기존 in_progress/analyzing 세션을 completed로 변경 후 새 세션을 생성한다. 이전 설문 결과(survey_results)는 보존된다.

**에러 케이스**:
| HTTP 상태 | 원인 | 프론트 처리 |
|-----------|------|------------|
| 401 | 미인증 | 로그인 화면으로 리다이렉트 |

### API 4: 로그아웃

**호출 코드**:
```dart
await supabase.auth.signOut();

// → /login 화면으로 이동 + 앱 상태 초기화
Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
```

**결과**: 로컬 세션/토큰이 제거되고, 이후 API 호출은 401로 실패한다.

### API 5: 회원탈퇴

**호출 코드**:
```dart
// 1. 확인 다이얼로그 표시
final confirmed = await showDialog<bool>(
  context: context,
  builder: (_) => AlertDialog(
    title: Text('회원탈퇴'),
    content: Text('모든 데이터가 영구 삭제됩니다. 정말 탈퇴하시겠습니까?'),
    actions: [
      TextButton(onPressed: () => Navigator.pop(context, false), child: Text('취소')),
      TextButton(onPressed: () => Navigator.pop(context, true), child: Text('탈퇴')),
    ],
  ),
);

if (confirmed != true) return;

// 2. Edge Function 호출
final response = await supabase.functions.invoke(
  'delete-account',
  body: {'confirm': 'DELETE'},
);

// 3. 성공 시 로그인 화면으로 이동
final data = response.data as Map<String, dynamic>;
if (data['success'] == true) {
  Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
}
```

**Request Body**:
```json
{
  "confirm": "DELETE"
}
```
> `confirm` 값이 정확히 `"DELETE"`가 아니면 400 에러 반환.

**Response JSON 예시**:
```json
{
  "success": true,
  "data": {
    "user_id": "uuid-사용자-id",
    "delete_summary": {
      "user_id": "uuid-사용자-id",
      "recommendations": 5,
      "survey_result_flavors": 4,
      "survey_results": 1,
      "survey_answers": 20,
      "survey_sessions": 1,
      "user_bean_lists": 3,
      "recipe_steps": 0,
      "recipe_aroma_tags": 0,
      "recipes": 0,
      "brew_logs": 12,
      "profiles": 1
    }
  }
}
```

**에러 케이스**:
| 코드 | HTTP | 원인 | 프론트 처리 |
|------|------|------|------------|
| INVALID_CONFIRM_TEXT | 400 | confirm != "DELETE" | 재시도 (코드 버그) |
| UNAUTHORIZED | 401 | 인증 헤더 없음/만료 | 로그인 화면으로 이동 |
| DELETE_DATA_FAILED | 500 | 데이터 삭제 실패 | "탈퇴에 실패했습니다" 토스트 |
| DELETE_AUTH_FAILED | 500 | 계정 삭제 실패 | "탈퇴에 실패했습니다" 토스트 |

## 사용자 액션 매핑

| # | 사용자 액션 | API 호출 | 성공 시 UI 변경 | 실패 시 처리 |
|---|------------|----------|----------------|-------------|
| 1 | 화면 진입 | `get_my_taste_profile()` + `profiles` SELECT | 프로필 또는 Empty 렌더링 | Empty 상태 폴백 |
| 2 | "취향 설문 다시 하기" 탭 | `retake_survey()` | `/survey`로 이동 | "실패했습니다" 토스트 |
| 3 | "취향 설문 하기" 탭 (Empty) | 없음 (네비게이션) | `/survey`로 이동 | - |
| 4 | "로그아웃" 탭 | `supabase.auth.signOut()` | `/login`으로 이동 | 재시도 안내 |
| 5 | "회원탈퇴" 탭 | `delete-account` Edge Function | 확인 다이얼로그 → `/login` | "탈퇴에 실패했습니다" 토스트 |
| 6 | 개인정보처리방침 탭 | 없음 (외부 URL) | 웹뷰/브라우저 열기 | - |
| 7 | 서비스 이용약관 탭 | 없음 (외부 URL) | 웹뷰/브라우저 열기 | - |

## 네비게이션 파라미터

### 이 화면으로 진입 시 필요한 파라미터
| 파라미터 | 타입 | 필수 | 출처 화면 | 설명 |
|----------|------|:----:|-----------|------|
| - | - | - | - | 파라미터 없음 (탭바 루트 화면) |

### 이 화면에서 다른 화면으로 전달하는 파라미터
| 대상 화면 | 파라미터 | 타입 | 설명 |
|-----------|----------|------|------|
| 설문 | - | - | `retake_survey()` 결과의 `new_session_id`는 내부적으로 최신 세션 사용 |
| 로그인 | - | - | 파라미터 없음 (로그아웃/탈퇴 후 이동) |

## 참고사항

- **두 가지 상태**: `get_my_taste_profile()` 반환값이 null이면 Empty, 아니면 프로필 표시
- **맛 점수→라벨 변환**: 서버는 0-100 숫자를 반환하며, "좋음/보통/싫음" 변환은 클라이언트 책임
- **aroma 필드**: UI에 직접 표시되지 않지만, 내부 매칭 알고리즘에서 사용됨
- **설문 재실행**: 이전 결과는 보존되며, 새 결과가 최신으로 표시됨
- **회원탈퇴**: `confirm: "DELETE"` 필수 — 실수 방지용 안전장치
- **get_my_dashboard()**: 닉네임 + 원두 찜 수 + 레시피 수 등 집계 정보 필요 시 병행 호출 가능
