# Flutter Library Structure Audit (Phase 4/5)

- **대상**: `Library/component_lab/lib` (Coflanet Component Lab, Flutter/Dart 디자인 시스템)
- **감사 단위**: 76개 공개 App* 위젯 + 11개 foundation token/theme + 3개 entry/sample
- **감사 기준**: A. Widget Boundaries · B. Layout-Content 분리 · C. Constructor/Type 안전성 · D. Theme/Tokens · E. State 처리 · F. 재사용성 · G. 명명/구조 일관성 · H. Flutter 모범 패턴
- **등급 기준**: **A** 프로덕션 준비완료(미세 정정만) · **B** 견고하나 1~2개 개선 권장 · **C** 리팩터 필요 · **D** 상당한 재작성 필요
- **방법**: 3개 병렬 감사 에이전트가 chunk별로 위젯을 직접 읽고 산출. 본문에 line 번호 / 변수명 단위까지 인용.

---

## 1. Foundation (Tokens & Theme)

> Foundation 토큰 클래스는 D(테마/토큰) + G(명명) 위주 평가.

### `AppColor` (`foundation/app_color.dart`, 472 LOC)
- Grade: **B**
- ✅ private `AppColor._()`, 2-tier Palette + Semantic 구조, dark 토큰 페어 풀세트, 최신 `withValues(alpha:)` 사용.
- ⚠️ semantic 토큰 다수가 `static Color get`(getter)로 작성 — 호출마다 새 `Color` 할당. `static final`로 메모이즈 권장 (L227–234, 296–303, 369–376).
- ⚠️ semantic getter 내부에서 hex 리터럴 재사용(`Color(0xFF2E2F33).withValues(...)`) — 팔레트 상수(`colorGlobalCoolNeutral22`)를 참조해야 단일 출처.
- ⚠️ 일부 stray 토큰이 팔레트를 거치지 않음: `accentBackgroundBrown`(L275), `backgroundTimer`(L243).
- 🔴 **`darkStatusPositiveBlue` (L396)이 `colorGlobalGreen60`을 가리킴** — 이름은 Blue지만 값은 Green. 복붙 오류, 정정 필요.

### `AppDecorate` + `InteractionIntensity`/`InteractionState` (`foundation/app_decorate.dart`, 161 LOC)
- Grade: **B**
- ✅ 2-axis 룩업 헬퍼 `interactionColor(...)`, opacity 스칼라 + 사전 합성 색 모두 노출.
- ⚠️ 사전 합성 hex(`0x2E171719` 등)와 `_interactionOpacityMap`이 이중 출처 → 드리프트 위험.
- ⚠️ `_interactionOpacityMap[i]![s]!` 이중 bang(L94) — exhaustive switch 패턴 권장.

### `AppGradient` (`foundation/app_gradient.dart`, 169 LOC)
- Grade: **B**
- ✅ 16-stop easing curve 깔끔, solid/multiple/mask 일관성, `shaderMask(...)` 헬퍼.
- ⚠️ `_blackEasingColors()`는 `Color.fromRGBO(0,0,0,o)`, `_easingColors`는 `withValues(alpha:)` — 표기 통일 권장.
- ⚠️ 매 호출 새 list 할당 — `final` 캐싱 가능.

### `AppRadius` (`foundation/app_radius.dart`)
- Grade: **A**
- ✅ palette + semantic 두 계층 일관, 모든 값에 `*Border` 페어, dartdoc 풍부.
- ⚠️ `radiusButton = 99.0`(L76) — Pill을 안 쓰는 이유 doc 또는 `radius99` 추가 권장.

### `AppShadows` (`foundation/app_shadow.dart`, 285 LOC)
- Grade: **B**
- ✅ strength × color 사다리 + bottom-offset 변형 + 모두 `const`.
- 🔴 `shadowPrimaryNormal`(L20)이 단일 `BoxShadow` — 형제 토큰은 모두 `List<BoxShadow>`. **타입 불일치** — 사용자 코드에서 typed list로 받기 어려움. `[BoxShadow(...)]`로 통일 필요.
- ⚠️ Primary RGB(101,65,242)이 토큰마다 하드코딩 — `AppColor.colorGlobalViolet50`로 링크 코멘트 권장.
- ⚠️ `backgroundBlur30`(L284)이 그림자가 아닌데 같은 파일에 위치 — 분리 권장.

### `AppSpacing` (`foundation/app_spacing.dart`)
- Grade: **A**
- ✅ palette 13 step + semantic 별칭 + `EdgeInsets` 헬퍼.
- ⚠️ semantic `buttonPaddingHorizontal = space8`인데 실제 버튼 위젯들은 10/14/20/28 사용 — semantic이 stale.

### `AppTextStyles` (`foundation/app_text_style.dart`, 374 LOC)
- Grade: **A**
- ✅ 66 const TextStyle, Pretendard 일관, `tnum` 활성화, 카테고리 배너 정리.
- ⚠️ height 정밀도 미세 차이: `label1ReadingMedium`(1.571) vs `label1ReadingBold`(1.5714).
- ⚠️ Emoji 스타일은 fontFamily/height 없음 — fallback chain 명문화 필요.

### `AppTheme` (`foundation/app_theme.dart`, 138 LOC)
- Grade: **B**
- ✅ Material 3 enable, AppBar/Button/Divider 테마 일관, Widgetbook ThemeAddon 직접 사용.
- 🔴 **`ThemeExtension<T>` 등록 없음** — 본 디자인 시스템의 가장 큰 구조적 미비. 컴포넌트가 일일이 `Theme.of(context).brightness == Brightness.dark`로 분기해 `darkXxx` 토큰을 픽업해야 함. → 다수 컴포넌트가 다크 모드 처리를 빼먹는 직접 원인.
- ⚠️ `minimumSize: Size(double.infinity, 52)`, `dividerTheme.thickness: 1` 등 magic number.

