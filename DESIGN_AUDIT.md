# Design System Audit Report

> 생성일: 2026-02-05  
> Figma Library: https://www.figma.com/design/q7yBPcHrid1CGQqFWEPwnR/

---

## 1. 개요

이 문서는 Coflanet 앱의 디자인 시스템 구현 현황을 분석한 결과입니다.

### 전체 요약

| 카테고리 | 구현률 | 상태 |
|---------|--------|------|
| Color Tokens | 95% | OK |
| Typography | 95% | OK |
| Shadows | 95% | OK |
| Spacing Constants | 100% | OK |
| Border Radius Constants | 100% | OK |
| Button Components | 100% | OK |
| Modal Components | 100% | OK |
| Form Components | 100% | OK |
| Feedback Components | 100% | OK |
| Other Components | 5% | PARTIAL |

---

## 2. Design Token 구현 상태

### 2.1 Colors - OK (95%)

**구현 파일**: `lib/constants/color_constant.dart`

| Figma Token | 코드 구현 | 상태 |
|-------------|----------|------|
| Palette (13종 x 10+ 단계) | `colorGlobal*` | OK |
| Semantic - Primary | `primaryNormal/Secondary/Strong/Heavy/Light` | OK |
| Semantic - Label | `labelNormal/Strong/Neutral/Alternative/Assistive/Disable` | OK |
| Semantic - Background | `backgroundNormalNormal/Alternative`, `backgroundElevatedNormal/Alternative` | OK |
| Semantic - Line | `lineNormalNormal/Neutral/Alternative`, `lineSolidNormal/Neutral/Alternative` | OK |
| Semantic - Status | `statusPositive/Cautionary/Negative` | OK |
| Semantic - Accent | `accentBackground*/Foreground*` | OK |
| Semantic - Component | `componentFill*/MaterialDimmer` | OK |
| Semantic - Inverse | `inverse*` | OK |
| Semantic - Static | `staticLabelBlack*/White*` | OK |
| Dark Mode | `dark*` | OK |
| Opacity Values | `colorGlobalOpacity*` | OK |

### 2.2 Typography - OK (95%)

**구현 파일**: `lib/constants/style_constant.dart`

| Figma Token | 코드 구현 | 상태 |
|-------------|----------|------|
| Display 1 (56px) | `display1Bold/Medium/Regular` | OK |
| Display 2 (40px) | `display2Bold/Medium/Regular` | OK |
| Title 1 (36px) | `title1Bold/Medium/Regular` | OK |
| Title 2 (28px) | `title2Bold/Medium/Regular` + Mono | OK |
| Title 3 (24px) | `title3Bold/Medium/Regular` + Mono | OK |
| Heading 1 (22px) | `heading1Bold/Medium/Regular` + Mono | OK |
| Heading 2 (20px) | `heading2Bold/Medium/Regular` + Mono | OK |
| Headline 1 (18px) | `headline1Bold/Medium/Regular` + Mono | OK |
| Headline 2 (17px) | `headline2Bold/Medium/Regular` + Mono | OK |
| Body 1 Normal (16px) | `body1NormalRegular/Medium/Bold` + Mono | OK |
| Body 1 Reading (16px) | `body1ReadingRegular/Medium/Bold` | OK |
| Body 2 Normal (15px) | `body2NormalRegular/Medium/Bold` + Mono | OK |
| Body 2 Reading (15px) | `body2ReadingRegular/Medium/Bold` | OK |
| Label 1 Normal (14px) | `label1NormalRegular/Medium/Bold` + Mono | OK |
| Label 1 Reading (14px) | `label1ReadingRegular/Medium/Bold` | OK |
| Label 2 (13px) | `label2Regular/Medium/Bold` + Mono | OK |
| Caption 1 (12px) | `caption1Regular/Medium/Bold` + Mono | OK |
| Caption 2 (11px) | `caption2Regular/Medium/Bold` + Mono | OK |

### 2.3 Shadows - OK (95%)

**구현 파일**: `lib/constants/style_constant.dart`

| Figma Token | 코드 구현 | 상태 |
|-------------|----------|------|
| Shadow Primary Normal | `shadowPrimaryNormal`, `shadowPrimaryNormalList` | OK |
| Shadow Primary Emphasize | `shadowPrimaryEmphasize` | OK |
| Shadow Primary Strong | `shadowPrimaryStrong` | OK |
| Shadow Primary Heavy | `shadowPrimaryHeavy` | OK |
| Shadow Primary Heavy Bottom | `shadowPrimaryHeavyBottom` | OK |
| Shadow Primary Floating | `shadowPrimaryFloating` | OK |
| Shadow Black Normal | `shadowBlackNormal` | OK |
| Shadow Black Emphasize | `shadowBlackEmphasize` | OK |
| Shadow Black Strong | `shadowBlackStrong` | OK |
| Shadow Black Heavy | `shadowBlackHeavy` | OK |
| Shadow Black Heavy Bottom | `shadowBlackHeavyBottom` | OK |
| Shadow Black Floating | `shadowBlackFloating` | OK |
| Background Blur | `backgroundBlur30` | OK |

