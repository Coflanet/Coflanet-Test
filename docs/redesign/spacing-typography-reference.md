# Spacing · Radius · Typography · Color 레퍼런스 (Figma 검증)

> **목적**: 화면 작업 시 항상 참조하는 수치 SoT. margin/padding/gap/radius/text-size를 **토큰명 + 정확한 px + 용도**로 한눈에.
> **검증 기준**: Figma 변수/시안을 코드 토큰과 1:1 대조 (2026-06-23, Figma MCP `get_variable_defs`/`search_design_system`/`get_design_context`).
> - **📚 Library** (`q7yBPcHrid1CGQqFWEPwnR`) — Foundation 토큰(변수)의 기준.
> - **⭐️ POC** (`EkpVnNrqyq9Agpy4aymv0j`) — 실제 앱 시안. 카드 패턴(`Round/40(Box)`, `Spacing/Padding/24`, `Static/Black`)이 여기 존재 → 코드 근거.
> - **🛍️ 쇼핑 상세** (`3B84XdpmsEduuvPVJKdTm9`) — 커머스 상세 시안(§7 화면 대조).
> **출처 링크**: `reference/figma-sources.md`. **Figma 읽기 전용.**
> 코드 SoT: `lib/constants/{spacing,radius,style,color}_constant.dart`, `lib/constants/app_color_scheme.dart`.

## 0. 검증 요약 (먼저 읽기)

1. **Library 변수는 코드와 동기화돼 있다.** 각 Figma 변수의 description이 대응 Flutter 토큰을 명시한다(예: `Round/12` → "Flutter: AppRadius.lg (12.0) … Source: lib/constants/radius_constant.dart"). 즉 Library는 코드에서 역으로 매핑된 상태.
2. **라이트 시맨틱 색은 Figma ↔ 코드 1:1 일치** (§4 표). `token-mapping.md`가 우려한 `Component/fill/alternative 8% vs 5%` 충돌은 **해소 상태** — Figma `Fill/Alternative`=5%, `Fill/Normal`=8%로 코드와 동일.
3. **카드 패턴 토큰(`sectionRadius=40` 등)은 Library Foundation엔 없지만 POC 앱 시안엔 있다.** POC `My Planet` 프레임 변수에 `Round/40(Box)=40`, `Spacing/Padding/24(Contents in Box)=24`, `Spacing/Padding/16(Box in Box)=16`, `Static/Black=#000000` 실재 → 코드 `sectionRadius/itemPadding/staticBlack`는 **추정이 아니라 POC 근거**. **시정 방향**: 값을 바꾸는 게 아니라 이 토큰들을 **📚 Library Foundation에 승격**(디자이너 합의).
4. **⚠️ 타이포 weight 불일치(실질적)**: Figma "Bold" 명칭 텍스트 스타일이 Heading/Headline/Body/Label 스케일에선 **SemiBold(weight 600)**, Title/Display에선 Bold(700)다. 코드는 전 스케일 `*Bold = FontWeight.w700` → **Heading~Label 계열에서 코드가 한 단계 더 무겁다**(§3). lineHeight도 Figma 실측(1.36~1.47)이 코드 라운드값(1.4/1.5)과 미세차, letterSpacing은 코드에 전무.
5. `token-mapping.md`의 "spacing 34/36/44 추가" 액션은 **`component_lab`(별도 코드 인벤토리) 기준**이라 실제 Figma엔 34/36/44가 없다 → **무효/재검토**.
6. 타이포 크기·family는 일치(Display1 56/Display2 40/heading 20/body 16/15, Pretendard). 발행 텍스트 스타일은 없고(specimen 문서화) **코드 type scale이 SoT**.

범례: ✅ Figma=코드 일치 · ⚠️ 코드에만 있음(Library 미존재) · 🔵 Figma에만 있음(코드 미반영) · 🆕 redesign/iyumi 도입.

---

## 1. Spacing (간격·패딩·마진·갭)

### 1-1. Primitive 스케일 — `AppSpacing.space*`