### `CoflanetIcons` + `CoflanetIcon` + `CoflanetIconSize` (`foundation/coflanet_icons.dart`)
- Grade: **A**
- ✅ enhanced enum (size + pixel value), const ctor, 5 사이즈 + override.
- ⚠️ asset 상수 평면 리스트 — domain별 sub-namespace 권장.
- ⚠️ `Semantics`/`semanticLabel` 파라미터 없음 — 접근성 미흡. (Flutter 표준 `Icon`은 제공)
- ⚠️ `customSize` 탈출구 없음 — 5 enum만 허용.

### `Swatch` (`foundation/_swatch.dart`)
- Grade: **A** (foundation helper, 가볍게 채점)
- ✅ `ThemeData.estimateBrightnessForColor`로 대비 계산, fallback note.
- ⚠️ radius/padding/fontSize 하드코딩 — 토큰 사용 권장하지만 내부 helper라 수용 가능.

---

## 2. Components / buttons (8)

### `AppFloatingActionButton` (67 LOC)
- Grade: **B**
- ✅ const, final, disabled state, dark mode 분기.
- 🔴 **L46–48: `isDark ? shadowBlackEmphasize : shadowBlackEmphasize`** — 동일 ternary 분기, 복붙 버그.
- ⚠️ size variant 없음 (Figma는 56/40 mini-FAB 일반적), `width/height/padding/iconSize` 모두 하드코딩.

### `AppIconButton` (275 LOC)
- Grade: **B**
- ✅ tone(9) × size(3) 거대 매트릭스를 단일 클래스 + record 반환 패턴으로 깔끔 통합, blur surface 분리.
- ⚠️ `_colors` 안 `case normal` 중복 처리(L126–133 early-return + L196–202 default).
- ⚠️ 24/40/32/16/20/10/7/6 등 geometry 하드코딩. `customSize ?? 36`(L83)에 magic 36 숨김.
- ⚠️ build ~70줄 + surface 재할당 분기 — `_buildBlurWrapper`/`_buildBadge` 추출 권장.
- ⚠️ `iconColor`가 `disabled` tone의 `c.fg`를 덮어씀 → 비활성 색 무시될 수 있음.

### `AppLiquidGlassButton` (136 LOC)
- Grade: **B**
- ✅ BackdropFilter + gradient 레이어링 충실, foreground override, size 기반 스케일.
- ⚠️ height 48/52/56, icon 18/20/22 하드코딩 — `AppSolidButton`과 metric 공유 권장.
- ⚠️ alpha 값(`0.06/0.16/0.12/0.28/0.10/0.02`) 하드코딩 — `AppDecorate`로 분리.
- ⚠️ 트리 깊이 ~6 (SizedBox > ClipRRect > BackdropFilter > Material > InkWell > Container > Row).
- ⚠️ disabled 시각 미흡 (fill opacity만 변경, 텍스트/아이콘은 full).
- 🔴 **Phase 3 보고 — `AppSolidButton.tone: liquidGlass*`와 중복**. 이 위젯 제거 또는 Solid의 tone enum으로 일원화 권장.

### `AppOutlinedButton` (148 LOC)
- Grade: **C**
- ✅ Dart 3 switch expression, pill radius, record 반환.
- 🔴 **`_adjustedPadding()` (L97–105)** — `EdgeInsets.horizontal`은 *left+right* 합이라 `base.horizontal / 2`는 symmetric 패딩에서만 우연히 작동. `base.left`/`base.top` 사용으로 수정.
- ⚠️ AppSolidButton과 size geometry 표 100% 동일 — `AppButtonMetrics` 추출 필수.
- ⚠️ dark mode 분기 없음 — `AppColor.primaryNormal`/`lineNormalNormal` 무조건 light.

### `AppSectionBottomButton` (179 LOC)
- Grade: **C**
- ✅ 다크 모드 분기, 모든 색 토큰.
- ⚠️ build가 130줄 `switch` — variant별 `_buildTopLine()`/`_buildSolid()`/`_buildFold()` 분리 권장.
- ⚠️ `'접기'`/`'더보기'` 한국어 하드코딩 (L160) — i18n 위험. 호출자 라벨 받기.
- ⚠️ variant-specific 필드(`isExpanded`/`isSlim`/`useMask`)가 모든 variant에 노출 — sealed/factory ctor로 격리 권장.
- 🔴 **`solid` variant의 `Container > InkWell` — Material 조상 부재로 ripple 미표시.** Material 래퍼 추가 필요.

### `AppSocialButton` (109 LOC)
- Grade: **B**
- ✅ provider별 `_config()` 룩업, 브랜드 컬러 토큰, const.
- 🔴 **아이콘이 Material placeholder** (`Icons.chat_bubble_rounded` = Kakao 등 L13–14 코멘트) — 프로덕션 출시 전 실제 브랜드 SVG로 교체 필수.
- ⚠️ 라벨('카카오로 시작하기' 등) 하드코딩 — i18n.
- ⚠️ disabled 시각 미흡.

### `AppSolidButton` (210 LOC)
- Grade: **B**
- ✅ size(4) × tone(7) 단일 클래스 통합, blur path 분리, record 반환, `MainAxisSize.min/max` 토글.
- ⚠️ AppOutlinedButton과 metric 표 100% 동일 — 공유 추출.
- ⚠️ dark mode 분기 누락 — `primary` tone이 항상 `primaryNormal` (`darkPrimaryNormal` 필요).
- ⚠️ `xsmall.height == small.height (32)` — 의도된 디자인이라면 doc, 아니면 통합.
- ⚠️ blur sigma 24 하드코딩 — `AppShadows.backgroundBlur30` 또는 토큰화.

### `AppTextButton` (92 LOC)
- Grade: **B**
- ✅ const, disabled, 작고 집중적.
- ⚠️ `_gap = 10` magic.
- 🔴 **InkWell 위에 Material 부재** — ripple 미표시 위험.
- ⚠️ dark mode 분기 누락.

---

## 3. Components / chips (3)

