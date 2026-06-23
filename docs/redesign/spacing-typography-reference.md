# Spacing · Radius · Typography · Color 레퍼런스 (Figma 검증)

> **목적**: 화면 작업 시 항상 참조하는 수치 SoT. margin/padding/gap/radius/text-size를 **토큰명 + 정확한 px + 용도**로 한눈에.
> **검증 기준**: Figma 📚 Library (`q7yBPcHrid1CGQqFWEPwnR`) 변수를 코드 토큰과 1:1 대조 (2026-06-23, Figma MCP `get_variable_defs`/`search_design_system`/`get_design_context`).
> **출처 링크**: `reference/figma-sources.md`. **Figma 읽기 전용.**
> 코드 SoT: `lib/constants/{spacing,radius,style,color}_constant.dart`, `lib/constants/app_color_scheme.dart`.

## 0. 검증 요약 (먼저 읽기)

1. **Library 변수는 코드와 동기화돼 있다.** 각 Figma 변수의 description이 대응 Flutter 토큰을 명시한다(예: `Round/12` → "Flutter: AppRadius.lg (12.0) … Source: lib/constants/radius_constant.dart"). 즉 Library는 코드에서 역으로 매핑된 상태.
2. **라이트 시맨틱 색은 Figma ↔ 코드 1:1 일치** (§4 표). `token-mapping.md`가 우려한 `Component/fill/alternative 8% vs 5%` 충돌은 **해소 상태** — Figma `Fill/Alternative`=5%, `Fill/Normal`=8%로 코드와 동일.
3. **불일치는 거의 전부 "redesign/iyumi 도입 토큰"이 Library에 아직 없는 것**이지, 값이 어긋난 게 아니다. 대표: `AppRadius.sectionRadius=40`(iyumi 큰 카드)은 Library 라디우스 스케일(8·12·16·20·24·32)에 **없음**.
4. `token-mapping.md`의 "spacing 34/36/44 추가" 같은 액션은 **`component_lab`(별도 코드 인벤토리) 기준**이었고, 실제 Figma Library에는 34/36/44가 없다 → 그 액션은 **무효/재검토 대상**.
5. **타이포는 Figma에 발행된 텍스트 스타일/폰트 변수가 없다**(스펙 프레임 specimen으로만 문서화). 따라서 **코드 type scale이 SoT**이고, Library Typography 페이지(node `2414-9843`)는 시각 참조. 크기는 스폿 검증 일치(Display1 56/Bold, Display2 40/Bold, body 16, Pretendard).

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
| **`sectionRadius`** | **40** | **— (Library 없음)** | **⚠️🆕 iyumi 큰 카드. Library 라디우스 스케일에 부재** |
| `itemRadius` | 24 | `Round/24(Box)` | ✅ (= xxxl) |

> 컴포넌트 별칭: `button=12, input=12, card=16, modal=20, chip=8, checkbox=6, avatar=100`.
> **시정 플래그**: `sectionRadius=40`은 Library에 없는 iyumi 토큰 — 디자이너가 Library에 `Round/40` 추가 합의 필요(또는 큰 카드를 32로 정렬). 그 전까지 코드 유지.

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
> **미검증 항목(정직하게 표기)**: Figma specimen 데모 텍스트의 렌더 lineHeight가 일부 1.286~1.3으로 보였으나(코드 display=1.2), 이는 데모 문구 렌더값일 수 있어 토큰 정의값으로 단정하지 않음 → 디자이너 확인 시 정정.

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

## 6. 후속(이 문서 범위 밖)

- POC(`EkpVnNrqyq9Agpy4aymv0j`)·쇼핑 상세(`3B84XdpmsEduuvPVJKdTm9`) **화면 단위** 패딩/간격 대조(홈·마이·상품 상세).
- 다크 모드 Figma 변수 대조.
- `Round/40` Library 추가 또는 `sectionRadius` 정렬 디자이너 합의.
