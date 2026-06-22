# Task 2 — component_lab 라이브러리 마이그레이션

> 목표: `Coflanet/Coflanet-Test`의 `Library/component_lab`(Coflanet Design System)을 본 앱(`coflanet-app`)으로 가져온다.
> 사전 읽기: `reference/component-lab-inventory.md`, `reference/token-mapping.md`, `reference/current-design-system.md`.

## 1. 핵심 제약 — 순환 의존

component_lab `pubspec.yaml`은 `coflanet` 앱을 path 의존성으로 가진다(`../../coflanet-app-0.1.2`).
→ 앱이 component_lab을 다시 path 의존성으로 추가하면 **순환**. 따라서 path 의존 방식은 **불가**.

## 2. 마이그레이션 전략 — "소스 흡수(Vendoring)"

> 선택: **전략 A (소스 흡수)**. 라이브러리의 foundation/components 소스를 앱 내부로 복사·정리하여 단일 코드베이스로 통합한다.

### 왜 A인가
- 순환 의존 회피(유일하게 깔끔).
- 앱은 이미 동등한 토큰 시스템(`AppColorScheme` 등)을 가짐 → 별도 패키지보다 **병합**이 자연스러움.
- 단일 레포 빌드/배포 단순화. Widgetbook은 선택적으로 별도 유지.

### 대안(비채택)
- B: 별도 pub 패키지로 분리 후 양쪽이 의존 → component_lab의 앱 역의존을 먼저 끊어야 함(대공사). 추후 디자인 시스템을 여러 앱이 공유할 때 재검토.

## 3. 타깃 디렉터리 설계

옵션 1(권장): 기존 구조 확장 — 토큰은 `lib/constants/`에 병합, 컴포넌트는 `lib/widgets/`에 카테고리별 편입.
옵션 2: `lib/design_system/` 신설(foundation/ + components/) 후 `lib/widgets`는 점진 이관.

> **권장: 옵션 1**. 현재 앱의 `lib/constants` + `lib/widgets` 관습을 유지해 디프를 최소화하고, 화면 코드 임팩트를 줄인다. 단, 컴포넌트가 커지면 `lib/widgets/<category>/`로 21개 카테고리를 정리.

## 4. 단계별 실행

### 단계 0 — 준비/분석
- [ ] Coflanet-Test 레포 클론(로컬). `Library/component_lab/`, 루트 `ACTION_PLAN.md`/`AUDIT_REPORT.md`/`CODE_INVENTORY.md`/`MISMATCH_REPORT.md`, `HANDOFF.md` 확보.
- [ ] component_lab `lib/foundation`·`lib/components`·`lib/util` 전체 파일 목록화.
- [ ] `reference/token-mapping.md` 체크리스트로 토큰 디프 산출.

### 단계 1 — Foundation 토큰 흡수 (task 3와 공유)
- [ ] 팔레트 색 대조 → 누락 색 `AppColor`에 추가.
- [ ] **Static 그룹 명시화**(`staticBlack`/`staticWhite`) — task 4 의존.
- [ ] Spacing 34/36/44, Radius 누락 단계 추가.
- [ ] Typography 누락 변형 추가.
- [ ] `AppShadow` 신설 여부 결정(iyumi 확인 후) → 도입 시 `lib/constants/shadow_constant.dart`.
- [ ] **컬러 아키텍처는 앱의 `AppColorScheme` 유지** — component_lab의 static+dark프리픽스를 그대로 들이지 말 것. 값만 흡수.

### 단계 2 — 컴포넌트 마이그레이션 (Figma 검증 우선순위)
검증도 높은 순으로 이관. 각 컴포넌트는 **앱 토큰으로 리바인딩**(component_lab `AppColor.dark*` → 앱 `AppColorScheme.of(context)`).

1. [ ] **Buttons (✅완전검증)** — AppSolidButton, AppOutlinedButton, AppTextButton, AppIconButton, AppFloatingActionButton, AppSectionBottomButton.
   - 기존 `primary_button.dart`/`social_button.dart` 호출부를 신규 버튼으로 교체(사이즈 52/40/32 체계 재정렬).
2. [ ] **Chips** — Action/Filter 변형(deprecated `app_chip.dart` 폐기). `flavor_tag.dart`는 flavor 색 유지하며 chips 기반으로 재구성.
3. [ ] **Cards** — iyumi 카드 스타일 반영(task 4). `product_card`/`recipe_card`를 라이브러리 카드 위에 재구성.
4. [ ] **Forms / Inputs** — 기존 `app_text_field.dart` 교체 + P0 신규(AppSearchInput, AppTextArea).
5. [ ] **Modals** — `components/modals/*` + P0 신규(AppFullModal, AppActionSheet). 기존 모달 7종 매핑.
6. [ ] **Feedback** — `AppEmptyState`(P0), AppSectionMessage(P0).
7. [ ] **나머지** — avatars, dividers, indicators, gauge, controls, selection, tabs, thumbnails, ratio, scrolls, pagination, navigation, contents, control_box, presentation.
   - **도메인 특화(타이머·레이더차트·셸 탭바/탑내비)는 앱에 유지**, 토큰만 정합.

### 단계 3 — P0 누락 위젯 구현 (ACTION_PLAN)
AppSectionMessage, AppEmptyState, AppFullModal, AppActionSheet, AppAutoComplete, AppDatePicker, AppTimePicker, AppSearchInput, AppTextArea, AppProgressTracker (~36h).

### 단계 4 — 버그·정리
- [ ] ACTION_PLAN 크리티컬 버그 12종(색 토큰 불일치, 그림자 불일치, 안전하지 않은 render-object 접근 등) 반영.
- [ ] deprecated 제거: `app_button.dart`, `icon_button_use_cases.dart`, `app_chip.dart`.
- [ ] Component/fill 네이밍 충돌 — 값 변경 없이 주석화(디자이너 합의 전까지).

### 단계 5 — (선택) Widgetbook 유지
- 디자인 시스템 카탈로그를 계속 쓰려면 Widgetbook을 앱 내 `widgetbook/`(별도 entrypoint) 또는 별도 디렉터리로 이식. MVP에선 후순위.

## 5. 검증 게이트 (ACTION_PLAN 준수)

각 컴포넌트 PR마다:
- [ ] `flutter analyze` 0 이슈
- [ ] 관련 테스트 통과
- [ ] **라이트/다크 양쪽** 시각 확인(Static/Black 배경 위 포함 — task 4)
- [ ] No-estimation: 색/간격 값은 Figma/HANDOFF 근거 기록

## 6. 산출물

- 마이그레이션된 토큰(`lib/constants/*`) + 컴포넌트(`lib/widgets/*`).
- 컴포넌트별 교체 로그(어느 화면의 어느 위젯을 무엇으로 교체했는지) → `docs/redesign/apply-log.md`(누적).
- `reference/token-mapping.md` 체크리스트 완료 표시.

## 7. 의존성·순서

- task 3(스타일 적용)·task 4(Static/Black)는 **단계 1(토큰 흡수)** 완료 후 본격화.
- task 1(플로우 수정)은 독립 — 먼저/병행 가능. 단, 리스타일 대상 화면은 task 4 이후 재작업 줄이려면 플로우 안정화를 앞에 두는 편이 좋다.
