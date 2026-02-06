# Coflanet App Refactoring Plan

> Generated: 2024-02-06
> Total Issues Found: 67
> Priority Tasks: 15

---

## Executive Summary

| Category | Issues | Critical | High | Medium | Low |
|----------|--------|----------|------|--------|-----|
| Performance | 12 | 2 | 4 | 4 | 2 |
| Code Quality | 18 | 0 | 6 | 8 | 4 |
| Modularization | 14 | 1 | 5 | 6 | 2 |
| Directory Structure | 23 | 0 | 2 | 5 | 16 |

---

## Phase 1: Critical & High Priority (1-2 weeks)

### 1.1 Performance - Image Caching (CRITICAL)

**Files to fix:**
```
lib/widgets/cards/app_card.dart:269
lib/widgets/containers/app_aspect_ratio.dart:255-265
```

**Issue:** `Image.network` without caching causes repeated network requests

**Fix:**
```dart
// Before
Image.network(imageUrl!, ...)

// After
CachedNetworkImage(
  imageUrl: imageUrl!,
  placeholder: (context, url) => Shimmer(...),
  errorWidget: (context, url, error) => Icon(Icons.error),
)
```

---

### 1.2 Architecture - EspressoSettingsView Pattern Break (CRITICAL)

**File:** `lib/modules/coffee/espresso/espresso_settings_view.dart`

**Issue:** Uses `StatefulWidget` instead of GetX pattern, breaking MVVM consistency

**Fix:** Convert to `GetView<EspressoSettingsController>` with proper binding

---

### 1.3 Performance - Missing ListView Keys (HIGH)

**Files:**
```
lib/modules/matching/matching_result_view.dart:436
lib/modules/planet/my_planet_view.dart:200
```

**Fix:** Add `key: ValueKey(item.id)` to all list item builders

---

### 1.4 Code Duplication - Recipe Card Widget (HIGH)

**Duplicated in:**
- `lib/modules/coffee/hand_drip/hand_drip_view.dart` (lines 98-173)
- `lib/modules/coffee/espresso/espresso_view.dart` (lines 123-161)

**Action:** Extract to `lib/widgets/cards/recipe_card.dart`

---

### 1.5 Code Duplication - Survey Result Loading (HIGH)

**Duplicated in:**
- `lib/modules/matching/matching_controller.dart`
- `lib/modules/profile/my_taste_controller.dart`
- `lib/modules/planet/my_planet_controller.dart`

**Action:** Create `lib/core/services/survey_service.dart`

---

### 1.6 Missing Constants (HIGH)

**Create:** `lib/constants/duration_constant.dart`
```dart
class AppDuration {
  static const fast = Duration(milliseconds: 200);
  static const normal = Duration(milliseconds: 300);
  static const slow = Duration(milliseconds: 500);
  static const animation = Duration(milliseconds: 800);
}
```

**Create:** Social colors in `lib/constants/color_constant.dart`
```dart
static const socialKakao = Color(0xFFFEE500);
static const socialNaver = Color(0xFF03C75A);
static const socialApple = Color(0xFF000000);
```

---

## Phase 2: Medium Priority (2-3 weeks)

### 2.1 Large File Decomposition

| File | Lines | Action |
|------|-------|--------|
| `coffee_timer_view.dart` | 643 | Split into TimerDisplay, TimerControls, TimerStepList widgets |
| `survey_result_view.dart` | 619 | Extract ResultHeader, BeanRecommendationList, TasteProfileChart |
| `matching_result_view.dart` | 565 | Extract MatchingHeader, RecommendationCards |
| `coffee_settings_view.dart` | 553 | Extract RecipeParameterCard widget |
| `my_taste_view.dart` | 515 | Extract TasteSummaryCard, TasteChartWidget |
| `select_coffee_view.dart` | 496 | Extract CoffeeCard widget (already partially done) |
| `espresso_settings_view.dart` | 474 | Extract StepCard widget |
| `my_planet_view.dart` | 467 | Extract TasteCards, FlavorList widgets |

### 2.2 Reusable Widget Extraction

