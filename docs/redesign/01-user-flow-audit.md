# Task 1 — 전체 유저 플로우 정리·검증·블로커 수정

> 목표: 앱의 전체 내비게이션을 지도화하고, 막히거나 끊기는 지점을 식별해 수정 계획을 제공.
> 출처: `lib/routes/app_routes.dart`, `lib/routes/app_pages.dart`, `lib/modules/**`, `lib/main.dart`.

## 1. 라우트 맵 (30+ named routes)

**초기 라우트**: `Routes.splash = '/'`

| 영역 | 라우트 |
|------|--------|
| Core | `splash '/'` |
| Auth | `signIn '/login/sign-in'`, `emailLogin`, `emailSignUp`, `signUpComplete`, `profileSetup`, `accountLink` |
| Onboarding | `surveyReason`, `surveyIndex`, `surveyIntro`, `surveySectionIntro '/onboarding/survey-section/:section'`, `survey '/onboarding/survey/:step'`, `surveyAnalyzing`, `surveyComplete`, `surveyResult` |
| Matching | `matchingResult '/matching/result'` |
| Profile | `myTaste '/profile/my-taste'`, `myPlanet '/my-planet'` |
| Shell | `mainShell '/main-shell'` (5탭) |
| Feature(modal) | `search`, `notification`, `cart` |
| Coffee | `coffeeMain '/coffee'`, `handDrip`, `espresso`, `espressoSettings`, `coffeeSettings`, `coffeeSettingDetail`, `selectCoffee`, `timerActive`, `timerComplete` |
| Bean | `beanDetail`, `beanEdit` |
| Recipe | `recipeEdit`, `recipeAdd` (둘 다 `RecipeFormView`, `isEditMode` 분기) |

## 2. 메인 셸 (5탭, 글래스 모피즘)

`lib/modules/shell/main_shell_view.dart` · `main_shell_controller.dart`

| idx | 탭 | 콘텐츠 | 비고 |
|---|---|---|---|
| 0 | 홈 | `HomeContent` | 자체 헤더, 풀스크린(상단 라운드 없음) |
| 1 | 원두 | `SelectCoffeeContent` | 편집 모드 토글(목록 편집/완료) |
| 2 | 커뮤니티 | `CommunityContent` | ⚠️ 플레이스홀더 |
| 3 | 쇼핑 | `ShoppingContent` | ⚠️ 플레이스홀더 |
| 4 | 마이 | `MyPlanetContent` | 타이틀=유저명(RxString) |

- 탭바: pill 99px 글래스, 블러 24px, 활성=violet60. **테마 무관 고정 다크** (task 4와 일관).
- 콘텐츠 배경: `backgroundNormalAlternative` (라이트 CN99 / 다크 검정), 상단 라운드 40px(홈 제외).

## 3. 핵심 E2E 여정 (정상 동작 확인됨 ✅)

**A. 스플래시 → 온보딩 → 메인**
```
splash(/) ─ config 로드 ─┬─ 비로그인 → signIn → (소셜/이메일/게스트) → profileSetup|surveyIntro
                         └─ 로그인 ┬ 온보딩 미완 → surveyIntro → surveySectionIntro(:0)
                                  │                → survey(:0..N) → surveyAnalyzing → surveyComplete → surveyResult → mainShell(0)
                                  └ 온보딩 완료 → mainShell(0)
```
**B. 소셜 로그인(신규)**: signIn → AuthService.signIn → (소셜명 有 → 이름 자동저장 → surveyReason|surveyIntro) | (無 → profileSetup → surveyReason → surveyIntro)
**C. 핸드드립 추출**: Home → handDrip → "타이머 시작" → timerActive(type:handDrip) → timerComplete → mainShell(0)
**D. 원두 탭**: mainShell(1) → beanDetail → coffeeSettings/coffeeSettingDetail / 편집모드 토글(탭바 숨김+뒤로가기)
**E. 마이 탭**: mainShell(4) → accountLink | surveyIntro(재설문) | signIn(로그아웃)

## 4. 🚧 블로커·끊김·미완 (수정 대상)

> 우선순위: **P0 = 사용자 막힘/크래시 위험, P1 = 죽은 화면/일관성, P2 = 미완 기능**

