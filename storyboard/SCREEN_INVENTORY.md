# Coflanet App - Screen Inventory (화면 설계서)

> Figma Source: https://www.figma.com/design/EkpVnNrqyq9Agpy4aymv0j/%E2%AD%90%EF%B8%8F-POC
> Page: ⭐️ MASTER (Ready for dev)
> Last Updated: 2026-02-06

---

## Summary

| Category | Count |
|----------|-------|
| **Total Layers** | 32 |
| **Routes (GetPage)** | 23 |
| **View Files** | 25 |
| **Shell Tab Contents** | 4 |
| **Figma MASTER Frames** | 38+ |

---

## Complete Layer Inventory (32 Layers)

### Auth Flow (Layer #1-4)

| Layer | Screen | Route | File | Figma | BG Color |
|-------|--------|-------|------|-------|----------|
| #1 | Splash | `/` | `splash/splash_view.dart` | - | #6B4EFF |
| #2 | Sign In | `/login/sign-in` | `auth/signin/signin_view.dart` | 로그인 | #FFFFFF |
| #3 | Email Sign Up | `/login/email-sign-up` | `auth/signup/signup_view.dart` | 회원가입 | #FFFFFF |
| #4 | Sign Up Complete | `/login/sign-up-complete` | `auth/signup/signup_complete_view.dart` | 회원가입 완료 | #FFFFFF |

### Onboarding Flow (Layer #5-14)

| Layer | Screen | Route | File | Figma | BG Color |
|-------|--------|-------|------|-------|----------|
| #5 | Survey Intro | `/onboarding/survey-intro` | `onboarding/intro/survey_intro_view.dart` | 설문 시작 | #FFFFFF |
| #6 | Survey Q1 | `/onboarding/survey/0` | `onboarding/question/survey_question_view.dart` | Q1-커피목적 | #FFFFFF |
| #7 | Survey Q2 | `/onboarding/survey/1` | (same) | Q2-맛선호 | #FFFFFF |
| #8 | Survey Q3 | `/onboarding/survey/2` | (same) | Q3-과일향 | #FFFFFF |
| #9 | Survey Q4 | `/onboarding/survey/3` | (same) | Q4-빈도 | #FFFFFF |
| #10 | Survey Q5 | `/onboarding/survey/4` | (same) | Q5-추출방식 | #FFFFFF |
| #11 | Survey Q6 | `/onboarding/survey/5` | (same) | Q6-농도 | #FFFFFF |
| #12 | Survey Analyzing | `/onboarding/survey-analyzing` | `onboarding/analyzing/survey_analyzing_view.dart` | Flow | #FFFFFF |
| #13 | Survey Complete | `/onboarding/survey-complete` | `onboarding/complete/survey_complete_view.dart` | Flow | #FFFFFF |
| #14 | Survey Result | `/onboarding/survey-result` | `onboarding/result/survey_result_view.dart` | SR-01 | #000000 |

### Home (Layer #15)

| Layer | Screen | Route | File | Figma | BG Color |
|-------|--------|-------|------|-------|----------|
| #15 | Home | `/home` | `home/home_view.dart` | 홈 | #FFFFFF |

### Coffee Flow (Layer #16-24)

| Layer | Screen | Route | File | Figma | BG Color |
|-------|--------|-------|------|-------|----------|
| #16 | Coffee Main | `/coffee` | `coffee/main/coffee_main_view.dart` | 추출 선택 | #FFFFFF |
| #17 | Hand Drip | `/coffee/hand-drip` | `coffee/hand_drip/hand_drip_view.dart` | 핸드드립 | #FFFFFF |
| #18 | Espresso | `/coffee/espresso` | `coffee/espresso/espresso_view.dart` | 에스프레소 | #FFFFFF |
| #19 | Espresso Settings | `/coffee/espresso/settings` | `coffee/espresso/espresso_settings_view.dart` | 에스프레소 설정 | #FFFFFF |
| #20 | Coffee Settings | `/coffee/settings` | `coffee/settings/coffee_settings_view.dart` | RS-01,02 | #000000 |
| #21 | Coffee Setting Detail | `/coffee/settings/detail` | `coffee/settings/coffee_setting_detail_view.dart` | RS-03,04,05 | #000000 |
| #22 | Select Coffee | `/coffee/select` | `coffee/select/select_coffee_view.dart` | SC-01,02 | #000000 |
| #23 | Recipe Timer | `/coffee/timer` | `coffee/timer/coffee_timer_view.dart` | RT-01~06 | #333333 |
| #24 | Timer Complete | `/coffee/timer/complete` | `coffee/timer/timer_complete_view.dart` | RT-07 | #333333 |

### Profile & Matching (Layer #25-27)

| Layer | Screen | Route | File | Figma | BG Color |
|-------|--------|-------|------|-------|----------|
| #25 | Matching Result | `/matching/result` | `matching/matching_result_view.dart` | 매칭 결과 | #FFFFFF |
| #26 | My Taste | `/profile/my-taste` | `profile/my_taste_view.dart` | 내 취향 | #FFFFFF |
| #27 | My Planet | `/my-planet` | `planet/my_planet_view.dart` | MP-01,02 | #000000 |

