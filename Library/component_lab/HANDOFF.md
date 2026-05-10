# Coflanet Design System — 인수인계 문서

다음 세션에서 바로 이어서 작업하기 위한 컨텍스트 정리. 
Figma `📚 Library` 파일을 코드화하는 작업이며 현재 **Components 카테고리의 Button 페이지 완료** 상태.

---

## 1. 기본 정보

### 프로젝트 경로
```
저장소 루트:    /Users/yooju/Desktop/Coflanet-Test
디자인 라이브러리: /Users/yooju/Desktop/Coflanet-Test/Library/component_lab
앱 (참고용):     /Users/yooju/Desktop/Coflanet-Test/coflanet-app-0.1.2
앱 토큰 출처:    /Users/yooju/Desktop/Coflanet-Test/coflanet-backend-main/coflanet-backend-main/refs/Coflanet-main/tokens
```

### Figma
- **파일명**: `📚 Library`
- **fileKey**: `q7yBPcHrid1CGQqFWEPwnR`
- **베이스 URL**: `https://www.figma.com/design/q7yBPcHrid1CGQqFWEPwnR/...`

### 핵심 도구 (Figma MCP)
- `mcp__758565dc-...__use_figma` — Figma Plugin API로 JavaScript 실행. **sandbox 토큰 제한 우회용 핵심 도구**
- `mcp__758565dc-...__get_metadata` — 페이지 구조 빠른 확인 (큰 페이지는 90K+ 토큰이라 자주 실패)
- `mcp__758565dc-...__get_design_context` — 코드 + 스크린샷 (응답이 큰 경우 많음)
- `mcp__758565dc-...__get_screenshot` — 이미지 URL 반환 (sandbox에서 fetch 차단됨)

### 라이브러리 구조 (component_lab)
```
component_lab/
├── pubspec.yaml               # widgetbook + coflanet path dep
├── lib/
│   ├── main.dart              # Widgetbook entry — 3계층 카테고리
│   ├── foundation/            # 토큰 자체 정의 (coflanet 의존 X)
│   │   ├── app_color.dart
│   │   ├── app_text_style.dart
│   │   ├── app_spacing.dart
│   │   ├── app_radius.dart
│   │   ├── app_shadow.dart
│   │   ├── app_theme.dart
│   │   ├── _swatch.dart
│   │   ├── palette_use_cases.dart
│   │   ├── semantic_use_cases.dart
│   │   ├── typography_use_cases.dart
│   │   ├── spacing_use_cases.dart
│   │   ├── radius_use_cases.dart
│   │   ├── shadow_use_cases.dart
│   │   └── opacity_use_cases.dart
│   └── components/
│       ├── buttons/           # ✅ Figma 검증 완료
│       ├── chips/             # 작성됨, Figma 검증 미완
│       ├── avatars/           # 작성됨, Figma 검증 미완
│       ├── cards/             # 작성됨, Figma 검증 미완
│       ├── chips/
│       ├── controls/          # Switch/Checkbox/Radio
│       ├── dividers/
│       ├── forms/             # TextField
│       ├── indicators/        # Progress + Indicators(Badge·Pagination)
│       ├── modals/            # ConfirmDialog
│       ├── ratio/             # ✅ Figma 검증 완료 (Components 단계에서)
│       ├── scrolls/           # ✅ Figma 검증 완료
│       └── thumbnails/        # 작성됨, Figma 검증 미완
└── HANDOFF.md                 # 이 문서
```

---

## 2. 완료된 Button 6개 위젯 (Figma 1:1 매핑)

**Figma 페이지**: `⏹️ Button` (`2414:32026` / 컨테이너 `2414:32027`)

### 2-1. AppSolidButton — `Button/Solid/*` 7종
**파일**: `lib/components/buttons/app_solid_button.dart`