**Pattern 1: Circular Taste Indicator** (appears 3+ times)
- `survey_result_view.dart` lines 180-206
- `matching_result_view.dart` lines 352-391
- `my_taste_view.dart` lines 347-401

**Create:** `lib/widgets/gauge/app_circular_taste_indicator.dart`

**Pattern 2: Animated Taste Bar** (appears 2+ times)
- `matching_result_view.dart`
- `my_taste_view.dart`

**Create:** `lib/widgets/gauge/app_animated_taste_bar.dart`

**Pattern 3: Round Checkbox** (appears 3+ times)
- `survey_result_view.dart`
- `select_coffee_view.dart`
- `onboarding/widgets/survey_checkbox_item.dart`

**Create:** `lib/widgets/forms/app_round_checkbox.dart`

### 2.3 Inline Models Extraction

**From:** `lib/modules/planet/my_planet_controller.dart`

**To:** `lib/data/models/taste_preference_model.dart`
```dart
// Move these classes:
class TastePreference { ... }
enum TasteGradientType { ... }
class FlavorDescription { ... }
class SavedRecipe { ... }
```

### 2.4 Performance - Obx Optimization

**File:** `lib/modules/onboarding/question/survey_question_view.dart:26`

**Issue:** `Obx()` wrapping entire content

**Fix:** Wrap only reactive parts with granular Obx widgets

### 2.5 Performance - Build Method Computation

**File:** `lib/modules/profile/my_taste_view.dart:271-277`

**Issue:** List created on every build

**Fix:** Move `tasteData` list to controller as computed property

---

## Phase 3: Low Priority / Cleanup (3-4 weeks)

### 3.1 Misplaced Files

| Current | Move To |
|---------|---------|
| `lib/constants/util_constant.dart` | `lib/core/utils/app_util.dart` |
| `lib/constants/image_utils.dart` | `lib/core/utils/image_utils.dart` |

### 3.2 Orphaned Widgets Audit (27 files)

**Decision needed for each:**
- **DELETE** if truly unused
- **DEPRECATE** move to `widgets/_deprecated/`
- **INTEGRATE** use in existing views

**Orphaned widgets list:**
```
widgets/navigation/: app_pagination, app_tab_bar, app_app_bar, app_bottom_nav
widgets/indicators/: app_status_indicator, app_dot_indicator, app_step_indicator, 
                     app_circular_progress, app_linear_progress
widgets/forms/:      app_text_field, app_radio, app_dropdown, app_toggle, app_checkbox
widgets/feedback/:   app_tooltip, app_snackbar, app_bottom_sheet
widgets/buttons/:    text_button, tonal_button, secondary_button
widgets/other/:      app_avatar, app_badge, app_chip, app_card, app_aspect_ratio,
                     app_preference_gauge, app_scroll_indicator, app_theme_toggle
```

### 3.3 Naming Standardization

| Current | Change To |
|---------|-----------|
| `PrimaryButton` | `AppPrimaryButton` |
| `SecondaryButton` | `AppSecondaryButton` |
| `TonalButton` | `AppTonalButton` |
| `SocialButton` | `AppSocialButton` |
| `text_button.dart` | `app_text_button.dart` (conflicts with Flutter) |

### 3.4 Dead Code Removal

| File | Lines | Description |
|------|-------|-------------|
| `social_button.dart` | 113-129 | `_KakaoIcon`, `_NaverIcon` classes unused |
| `color_constant.dart` | 500-529 | Legacy shadow definitions |

### 3.5 TODO Items Resolution

| File | Line | TODO | Priority |
|------|------|------|----------|
| `signin_controller.dart` | 17 | Implement actual social login | HIGH |
| `signup_controller.dart` | 112 | Implement actual signup API | HIGH |
| `my_planet_controller.dart` | 166 | Implement account withdrawal | MEDIUM |
| `select_coffee_controller.dart` | 90 | Implement share functionality | MEDIUM |
| `color_constant.dart` | 407 | Complete AppGradients | LOW |
| `survey_complete_view.dart` | 35 | Navigate to settings | LOW |
| `image_utils.dart` | 4 | Add image_picker package | LOW |

### 3.6 Style Constant Split