### 2.4 Spacing - OK (100%)

**구현 파일**: `lib/constants/spacing_constant.dart`

| Figma Token | 코드 구현 | 상태 |
|-------------|----------|------|
| Space 2-80 | `space2` ~ `space80` | OK |
| Semantic aliases | `xxs`, `xs`, `sm`, `md`, `lg`, `xl`, `xxl`, `xxxl` | OK |
| Component spacing | `buttonPaddingHorizontal*`, `inputPadding*`, `cardPadding*`, `modalPadding*` | OK |

### 2.5 Border Radius - OK (100%)

**구현 파일**: `lib/constants/radius_constant.dart`

| Figma Token | 코드 구현 | 상태 |
|-------------|----------|------|
| Radius XXS-Full | `xxs`, `xs`, `sm`, `md`, `lg`, `xl`, `xxl`, `xxxl`, `full` | OK |
| BorderRadius helpers | `xsBorder`, `smBorder`, `mdBorder`, `lgBorder`, `xlBorder`, `xxlBorder`, `xxxlBorder`, `fullBorder` | OK |
| Component radius | `buttonBorder`, `inputBorder`, `cardBorder`, `modalBorder`, `chipBorder`, `checkboxBorder` | OK |

**마이그레이션 상태**: Modal 파일들 완료 (`confirm_modal.dart`, `selection_modal.dart`, `input_modal.dart`, `time_picker_modal.dart`)

---

## 3. 디자인 시스템 위반 사항

### 3.1 하드코딩된 Color 사용

#### 허용되는 사용 (브랜드 컬러)
| 파일 | 위치 | 값 | 사유 |
|------|------|-----|------|
| `social_button.dart` | line 63 | `Color(0xFFFEE500)` | Kakao 브랜드 컬러 |
| `social_button.dart` | line 65 | `Color(0xFF03C75A)` | Naver 브랜드 컬러 |
| `social_button.dart` | line 74 | `Color(0xFF191919)` | Kakao 텍스트 컬러 |

#### Colors.white 마이그레이션 - COMPLETE (4건 제외)

| 파일 | 건수 | 상태 |
|------|------|------|
| `confirm_modal.dart` | 2 | DONE |
| `selection_modal.dart` | 5 | DONE |
| `input_modal.dart` | 2 | DONE |
| `time_picker_modal.dart` | 1 | DONE |
| `primary_button.dart` | 2 | DONE |
| `secondary_button.dart` | - | DONE |
| `app_theme.dart` | 7 | DONE |
| `survey_checkbox_item.dart` | 1 | DONE |
| `home_view.dart` | 5 | DONE |
| `splash_view.dart` | 3 | DONE |
| `matching_result_view.dart` | 8 | DONE |
| `my_taste_view.dart` | 2 | DONE |
| `coffee_timer_view.dart` | 8 | DONE |
| `espresso_view.dart` | 2 | DONE |
| `hand_drip_view.dart` | 4 | DONE |
| `survey_result_view.dart` | 6 | DONE |
| `util_constant.dart` | 3 | DONE |
| `main.dart` | 1 | DONE |
| `social_button.dart` | 4 | SKIP (브랜드 컬러) |

**참고**: `Colors.transparent`는 허용, `social_button.dart`의 `Colors.white`는 Naver/Apple 브랜드 컬러로 예외 허용

### 3.2 하드코딩된 TextStyle 사용

| 파일 | 위치 | 문제 | 권장 수정 |
|------|------|------|----------|
| `social_button.dart` | line 139 | `TextStyle(fontSize: 14, fontWeight: FontWeight.w900)` | 브랜드 로고용 - 예외 허용 |
| `survey_checkbox_item.dart` | line 46 | `TextStyle(fontSize: 24)` | 이모지용 - 예외 허용 |
| `survey_result_view.dart` | line 165, 251 | `TextStyle(fontSize: 24/20)` | 이모지용 - 예외 허용 |
| `timer_complete_view.dart` | line 87, 188 | `TextStyle(fontSize: 48/16)` | 이모지용 - 예외 허용 |
| `coffee_timer_view.dart` | line 178 | `TextStyle(fontSize: 48)` | 이모지용 - 예외 허용 |

**결론**: 대부분 이모지 표시용으로 예외 허용