```dart
enum AppSolidButtonTone {
  primary,                  // Button/Solid/Primary             → fill primaryNormal, text white
  grayPrimary,              // Button/Solid/Gray Primary        → fill componentFillNormal, text primaryNormal
  gray,                     // Button/Solid/Gray                → fill componentFillNormal, text labelNormal
  liquidGlassPrimary,       // Button/Solid/LiquidGlass Primary → blur, text staticLabelWhiteNormal
  liquidGlass,              // Button/Solid/LiquidGlass         → blur, text labelNormal
  backgroundBlurPrimary,    // Button/Solid/Background Blur Primary → blur, text staticLabelWhiteNormal
  backgroundBlur,           // Button/Solid/Background Blur     → componentFillNormal + blur, text labelNormal
}
enum AppSolidButtonSize { large, medium, small, xsmall }
```

**Size 측정값** (Figma 정확):
| Size | Height | Padding(h/v) | Gap | Icon | TextStyle |
|---|---|---|---|---|---|
| Large | 52 | 28/12 | 6 | 16×20 | `body1NormalBold` (16/150%/0.57%) |
| Medium | 40 | 20/9 | 5 | 14×18 | `body2NormalBold` (15/146.7%/0.96%) |
| Small | 32 | 14/7 | 4 | 12×16 | `label2Bold` (13/138.5%/1.94%) |
| XSmall | 32 | 10/7 | 4 | 12×16 | `label2Bold` |

**Disable**: fill `interactionDisable` 50%, text `labelAssistive` 35% (`Label/assistive`)
**Radius**: 99 (Pill, 모두 동일)

### 2-2. AppOutlinedButton — `Button/Outlined/*` 3종
**파일**: `lib/components/buttons/app_outlined_button.dart`

```dart
enum AppOutlinedButtonTone { primary, secondary, assistive }
enum AppOutlinedButtonSize { large, medium, small, xsmall }
```

| Tone | Stroke | Text |
|---|---|---|
| primary | `Primary/normal` 1px | `Primary/normal` |
| secondary | `line/normal/normal` 1px | `Primary/normal` |
| assistive | `line/normal/normal` 1px | `Label/normal` |
| **Disable (모두)** | `line/normal/normal` 1px | `Label/disable` |

**Padding 차이**: Primary는 28/12. Secondary/Assistive는 stroke 1px 보정으로 28/11 (vertical -1).
**Radius**: 99 (Pill).

### 2-3. AppTextButton — `Button/Text/*` 3종
**파일**: `lib/components/buttons/app_text_button.dart`

```dart
enum AppTextButtonTone { primary, normal, assistive }
enum AppTextButtonSize { medium, small }   // ← Medium/Small 2개만
```

| Size | Width | Height | Padding | Gap | TextStyle |
|---|---|---|---|---|---|
| Medium | 41 | 32 | 0/0/4/4 | 10 | `body1NormalBold` (16) |
| Small | 36 | 28 | 0/0/4/4 | 10 | `label1NormalBold` (14) |

**Tone**: primary→primaryNormal, normal→labelNormal, assistive→labelAlternative
**Disable**: text `labelDisable`. Radius 0, fill/stroke 없음.

### 2-4. AppIconButton — `Button/Icon/*` 9종
**파일**: `lib/components/buttons/app_icon_button.dart`

```dart
enum AppIconButtonTone {
  normal,                  // 24×24 단순 아이콘 (Badge 옵션, 배경 없음)
  primary,                 // 40×40 Pill, fill primaryNormal
  liquidGlassPrimary,      // 40×40 Pill, blur + 흰색
  liquidGlass,             // 40×40 Pill, 거의 투명 (4%)
  backgroundBlurPrimary,   // 40×40 Pill, blur + 흰색
  backgroundBlur,          // 40×40 Pill, componentFillNormal + BG Blur sigma 30
  liquidGlassGrayPrimary,  // 40×40 Pill, componentFillNormal + Primary 아이콘
  gray,                    // 40×40 Pill, fill 없음
  outlined,                // 40×40 Pill, stroke lineNormalNormal 1px
}
enum AppIconButtonSize { normal, small, custom }   // 40 / 32 / 36 (또는 customSize)
```

**Padding 규칙**:
- Primary 계열 (강조 fill/border 있음): Normal 10, Small 7, Custom 6
- 단순 hover 계열 (LG·BG Blur·Gray): 모든 사이즈 6