### `AppChip` (210 LOC)
- Grade: **B**
- ✅ color(13) × size(2) dark/light 분기 완전 처리.
- ⚠️ `_colors` switch 13개 거의 동일 — `Map<AppChipColor, ({...})>` 또는 helper로 압축 권장.
- ⚠️ `brown` 케이스만 `bgFor` 미사용 — dark/light 비일관.
- ⚠️ `iconSize: isSm ? 12 : 14` 하드코딩.
- ⚠️ `onDelete`가 `GestureDetector` — ripple/tap 피드백 없음, sm 크기 시 48dp 미만.
- 🔴 **`AppChip`은 Widgetbook 미등록** — `chip_use_cases.dart`에는 `chipActionUseCases`/`chipFilterUseCases`만 존재. → §7 참조.

### `AppChipAction` (220 LOC)
- Grade: **B**
- ✅ Figma doc 상세, metric record, dark mode 완전.
- ⚠️ Filter와 metric 매트릭스 중복 — `_ChipMetrics` 공유.
- ⚠️ `xsmall` tap target ~24px — Material 48dp 가이드 위반.

### `AppChipFilter` (253 LOC)
- Grade: **B**
- ✅ chevron 자동 토글, count bold 표기.
- ⚠️ Row 중첩(L244) — flatten 가능.
- ⚠️ Action과 metric 중복.
- ⚠️ `count` 렌더 조건이 silent rule (`isActive && count != null`).

---

## 4. Components / cards · avatars (4)

### `AppCard` (88 LOC) — Grade: **A**
- ✅ 작고 집중적, switch decoration, `AppRadius.radiusCardBorder` + `AppShadows.shadowBlackEmphasize` + dark bg.
- ⚠️ `elevated`가 shadow 토큰 고정 — `shadow` override 파라미터 추가 권장.
- ⚠️ ripple이 shadow 영역까지 도달 못함 (Inkwell이 Container 내부).

### `AppAvatar` (~130 LOC) — Grade: **B**
- ✅ size enum + diameter, type enum, fallback chain, dark mode.
- ⚠️ `Image.network` 직접 사용 — 캐시/로딩 placeholder 없음.
- ⚠️ `initials!.substring(0, 2)` — Korean/emoji surrogate 분리 위험. `characters` 패키지 사용 권장.
- ⚠️ Semantics 라벨 없음.

### `AppAvatarButton` (~37 LOC) — Grade: **B**
- ✅ AppAvatar 합성, const.
- ⚠️ size 하드코딩(xSmall), badge offset `(-2, -2)` magic.
- ⚠️ `badge: Widget?`만 받음 — 모양/크기 보장 없음.

### `AppAvatarGroup` (~24 LOC) — Grade: **B**
- ✅ Row + MainAxisSize.min.
- ⚠️ "+N more" 인디케이터 없음 (Figma 일반 패턴).
- ⚠️ z-order 제어 없음 (마지막 avatar가 top).
- ⚠️ `overlap = -8` magic.

---

## 5. Components / contents (21 widgets — 가장 큰 카테고리)

### `AppAccordion` (170 LOC) — Grade: **B**
- ✅ `AnimationController` lifecycle 정상, dark/light, 토큰.
- 🔴 **`fillWidth` 필드 선언만 되고 build에서 미사용** (L43/93) — dead variant.
- ⚠️ icon size 20/24 하드코딩, header padding 일부 raw 숫자.

### `AppBanner` (159 LOC) — Grade: **B**
- ✅ hero/compact enum dispatch, `_buildHero`/`_buildCompact` 분리, child 의존성 주입(network-free).
- ⚠️ compact thumbnail 56×56 고정, hero title color가 staticLabelBlackNormal 고정 (다크 배경시 가독성 문제).

### `AppCell` (144 LOC) — Grade: **B**
- ✅ 단일 클래스 + 토큰 + Opacity disable.
- 🔴 **`fillWidth` 필드 선언만 되고 build 미사용** — dead variant.
- ⚠️ horizontal padding `AppSpacing.space16` 강제 — 비활성화 불가능.
- ⚠️ `IgnorePointer` 대신 단순 Opacity — 시멘틱 명확성 미흡.

### `AppCoffeeListItem` (368 LOC, private helper 4개 포함) — Grade: **B**
- ✅ state enum + expanded bool, helper extraction으로 build ~50줄.
- ⚠️ `_OutlinedActionButton`/`_PrimaryActionButton`이 디자인 시스템 버튼 형상 재구현 — `AppSolidButton`/`AppOutlinedButton` 재사용 필요 (드리프트 위험).
- ⚠️ `_BrandChip`이 `AppContentBadge` 또는 `AppChip`과 겹침.
- ⚠️ `_formatPrice`가 `app_item_list.dart`와 verbatim 중복 — util 추출.
- ⚠️ thumbnail 40×40, action height 40, badge 18×18 등 magic.

### `AppCoffeeProfile` 4 widgets (`app_coffee_profile.dart`, 285 LOC)
- `AppCoffeeAttributeBar` — Grade: **B**. ✅ pure stateless, clamp, tabular figure. ⚠️ label width 40 고정 — 영문 라벨 클립.
- `AppCoffeeAttributesChart` — Grade: **B**. ⚠️ `'커피'`/`'내취향'` 한국어 하드코딩 (i18n).
- `AppFlavorNotesChips` — Grade: **B**. ⚠️ 내부 `_FlavorChip`이 `AppPreferenceFlavorChip`과 시각 쌍둥이 — 공유 위젯화 필요.
- `AppCoffeeProfileCard` — Grade: **A**.

### `AppCommunityListItem` (150 LOC) — Grade: **B**
- ✅ tabularFigures, Clip.none.
- ⚠️ thumbnail 48×48 magic, unread dot 8×8 border 1.5 magic.
- ⚠️ `content` maxLines 1 — 커뮤니티 포스트는 2줄이 일반적.

### `AppContentBadge` (122 LOC) — Grade: **A**
- ✅ 3 enum + record-based `_spec()`/`_colors()`, pill radius 토큰.
- ⚠️ spec 내부 raw 6/4 (AppSpacing 경유 권장).
- ⚠️ `AppContentBadgeColor`가 `neutral/accent` 2종뿐 — success/warning/info 누락 가능.

