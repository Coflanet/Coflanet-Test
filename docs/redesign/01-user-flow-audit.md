# Task 1 — 전체 유저 플로우 정리·검증·블로커 수정

> 목표: 앱의 전체 내비게이션을 지도화하고, 막히거나 끊기는 지점을 식별해 수정 계획을 제공.
> 출처: `lib/routes/app_routes.dart`, `lib/routes/app_pages.dart`, `lib/modules/**`, `lib/main.dart`.
>
> 🔎 **탭/버튼/데이터 레벨의 실제 깨진 인터랙션**(탭 무반응, 안 먹는 버튼, 빈 데이터 영역)은 별도 전수 감사 → **`01a-flow-defects.md`**. "새 데이터 만들기 전에 고칠 목록"은 그쪽을 본다.

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

### P1 — 죽은 화면/일관성 → ✅ "커피 저널" 루프로 통합
3. **`ExtractionListView` + `TastingNotesView` → 하나의 "커피 저널" 기능으로 활성화**.
   - **`ExtractionListView` = 완성된 "추출 기록"** (brewLog 통계+무한스크롤+삭제, `BrewLogRepository` 실연결). 진입점만 없음.
     → ✅ **결정: 활성화**. `app_pages.dart` 라우트 추가 + 마이 탭에 "추출 기록" 진입점.
   - **`TastingNotesView` = 빈 스텁이지만 UI 부품은 이미 존재** (`FlavorRadarChart`·`FlavorTag`·`AppAnimatedTasteBar`).
     → ✅ **결정: 활성화(커피 저널로 편입)**. 위치:
       1. **추출 직후** `TimerCompleteView`에 "시음 노트 남기기" CTA → `TastingNotesView(brewLogId)` (맛이 생생할 때 1차 진입).
       2. **추출 기록 상세**: ExtractionList 항목 → 상세 → 시음 노트 보기/수정 (소급 진입).
       3. 독립 탭/메뉴는 두지 않음 — 노트는 항상 특정 brew에 귀속.
   - **구현 범위 주의**: ExtractionList는 이미 완성 → 라우트+진입점만. TastingNotes는 **신규 구현 필요**: `TastingNoteModel`(맛 점수·태그·메모·평점) + 저장(브루로그에 부착 또는 별도 repo) + 폼 UI(기존 flavor 위젯 재사용). brewLog ↔ 노트 1:1 매핑.
   - 산출물: "원두선택→설정→타이머→완료→**시음 노트**→추출 기록" 으로 닫히는 저널 루프.
4. **`MyTasteView`가 셸에서 접근 불가**
   - `'/profile/my-taste'`는 `surveyResult` 하단 링크에서만 진입. 메인 셸에 상시 진입점 없음.
   - **수정**: 마이 탭(`MyPlanetContent`)에 "내 취향" 항목 추가.
5. **`SurveyReasonView`(가입 이유 설문) — ✅ 결정: 항상 노출**
   - 현재: 소셜 로그인이 이름 제공 + signup_reasons 없을 때만 진입(일부 경로 스킵).
   - **수정**: 모든 가입 경로(소셜/이메일/게스트)가 가입 완료 전 **한 번은 `surveyReason`을 거치도록 통일**. 진입 분기를 `signIn`/`profileSetup` 이후 공통 단계로 승격. 이미 제출한 사용자는 재노출 안 되게 가드(중복 저장 방지).
6. **`AccountLink` 이후 온보딩 체크 불명확**
   - 기존 계정 연동 후 온보딩 완료 검사가 도는지/바로 셸로 가는지 코드상 모호.
   - **수정**: 연동 성공 콜백에서 `SurveyService` 온보딩 상태 재조회 → 분기 명시.

### P2 — 미완 기능(플레이스홀더)
7. **탭 정리 — ✅ 결정 변경 + 구현 완료**
   - **쇼핑 탭: 유지/오픈**(사용자 취향 추천 페이지) — 이전 "숨김" 결정 **철회**.
   - **커뮤니티 탭: 숨김** → 5탭 → **4탭(홈/원두/쇼핑/마이)**.
   - **장바구니/결제: 숨김**(MVP 밖) — 홈 탑바 장바구니 아이콘 비노출.
   - 구현(완료, commit `a45605a`): `shell_tab_bar.dart`에서 커뮤니티(index 2)만 탭바에서 제외(인덱스·컨트롤러·콘텐츠 스위치는 보존). 홈 커뮤니티 섹션 제거. `home_top_bar.dart` 장바구니 아이콘 제거. `CommunityContent`/`ShoppingContent`/cart 코드는 보존.
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

## 7. 의사결정 현황 (모두 확정 ✅)

- ✅ **커뮤니티·쇼핑 탭: 숨김** — 5탭→3탭(홈/원두/마이) (§4-7).
- ✅ **ExtractionList: 활성화** + **TastingNotes: 활성화(커피 저널 편입)** — 추출완료/추출기록에 시음 노트 부착 (§4-3).
- ✅ **SurveyReason: 항상 노출** — 모든 가입 경로 공통 단계로 승격 (§4-5).
- [ ] 셸 탭 상태 영속화 필요 여부? (선택 — 미정이어도 진행 무방)

> task 1 정책 확정 완료. 로컬 세션은 위 결정대로 구현하면 된다.