| 토큰 | px | Figma `spacing/*` | 상태 |
|---|---|---|---|
| — | 1 | `spacing/1` | 🔵 Figma만 |
| `space2` | 2 | `spacing/2` | ✅ |
| — | 3 | `spacing/3` | 🔵 Figma만 |
| `space4` (xxs) | 4 | `Spacing/4` (= AppSpacing.space4) | ✅ |
| `space6` | 6 | `spacing/6` | ✅ |
| `space8` (xs) | 8 | `Spacing/8` (= AppSpacing.space8) | ✅ |
| `space10` | 10 | `spacing/10` | ✅ |
| `space12` (sm) | 12 | `spacing/12` | ✅ |
| `space14` | 14 | `spacing/14` | ✅ |
| `space16` (md) | 16 | `spacing/16` | ✅ |
| `space20` (lg) | 20 | `spacing/20` | ✅ |
| `space24` (xl) | 24 | `spacing/24` | ✅ |
| `space28` | 28 | `spacing/28` | ✅ |
| `space32` (xxl) | 32 | `spacing/32` | ✅ |
| `space40` | 40 | `spacing/40` | ✅ |
| `space48` (xxxl) | 48 | `spacing/48` | ✅ |
| `space56` | 56 | (미발견) | ⚠️ 코드만 |
| `space64` | 64 | (미발견) | ⚠️ 코드만 |
| `space80` | 80 | (미발견) | ⚠️ 코드만 |

> 시맨틱 별칭: `xxs=4, xs=8, sm=12, md=16, lg=20, xl=24, xxl=32, xxxl=48`.
> **시정 후보**: Figma `spacing/1`·`spacing/3`은 코드에 없음(거의 안 쓰임 — 필요 시 추가). 코드 56/64/80은 Library 변수로 미확인(레이아웃 큰 간격용 — 사용 중이므로 유지).

### 1-2. 시맨틱/컴포넌트 spacing — Figma `Margin/*`·`Value/*` ↔ 코드

| 용도 | Figma 변수 | px | 코드 토큰 |
|---|---|---|---|
| 화면 좌우 여백(플랫폼) | `Value/Margin/Platform`, `Margin/Navigation` | 20 | `screenPaddingH`, `headerHorizontalPadding` |
| 콘텐츠 여백 | `Margin/Content` | 24 | `modalPadding`, `sectionSpacing` |
| 액션(단일) 여백 | `Margin/Action/Single` | 12 | `listItemSpacing` |
| 기본 갭 | `Value/Space/Gap/Normal` | 16 | `space16` (md), `iconTextGap`=8 |
| 박스 내 콘텐츠 패딩 | `Spacing/Padding/8(Contents in Box 16+8=24)` | 8 | `space8` |
| 뷰포트 lg | `Value/Width/Viewport/lg` | 1100 | (해당 없음 — 모바일) |

> 코드 컴포넌트 상수: `buttonPadding`(h16,v14), `cardPadding`=16, `listItemPadding`(h16,v12), `screenPadding`(h20,v16).

### 1-3. iyumi 카드 패턴 spacing (🆕 redesign 도입 — Library 시맨틱 변수 없음)

| 코드 토큰 | px | 용도 | Figma 대응 |
|---|---|---|---|
| `screenTopMargin` | 32 | 화면 최상단 텍스트 위 마진(전 화면 통일) | primitive `spacing/32` ✅ (시맨틱 토큰은 🆕) |
| `headerHorizontalPadding` | 20 | 헤더(카드 밖) 좌우 패딩 | `Margin/Navigation` 20 ✅ |
| `sectionPadding` | (h24, v32) | 큰 카드 패딩 | `spacing/24`·`spacing/32` ✅ |
| `itemPadding` | 24 | 작은 카드 패딩 | `spacing/24` ✅ |
| `cardGap`/`sectionGap`/`itemGap` | 4 | 카드 사이 간격 | `spacing/4` ✅ |
| `bottomDockAllowance` | 96 (80+16) | OS 독바 여유 | primitive 합성 (80은 ⚠️) |
| `bottomBreathingRoom` | 16 | 독바 여유 위 호흡 | `spacing/16` ✅ |
| `bottomScrollInset(context)` | 동적 | 스크롤 최하단 패딩 | — (런타임 계산) |

> **핵심**: 카드 패턴 토큰의 **개별 값(24·32·4·16)은 Figma primitive 스케일에 존재**한다. "시맨틱 카드 토큰" 자체만 redesign에서 새로 명명한 것(iyumi 이식). 값 불일치 아님.

---

## 2. Radius (라운드)

코드 `AppRadius` ↔ Figma `Semantic/Round/*`(FLOAT). Figma 시맨틱 Round 스케일 = **8 · 12 · 16 · 20 · 24 · 32** (그 외 단계는 Library에 시맨틱 변수로 없음).