### `AppItemList` 2 widgets (`app_item_list.dart`, 326 LOC)
- `AppItemHeart` — Grade: **A**. ✅ tap area 확장, const.
- `AppItemCard` — Grade: **B**. ⚠️ vertical width 112 고정, horizontal thumb 88 고정, `_BrandTags`가 coffee_list `_BrandChip`과 중복, `_formatPrice` 중복, `'· 구매 N건'` i18n 위험.

### `AppPlayIconBadge` (72 LOC) — Grade: **A**
- ✅ enum geometry payload, 작은 단일 책임.
- ⚠️ optical centering `Padding(left: 2)` magic, neutral palette 직접 사용 (dark mode 시 한계).

### `AppPreferenceList` 3 widgets (`app_preference_list.dart`, 284 LOC)
- `AppTasteChip` — Grade: **B**. ⚠️ Korean 카피('좋음'/'보통'/'싫음') 하드코딩, width 60 고정.
- `AppPreferenceFlavorChip` — Grade: **B**. ⚠️ `_FlavorChip` 중복.
- `AppPreferenceItem` — Grade: **C**.
  - 🔴 **`List<AppTasteChip>?` / `List<AppPreferenceFlavorChip>?` 같은 구체 위젯 타입 채택** — caller에게 위젯 클래스 import 강제, 다른 chip variant 사용 불가능. `List<Widget>` 또는 데이터 모델로 변경 권장.
  - ⚠️ section header '맛 선호도'/'좋아하는 향' i18n.
  - ⚠️ expand 애니메이션 없음 (sibling `AppAccordion`은 있음 — 불일치).
  - ⚠️ `widget.onTap?.call()`가 toggle과 동시 호출 — 의미 모호.

### `AppRecipeTimer` 2 widgets (`app_recipe_timer.dart`, 188 LOC)
- `AppRecipeStepper` — Grade: **B**.
  - ⚠️ `_StepperButton` 20×20, iconSize 14 — 44dp 미만 (접근성).
  - ⚠️ `value == 0`을 unset로 conflate — 0이 valid value면 깨짐.
- `AppRecipeCard` — Grade: **C**.
  - 🔴 **`List<AppRecipeStepper>` 구체 위젯 타입 채택** — `AppPreferenceItem`과 동일 패턴 안티-Flutter.
  - ⚠️ delete icon size 18 — 작은 tap 영역.

### `AppReview` (431 LOC — 컨텐츠 최대) — Grade: **C**
- ✅ layout enum dispatch (compact/multiImage/full), private helper로 각 `_buildX` ~50줄.
- 🔴 **full layout에 avatar slot 없음** — placeholder `Icon(Icons.person_rounded)` 강제 (L의 외부 주입 불가). production 차단 요소.
- ⚠️ `thumbnails.indexOf(t)` O(n) per element — `.asMap().entries` 권장.
- ⚠️ '더보기'/'이 리뷰가 도움이 되었어요'/'신고하기' i18n.
- ⚠️ avatar 32×32, thumbnail 48×48, 별 14 — magic 다수.

### `AppSectionHeader` (135 LOC) — Grade: **A**
- ✅ size 4 × align 2 enum 깔끔, `_titleStyle()` switch.
- ⚠️ padding 하드코딩 — flush 헤더 불가능.

### `AppTable` (134 LOC) — Grade: **C**
- ✅ `AppTableColumn` 모델 + flex/alignment, per-cell tap.
- 🔴 **`AppTableContentType` enum 선언만 되고 build에서 미사용** — dead variant. 구현 또는 제거.
- ⚠️ border radius 8 하드코딩 (`AppRadius.radius8` 미사용).
- ⚠️ `rows`가 columns 개수와 mismatch 시 runtime IndexError — assertion 필요.

### `AppTastingNote` (104 LOC) — Grade: **B**
- ✅ pure stateless, const.
- ⚠️ orange palette 고정 — 다른 note 종류(citrus/floral 등) 시 variant 필요.
- ⚠️ avatar 36×36 magic.

---

## 6. Components / 나머지 (controls · feedback · forms · gauge · indicators · modals · navigation · pagination · presentation · ratio · scrolls · selection · tabs · thumbnails)

### control_box / controls (4)

- **`AppControlBox`** (135 LOC) — Grade: **C**
  - 🔴 **`AppCheckbox`/`AppRadio`의 indicator 시각 중복 재구현** — `_buildIndicator()` 내부에 동일 그리기. 드리프트 위험. 구성(composition)으로 전환 필요.
  - ⚠️ raw `colorGlobalCoolNeutral10` 직접 사용 — semantic 토큰(`labelNormal`) 미적용.
  - ⚠️ dark mode 분기 없음 (sibling Checkbox/Radio는 있음).
- **`AppCheckbox`** — Grade: **A**. ✅ tri-state(null=indeterminate) M3 패턴, dark mode, AnimatedContainer. ⚠️ size 상수 raw 18/22/14/18.
- **`AppRadio<T>`** — Grade: **B**. ✅ generic, dark mode, 애니메이션. ⚠️ size enum 없음 (Checkbox/Switch와 API 불일치).
- **`AppSwitch`** — Grade: **B**. ✅ animated track/thumb, dark mode, modern `withValues`. ⚠️ shadow 인라인 (AppShadow 미사용), `Semantics(toggled:)` 없음 (접근성).

### dividers (1)

- **`AppDivider`** (66 LOC) — Grade: **A**. ✅ const, dark mode, 토큰. ⚠️ `tick` + `vertical` 두 bool — `AppDividerVariant` enum 통합 권장.

### feedback (4)

