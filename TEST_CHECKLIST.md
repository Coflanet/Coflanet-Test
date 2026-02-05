# Test Checklist - Coflanet App

> Run all: `flutter test`
> Run integration: `flutter test integration_test/app_test.dart`

## Existing Tests

### Unit Tests

| File | Status | Notes |
|------|--------|-------|
| `test/unit/survey_controller_test.dart` | PASS | Survey data, questions, progress, option selection, result generation |
| `test/unit/timer_controller_test.dart` | BROKEN | References old `TimerController` class — needs rewrite for `CoffeeTimerController` |

### Widget Tests

| File | Status | Notes |
|------|--------|-------|
| `test/widget/circular_timer_test.dart` | PASS | CircularTimer rendering (0%/50%/100%), custom color, child widget, phase markers, PhaseIndicator |
| `test/widget/primary_button_test.dart` | PASS | Render text, onPressed callback, disabled state, icon display |
| `test/widget_test.dart` | PASS | Basic environment sanity check |

### Integration Tests

| File | Status | Notes |
|------|--------|-------|
| `integration_test/app_test.dart` | PASS | Navigates 22 routes, takes screenshots, handles animation screens |

---

## Tests to Write / Fix

### HIGH PRIORITY — Broken Tests

- [ ] **Rewrite `test/unit/timer_controller_test.dart`** for new `CoffeeTimerController`
  - Test `TimerState` enum transitions (idle → preCountdown → running → paused → completed)
  - Test step navigation: `nextStep()`, `previousStep()`, boundary cases
  - Test 5-second pre-countdown logic
  - Test auto-advance on timer completion
  - Test preparation steps skip timer (manual "다음" only)
  - Test computed properties: `stepProgress`, `totalProgress`, `totalWaterLabel`, `totalTimeLabel`
  - Test `formatTime()` output
  - Test recipe loading from `DummyTimerData`

### MEDIUM PRIORITY — New Unit Tests

- [ ] **`test/unit/survey_result_model_test.dart`** — New model fields
  - `FlavorDescriptionModel` creation and fields
  - `CoffeeRecommendationModel` price/discount fields
  - `SurveyResultModel.flavorDescriptions` list

- [ ] **`test/unit/timer_step_model_test.dart`** — New model fields
  - `TimerStepType` enum values
  - `TimerStepModel.hasTimer` / `isPreparation` computed properties
  - `AromaTagModel` creation
  - `TimerRecipeModel.completionMessage` / `aromaDescription` / `aromaTags`

- [ ] **`test/unit/dummy_timer_data_test.dart`** — Data integrity
  - Hand drip recipe has 6 steps
  - Step types correct (2 prep → 3 brew → 1 wait)
  - Durations sum correctly
  - Aroma tags exist
  - Espresso recipe valid

- [ ] **`test/unit/survey_controller_bean_selection_test.dart`** — Bean selection logic
  - `toggleBeanSelection()` add/remove
  - `isBeanSelected()` query
  - `selectedBeanCount` computed value

### MEDIUM PRIORITY — New Widget Tests

- [ ] **`test/widget/survey_result_view_test.dart`**
  - Renders taste profile grid (4 columns)
  - Renders flavor description list
  - Renders recommended bean cards
  - Bean checkbox toggles on tap (Obx reactivity)
  - Bottom CTA disabled when 0 beans selected
  - Bottom CTA shows count when beans selected

- [ ] **`test/widget/coffee_timer_view_test.dart`**
  - Step dot indicator renders correct count
  - Preparation step shows emoji illustration + action text
  - Timer step shows CircularTimer
  - Pre-countdown overlay displays
  - Bottom controls change per step type

- [ ] **`test/widget/timer_complete_view_test.dart`**
  - Completion message renders
  - Aroma card renders with tags
  - "완료하기" button present and clickable

- [ ] **`test/widget/social_button_test.dart`**
  - Kakao button shows "3초만에 시작하기"
  - Apple button has black background
  - Naver button renders correctly

### LOW PRIORITY — Additional Coverage

- [ ] **`test/widget/secondary_button_test.dart`** — SecondaryButton rendering and interaction
- [ ] **`test/widget/splash_view_test.dart`** — Gradient background, logo, auto-navigation timer
- [ ] **`test/widget/my_planet_view_test.dart`** — Dark theme, profile card, tab bar

---

## Manual Testing Checklist (Pre-release)

### Auth Flow
- [ ] Splash → auto-navigate to Sign In after 2s
- [ ] Kakao/Naver/Apple buttons visible and tappable
- [ ] Guest login navigates to Survey Intro

### Survey Flow
- [ ] Survey Intro → "취향 찾으러 가기" navigates to Step 1
- [ ] Steps 1-6: progress bar advances, back/skip work
- [ ] Single-select questions replace previous selection
- [ ] Multi-select questions toggle correctly
- [ ] Analyzing screen shows loading animation
- [ ] Complete screen shows success state
- [ ] Result screen: taste profile, flavor descriptions, bean cards

### Coffee Timer Flow
- [ ] Hand Drip / Espresso selection from home
- [ ] Timer: preparation steps show emoji + action text
- [ ] Timer: "다음" advances to next step
- [ ] Timer: brew steps auto-start after 5s pre-countdown
- [ ] Timer: play/pause controls work
- [ ] Timer: auto-advance to next step on completion
- [ ] Timer Complete: aroma card + "완료하기" button

### My Planet
- [ ] Dark background with profile card
- [ ] Flavor list renders
- [ ] Tab bar switches content

### General
- [ ] All text uses `AppTextStyles.*`
- [ ] All colors use `AppColor.*`
- [ ] No hardcoded hex values in views
- [ ] Korean text displays correctly
- [ ] `flutter build web --no-tree-shake-icons` succeeds
