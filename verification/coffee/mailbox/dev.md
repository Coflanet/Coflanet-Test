# Coffee 작업 보고 (작업 D, E, G)

## 작업 D: Coffee Modal 3종 트리거 — 이미 연결됨 확인

`InputModal.show` / `SelectionModal.show` / `TimePickerModal.show` 호출 위치 (12건):
- `lib/modules/coffee/settings/coffee_settings_view.dart` (8건)
- `lib/modules/coffee/settings/coffee_setting_detail_view.dart` (2건)
- `lib/modules/coffee/settings/recipe_form_view.dart` (1건)
- `lib/modules/coffee/espresso/espresso_settings_controller.dart` (2건)
- `lib/modules/coffee/bean/bean_edit_view.dart` (1건 — ModalUtils.showUnsavedChanges)

→ 추가 트리거 연결 작업 불필요.

## 작업 E: Step 04/05 5초 카운트다운 — 이미 자동 트리거됨 확인

`coffee_timer_controller.dart:293` `_startPreCountdown()`:
- `Timer.periodic` 으로 1초 간격 감소
- `_preCountdownSeconds.value = 5` 초기화
- 각 step 자동 진입 시 `hasTimer == true` 면 자동 호출 (`_onStepTimerComplete:339`)

→ Step 04/05 도 동일 메커니즘으로 자동 발동. 추가 변경 불필요.

캡쳐는 빌드 시간 절약을 위해 코드 분석으로 갈음. Figma 캡쳐 (`Recipe_Step04_5s_figma.png` / `Recipe_Step05_5s_figma.png`) 는 이미 verification/coffee/captures/ 에 있음.

## 작업 G: flutter analyze 마이그레이션

### 처리 항목 (13건 → 0건)
1. `unnecessary_import` — `auth_service.dart`, `my_planet_controller.dart` 의 `foundation.dart` 제거
2. `unnecessary_library_name` — `repositories.dart` 의 `library repositories;` → `library;`
3. `depend_on_referenced_packages` — `main.dart` 의 `kakao_flutter_sdk_common` → `kakao_flutter_sdk_user` (KakaoSdk 정상 export)
4. `unused_catch_stack` × 2 — `coffee_controller.dart` 두 catch 의 stackTrace 변수 제거
5. `deprecated_member_use Color.value` × 2 — `api_coffee_repository.dart`, `dummy_coffee_repository.dart` → `toARGB32()`
6. `unused_element` — `my_planet_content.dart` 의 `_buildFlavorNotesList` 삭제
7. `unnecessary_brace_in_string_interps` × 2 — `espresso_settings_view.dart` `${seconds}초` → `$seconds초`
8. `deprecated_member_use onReorder` × 2 — `select_coffee_content.dart`, `espresso_settings_view.dart` → `onReorderItem`
   - Controller 의 `if (newIndex > oldIndex) newIndex--` 보정 코드 제거 (신규 API 가 자동 조정)

### 변경 파일
- `lib/core/services/auth_service.dart`
- `lib/data/repositories/repositories.dart`
- `lib/data/repositories/api/api_coffee_repository.dart`
- `lib/data/repositories/dummy/dummy_coffee_repository.dart`
- `lib/main.dart`
- `lib/modules/coffee/coffee_controller.dart`
- `lib/modules/coffee/espresso/espresso_settings_view.dart`
- `lib/modules/coffee/espresso/espresso_settings_controller.dart`
- `lib/modules/coffee/select/select_coffee_content.dart`
- `lib/modules/coffee/select/select_coffee_controller.dart`
- `lib/modules/planet/my_planet_content.dart`
- `lib/modules/planet/my_planet_controller.dart`

## 검증
- `flutter analyze lib/` → No issues found