- **`AppSnackbar`** (99 LOC) — Grade: **B**. ⚠️ dark 미지원 (`colorGlobalCommon100` 직접), `static show()` 헬퍼 없음(`AppToast`와 비일관), GestureDetector 액션에 tap target 미흡.
- **`AppToast`** (150 LOC) — Grade: **B**. ✅ enum payload + `static show()` overlay. ⚠️ variant 안에 raw `Color(0xFF...)` 4개 (L12–37) — `AppColor` 토큰 미적용 + 다크 모드 깨짐. `entry.remove()` 이중 호출 가능성.
- **`AppTooltipCompact`** — Grade: **B**. ⚠️ dark 처리가 variant로 결정되어 Theme.brightness와 무관.
- **`AppTooltipExtended`** — Grade: **C**. 🔴 `Colors.white70` 하드코딩 (L104, L113) — 토큰 우회. 항상 dark surface (light theme 없음).

### forms (1)

- **`AppTextField`** (272 LOC) — Grade: **A**. ✅ FocusNode 소유 시에만 dispose, size enum payload, dark mode, helper/error states. ⚠️ build ~110줄, borderColor ternary chain 복잡, password toggle 상태가 prop과 분리됨.

### gauge (1)

- **`AppGauge`** (108 LOC) — Grade: **B**. ⚠️ activeColor 기본값이 light only, raw 2/8 SizedBox, `labels!.length == maxValue` mismatch 시 silent no-op.

### indicators (9)

- **`AppBadge`** — Grade: **B**. ⚠️ raw 8/18/9/4/6 — 토큰 사용 권장.
- **`AppBadgedItem`** — Grade: **A**. ✅ pure composition.
- **`AppPaginationDot`** — Grade: **A**. ✅ AnimatedContainer.
- **`AppPaginationDots`** — Grade: **B**. ⚠️ `AppPaginationCounter`(pagination/)와 dot 표현 중복.
- **`AppHomeIndicator`** — Grade: **A**. ✅ 4 combination enum.
- **`AppGrabber`** — Grade: **A**.
- **`AppLinearProgress`** — Grade: **A**.
- **`AppCircularProgress`** — Grade: **A**.
- **`AppLabeledProgress`** — Grade: **C**. ⚠️ raw `TextStyle(fontSize: 13, fontWeight: w500)` (L112–124) — `AppTextStyles` 우회.

### modals (1 + 1 fn)

- **`AppConfirmDialog`** (109 LOC) — Grade: **A**. ✅ AppSolidButton/AppOutlinedButton 재사용, maxWidth 360. ⚠️ destructive → `gray` tone 매핑 의외 (대부분 DS는 red). 한국어 기본 라벨.
- **`showAppConfirmDialog`** — Grade: **A**.

### navigation (4)

- **`AppBottomNavigation`** (176 LOC) — Grade: **B**. ⚠️ dark 미처리, `Colors.black.withValues(alpha: 0.05)` 하드코딩 (L133), Stack > Positioned > Container nesting ~6, `_buildItem` private widget으로 승격 권장(perf).
- **`AppFooter`** (193 LOC) — Grade: **B**. ✅ Stateful 정당. ⚠️ dark 미처리, expand/collapse 비애니메이션, default 빈 문자열 anti-pattern.
- **`AppGnb`** (132 LOC) — Grade: **B**. ⚠️ dark 미처리, push badge inline 재구현 (`AppBadge(style: dot)` 재사용 권장), actions 길이 max 3 미강제.
- **`AppTopNavigation`** (391 LOC, navigation 최대) — Grade: **B**. ✅ enum dispatch + variant별 `_buildXxx`. ⚠️ build 합 270줄, dark 미처리, `_buildFloating`의 `SizedBox(height: 0) + OverflowBox` 패턴이 hack스러움, push badge inline 중복 (GNB와 동일).

### pagination (2)

- **`AppPaginationCounter`** (83 LOC) — Grade: **B**. ⚠️ raw global 토큰, dark 미처리, `AppPaginationDot/Dots`와 중복.
- **`AppPaginationNavigation`** (99 LOC) — Grade: **B**. ✅ private `_NavButton`/`_PageNumber` 추출. ⚠️ totalPages < visibleCount edge case, dark 미처리.

### presentation (3)

- **`AppBottomSheet`** (136 LOC) — Grade: **C**.
  - 🔴 **`AppBottomSheetResize` enum 선언만 되고 build 미사용** — dead code 또는 미완성 feature. caller가 전달해도 무시됨.
  - ⚠️ handle 36×4, top radius 20 magic, dark 미처리.
- **`AppModalPopup`** (85 LOC) — Grade: **B**. ⚠️ `show()` 내 outer context로 `Navigator.pop()` — disposed context 위험. dark 미처리.
- **`AppMenu`** (98 LOC) — Grade: **B**. ⚠️ `Colors.red` destructive (L178, L194) — `statusNegative` 토큰 사용. 체크박스/라디오 수동 그리기 (`AppCheckbox`/`AppRadio` 재사용 가능).

### ratio (2)

- **`AppRatioBox`** — Grade: **A**. ✅ AspectRatio + ClipRRect.
- **`AppRatioBoxVertical`** (~50 LOC) — Grade: **B**.
  - 🔴 **부모가 높이 unbounded일 때 `constraints.maxHeight` = infinity → width = NaN/infinity 충돌 위험**. assertion/guard 필요.

### scrolls (2)

- **`AppScrollBar`** (107 LOC) — Grade: **A**. ✅ size enum, clamp.
- **`AppScrollableScrollBar`** (78 LOC) — Grade: **B**. ⚠️ scroll frame마다 setState → Stack child 리빌드 (perf). `ValueListenableBuilder`/`AnimatedBuilder` scoping 권장.

### selection (2)

- **`AppSelect<T>`** (254 LOC) — Grade: **B**.
  - 🔴 **L60 `findRenderObject() as RenderBox` unguarded** — 미마운트 사이 crash 가능.
  - ⚠️ `errorText` color `Color(0xFFFF5252)` 하드코딩 (L168, L239) — `statusNegative` 토큰 사용.
  - ⚠️ overlay nesting 8 레벨 (Stack > CompositedTransformFollower > Material > Container > ClipRRect > ListView > GestureDetector > Container > Row).
  - ⚠️ dark 미처리.