**Primary Disable**: fill `componentFillStrong` (12%) + BackgroundBlur sigma 32

### 2-5. AppFloatingActionButton — `Button/Floating Action`
**파일**: `lib/components/buttons/app_floating_action_button.dart`

- 56×56, padding 16, **radius 1000 (완전 원형)**
- Disable=False: fill `Component/fill/alternative` 8% (`componentFillNormal`)
- Disable=True: fill `interaction/disable` 50% (`interactionDisable`)
- 그림자: `shadowBlackEmphasize` (라이트/다크 동일)
- ⚠️ `isPrimary` 옵션 없음 (이전에 임의 추가했다 제거함)

### 2-6. AppSectionBottomButton — `Button/Section Bottom/*` 3 variants
**파일**: `lib/components/buttons/app_section_bottom_button.dart`

```dart
enum AppSectionBottomVariant {
  topLine,   // 위쪽 line + 텍스트 (320×48, padding 28/11, border-top lineNormalNormal)
  solid,     // 그라데이션 fade (320×48, padding 24/4)
  fold,      // 펼침/접힘 토글 (Slim·Mask·Expand)
}
// Fold 옵션: isExpanded · isSlim (40↔32) · useMask
```

**Top Line**: text `labelAlternative` (Disable 시 `labelDisable`).

### use_cases 통합 파일
**파일**: `lib/components/buttons/button_use_cases.dart`

내보내는 list 변수:
- `solidButtonUseCases`
- `outlinedButtonUseCases`
- `textButtonUseCases`
- `iconButtonUseCases`
- `fabUseCases`
- `sectionBottomUseCases`

`main.dart`에서 위 6개 모두 `Components > Button` 폴더에 등록됨.

### 폐기된 추정 코드 (사용자가 로컬 rm 필요)
```bash
cd ~/Desktop/Coflanet-Test/Library/component_lab/lib/components/buttons
rm app_button.dart                        # 기존 5-variant AppButton (Figma와 안 맞음)
rm icon_button_use_cases.dart             # 기존 use_cases (button_use_cases에 통합됨)
rm app_social_button.dart                 # 추정 (Figma 검증 안 거침)
rm app_liquid_glass_button.dart           # 추정
rm social_liquid_button_use_cases.dart    # 추정

cd ../chips
rm app_chip.dart                          # 추정 기반 13색 Chip (Figma는 Action/Filter 2종만)
```

---

## 3. Figma 변수명 ↔ 우리 토큰 매핑

`use_figma`로 `boundVariables` 추적해서 검증된 매핑:

| Figma 변수명 | 우리 토큰 (`AppColor`) | 의미 |
|---|---|---|
| `Primary/normal` | `primaryNormal` | 브랜드 violet 50 |
| `Static/White` | `staticLabelWhiteStrong` | 흰색 강조 텍스트 |
| `Static/label/White/normal` | `staticLabelWhiteNormal` | 흰색 일반 텍스트 |
| `Component/fill/alternative` (8% 의도) | `componentFillNormal` | ⚠️ Figma 명명과 우리 명명이 다름 |
| `Component/fill/normal` (12% 의도) | `componentFillStrong` | ⚠️ 명명 차이 주의 |
| `Label/normal` | `labelNormal` | 검정 일반 |
| `Label/alternative` | `labelAlternative` | 61% |
| `Label/assistive` | `labelAssistive` | 35% |
| `Label/disable` | `labelDisable` | 16% |
| `interaction/disable` (50%) | `interactionDisable` | |
| `line/normal/normal` | `lineNormalNormal` | 22% |

⚠️ **Figma `Component/fill/alternative`(8%)와 우리 `componentFillAlternative`(5%)는 의미가 다름**. 디자이너와 향후 명명 정합성 점검 필요.

---

## 4. 작업 규칙 (반드시 준수)

### 4-1. 추정 금지
- Figma 데이터 없이 일반적 디자인 패턴으로 만드는 것 금지
- 데이터를 못 받으면 "방법 찾아서" 가져옴 — sandbox 토큰 제한은 핑계 X
- 추정으로 만든 코드 발견 시 즉시 폐기