### Shell & Tabs (Layer #28-32)

| Layer | Screen | Route / Tab | File | Figma | BG Color |
|-------|--------|-------------|------|-------|----------|
| #28 | Main Shell | `/main-shell` | `shell/main_shell_view.dart` | Shell | #000000 |
| #29 | 원두 (Tab 0) | Shell Tab | `coffee/select/select_coffee_content.dart` | SC-01 | #000000 |
| #30 | 추출 목록 (Tab 1) | Shell Tab | `extraction/extraction_list_view.dart` | - | #000000 |
| #31 | 시음 기록 (Tab 2) | Shell Tab | `tasting/tasting_notes_view.dart` | - | #000000 |
| #32 | My 행성 (Tab 3) | Shell Tab | `planet/my_planet_content.dart` | MP-01,02 | #000000 |

---

## Figma Frame Mapping (38+ Frames)

### Figma Section Structure

| Section | Korean Name | Frame Count | Description |
|---------|-------------|-------------|-------------|
| Section 0 | 디자인 문서 | 2 | Start User Flow, 디자인 가이드 |
| Section 1 | 회원가입/로그인 | 8-10 | Auth 플로우 |
| Section 2 | 설문 | 12-14 | Survey/Onboarding 플로우 |
| Section 3 | 레시피 타이머 | 8-10 | Hand Drip Timer 플로우 |
| Section 4 | 에스프레소 | 6-8 | Espresso Timer 플로우 |
| Section 5 | 기타 | 2-3 | 추가 화면들 |

### Recipe Setting (RS)

| Figma ID | Frame Name | → Layer | Screen |
|----------|------------|---------|--------|
| RS-01 | Recipe Setting | #20 | Coffee Settings |
| RS-02 | Recipe Setting (variant) | #20 | Coffee Settings |
| RS-03 | Recipe Setting_Detail | #21 | Coffee Setting Detail (원두량) |
| RS-04 | Recipe Setting_Detail | #21 | Coffee Setting Detail (물온도) |
| RS-05 | Recipe Setting_Detail | #21 | Coffee Setting Detail (추출시간) |

### Select Coffee (SC)

| Figma ID | Frame Name | → Layer | Screen |
|----------|------------|---------|--------|
| SC-01 | Select Coffee Section | #22, #29 | Select Coffee / 원두 Tab |
| SC-02 | Select Coffee Section_Editing | #22, #29 | Select Coffee (Edit Mode) |

### My Planet (MP)

| Figma ID | Frame Name | → Layer | Screen |
|----------|------------|---------|--------|
| MP-01 | My Planet | #27, #32 | My Planet (Filled) |
| MP-02 | My Planet_Empty | #27, #32 | My Planet (Empty) |

### Survey Result (SR)

| Figma ID | Frame Name | → Layer | Screen |
|----------|------------|---------|--------|
| SR-01 | Survey_Result (Light) | #14 | Survey Result |

### Recipe Timer (RT)

| Figma ID | Frame Name | → Layer | Screen |
|----------|------------|---------|--------|
| RT-01 | Recipe Step01 | #23 | Timer (시작) |
| RT-02 | Recipe Step02 | #23 | Timer (진행 중) |
| RT-03 | Recipe Step04 | #23 | Timer (진행 중) |
| RT-04 | Recipe Step04 5s | #23 | Timer (5초 경과) |
| RT-05 | Recipe Step06 | #23 | Timer (진행 중) |
| RT-06 | Recipe Step06 | #23 | Timer (진행 중) |
| RT-07 | Recipe Step Complete | #24 | Timer Complete |
| RT-08 | Recipe Close Alert | #23 | Timer (Close Modal) |

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
#6-11 Survey Questions (6 steps)
    ↓
#12 Survey Analyzing
    ↓
#13 Survey Complete
    ↓
#14 Survey Result
    ↓
#15 Home
    ↓
    ├─→ #16 Coffee Main
    │       ├─→ #17 Hand Drip ─→ #23 Timer ─→ #24 Complete
    │       └─→ #18 Espresso ─→ #19 Espresso Settings
    │                    └─→ #23 Timer ─→ #24 Complete
    │
    ├─→ #26 My Taste
    │
    ├─→ #27 My Planet
    │
    └─→ #28 Main Shell
            ├─ Tab 0: #29 원두
            ├─ Tab 1: #30 추출 목록
            ├─ Tab 2: #31 시음 기록
            └─ Tab 3: #32 My 행성
```

### Coffee Recipe Flow

```
#22 Select Coffee / #29 원두 Tab
    ↓
#20 Coffee Settings
    ├─→ #21 Coffee Setting Detail
    └─→ Modals (Selection, Input, Time Picker)
    ↓
#23 Recipe Timer
    ├─→ RT-08 Close Alert (취소 시)
    └─→ #24 Timer Complete
            ├─→ 다시 추출 → #23
            └─→ 홈으로 → #15
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

- [x] Layer count matches storyboard count: **32 = 32** ✅
- [x] All routes have corresponding view files
- [x] All Figma MASTER frames mapped to layers
- [x] Background colors documented per Figma CSS
- [x] Navigation flows documented
- [x] Modal components listed
- [x] Figma section structure documented (38+ frames → 32 layers)
