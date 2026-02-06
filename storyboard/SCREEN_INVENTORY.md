# Coflanet App - Screen Inventory (화면 설계서)

> Figma Source: https://www.figma.com/design/EkpVnNrqyq9Agpy4aymv0j/%E2%AD%90%EF%B8%8F-POC
> Page: ⭐️ MASTER (Ready for dev)
> Last Updated: 2025-02-06

---

## Summary

| Category | Count |
|----------|-------|
| **Total Layers** | 27 |
| **Routes (GetPage)** | 23 |
| **View Files** | 25 |
| **Shell Tab Contents** | 4 |
| **Figma MASTER Frames** | 38 |

---

## Complete Layer Inventory (27 Layers)

### Auth Flow (Layer #1-4)

| Layer | Screen | Route | File | Figma | BG Color |
|-------|--------|-------|------|-------|----------|
| #1 | Splash | `/` | `splash/splash_view.dart` | - | #6B4EFF |
| #2 | Sign In | `/login/sign-in` | `auth/signin/signin_view.dart` | - | #FFFFFF |
| #3 | Email Sign Up | `/login/email-sign-up` | `auth/signup/signup_view.dart` | - | #FFFFFF |
| #4 | Sign Up Complete | `/login/sign-up-complete` | `auth/signup/signup_complete_view.dart` | - | #FFFFFF |

### Onboarding Flow (Layer #5-9)

| Layer | Screen | Route | File | Figma | BG Color |
|-------|--------|-------|------|-------|----------|
| #5 | Survey Intro | `/onboarding/survey-intro` | `onboarding/intro/survey_intro_view.dart` | - | #FFFFFF |
| #6 | Survey Question | `/onboarding/survey/:step` | `onboarding/question/survey_question_view.dart` | - | #FFFFFF |
| #7 | Survey Analyzing | `/onboarding/survey-analyzing` | `onboarding/analyzing/survey_analyzing_view.dart` | Flow | #FFFFFF |
| #8 | Survey Complete | `/onboarding/survey-complete` | `onboarding/complete/survey_complete_view.dart` | Flow | #FFFFFF |
| #9 | Survey Result | `/onboarding/survey-result` | `onboarding/result/survey_result_view.dart` | SR-01 | #000000 |

### Home (Layer #10)

| Layer | Screen | Route | File | Figma | BG Color |
|-------|--------|-------|------|-------|----------|
| #10 | Home | `/home` | `home/home_view.dart` | - | #FFFFFF |

### Coffee Flow (Layer #11-19)

| Layer | Screen | Route | File | Figma | BG Color |
|-------|--------|-------|------|-------|----------|
| #11 | Coffee Main | `/coffee` | `coffee/main/coffee_main_view.dart` | - | #FFFFFF |
| #12 | Hand Drip | `/coffee/hand-drip` | `coffee/hand_drip/hand_drip_view.dart` | - | #FFFFFF |
| #13 | Espresso | `/coffee/espresso` | `coffee/espresso/espresso_view.dart` | - | #FFFFFF |
| #14 | Espresso Settings | `/coffee/espresso/settings` | `coffee/espresso/espresso_settings_view.dart` | - | #FFFFFF |
| #15 | Coffee Settings | `/coffee/settings` | `coffee/settings/coffee_settings_view.dart` | RS-01,02 | #000000 |
| #16 | Coffee Setting Detail | `/coffee/settings/detail` | `coffee/settings/coffee_setting_detail_view.dart` | RS-03,04,05 | #000000 |
| #17 | Select Coffee | `/coffee/select` | `coffee/select/select_coffee_view.dart` | SC-01,02 | #000000 |
| #18 | Recipe Timer | `/coffee/timer` | `coffee/timer/coffee_timer_view.dart` | RT-01~06 | #333333 |
| #19 | Timer Complete | `/coffee/timer/complete` | `coffee/timer/timer_complete_view.dart` | RT-07 | #333333 |

### Profile & Matching (Layer #20-22)