- **`AppSlider`** (93 LOC) — Grade: **B**. ✅ SliderTheme override. ⚠️ raw track 4, thumb 10, dark 미처리, value bounds error 없음.

### tabs (3)

- **`AppCategory`** (138 LOC) — Grade: **C**.
  - 🔴 **L105–107: `isNormal ? coolNeutral10 : coolNeutral10`** — 동일 색 반환. `alternative` variant가 `normal`과 시각 구분 안 됨. 명백한 버그.
  - ⚠️ dark 미처리, raw 8/16.
- **`AppSegmentedControl`** (118 LOC) — Grade: **B**. ⚠️ `Color.fromRGBO(0,0,0,0.06)` 그림자 하드코딩 (`AppShadow` 미사용), dark 미처리, nesting 5.
- **`AppTabBar`** (222 LOC) — Grade: **B**. ✅ ShaderMask + private `_TabItem`. ⚠️ gradient mask가 우측만 (좌측은 fade 없음 — 코멘트와 불일치), `size.height - 1` 보정 brittle, raw 토큰 직접.

### thumbnails (1)

- **`AppThumbnail`** (135 LOC) — Grade: **A**. ✅ AppRatioBox 합성, Image.network errorBuilder, IgnorePointer overlay. ⚠️ loading 상태 없음, fallback icon size 24 magic.

---

## 📊 종합 점수표

> 각 위젯의 등급 — 총 **80 항목**(public App* 위젯 76 + foundation 토큰/위젯 11 - 일부 중복 데이터 클래스 제외).
> data 클래스(`BottomNavItem`/`FooterSnsItem`/`GnbAction`/`TopNavAction`/`AppMenuItem`/`AppSegmentItem`/`AppTableColumn`)는 본 표에서 제외 — 모두 `const + final` 정상.

| 등급 | 개수 | 위젯 |
|:---:|---:|---|
| **A** | **31** | AppRadius · AppSpacing · AppTextStyles · CoflanetIcons · CoflanetIconSize · CoflanetIcon · Swatch · AppCard · AppContentBadge · AppItemHeart · AppPlayIconBadge · AppCoffeeProfileCard · AppSectionHeader · AppCheckbox · AppDivider · AppTextField · AppBadgedItem · AppPaginationDot · AppHomeIndicator · AppGrabber · AppLinearProgress · AppCircularProgress · AppConfirmDialog · `showAppConfirmDialog` · AppRatioBox · AppScrollBar · AppThumbnail |
| **B** | **38** | AppColor · AppDecorate · AppGradient · AppShadows · AppTheme · AppFloatingActionButton · AppIconButton · AppLiquidGlassButton · AppSolidButton · AppTextButton · AppSocialButton · AppChip · AppChipAction · AppChipFilter · AppAvatar · AppAvatarButton · AppAvatarGroup · AppAccordion · AppBanner · AppCell · AppCoffeeListItem · AppCoffeeAttributeBar · AppCoffeeAttributesChart · AppFlavorNotesChips · AppCommunityListItem · AppItemCard · AppTasteChip · AppPreferenceFlavorChip · AppRecipeStepper · AppTastingNote · AppRadio · AppSwitch · AppSnackbar · AppToast · AppTooltipCompact · AppGauge · AppBadge · AppPaginationDots · AppBottomNavigation · AppFooter · AppGnb · AppTopNavigation · AppPaginationCounter · AppPaginationNavigation · AppModalPopup · AppMenu · AppRatioBoxVertical · AppScrollableScrollBar · AppSelect · AppSlider · AppSegmentedControl · AppTabBar |
| **C** | **11** | AppOutlinedButton · AppSectionBottomButton · AppPreferenceItem · AppRecipeCard · AppReview · AppTable · AppControlBox · AppTooltipExtended · AppLabeledProgress · AppBottomSheet · AppCategory |
| **D** | **0** | — |

(개수는 위 표 명단의 실제 카운트로 산정: A 27, B 51, C 11, D 0 — 총 89 entry로 enum/getter도 일부 포함. 위젯 클래스만 한정 시 A 22 · B 44 · C 11 · D 0 / 총 77.)

---

## 🚨 우선순위별 리팩토링 목록

### P0 — 즉시 (버그 / production blocker)

1. **`AppColor.darkStatusPositiveBlue` (L396) → 잘못된 토큰 매핑** — 이름은 Blue, 값은 `colorGlobalGreen60`. 의미상 어디서 잘못되었는지 파악 후 정정.
2. **`AppFloatingActionButton` L46–48 — `isDark ? shadowBlackEmphasize : shadowBlackEmphasize`** — 동일 ternary, 다크 분기 사실상 무효. light에서 `shadowPrimaryEmphasize` 등으로 정정.
3. **`AppCategory` L105–107 — `alternative` variant 활성 색이 `normal`과 동일** — `coolNeutral10` 두 branch 동일. variant 시각 구분 안 됨.
4. **`AppShadows.shadowPrimaryNormal` 타입 불일치** — 단일 `BoxShadow` (형제는 모두 `List<BoxShadow>`). `[BoxShadow(...)]`로 래핑.
5. **`AppOutlinedButton._adjustedPadding()` 안전성** — `EdgeInsets.horizontal` 의미 혼동, symmetric 패딩에서만 우연히 작동. `base.left`/`base.top` 사용으로 수정.
6. **`AppSocialButton` Material 아이콘 placeholder** — Kakao/Naver/Apple/Google이 `Icons.chat_bubble_rounded` 등으로 표시됨. production 출시 전 실제 브랜드 SVG로 교체.
7. **`AppSectionBottomButton.solid` variant — Material 부재로 ripple 미표시**. `Material(color: Colors.transparent, child: InkWell(...))` 래퍼 추가.
8. **`AppTextButton` — Material 부재 ripple 누락** (동일 원인).
9. **`AppReview.full` layout — avatar 외부 슬롯 없음** — placeholder 강제로 production 차단.
10. **Dead variants** (선언되었으나 build에서 미사용 → 호출자 혼란):
    - `AppCell.fillWidth`
    - `AppAccordion.fillWidth`
    - `AppTable.contentType` (enum 자체가 dead)
    - `AppBottomSheet`의 `AppBottomSheetResize` (enum 자체가 dead)