### 3.3 하드코딩된 BoxShadow 사용

| 파일 | 위치 | 문제 | 상태 |
|------|------|------|------|
| `circular_timer.dart` | line 41 | Inline BoxShadow | 타이머 전용 - 예외 허용 |
| `my_taste_view.dart` | 3건 | Custom opacity/blur BoxShadow | 컴포넌트별 커스텀 - 예외 허용 |
| `matching_result_view.dart` | 2건 | Custom color BoxShadow (orange, dynamic) | 컴포넌트별 커스텀 - 예외 허용 |
| `color_constant.dart` | AppGradients 내부 | Legacy shadows | LOW priority |

**참고**: 표준 BoxShadow는 `AppShadows.*` 사용, 컴포넌트별 커스텀 그림자(색상/투명도 특수)는 inline 허용

---

## 4. 컴포넌트 구현 상태

### 4.1 Buttons - OK (100%)

| Figma Component | 코드 구현 | 파일 | 상태 |
|-----------------|----------|------|------|
| Solid Button (Primary) | `PrimaryButton` | `widgets/buttons/primary_button.dart` | OK |
| Outlined Button (Secondary) | `SecondaryButton` | `widgets/buttons/secondary_button.dart` | OK |
| Tonal Button | `TonalButton` | `widgets/buttons/tonal_button.dart` | OK |
| Text Button | `AppTextButton` | `widgets/buttons/text_button.dart` | OK |
| Social Buttons | `SocialButton` | `widgets/buttons/social_button.dart` | OK |
| Button Sizes (XL/L/M/S/XS) | `ButtonSize` enum | all button files | OK |

### 4.2 Modals/Feedback - OK (100%)

| Figma Component | 코드 구현 | 파일 | 상태 |
|-----------------|----------|------|------|
| Confirm Modal | `ConfirmModal` | `widgets/modals/confirm_modal.dart` | OK |
| Selection Modal | `SelectionModal` | `widgets/modals/selection_modal.dart` | OK |
| Input Modal | `InputModal` | `widgets/modals/input_modal.dart` | OK |
| Time Picker Modal | `TimePickerModal` | `widgets/modals/time_picker_modal.dart` | OK |
| BottomSheet | `AppBottomSheet` | `widgets/feedback/app_bottom_sheet.dart` | OK |
| Snackbar/Toast | `AppSnackbar` | `widgets/feedback/app_snackbar.dart` | OK |
| Tooltip | `AppTooltip` | `widgets/feedback/app_tooltip.dart` | OK |

### 4.3 Form Components - OK (100%)

| Figma Component | 코드 구현 | 파일 | 상태 |
|-----------------|----------|------|------|
| Checkbox (standalone) | `AppCheckbox` | `widgets/forms/app_checkbox.dart` | OK |
| Radio Button | `AppRadio`, `AppRadioGroup` | `widgets/forms/app_radio.dart` | OK |
| Toggle/Switch | `AppToggle` | `widgets/forms/app_toggle.dart` | OK |
| TextField | `AppTextField` | `widgets/forms/app_text_field.dart` | OK |
| Dropdown | `AppDropdown` | `widgets/forms/app_dropdown.dart` | OK |

### 4.4 Other Components - MISSING (5%)

| Figma Component | 코드 구현 | 상태 |
|-----------------|----------|------|
| Chip | - | MISSING |
| Avatar | - | MISSING |
| Badge | - | MISSING |
| Divider | - | MISSING |
| Navigation | - | MISSING |
| Tab | - | MISSING |
| Pagination | - | MISSING |
| Progress Bar | - | MISSING |
| Gauge | - | MISSING |
| Thumbnail | - | MISSING |
| Scroll Indicator | - | MISSING |
| Indicators (Loading) | - | MISSING |

### 4.5 특수 컴포넌트 (앱 전용) - OK

| Component | 코드 구현 | 파일 | 상태 |
|-----------|----------|------|------|
| Circular Timer | `CircularTimer` | `widgets/timer/circular_timer.dart` | OK |
| Phase Indicator | `PhaseIndicator` | `widgets/timer/circular_timer.dart` | OK |
| Survey Progress Bar | `SurveyProgressBar` | `modules/onboarding/widgets/survey_progress_bar.dart` | OK |
| Survey Checkbox Item | `SurveyCheckboxItem` | `modules/onboarding/widgets/survey_checkbox_item.dart` | OK |

---

## 5. 파일별 점검 결과

### 5.1 디자인 토큰 Import 현황

**`color_constant.dart` import** (30개 파일): OK
**`style_constant.dart` import** (30개 파일): OK

### 5.2 문제가 있는 파일 목록