| Layer | Screen | Route | File | Figma | BG Color |
|-------|--------|-------|------|-------|----------|
| #20 | Matching Result | `/matching/result` | `matching/matching_result_view.dart` | - | #FFFFFF |
| #21 | My Taste | `/profile/my-taste` | `profile/my_taste_view.dart` | - | #FFFFFF |
| #22 | My Planet | `/my-planet` | `planet/my_planet_view.dart` | MP-01,02 | #000000 |

### Shell & Tabs (Layer #23-27)

| Layer | Screen | Route / Tab | File | Figma | BG Color |
|-------|--------|-------------|------|-------|----------|
| #23 | Main Shell | `/main-shell` | `shell/main_shell_view.dart` | - | #000000 |
| #24 | 원두 (Tab 0) | Shell Tab | `coffee/select/select_coffee_content.dart` | SC-01 | #000000 |
| #25 | 추출 목록 (Tab 1) | Shell Tab | `extraction/extraction_list_view.dart` | - | #000000 |
| #26 | 시음 기록 (Tab 2) | Shell Tab | `tasting/tasting_notes_view.dart` | - | #000000 |
| #27 | My 행성 (Tab 3) | Shell Tab | `planet/my_planet_content.dart` | MP-01,02 | #000000 |

---

## Figma MASTER Frame Mapping

### Recipe Setting (RS)

| Figma ID | Frame Name | → Layer | Screen |
|----------|------------|---------|--------|
| RS-01 | Recipe Setting | #15 | Coffee Settings |
| RS-02 | Recipe Setting (variant) | #15 | Coffee Settings |
| RS-03 | Recipe Setting_Detail | #16 | Coffee Setting Detail (원두량) |
| RS-04 | Recipe Setting_Detail | #16 | Coffee Setting Detail (물온도) |
| RS-05 | Recipe Setting_Detail | #16 | Coffee Setting Detail (추출시간) |

### Select Coffee (SC)

| Figma ID | Frame Name | → Layer | Screen |
|----------|------------|---------|--------|
| SC-01 | Select Coffee Section | #17, #24 | Select Coffee / 원두 Tab |
| SC-02 | Select Coffee Section_Editing | #17, #24 | Select Coffee (Edit Mode) |

### My Planet (MP)

| Figma ID | Frame Name | → Layer | Screen |
|----------|------------|---------|--------|
| MP-01 | My Planet | #22, #27 | My Planet (Filled) |
| MP-02 | My Planet_Empty | #22, #27 | My Planet (Empty) |

### Survey Result (SR)

| Figma ID | Frame Name | → Layer | Screen |
|----------|------------|---------|--------|
| SR-01 | Survey_Result (Light) | #9 | Survey Result |

### Recipe Timer (RT)

| Figma ID | Frame Name | → Layer | Screen |
|----------|------------|---------|--------|
| RT-01 | Recipe Step01 | #18 | Timer (시작) |
| RT-02 | Recipe Step02 | #18 | Timer (진행 중) |
| RT-03 | Recipe Step04 | #18 | Timer (진행 중) |
| RT-04 | Recipe Step04 5s | #18 | Timer (5초 경과) |
| RT-05 | Recipe Step06 | #18 | Timer (진행 중) |
| RT-06 | Recipe Step06 | #18 | Timer (진행 중) |
| RT-07 | Recipe Step Complete | #19 | Timer Complete |
| RT-08 | Recipe Close Alert | #18 | Timer (Close Modal) |

### Modal Components (SM, IM, OV)

| Figma ID | Component | Usage |
|----------|-----------|-------|
| SM-01 | Selection Modal01 | 농도 선택 |
| SM-02 | Selection Modal01 (variant) | 농도 선택 |
| SM-03 | Selection Modal02 | 잔수 선택 |
| SM-04 | Selection Modal03 | 기타 선택 |
| IM-01 | Input Modal01 | 텍스트 입력 |
| IM-02 | Input Modal02 | 텍스트 입력 |
| IM-03 | Input Modal03 | 텍스트 입력 |
| IM-04 | Input Modal04 | 텍스트 입력 |
| OV-01 | Time Picker | 시간 선택 |
| OV-02 | Alert/Alert | 확인/취소 |

### Design Components (DC)