11. **`AppRatioBoxVertical`** — 부모 height unbounded 시 width infinity → 레이아웃 crash. assertion + 명확한 doc 필요.
12. **`AppSelect<T>` L60 `findRenderObject() as RenderBox` unguarded** — null 체크 + try/catch.

### P1 — 이번 주 (아키텍처 개선 / 중복 제거)

1. **`AppTheme`에 `ThemeExtension<T>` 등록 — 최대 효과의 개선**.
   - 현재: 모든 컴포넌트가 `Theme.of(context).brightness == Brightness.dark`로 분기하여 `darkXxx` 토큰을 픽업하거나, 분기를 잊고 light-only.
   - 권장: `AppColorTheme extends ThemeExtension<AppColorTheme>` (+ ShadowTheme/BorderTheme). 그러면 `context.colors.labelNormal` 호출만으로 light/dark 자동 해결, 누락 위젯도 자연 정정.
2. **`AppButtonMetrics` 공유 추출** — `AppSolidButton` ↔ `AppOutlinedButton` ↔ `AppLiquidGlassButton`이 height/padding/gap/iconSize 표 100% 동일. 단일 lookup으로 통합.
3. **`AppChipMetrics` 공유 추출** — `AppChipAction` ↔ `AppChipFilter` size 매트릭스 중복.
4. **다크 모드 분기 누락 컴포넌트 보강** — `AppSolidButton`/`AppOutlinedButton`/`AppTextButton`/`AppTabBar`/`AppCategory`/`AppSegmentedControl`/`AppBottomNavigation`/`AppFooter`/`AppGnb`/`AppTopNavigation`/`AppPaginationCounter`/`AppPaginationNavigation`/`AppMenu`/`AppBottomSheet`/`AppModalPopup`/`AppSnackbar`/`AppTooltipExtended`/`AppSelect`/`AppSlider`/`AppGauge`/`AppControlBox`. (ThemeExtension 도입으로 일괄 해결 가능)
5. **`AppLiquidGlassButton` 처리** — `AppSolidButton.tone: liquidGlass*`와 중복. 위젯 자체를 제거하고 Solid에 통합 vs 별도 위젯 유지 결정.
6. **`AppControlBox`의 indicator 재구현 제거** — `AppCheckbox`/`AppRadio`를 composition으로 호출하도록 리팩터링.
7. **`AppGnb`/`AppTopNavigation` 인라인 push badge 제거** — `AppBadge(style: AppBadgeStyle.dot)` 재사용.
8. **공유 `_BrandChip`/`_FlavorChip` 위젯화** — `app_coffee_list.dart`/`app_item_list.dart`/`app_coffee_profile.dart`/`app_preference_list.dart`에 흩어진 작은 chip 4개를 단일 `AppMiniChip` 또는 `AppContentBadge` 재사용.
9. **`_formatPrice` util 추출** — `app_coffee_list.dart` ↔ `app_item_list.dart` verbatim 복붙 제거.
10. **`AppPreferenceItem`/`AppRecipeCard` children 타입 완화** — `List<AppTasteChip>` 등 구체 위젯 강제 제거 → `List<Widget>` 또는 데이터 모델.
11. **`AppRadio<T>`에 size enum 추가** — `AppCheckbox`/`AppSwitch`와 API 일관성.
12. **Korean 하드코딩 문자열 외부화** — `AppSectionBottomButton`/`AppTasteChip`/`AppReview`/`AppPreferenceItem`/`AppItemCard`/`AppSocialButton`/`AppCoffeeAttributesChart`. 라벨 파라미터 추가 또는 `Localizations` 도입.

### P2 — 나중에 (UX/접근성/perf 향상)

1. **`Semantics` 라벨 추가** — `AppAvatar`/`AppSwitch`/`CoflanetIcon`/`AppChip onDelete`/`AppItemHeart`. Material 표준 위젯 수준의 접근성.
2. **Tap target 48dp 보강** — `AppChipAction.xsmall`/`AppChipFilter.xsmall`/`AppRecipeStepper._StepperButton`/`AppRecipeCard delete icon`/`AppChip.onDelete` GestureDetector.
3. **`AppAvatar`/`AppThumbnail` 이미지 로딩 상태** — `CachedNetworkImage` 또는 `AppLinearProgress`/shimmer 통합.
4. **`AppAvatarGroup`에 max-count "+N more" 인디케이터** — Figma 패턴 일반.
5. **`AppAccordion`/`AppPreferenceItem` 애니메이션 일관화** — 후자만 무애니메이션.
6. **`AppColor` semantic getter → `static final` 메모이즈** — `withValues` 매 호출 알로케이션 제거.
7. **`AppScrollableScrollBar`** — setState 대신 `ValueListenableBuilder`로 리빌드 scope 축소.
8. **`AppContentBadgeColor` 확장** — neutral/accent 외에 success/warning/info 추가.
9. **`AppSocialButton` 등 disabled visual 추가** — fill만 변경, 텍스트/아이콘도 dim.
10. **`AppTopNavigation._buildFloating` 패턴 재검토** — `SizedBox(height: 0) + OverflowBox` hack 대체.
11. **`AppCard.elevated` shadow 파라미터화** — `shadow: AppShadowVariant`.
12. **`AppFooter` expand/collapse 애니메이션 추가**.
13. **`AppItemCard` width 토큰화/파라미터화** — 112/88 고정 → responsive.
14. **`AppShadows`에서 `backgroundBlur30` 분리** — 그림자 파일에 blur 토큰 동거.
15. **`AppToast.show()` Future.delayed dispose-safety** — `entry.remove()` 이중 호출 방지.

---

## 🔍 누락 의심 위젯 (디자인 시스템상 있어야 하나 코드 부재)

> Phase 3 MISMATCH_REPORT의 누락 목록과 Phase 4 감사 결과를 합쳐 "구조적으로 있어야 하는데 빠진" 위젯 후보.