### 4-2. 페이지 순서대로
- Figma 페이지 트리 순서를 따라가기
- 임의로 건너뛰지 않기
- 각 페이지의 모든 변형(variant) 면밀히 분석

### 4-3. Sandbox 토큰 제한 우회 패턴

큰 페이지 metadata가 25K~90K+ 토큰으로 응답이 잘릴 때 다음 패턴 사용:

```js
// 1) 페이지 root에서 자식 트리 깊이 1-2만 추출
const node = await figma.getNodeByIdAsync('PAGE_ID');
const children = node.children.map(c => ({
  id: c.id, name: c.name, type: c.type,
  w: Math.round(c.width||0), h: Math.round(c.height||0),
}));

// 2) 각 자식의 COMPONENT_SET 위치만 따로 호출
async function findComponentSets(node, out=[]) {
  if (node.type === 'COMPONENT_SET' || node.type === 'COMPONENT') {
    out.push({id: node.id, name: node.name});
    return out;
  }
  if ('children' in node) for (const c of node.children) findComponentSets(c, out);
  return out;
}

// 3) 각 COMPONENT_SET의 props만
const set = await figma.getNodeByIdAsync('SET_ID');
const props = set.componentPropertyDefinitions
  ? Object.fromEntries(Object.entries(set.componentPropertyDefinitions).map(([k,v]) => [
      k.replace(/#.*$/, ''),  // "#hash" 제거
      { type: v.type, options: v.variantOptions }
    ]))
  : null;

// 4) variant 한 개의 정밀 detail (fill/stroke/text 색상은 boundVariables로 토큰명 추적!)
const varCache = {};
async function resolveVar(boundVar) {
  if (!boundVar?.id) return null;
  if (varCache[boundVar.id] !== undefined) return varCache[boundVar.id];
  const v = await figma.variables.getVariableByIdAsync(boundVar.id);
  varCache[boundVar.id] = v ? v.name : null;
  return varCache[boundVar.id];
}
// 사용 예:
// const fill = variant.fills?.[0];
// const tokenName = await resolveVar(fill?.boundVariables?.color);
```

### 4-4. boundVariables 추적
- 색상은 항상 `boundVariables.color`로 토큰명 추출
- RGB 값보다 토큰명이 우선
- effects의 BackgroundBlur sigma 값도 정확히 측정

### 4-5. 위젯북 폴더 구조
```
WidgetbookCategory(name: 'Foundation')   # 토큰
WidgetbookCategory(name: 'Components')   # atoms
WidgetbookCategory(name: 'Molecular')    # molecules
```
임의로 위치 바꾸지 말 것. Figma 페이지 분류와 동일하게.

---

## 5. Figma 라이브러리 페이지 리스트

`use_figma`로 추출한 전체 페이지 (`figma.root.children`).

### 🛠️ Foundation (토큰)
| 페이지 | nodeId | 상태 |
|---|---|---|
| 🔠 Typography | `2414:9843` | ✅ 완료 |
| 📐 Space | `2485:8842` | ✅ 완료 |
| 🎨 Colors | `2414:11941` | ✅ 완료 |
| 🌈 Gradient | `2452:6035` | ❌ 미정 |
| 💅 Decorate | `2452:6034` | ❌ 미정 (디자인 영역, 코드화 X로 결정) |
| 🔘 Icon | `2414:34422` | ❌ 미정 |
| 🎨 Image | `2934:19018` | ❌ 미정 |
| 3️⃣ 3D Illustration | `2941:667` | ❌ 미정 |
| ☕️ Product | `2941:684` | ❌ 미정 |
| 🏷️ Logo | `0:1` | ❌ 미정 |

