# Auth 작업 보고 (작업 F)

## 06_complete (signup_complete_view) 활용 결정

### 이전 상태 (데드 코드)
- `signup_controller._submitSignUp` 가 `Get.offNamed(Routes.profileSetup)` 직접 호출
- `SignUpCompleteView` 코드는 라우트에 등록되어 있으나 진입 경로 없음

### 결정
사용자 명시 결정: signup → signup_complete → profileSetup 흐름으로 활용.
사유: Figma 완료 페이지가 존재하므로 UX 정합성을 위해 살리는 게 옳다.

### 변경
- `signup_controller.dart:188` — `Get.offNamed(Routes.profileSetup)` → `Get.offNamed(Routes.signUpComplete)`
- `signup_complete_view.dart:_buildCTAButton` — `Get.offAllNamed(Routes.surveyIntro)` → `Get.offAllNamed(Routes.profileSetup)`

### 흐름
1. `회원가입 폼` (signup_view) → 폼 제출
2. `signup_controller._submitSignUp` → Supabase signUp 성공 → `Routes.signUpComplete` 이동
3. `signup_complete_view` 표시 (축하 이미지 + 환영 텍스트)
4. "시작하기" 버튼 클릭 → `Routes.profileSetup` 이동
5. 프로필 설정 후 → 설문 흐름 진입 (기존 동일)

## 검증
- `flutter analyze lib/` → No issues found