| Figma ID | Component | Usage |
|----------|-----------|-------|
| DC-01 | Tab Bar_poc | 하단 탭바 |
| DC-02 | Detail Setting | 상세 설정 항목 |
| DC-03 | 진하기 정도 | 농도 선택 UI |
| DC-04 | 잔수 | 잔수 선택 UI |
| DC-05 | Select Box | 범용 선택 박스 |

---

## Navigation Flow Diagrams

### Main App Flow

```
#1 Splash
    ↓
#2 Sign In ─→ #3 Email Sign Up ─→ #4 Sign Up Complete
    ↓
#5 Survey Intro
    ↓
#6 Survey Question (7 steps)
    ↓
#7 Survey Analyzing
    ↓
#8 Survey Complete
    ↓
#9 Survey Result
    ↓
#10 Home
    ↓
    ├─→ #11 Coffee Main
    │       ├─→ #12 Hand Drip ─→ #18 Timer ─→ #19 Complete
    │       └─→ #13 Espresso ─→ #14 Espresso Settings
    │                    └─→ #18 Timer ─→ #19 Complete
    │
    ├─→ #21 My Taste
    │
    ├─→ #22 My Planet
    │
    └─→ #23 Main Shell
            ├─ Tab 0: #24 원두
            ├─ Tab 1: #25 추출 목록
            ├─ Tab 2: #26 시음 기록
            └─ Tab 3: #27 My 행성
```

### Coffee Recipe Flow

```
#17 Select Coffee / #24 원두 Tab
    ↓
#15 Coffee Settings
    ├─→ #16 Coffee Setting Detail
    └─→ Modals (Selection, Input, Time Picker)
    ↓
#18 Recipe Timer
    ├─→ RT-08 Close Alert (취소 시)
    └─→ #19 Timer Complete
            ├─→ 다시 추출 → #18
            └─→ 홈으로 → #10
```

---

## Required Assets

### Images (Real Assets)

| Asset | Description | Status |
|-------|-------------|--------|
| `logo_main.png` | 메인 로고 | ✅ |
| `logo_splash.png` | 스플래시 로고 | ✅ |
| `onboarding_complete.png` | 우주 토끼 마스코트 | ✅ |
| `onboarding_analyzing.png` | 분석 중 이미지 | ✅ |
| `timer_step01_grinder.png` | 타이머 Step1 일러스트 | ✅ |
| `timer_step02_pourover.png` | 타이머 Step2 일러스트 | ✅ |
| `timer_complete.png` | 타이머 완료 일러스트 | ✅ |

### Images (Placeholder - Figma Export 필요)

| Asset | Description | Status |
|-------|-------------|--------|
| `onboarding_welcome.png` | 설문 시작 환영 이미지 | ⚠️ |
| `coffee_hand_drip.png` | 핸드드립 이미지 | ⚠️ |
| `coffee_espresso.png` | 에스프레소 이미지 | ⚠️ |
| `coffee_mokapot.png` | 모카포트 이미지 | ⚠️ |

### Icons (SVG)

| Asset | Description | Status |
|-------|-------------|--------|
| `ic_arrow_back.svg` | 뒤로 가기 | ✅ |
| `ic_arrow_forward.svg` | 앞으로 가기 | ✅ |
| `ic_close.svg` | 닫기 (X) | ✅ |
| `ic_check.svg` | 체크마크 | ✅ |
| `ic_check_circle.svg` | 원형 체크 | ✅ |
| `ic_home.svg` | 홈 | ✅ |
| `ic_coffee.svg` | 커피 | ✅ |
| `ic_profile.svg` | 프로필 | ✅ |
| `ic_settings.svg` | 설정 | ✅ |
| `ic_timer.svg` | 타이머 | ✅ |
| `ic_kakao.svg` | 카카오 로그인 | ✅ |
| `ic_naver.svg` | 네이버 로그인 | ✅ |
| `ic_apple.svg` | Apple 로그인 | ✅ |

---

## Verification Checklist

- [x] Layer count matches storyboard count: **27 = 27** ✅
- [x] All routes have corresponding view files
- [x] All Figma MASTER frames mapped to layers
- [x] Background colors documented per Figma CSS
- [x] Navigation flows documented
- [x] Modal components listed