| 코드 토큰 | px | Figma `Round/*` (description) | 상태 |
|---|---|---|---|
| `none` | 0 | — | ⚠️ 코드만 |
| `xxs` | 2 | — | ⚠️ 코드만 |
| `xs` | 4 | — | ⚠️ 코드만 |
| `sm` | 6 | — | ⚠️ 코드만 (checkbox) |
| `md` (chip) | 8 | `Round/8` → "AppRadius.md / chip" | ✅ |
| `lg` (button/input) | 12 | `Round/12` → "AppRadius.lg / 버튼·입력(가장 자주)" | ✅ |
| `lgPlus` | 14 | — | ⚠️ 코드만 |
| `xl` (card) | 16 | `Round/16(Box in Box)` → "AppRadius.xl / 카드·중첩박스" | ✅ |
| `xxl` (modal) | 20 | `Round/20(Box)` → "AppRadius.xxl / 모달" | ✅ |
| `xxxl` | 24 | `Round/24(Box)` → "AppRadius.xxxl / 모달·대형박스" | ✅ |
| `round` | 32 | `Round/32(Box)` → "AppRadius.round / pill" | ✅ |
| `full` | 100 | — | ⚠️ 코드만 (Figma pill=32) |
| **`sectionRadius`** | **40** | **POC `Round/40(Box)`=40** (Library Foundation엔 없음) | **🆕 iyumi 큰 카드. POC 근거 있음** |
| `itemRadius` | 24 | `Round/24(Box)` | ✅ (= xxxl) |

> 컴포넌트 별칭: `button=12, input=12, card=16, modal=20, chip=8, checkbox=6, avatar=100`.
> **시정 플래그**: `sectionRadius=40`은 **POC 시안엔 `Round/40(Box)`로 존재**하나 📚 Library Foundation 라디우스 스케일(8·12·16·20·24·32)엔 미승격. → 값 변경 불필요, Library에 `Round/40` **승격**만 디자이너 합의.

---

## 3. Typography (타이포)

폰트 **Pretendard / PretendardMono**(숫자 고정폭). Figma는 폰트 변수/발행 텍스트 스타일이 없어 **코드가 SoT**이며, Library Typography 페이지(node `2414-9843`)가 시각 참조. 스폿 검증: Display1 56/Bold, Display2 40/Bold, body 16/Medium, 헤딩 20/SemiBold — 코드와 일치.

| 그룹 | 토큰(대표) | px | lineHeight | weight 변형 |
|---|---|---|---|---|
| Display1 | `display1Bold/Medium/Regular` | 56 | 1.2 | 700/500/400 |
| Display2 | `display2*` | 40 | 1.2 | 700/500/400 |
| Title1 | `title1*` | 36 | 1.3 | 700/500/400 |
| Title2 | `title2*` (+Mono) | 28 | 1.3 | 700/500/400 |
| Title3 | `title3*` (+Mono) | 24 | 1.3 | 700/500/400 |
| Heading1 | `heading1*` (+BoldMono) | 22 | 1.4 | 700/500/400 |
| Heading2 | `heading2*` (+BoldMono) | 20 | 1.4 | 700/500/400 |
| Headline1 | `headline1*` (+BoldMono) | 18 | 1.4 | 700/500/400 |
| Headline2 | `headline2*` (+BoldMono) | 17 | 1.4 | 700/500/400 |
| Body1 | `body1Normal*` / `body1Reading*` (+Mono) | 16 | 1.5 / 1.6 | 400/500/700 |
| Body2 | `body2Normal*` / `body2Reading*` (+Mono) | 15 | 1.5 / 1.6 | 400/500/700 |
| Label1 | `label1Normal*` / `label1Reading*` (+Mono) | 14 | 1.4 / 1.5 | 400/500/700 |
| Label2 | `label2*` (+Mono) | 13 | 1.4 | 400/500/700 |
| Caption1 | `caption1*` (+Mono) | 12 | 1.3 | 400/500/700 |
| Caption2 | `caption2*` (+Mono) | 11 | 1.3 | 400/500/700 |
| Emoji | `emojiSmall~XLarge` | 16/20/24/48/80 | — | — |

> **전 화면 통일 타이틀** = `title2Bold` (28/Bold) — 화면 최상단 텍스트.

### 3-1. ⚠️ "Bold" weight 불일치 (Figma 텍스트 스타일 실측 vs 코드)

쇼핑 상세(`get_design_context`)·POC(`get_variable_defs`)에서 읽은 **Figma 텍스트 스타일 실측 정의**. Heading/Headline/Body/Label 스케일의 "Bold"는 **SemiBold(600)** 인데 코드는 `w700`.