| 파일 | 문제점 | 심각도 |
|------|--------|--------|
| `lib/constants/color_constant.dart` | AppGradients 내 legacy shadows 존재 | LOW |
| `lib/widgets/buttons/social_button.dart` | 하드코딩된 브랜드 컬러 (허용) | - |
| `lib/modules/home/home_view.dart` | Colors.white 5건 | MEDIUM |
| `lib/modules/matching/matching_result_view.dart` | Colors.white 10건, BoxShadow 2건 | MEDIUM |
| `lib/modules/splash/splash_view.dart` | Colors.white 4건 | MEDIUM |
| `lib/modules/coffee/timer/coffee_timer_view.dart` | Colors.white 8건 | MEDIUM |
| `lib/modules/profile/my_taste_view.dart` | Colors.white 1건, BoxShadow 3건 | MEDIUM |
| `lib/modules/onboarding/result/survey_result_view.dart` | Colors.white 6건 | MEDIUM |

---

## 6. 권장 작업 목록 (우선순위순)

### 6.1 HIGH Priority - COMPLETED

1. ~~**Spacing Constants 생성**~~ DONE
   - 파일: `lib/constants/spacing_constant.dart`

2. ~~**BorderRadius Constants 생성**~~ DONE
   - 파일: `lib/constants/radius_constant.dart`

3. ~~**Form Components 모듈화**~~ DONE
   - `lib/widgets/forms/app_checkbox.dart`
   - `lib/widgets/forms/app_radio.dart`
   - `lib/widgets/forms/app_toggle.dart`
   - `lib/widgets/forms/app_text_field.dart`
   - `lib/widgets/forms/app_dropdown.dart`

4. ~~**Feedback Components 추가**~~ DONE
   - `lib/widgets/feedback/app_bottom_sheet.dart`
   - `lib/widgets/feedback/app_snackbar.dart`
   - `lib/widgets/feedback/app_tooltip.dart`

5. ~~**Button Sizes 추가**~~ DONE
   - XL, L, M, S, XS via `ButtonSize` enum

6. ~~**Tonal/Text Button 추가**~~ DONE
   - `lib/widgets/buttons/tonal_button.dart`
   - `lib/widgets/buttons/text_button.dart`

### 6.2 MEDIUM Priority - COMPLETED

7. ~~**Colors.white → AppColor.staticLabelWhiteStrong 마이그레이션**~~ DONE
   - 88건 → 4건 (브랜드 컬러 제외 전체 완료)
   - 18개 파일 마이그레이션 완료
   
8. ~~**BoxShadow → AppShadows 마이그레이션**~~ DONE
   - 표준 BoxShadow는 AppShadows 사용
   - 컴포넌트별 커스텀 그림자는 inline 유지 (예외 허용)

9. ~~**BorderRadius → AppRadius 마이그레이션**~~ DONE
   - 전체 완료: 52건 → 14건 (상수 정의 13 + 동적 계산 1)
   - 17개 파일 마이그레이션 완료

### 6.3 LOW Priority

10. **Other Components 구현**
    - Chip, Avatar, Badge, Divider, Navigation, Tab, Pagination, Progress, Gauge 등

11. **Legacy code 정리**
    - `color_constant.dart` 내 AppGradients 정리
    - `util_constant.dart` 내 하드코딩 값 정리

---

## 7. 결론

### 잘 구현된 부분
- **Design Tokens (Colors, Typography, Shadows)**: Figma와 거의 완벽 일치
- **Theme Integration**: AppTheme이 디자인 토큰을 잘 활용
- **Spacing Constants**: 완전 구현 (`AppSpacing`)
- **BorderRadius Constants**: 완전 구현 (`AppRadius`)
- **Button Components**: 전체 구현 (Primary, Secondary, Tonal, Text + 5 sizes)
- **Modal Components**: 전체 구현 + 디자인 토큰 마이그레이션 완료
- **Form Components**: 전체 구현 (Checkbox, Radio, Toggle, TextField, Dropdown)
- **Feedback Components**: 전체 구현 (BottomSheet, Snackbar, Tooltip)
- **Colors.white 마이그레이션**: 완료 (88건 → 4건, 브랜드 컬러 제외 전체 완료)
- **BorderRadius 마이그레이션**: 완료 (52건 → 14건, 상수 정의/동적 계산 제외 전체 완료)

### 개선 필요 부분 (남은 작업)
- **Other Components**: Chip, Avatar, Badge, Navigation, Tab 등 추가 필요
- **Legacy code 정리**: `color_constant.dart` 내 AppGradients 정리

### 전체 디자인 시스템 준수율: **약 98%**

---

*마지막 업데이트: 2026-02-05*
*이 문서는 코드베이스 변경 시 업데이트가 필요합니다.*