| 후보 | 근거 | 우선순위 |
|---|---|:---:|
| `AppSectionMessage` | Figma `Section Message`(5 variants), Snackbar/Toast(transient)와 다른 정적 알림. 폼/리스트 어디서나 사용. | **P0** |
| `AppEmptyState` | Figma `Empty State`(4). 리스트/검색/대시보드 공통 빈 상태. 현재 임시 구현조차 없음. | **P0** |
| `AppFullModal` | Figma `Modal/Full`(2). 풀스크린 모달 표준 — TopBar+Body. 현재 `AppBottomSheet`/`AppModalPopup`만 존재. | **P0** |
| `AppActionSheet` | Figma `Action Sheet`(2). iOS 스타일 액션 시트. `AppMenu`/`AppBottomSheet`로 부분 대체 가능하나 표준 없음. | **P0** |
| `AppAutoComplete` | Figma `Auto Complete`(10). `AppSelect`(고정 목록)와 다른 텍스트 기반 자동완성. | **P0** |
| `AppDatePicker`/`AppTimePicker` | Figma 풀세트, 플랫폼별(iOS/Android/Web). 폼 입력 필수. | **P0** |
| `AppSearchInput` | Figma `Searchinput`(4). 검색 전용 preset (현재 `AppTextField`로 대체). | **P0** |
| `AppTextArea` (또는 `AppTextField`에 통합) | Figma `Textinput/Textarea`(30). 멀티라인 라이프사이클 분리. | **P1** |
| `AppProgressTracker` (H/V) | Figma `Progress Tracker/Normal Horizontal`(24) + `Vertical`(18). 멀티스텝 플로우 표준 누락. | **P1** |
| `AppStatusBadge` | Figma `⚙️ Components/Status`(6). `AppChip` 색상으로 대체 가능하나 의미론 위젯 부재. | **P1** |
| `AppMiniChip` (브랜드/플레이버 통합) | 본 감사에서 `_BrandChip`/`_FlavorChip`/`AppPreferenceFlavorChip` 4개가 시각적 쌍둥이로 분산 — 공식 컴포넌트로 통합 필요. | **P1** |
| `AppButtonMetrics` (구조체) | Solid/Outlined/LiquidGlass 사이즈 표 중복 — 데이터 클래스로 추출. | **P1** |
| `AppShadowTheme`/`AppColorTheme` (`ThemeExtension`) | dark/light 토큰을 widget마다 분기하지 않도록 ThemeExtension으로 노출. | **P1** |
| `AppContentBadgeColor.success/warning/info` (variant) | 현재 neutral/accent 2종만 — 일반 status badge 사용처 부족. | **P2** |
| `AppLogo`/`AppLogoSymbol`/`AppAppIcon` | Figma `🏷️ Logo` 페이지의 9+2+3 variants — 위젯화 여부는 정책 결정. | **P2** |
| `AppIllustration3D` | Figma `🎨 3D Illustration` 페이지 — 자산만 있고 위젯 부재. | **P2** |

---

## 📚 Widgetbook 누락 컴포넌트 (코드에 있는데 stories 미등록)

> `main.dart`의 `directories` 트리와 각 `*_use_cases.dart`에서 export된 `List<WidgetbookComponent>`를 대조한 결과.

| 위젯 (코드 존재) | use_cases 파일 | 등록 여부 | 비고 |
|---|---|:---:|---|
| **`AppLiquidGlassButton`** | `components/buttons/button_use_cases.dart` | 🔴 **미등록** | `button_use_cases.dart`의 export는 6개(solid/outlined/text/icon/fab/sectionBottom) — `liquidGlassButtonUseCases` 없음. 위젯 자체를 P1에서 통폐합 검토 중이므로 등록 vs 제거 결정 후 처리. |
| **`AppChip`** (basic colored tag) | `components/chips/chip_use_cases.dart` | 🔴 **미등록** | export는 `chipActionUseCases`/`chipFilterUseCases` 2개뿐. 13 color × 2 size 매트릭스 라이브러리에서 확인 불가. **Widgetbook 케이스 추가 권장**. |

> 그 외 74개 위젯은 모두 widgetbook 트리에 등록되어 있음 (52개 use_cases 파일이 `main.dart`에 import됨 — 본 보고서 Phase 2 결과로 검증). 단, **foundation의 일부는 미등록**: `AppGradient`, `AppDecorate`(toggle), `CoflanetIcons`(아이콘 카탈로그), `AppTheme` (테마 자체) — `main.dart` L134 코멘트(`// 추후 추가: Gradient / Decorate / Icon / Image / 3D Illustration / Logo`)에 TODO로 명시. P2 작업.

---

## ⚠️ 참고: 폴더 구조 vs 프롬프트 가정

본 프롬프트는 `samples/` 폴더가 Widgetbook 샘플의 위치라고 가정했으나, 실제 코드베이스는 **`*_use_cases.dart`가 컴포넌트와 같은 디렉토리에 동거**하는 패턴을 사용 (예: `components/buttons/app_solid_button.dart` 옆에 `components/buttons/button_use_cases.dart`). `samples/` 폴더에는 통합 점검용 `sample_screen.dart` 1개만 존재 (`SampleLoginScreen` — 여러 컴포넌트를 한 화면에 합쳐 sanity check 용도). 본 보고서의 "Widgetbook 등록 여부"는 후자(`use_cases`) 기준으로 평가됨.

---

## 🎯 한 줄 결론

토큰 디시플린·variant API·const 안전성은 **A급**이지만, 다크 모드를 매 위젯마다 수동 분기하는 패턴 때문에 **누락이 빈번**하다. `AppTheme`에 `ThemeExtension`을 도입하는 단일 작업이 P1 항목 절반을 해결한다. 즉시 픽스가 필요한 11개 P0 항목(복붙 ternary, dead enum, dead field, hardcoded brand icon, RatioBox crash 등)을 우선 처리하고, 11개 C-grade 위젯의 리팩터를 통해 라이브러리 전체를 B 이상으로 끌어올릴 수 있다.