| 스타일 | Figma 실측 | 코드 토큰 | 불일치 |
|---|---|---|---|
| Title3/Bold | 24 / **700** / LH1.334 | `title3Bold` 24·w700·1.3 | weight ✅ (LH 미세) |
| Heading1/Bold | 22 / **600** / 1.364 / ls-1.94 | `heading1Bold` 22·**w700**·1.4 | ⚠️ weight·LH·ls |
| Heading2/Bold | 20 / **600** / 1.40 | `heading2Bold` 20·**w700**·1.4 | ⚠️ weight |
| Headline2/Bold | 17 / **600** / 1.412 | `headline2Bold` 17·**w700**·1.4 | ⚠️ weight·LH |
| Body1/Normal-Bold | 16 / **600** / 1.50 | `body1NormalBold` 16·**w700**·1.5 | ⚠️ weight |
| Body2/Normal-Regular | 15 / 400 / 1.467 / ls0.96 | `body2NormalRegular` 15·w400·1.5 | LH·ls 미세 |
| Label1/Normal-Bold | 14 / **600** / 1.429 | `label1NormalBold` 14·**w700**·1.4 | ⚠️ weight·LH |
| Label2/Regular | 13 / 400 / 1.385 | `label2Regular` 13·w400·1.4 | LH 미세 |
| Caption2/Medium | 11 / 500 / 1.273 | `caption2Medium` 11·w500·1.3 | LH 미세 |

> **시정 후보**: Display/Title "Bold"는 700 일치, **Heading·Headline·Body·Label "Bold"는 Figma 600 / 코드 700** — 코드가 더 굵게 렌더. 디자이너에게 "Bold 명칭=600 의도인지" 확인 후, 맞으면 해당 코드 토큰을 `w600`으로 정렬. lineHeight/letterSpacing 미세차는 Figma가 Pretendard 광학값(1.36~1.47)을 쓰고 코드는 1.4/1.5 라운드 — 디테일 정합 시 반영.

---

## 4. Color (시맨틱 — 라이트 1:1 검증)

Figma `Semantic/*` 변수 ↔ 코드 `AppColorScheme.light`. 아래는 `get_variable_defs`로 확인된 값(전부 일치).

| 역할 | Figma 변수 | 값 | 코드 (`AppColorScheme.light`) |
|---|---|---|---|
| Label/Normal | `Label/Normal` | #171719 | `labelNormal` (coolNeutral10) ✅ |
| Label/Strong | `Label/Strong` | #000000 | `labelStrong` (common0) ✅ |
| Label/Alternative | `Label/Alternative` | #37383C @61% | `labelAlternative` ✅ |
| Label/Assistive | `Label/Assistive` | #37383C @35% | `labelAssistive` ✅ |
| Label/Disable | `Label/Disable` | #37383C @16% | `labelDisable` ✅ |
| Background/Normal/Normal | `Background/Normal/Normal` | #FFFFFF | `backgroundNormalNormal` ✅ |
| Background/Normal/Alternative | `Background/Normal/Alternative` | #F7F7F8 | `backgroundNormalAlternative` (coolNeutral99) ✅ |
| Background/Elevated/Normal | `Background/Elevated/Normal` | #FFFFFF | `backgroundElevatedNormal` ✅ |
| Line/Normal/Normal | `Line/Normal/Normal` | #70737C @22% | `lineNormalNormal` ✅ |
| Line/Normal/Neutral | `Line/Normal/Neutral` | #70737C @16% | `lineNormalNeutral` ✅ |
| Line/Normal/Alternative | `Line/Normal/Alternative` | #70737C @8% | `lineNormalAlternative` ✅ |
| Fill/Normal | `Fill/Normal` | #70737C @8% | `componentFillNormal` (0.08) ✅ |
| Fill/Alternative | `Fill/Alternative` | #70737C @5% | `componentFillAlternative` (0.05) ✅ |
| Primary/Normal | `Primary/normal` | #6541F2 | `primaryNormal` (violet50) ✅ |
| Interaction/Inactive | `Interaction/Inactive` | #989BA2 | `interactionInactive` (coolNeutral70) ✅ |
| Status/Negative | `Status/Negative` | #FF4242 | `statusNegative` (red50) ✅ |
| Static/White | `Static/White` | #FFFFFF | `AppColor.staticWhite` ✅ |
| Material/Dimmer | `Material/Dimmer` | #171719 @52% | `componentMaterialDimmer` ✅ |

> **`Fill/Alternative` 충돌 해소 확인**: `token-mapping.md`가 "Figma 8% vs 코드 5%"로 보류했으나, 실측 Figma `Fill/Alternative`=5% (`#70737c0d`)로 **코드와 일치**. 그 보류 항목은 닫아도 됨.
> **다크 스킴**: Library 변수 덤프는 라이트 모드 기준. 코드 `AppColorScheme.dark`는 Figma 다크 시안(홈/원두 상세) 기반(코드 주석 명시). 다크 변수 모드 별도 대조는 후속.