### 🧩 Components (atoms)
| 페이지 | nodeId | 상태 |
|---|---|---|
| ⏹️ Button | `2414:32026` (컨테이너 `2414:32027`) | ✅ **완료 (이번 세션)** |
| 🍪 Chip | `2546:166598` | 🔄 **다음 진행** |
| 📏 Ratio | `2452:6033` | ⚠️ 작성됨, Figma 검증 미완 |
| 🖼️ Thumbnail | `2452:6037` | ⚠️ 작성됨, Figma 검증 미완 |
| 🖱️ Scroll | `2452:7600` | ✅ Figma 검증 완료 (`2452:7831` 컨테이너) |
| 👤 Avatar | `2452:6039` | ⚠️ 작성됨, Figma 검증 미완 |
| 💡 Indicators | `2442:16180` | ⚠️ 작성됨, Figma 검증 미완 |
| ➗ Divider | `2452:6032` | ⚠️ 작성됨, Figma 검증 미완 |

### ⚙️ Molecular (molecules)
| 페이지 | nodeId | 상태 |
|---|---|---|
| 🧭 Navigation | `2452:3459` | ❌ |
| ↳ 📑 Tab | `2414:34400` | ❌ |
| ↳ 🔢 Pagination | `2452:6038` | ❌ |
| ⏳ Progress Indicators | `2449:415` | ⚠️ 작성됨, Figma 검증 미완 |
| ☑️ Selection and 📝 Input | `2442:7603` | ⚠️ 작성됨 (TextField/Switch/Checkbox/Radio) |
| 🕹️ Control Box | `2537:62051` | ❌ |
| 🌡️ Gauge | `2442:15568` | ❌ |
| 🪞 Feedback | `2546:36834` | ❌ |
| 📣 Presentation | `2546:42535` | ⚠️ 작성됨 (ConfirmDialog만) |
| 📑 Contents | `2573:404660` | ⚠️ 작성됨 (Card만) |

### 기타
| 페이지 | nodeId | 비고 |
|---|---|---|
| 📺 Thumbnail (다른 것) | `2636:31292` | 페이지 카드용 (별개) |
| ⚙️ Components (오버뷰) | `2643:8531` | 인덱스 페이지 |
| 🗂️ 피그마 파일관리 규칙 | `2925:192` | 메타 |
| Archive | `2556:146379` | 보관 |

⚠️ "작성됨, Figma 검증 미완" = 이전 세션에 일반적 패턴으로 작성. **다음 세션에서 Button 했던 방식대로 Figma 데이터로 재검증 필요.**

---

## 6. 다음 진행 순서

### 6-1. Components 카테고리 마저 검증 (페이지 순서대로)
1. ~~🍪 Chip (`2546:166598`)~~ ✅ 완료 (2026-05-08)
2. **📏 Ratio** (`2452:6033`) ← **다음 시작점**
3. 🖼️ Thumbnail (`2452:6037`)
4. 🖱️ Scroll (`2452:7600`) — 이미 검증 완료
5. 👤 Avatar (`2452:6039`)
6. 💡 Indicators (`2442:16180`)
7. ➗ Divider (`2452:6032`)

### 6-2. Molecular 진행
8. 🧭 Navigation (`2452:3459` — Tab + Pagination)
9. ⏳ Progress Indicators (`2449:415`)
10. ☑️ Selection and Input (`2442:7603`)
11. 🕹️ Control Box (`2537:62051`)
12. 🌡️ Gauge (`2442:15568`)
13. 🪞 Feedback (`2546:36834`)
14. 📣 Presentation (`2546:42535`)
15. 📑 Contents (`2573:404660`)

### 6-3. Foundation 보강 (선택)
- 🌈 Gradient (`2452:6035`)
- 🔘 Icon (`2414:34422`) — 사용자가 받아둔 SVG 카탈로그
- 🎨 Image / 3D Illustration / Product
- 🏷️ Logo

---

## 7. 다음 세션 시작 절차

1. 이 문서 읽기 (`HANDOFF.md`)
2. 사용자 컨펌:
   - "Chip부터 진행"
   - "다른 거부터 보고 싶다" → 페이지 nodeId로 시작