**Current:** `lib/constants/style_constant.dart` (760 lines)

**Split into:**
- `lib/constants/text_styles.dart` (AppTextStyles)
- `lib/constants/shadows.dart` (AppShadows)

---

## Recommended Directory Structure After Refactoring

```
lib/
├── constants/                    # Static values only
│   ├── asset_constant.dart
│   ├── color_constant.dart
│   ├── duration_constant.dart    # NEW
│   ├── radius_constant.dart
│   ├── shadows.dart              # Extracted from style_constant
│   ├── spacing_constant.dart
│   └── text_styles.dart          # Extracted from style_constant
│
├── core/
│   ├── base/
│   │   └── base_controller.dart
│   ├── network/
│   │   └── api_client.dart
│   ├── services/                 # NEW
│   │   └── survey_service.dart
│   ├── storage/
│   │   └── local_storage.dart
│   ├── theme/
│   │   └── theme_controller.dart
│   └── utils/                    # NEW
│       ├── app_util.dart
│       ├── image_utils.dart
│       └── time_utils.dart
│
├── data/
│   ├── dummy/
│   │   ├── dummy_coffee_data.dart
│   │   ├── dummy_survey_data.dart
│   │   └── dummy_timer_data.dart
│   └── models/
│       ├── coffee_item_model.dart
│       ├── extraction_step_model.dart
│       ├── survey_question_model.dart
│       ├── survey_result_model.dart
│       ├── taste_preference_model.dart  # NEW (from my_planet_controller)
│       └── timer_step_model.dart
│
├── modules/                      # Feature modules (unchanged structure)
│   ├── auth/
│   ├── coffee/
│   │   ├── espresso/
│   │   │   ├── espresso_binding.dart       # NEW
│   │   │   ├── espresso_controller.dart    # NEW
│   │   │   ├── espresso_settings_view.dart # REFACTORED
│   │   │   └── espresso_view.dart
│   │   ├── hand_drip/
│   │   ├── main/
│   │   ├── select/
│   │   ├── settings/
│   │   └── timer/
│   │       ├── widgets/                    # NEW - extracted widgets
│   │       │   ├── timer_controls.dart
│   │       │   ├── timer_display.dart
│   │       │   └── timer_step_list.dart
│   │       ├── coffee_timer_binding.dart
│   │       ├── coffee_timer_controller.dart
│   │       ├── coffee_timer_view.dart
│   │       └── timer_complete_view.dart
│   ├── home/
│   ├── matching/
│   ├── onboarding/
│   ├── planet/
│   ├── profile/
│   └── splash/
│
├── routes/
│   └── app_pages.dart
│
└── widgets/
    ├── buttons/
    ├── cards/
    │   └── recipe_card.dart              # NEW - extracted
    ├── feedback/
    ├── forms/
    │   └── app_round_checkbox.dart       # NEW - extracted
    ├── gauge/
    │   ├── app_animated_taste_bar.dart   # NEW - extracted
    │   └── app_circular_taste_indicator.dart # NEW - extracted
    ├── modals/
    ├── navigation/
    ├── timer/
    └── _deprecated/                      # Orphaned widgets
```

---

## Verification Checklist

After each phase, run:
```bash
# Static analysis
flutter analyze

# Build test
flutter build apk --debug
flutter build ios --debug --no-codesign

# E2E tests
flutter test integration_test/app_test.dart -d <device>
flutter test integration_test/comprehensive_test.dart -d <device>
```

---

## Estimated Effort

| Phase | Duration | Effort |
|-------|----------|--------|
| Phase 1 | 1-2 weeks | 20-30 hours |
| Phase 2 | 2-3 weeks | 40-50 hours |
| Phase 3 | 3-4 weeks | 30-40 hours |
| **Total** | **6-9 weeks** | **90-120 hours** |

---

## Quick Wins (Can be done immediately)

1. Add `ValueKey` to ListViews (5 min each)
2. Add `const` to static widgets (automated with lint)
3. Create `AppDuration` constants (15 min)
4. Add social colors to `AppColor` (5 min)
5. Move util files to core/utils (10 min)