---

## 5. 작업 시 빠른 규칙 (체크리스트용 수치)

- 화면 최상단 텍스트: 위 마진 **32**(`screenTopMargin`), 스타일 **title2Bold(28/Bold)**, 좌우 **20**(`headerHorizontalPadding`).
- 큰 카드(CardSection): radius **40**(`sectionRadius`, ⚠️Library 미존재 토큰), 패딩 **(24,32)**, 카드 간격 **4**.
- 작은 카드(CardItem): radius **24**(`itemRadius`=Figma `Round/24`), 패딩 **24**, 간격 **4**.
- 버튼/입력 radius **12**(`Round/12`), 카드 radius **16**(`Round/16`), 칩 **8**(`Round/8`), 모달 **20**(`Round/20`).
- 숫자 직접 금지 — 전부 `AppSpacing.*`/`AppRadius.*`/`AppTextStyles.*` 토큰.
- 색은 스킴으로 — 카드 밖 `AppColorScheme.canvas`(dark), 카드 안 `AppColorScheme.of(context)`.

## 6. 화면 대조 (POC·쇼핑 시안 ↔ 코드)

### 6-1. 마이(`My Planet` POC `1327:15788`) ↔ `lib/modules/planet/my_planet_content.dart`
**일치** — POC 변수/레이아웃 실측이 코드 카드 패턴과 정합:

| 항목 | POC 시안 | 코드 | 상태 |
|---|---|---|---|
| 캔버스 | `Static/Black`·`Background/normal/strong`=#000000 | `staticBlack` 캔버스 | ✅ |
| 큰 카드 radius | `rounded-[40px]` (`Round/40(Box)`) | `sectionRadius`=40 | ✅ |
| 큰 카드 배경 | `Background/normal/normal`=#FFFFFF | `surfaceCard`(light #FFFFFF) | ✅ |
| 인셋 아이템 배경 | `Background/normal/alternative`=#F4F4F5 | `surfaceCardStrong`(coolNeutral98 #F4F4F5) | ✅ |
| 카드 내부 패딩(좌우) | `Spacing/Padding/24(Contents in Box)`=24 | `sectionPadding` h24 | ✅ |
| 카드 사이 간격 | `Spacing/4`=4 | `CardGap`/`cardGap`=4 | ✅ |

### 6-2. 상품 상세(쇼핑 `184:23579` ↔ `lib/modules/product/product_detail_view.dart`)
**의도적 디자인 분기** — 쇼핑 상세는 **커머스 레이아웃**(flat 섹션, 좌우 마진 16/24, 리뷰 이미지·2열 추천 그리드·레시피 표), 코드는 동일 정보를 **iyumi 카드로 단순화**("모델에 없는 정보 미표시", commit "C1 본래 해법"). 1:1 픽셀 포트 아님. 측정 정합 지점:

| 항목 | 쇼핑 시안 | 코드 | 비고 |
|---|---|---|---|
| 히어로 섹션 패딩 | `px-24 py-32` | `CardSection` = `sectionPadding`(24,32) | ✅ 일치 |
| 섹션 내부 간격 | `Spacing/16` | 카드 내부 `SizedBox(lg/md)` | 유사 |
| 썸네일 | 360×360 정사각 | `AspectRatio 1` + `itemRadius`(24) | 카드화 |
| 본문 텍스트 | Body2 15·Label2 13·Heading1 22 등 | 동일 스케일 토큰 | ✅ 크기 |
| "Bold" 라벨 weight | SemiBold 600 | 코드 `*Bold` w700 | ⚠️ §3-1 |

> 쇼핑 상세를 **그대로 이식할 계획이면** 좌우 마진(16/24)·flat 섹션·2열 추천 그리드·리뷰 블록이 추가 필요. 현재는 Coflanet iyumi 카드로 재해석한 상태가 의도된 산출물.

## 7. 후속(이 문서 범위 밖)

- 홈(`home`) 화면 단위 대조 — POC 홈 프레임 ↔ `lib/modules/home/`.
- **다크 모드 Figma 변수 대조** — POC 마이는 라이트 모드(검정 캔버스+흰 카드)였음. 순수 다크 모드 프레임을 찾아 `AppColorScheme.dark` 대조 필요.
- 디자이너 합의: ① `Round/40` Library Foundation 승격 ② Heading~Label "Bold" weight(600 vs 700) 확정.