3. 작업 패턴 (Button에서 검증된 흐름):
   ```
   ① use_figma — 페이지 자식 트리 추출
   ② COMPONENT_SET들 props 일괄 추출
   ③ 각 set의 모든 variant detail (boundVariables 토큰명 + size geometry)
   ④ 우리 토큰과 매핑
   ⑤ 위젯 + use_cases 작성
   ⑥ main.dart 등록
   ⑦ 보고
   ```
4. **추정 금지**, **페이지 순서대로**, **boundVariables 토큰명 추적**.

---

## 8. Foundation 토큰 정리 상태 (이전 세션 완료)

### Color
- Palette 142색 (Common·Neutral·CoolNeutral·Blue·Red·Green·Orange·Yellow·Lime·Cyan·LightBlue·Violet·Pink)
- Semantic Light + Dark (Primary·Label·Background·Status·Line·Component·Interaction·Accent·Static·Inverse)
- Opacity 15단계

### Typography (66 + emoji 5)
- Display 1~2 (3 weight)
- Title 1~3 (3 weight + Tabular)
- Heading 1~2 (3 weight + Tabular) — Bold = SemiBold(w600)
- Headline 1~2
- Body 1~2 / Normal·Reading
- Label 1 / Normal·Reading + Label 2
- Caption 1~2
- Emoji 16/20/24/48/80

### Spacing (Palette 13단계 + Semantic)
- Palette: 4/8/12/14/16/20/24/32/34/36/40/44/48
- Semantic: containerVerticalPadding(32), containerHorizontalPadding(24), buttonPaddingHorizontal(8), buttonPaddingVertical(12), itemSpacing(12) 등
- Safe Area: iOS Status 44, Android Status 36, iOS Bottom 34, Android Bottom 14

### Radius (Palette + Semantic)
- Palette: 2/4/6/8/12/14/16/20/24/32/40/Pill(100)
- Semantic: radiusButton(12), radiusCard(16), radiusModal(20), radiusChip(8), radiusCheckbox(6), radiusAvatar(Pill)
- 단, Button 페이지 검증 결과 모든 Solid/Outlined 버튼은 **radius 99 (Pill)** 사용 → `radiusButton=12`는 Figma와 다름. 디자이너 컨펌 필요.

### Shadow
- Black/Primary 각 Normal·Emphasize·Strong·Heavy·HeavyBottom·Floating

### 기타
- AppShadows.shadowBlackEmphasize 등은 Figma 정확값 미검증 (boundVariables 추적 안 함). 추후 보강.

---

## 9. 알려진 이슈·주의사항

1. **`Component/fill/*` 명명 의미 차이**: Figma `alternative`(8%) ≠ 우리 `componentFillAlternative`(5%). 검증된 매핑은 §3 표 참고.
2. **`coflanet` path dependency 유지**: pubspec.yaml의 path dep은 아이콘 에셋용. 토큰은 component_lab 내부 자체 정의.
3. **사용자가 로컬 rm 해야 할 폐기 파일들**: §2의 폐기된 추정 코드 항목 참고.
4. **사용자가 만들어둔 Section Bottom Solid의 그라데이션**: Figma는 `Gradient/Solid`라는 fill 노드 별도 자식. 우리는 단순 색→투명 그라데이션으로 근사. 정확한 그라데이션 색은 추후 분석 필요.
5. **`pubspec.yaml` widgetbook 버전**: ^3.11.0 사용 중. 최신 마이그레이션 필요 시 별도 작업.

---

## 10. 변경 이력

- **2026-05-08**: Chip 페이지 정확 분석 (Action 24 variant + Filter 64 variant) → `AppChipAction` (4 size × 2 variant × Active × Disable + leading/trailing icon) + `AppChipFilter` (chevron + count badge) 작성. 폐기: 추정 기반 `app_chip.dart`.
- **2026-05-07**: Button 페이지 정확 분석 + 6 위젯 작성 + boundVariables 토큰 추적 + Disable 색상 정정. 인수인계 문서 작성.
- **이전 세션들**: Foundation 토큰 정리 + 위젯북 셋업 + 일반 컴포넌트 작성 (Figma 검증 미완 상태).

---

다음 세션에서 이 문서 읽고 §6 순서대로 진행.
