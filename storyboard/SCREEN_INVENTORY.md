# Coflanet App - Screen Inventory (화면 설계서)

> Figma Source: https://www.figma.com/design/EkpVnNrqyq9Agpy4aymv0j/%E2%AD%90%EF%B8%8F-POC
> Page: ⭐️ MASTER (Ready for dev)
> Last Updated: 2025-02-05

---

## Figma Pages Overview

| Page | Description | Status |
|------|-------------|--------|
| 📺 Thumbnail | Cover / 프로젝트 썸네일 | - |
| ⭐️ MASTER | **메인 디자인 페이지 (구현 대상)** | Ready for dev |
| ✅ 추후 업데이트 목록 | 향후 업데이트 예정 화면들 | 대기 |
| Archive | 이전 버전 / 폐기된 디자인 | 참고용 |

---

## 1. Core Screens (핵심 화면)

### 1.1 Recipe Setting (레시피 세팅)

| ID | Frame Name | Type | Description |
|----|-----------|------|-------------|
| RS-01 | Recipe Setting | 프레임 | 레시피 설정 메인 화면 (커피 카드 선택 + 세부 설정) |
| RS-02 | Recipe Setting | 프레임 | 레시피 설정 메인 화면 (변형 #2) |
| RS-03 | Recipe Setting_Detail | 프레임 | 레시피 상세 설정 화면 #1 |
| RS-04 | Recipe Setting_Detail | 프레임 | 레시피 상세 설정 화면 #2 |
| RS-05 | Recipe Setting_Detail | 프레임 | 레시피 상세 설정 화면 #3 |

**Notes:** 원두량(18g), 물 온도(93°C), 추출 시간(02:30), 물량(210ml) 등 세부 파라미터 설정 UI

### 1.2 Select Coffee Section (커피 선택)

| ID | Frame Name | Type | Description |
|----|-----------|------|-------------|
| SC-01 | Select Coffee Section | 프레임 | 커피 원두/레시피 선택 목록 (보기 모드) |
| SC-02 | Select Coffee Section_Editing | 프레임 | 커피 원두/레시피 선택 목록 (편집 모드 - 추가/삭제/순서변경) |

### 1.3 My Planet (나의 행성)

| ID | Frame Name | Type | Description |
|----|-----------|------|-------------|
| MP-01 | My Planet | 프레임 | 나의 행성 메인 화면 (데이터 있음) |
| MP-02 | My Planet_Empty | 프레임 | 나의 행성 빈 상태 화면 (데이터 없음) |

### 1.4 Survey Result (설문 결과)

| ID | Frame Name | Type | Description |
|----|-----------|------|-------------|
| SR-01 | Survey_Result (Light) | 컴포넌트 | 커피 취향 설문 결과 화면 |

**Flow:**
- Survey → Survey_Analyzing → Survey_Complete → Survey_Result

---

## 2. Recipe Timer Flow (레시피 타이머 플로우)

> Section: "레시피 타이머" (2개 섹션으로 구성)

### 2.1 Timer Steps (타이머 단계)

| ID | Frame Name | Type | Description |
|----|-----------|------|-------------|
| RT-01 | Recipe Step01 | 프레임 | 레시피 타이머 1단계 (시작 화면, 00:00) |
| RT-02 | Recipe Step02 | 프레임 | 레시피 타이머 2단계 (진행 중) |
| RT-03 | Recipe Step04 | 프레임 | 레시피 타이머 4단계 (진행 중, 00:05) |
| RT-04 | Recipe Step04 5s | 프레임 | 레시피 타이머 4단계 5초 경과 상태 |
| RT-05 | Recipe Step06 | 프레임 | 레시피 타이머 6단계 (진행 중, 00:15) #1 |
| RT-06 | Recipe Step06 | 프레임 | 레시피 타이머 6단계 (진행 중, 00:15) #2 |
| RT-07 | Recipe Step Complete | 프레임 | 레시피 타이머 완료 화면 (00:25, 보라색 원형 완료 표시) |

**Flow:**
```
Recipe Step01 → Recipe Step02 → Recipe Step03 → Recipe Step04 → Recipe Step04 5s
Recipe Step06 → Recipe Step Complete
```

### 2.2 Timer Alerts

| ID | Frame Name | Type | Description |
|----|-----------|------|-------------|
| RT-08 | Recipe Close Alert | 인스턴스 | 타이머 종료/닫기 확인 알림 |

**UI Elements:**
- 원형 타이머 (시간 표시: MM:SS)
- 원형 프로그레스 링 (파란/보라 그라디언트)
- 재생/일시정지 버튼
- 이전/다음 단계 네비게이션 (<, >)
- 하단 레시피 지시사항 텍스트

---

## 3. Modals & Overlays (모달 및 오버레이)

### 3.1 Selection Modals (선택 모달)

| ID | Frame Name | Type | Description |
|----|-----------|------|-------------|
| SM-01 | Selection Modal01 | 오토레이아웃 | "어떤 농도로 마셔볼까요?" - 농도 선택 (가벼운 맛 / 균형 잡힌 맛 / 진한 맛) |
| SM-02 | Selection Modal01 | 오토레이아웃 | Selection Modal01 변형 #2 |
| SM-03 | Selection Modal02 | 오토레이아웃 | "몇잔을 추출할까요?" - 잔수 선택 (1잔 / 2잔 / 3잔 / 4잔) |
| SM-04 | Selection Modal03 | 오토레이아웃 | 기타 선택 모달 |

### 3.2 Input Modals (입력 모달)

| ID | Frame Name | Type | Description |
|----|-----------|------|-------------|
| IM-01 | Input Modal01 | 프레임 | 텍스트 입력 모달 #1 |
| IM-02 | Input Modal02 | 프레임 | 텍스트 입력 모달 #2 |
| IM-03 | Input Modal03 | 프레임 | 텍스트 입력 모달 #3 |
| IM-04 | Input Modal04 | 프레임 | 텍스트 입력 모달 #4 |

### 3.3 Other Overlays

| ID | Frame Name | Type | Description |
|----|-----------|------|-------------|
| OV-01 | Time Picker | 인스턴스 | 시간 선택 피커 컴포넌트 |
| OV-02 | Alert/Alert | 인스턴스 | 범용 알림/확인 다이얼로그 |

---

## 4. Espresso Machine Settings (에스프레소 머신 설정)

> Section: "에스프레소 머신 추출 설정 카드 추가 삭제 순서"

에스프레소 머신 추출 설정에 대한 카드 기반 UI 플로우 (추가, 삭제, 순서 변경)

---

## 5. Design Components (디자인 컴포넌트 - 재사용)

> Section: "디자인용 🎨 컴포넌트"

| ID | Component Name | Type | Description |
|----|---------------|------|-------------|
| DC-01 | Tab Bar_poc | 컴포넌트 | POC용 하단 탭바 (홈/커피/프로필 등) |
| DC-02 | Detail Setting | 컴포넌트 | 상세 설정 항목 컴포넌트 |
| DC-03 | 진하기 정도 | 컴포넌트 | 농도 선택 UI 컴포넌트 |
| DC-04 | 잔수 | 컴포넌트 | 잔수 선택 UI 컴포넌트 |
| DC-05 | Select Box | 컴포넌트 | 범용 선택 박스 컴포넌트 |

---

## 6. Flutter App Routes ↔ Figma Mapping

### Implemented Routes (현재 구현된 라우트)

| Route | Flutter Module | Figma MASTER 대응 프레임 | Status |
|-------|---------------|--------------------------|--------|
| `/` (splash) | splash/ | - | 구현 완료 (Figma 미포함) |
| `/login/sign-in` | auth/signin/ | - | 구현 완료 (Figma 미포함) |
| `/login/email-sign-up` | auth/signup/ | - | 구현 완료 (Figma 미포함) |
| `/onboarding/survey-intro` | onboarding/intro/ | - | 구현 완료 (Figma 미포함) |
| `/onboarding/survey` | onboarding/question/ | - | 구현 완료 (Figma 미포함) |
| `/onboarding/survey-analyzing` | onboarding/analyzing/ | Survey → Survey_Analyzing (화살표) | Flow 참고 |
| `/onboarding/survey-complete` | onboarding/complete/ | Survey_Analyzing → Survey_Complete (화살표) | Flow 참고 |
| `/onboarding/survey-result` | onboarding/result/ | **Survey_Result (Light)** | ⬅️ Figma 확인 |
| `/home` | home/ | - | 구현 완료 (Figma 미포함) |
| `/coffee` | coffee/main/ | - | 구현 완료 (Figma 미포함) |
| `/coffee/hand-drip` | coffee/hand_drip/ | - | 구현 완료 (Figma 미포함) |
| `/coffee/espresso` | coffee/espresso/ | - | 구현 완료 (Figma 미포함) |
| `/coffee/settings` | coffee/settings/ | **Recipe Setting (x2)** | ⬅️ Figma 확인 |
| `/coffee/timer` | coffee/timer/ | **Recipe Step01~06, Complete** | ⬅️ Figma 확인 |
| `/coffee/timer/complete` | coffee/timer/ | **Recipe Step Complete** | ⬅️ Figma 확인 |
| `/my-planet` | planet/ | **My Planet, My Planet_Empty** | ⬅️ Figma 확인 |
| `/profile/my-taste` | profile/my_taste/ | - | 구현 완료 (Figma 미포함) |
| `/matching/result` | matching/ | - | 구현 완료 (Figma 미포함) |

### New Screens from Figma (신규 화면 - 추가 구현 필요)

| Figma Frame | 구현 필요 위치 | 설명 |
|-------------|---------------|------|
| Recipe Setting_Detail (x3) | coffee/settings/ | 레시피 상세 설정 화면 |
| Select Coffee Section | coffee/ (새 화면) | 커피 원두 선택 화면 |
| Select Coffee Section_Editing | coffee/ (새 화면) | 커피 원두 선택 편집 모드 |
| Selection Modal01~03 | widgets/modals/ | 농도/잔수 등 선택 모달 |
| Input Modal01~04 | widgets/modals/ | 다양한 입력 모달 |
| Time Picker | widgets/modals/ | 시간 선택 피커 |
| Alert/Alert | widgets/modals/ | 범용 알림 다이얼로그 |
| Recipe Close Alert | coffee/timer/ | 타이머 종료 확인 알림 |
| 에스프레소 머신 추출 설정 카드 | coffee/espresso/ (새 화면) | 에스프레소 머신 설정 플로우 |

---

## 7. Required Assets (필요 에셋)

> `pubspec.yaml`의 assets 섹션이 아직 주석 처리됨 - 에셋 준비 후 활성화 필요

### 7.1 Images (이미지)

| Asset Path | Description | Source | Status |
|------------|-------------|--------|--------|
| `assets/images/logo_main.png` | 메인 로고 | Figma | **필요** |
| `assets/images/logo_white.png` | 흰색 로고 | Figma | **필요** |
| `assets/images/logo_splash.png` | 스플래시 로고 | Figma | **필요** |
| `assets/images/onboarding_welcome.png` | 온보딩 환영 이미지 | Figma | **필요** |
| `assets/images/onboarding_complete.png` | 온보딩 완료 이미지 | Figma | **필요** |
| `assets/images/onboarding_analyzing.png` | 분석 중 이미지 | Figma | **필요** |
| `assets/images/survey_result_bg.png` | 설문 결과 배경 | Figma | **필요** |
| `assets/images/coffee_type_acidic.png` | 산미 커피 타입 이미지 | Figma | **필요** |
| `assets/images/coffee_type_balance.png` | 밸런스 커피 타입 이미지 | Figma | **필요** |
| `assets/images/coffee_type_bitter.png` | 쓴맛 커피 타입 이미지 | Figma | **필요** |
| `assets/images/coffee_type_sweet.png` | 단맛 커피 타입 이미지 | Figma | **필요** |
| `assets/images/coffee_hand_drip.png` | 핸드드립 이미지 | Figma | **필요** |
| `assets/images/coffee_espresso.png` | 에스프레소 이미지 | Figma | **필요** |
| `assets/images/coffee_mokapot.png` | 모카포트 이미지 | Figma | **필요** |

### 7.2 Icons (아이콘 - SVG)

| Asset Path | Description | Status |
|------------|-------------|--------|
| `assets/icons/ic_arrow_back.svg` | 뒤로 가기 화살표 | **필요** |
| `assets/icons/ic_arrow_forward.svg` | 앞으로 가기 화살표 | **필요** |
| `assets/icons/ic_close.svg` | 닫기 (X) | **필요** |
| `assets/icons/ic_check.svg` | 체크마크 | **필요** |
| `assets/icons/ic_check_circle.svg` | 원형 체크마크 | **필요** |
| `assets/icons/ic_home.svg` | 홈 아이콘 | **필요** |
| `assets/icons/ic_coffee.svg` | 커피 아이콘 | **필요** |
| `assets/icons/ic_profile.svg` | 프로필 아이콘 | **필요** |
| `assets/icons/ic_settings.svg` | 설정 아이콘 | **필요** |
| `assets/icons/ic_timer.svg` | 타이머 아이콘 | **필요** |
| `assets/icons/ic_kakao.svg` | 카카오 로그인 | **필요** |
| `assets/icons/ic_naver.svg` | 네이버 로그인 | **필요** |
| `assets/icons/ic_apple.svg` | Apple 로그인 | **필요** |

---

## 8. Flow Diagrams (화면 전환 플로우)

### 8.1 Main App Flow
```
Splash → Sign In → Survey Intro → Survey Steps → Survey Analyzing
                                                        ↓
                                              Survey Complete
                                                        ↓
                                                Survey Result
                                                        ↓
                                                      Home
                                                   ↙    ↓    ↘
                                           Coffee   MyPlanet  Profile
```

### 8.2 Coffee Recipe Flow (from Figma MASTER)
```
Select Coffee Section → Recipe Setting → Recipe Setting_Detail
                                              ↓
                           Selection Modal (농도, 잔수 등)
                                              ↓
                                   Recipe Timer Flow:
              Step01 → Step02 → Step03 → Step04 → Step04 5s
                                                      ↓
                                    Step06 → Step Complete
                                       ↓
                              Recipe Close Alert (종료 시)
```

### 8.3 Coffee Section Edit Flow
```
Select Coffee Section → (편집 모드 진입) → Select Coffee Section_Editing
                                                    ↓
                                     카드 추가/삭제/순서 변경
                                                    ↓
                                     Input Modals (01~04)
```

---

## 9. Notes

- Figma MASTER 페이지는 **POC (Proof of Concept)** 단계의 디자인을 포함
- 기본 앱 흐름(Sign In, Survey, Home 등)은 이미 구현 완료 상태
- MASTER 페이지는 주로 **커피 레시피 관련 상세 화면**과 **모달 컴포넌트**에 집중
- "✅ 추후 업데이트 목록" 페이지에 향후 추가 예정 화면이 있을 수 있음
- 모든 에셋(이미지/아이콘)이 아직 준비되지 않아 Figma에서 export 필요