### P0 — 막힘/위험
1. **`Routes.coffeeMain` 라우트 미등록**
   - `Routes.coffeeMain '/coffee'`는 정의됐으나 `app_pages.dart` `GetPage` 목록에 없음. `CoffeeMainView`는 프로그램적으로만 접근 → `Get.toNamed(Routes.coffeeMain)` 호출 시 **라우트 없음 에러**.
   - **수정**: `app_pages.dart`에 `GetPage(name: coffeeMain, page: CoffeeMainView, binding: CoffeeBinding)` 추가하거나, 모든 진입을 직접 위젯/명시 라우트로 통일. 진입점 일관화.
2. **복합 객체 인자 직렬화 위험** (`beanDetail` 등)
   - `Get.toNamed(beanDetail, arguments: beanObject)` 패턴. 딥링크/복원 시 객체 유실 가능.
   - **수정**: ID 기반 인자(`{'beanId': ...}`) + 컨트롤러에서 조회로 전환 검토.

### P1 — 죽은 화면/일관성
3. **`ExtractionListView`, `TastingNotesView` 진입점 없음**
   - 라우트/화면은 있으나 어떤 플로우에서도 호출되지 않음.
   - **수정**: (a) 마이/홈에 진입점 추가해 활성화, 또는 (b) 정식 미사용이면 라우트·화면 제거하고 백로그로 이동. **결정 필요**.
4. **`MyTasteView`가 셸에서 접근 불가**
   - `'/profile/my-taste'`는 `surveyResult` 하단 링크에서만 진입. 메인 셸에 상시 진입점 없음.
   - **수정**: 마이 탭(`MyPlanetContent`)에 "내 취향" 항목 추가.
5. **`SurveyReasonView` 트리거 조건 협소**
   - 소셜 로그인이 이름을 제공하고 signup_reasons 없을 때만 진입. 일반 플로우는 건너뜀 → 과소 테스트.
   - **수정**: 의도된 분기인지 확인. 항상 거치게 할지/스킵 유지할지 결정 후 주석화.
6. **`AccountLink` 이후 온보딩 체크 불명확**
   - 기존 계정 연동 후 온보딩 완료 검사가 도는지/바로 셸로 가는지 코드상 모호.
   - **수정**: 연동 성공 콜백에서 `SurveyService` 온보딩 상태 재조회 → 분기 명시.

### P2 — 미완 기능(플레이스홀더)
7. **커뮤니티·쇼핑 탭** 콘텐츠 플레이스홀더 → MVP 범위 결정(빈 상태 UI `AppEmptyState`로 정식화할지, 탭 자체를 숨길지).
8. **검색/알림/장바구니** 모달 라우트는 있으나 실연동 최소.
9. **레시피 add/edit** 단일 뷰 `isEditMode` 분기 — 라우트 분리 불필요하나 진입 인자 검증 필요.
10. **셸 탭 상태 비영속** — 앱 재시작 시 항상 초기 탭. 의도면 유지, 아니면 마지막 탭 복원 추가.

## 5. 수정 실행 순서(권장)

1. P0 두 건 먼저(라우트 등록·인자 안정화) — 크래시/막힘 제거.
2. P1 죽은 화면 결정(3,4) → 진입점 추가 또는 제거.
3. P1 분기 명확화(5,6) — 주석 + 가드 추가.
4. P2는 task 4/3 리스타일링과 함께 진행(빈 상태는 `AppEmptyState`로).

## 6. 검증 방법

- 기존 통합 테스트 활용: `integration_test/app_test.dart`(20개 화면 E2E), `integration_test/recipe_save_test.dart`.
- 수정 후 `flutter analyze` 0 이슈 + 위 두 테스트 통과.
- 수동: §3의 A~E 여정을 라이트/다크 양쪽에서 1회씩.
- **권장 산출물**: 각 블로커별 "before/after 내비게이션" 캡처를 `verification/`에 첨부.

## 7. 미결 질문 (로컬 세션/기획 확인 필요)

- [ ] ExtractionList/TastingNotes: 활성화 vs 제거?
- [ ] 커뮤니티·쇼핑 탭: MVP에 포함? (빈 상태 vs 탭 숨김)
- [ ] SurveyReason: 항상 노출 vs 조건부 유지?
- [ ] 셸 탭 상태 영속화 필요 여부?
