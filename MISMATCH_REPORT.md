# Figma ↔ Flutter Code Mismatch Report (Phase 3/5)

- **소스**:
  - `FIGMA_INVENTORY.md` — Figma file `q7yBPcHrid1CGQqFWEPwnR` ([📚 Library](https://www.figma.com/design/q7yBPcHrid1CGQqFWEPwnR)) · 페이지 39개 · 단일 Components 55 · Component Sets 378
  - `CODE_INVENTORY.md` — `Library/component_lab/lib/` · 76개 공개 App* 위젯 · 59개 컴포넌트 enum
- **대조 정책**:
  - Figma `Resource/*`, `_Resource/*`, `*Resource/Knob` 등 **내부 빌딩 블록**은 매칭 대상에서 제외 (디자이너 전용 구조)
  - Figma `Icon/*` 160개 ComponentSet은 코드에서 단일 `CoflanetIcons` 토큰 클래스 + 개별 SVG asset path로 매핑 → 항목별 1:1 비교는 의미가 없으므로 묶음 비교
  - 페이지 구분선(`-----------` 등 6개), 빈 카테고리 헤더 페이지(`🛠️ Foundation`/`🧩 Components`/`⚙️ Molecular`/`🎨 Image`) 4개, `Archive`, `🗂️ 피그마 파일관리 규칙` 페이지는 비교 대상에서 제외

---

## 1. 🔴 누락 (Figma에 있는데 코드에 없음)

> Figma에는 존재하나 `Library/component_lab/lib/components/` 또는 `foundation/`에 대응 위젯이 없는 항목.

### P0 — 핵심 UX (사용자 직접 노출, 즉시 구현 권장)

- [ ] `2546:37608` **Section Message** (variants: 5)
  - 위치: 🪞 Feedback
  - 추정: 인라인 알림 메시지(에러/경고/안내). `AppSnackbar`/`AppToast`와 다른 정적 컨테이너.
  - 예상 경로: `Library/component_lab/lib/components/feedback/app_section_message.dart`
- [ ] `2546:38093` **Empty State** (variants: 4)
  - 위치: 🪞 Feedback
  - 추정: "데이터 없음" 일러스트+텍스트+CTA — 리스트/검색 결과 공통 빈 상태.
  - 예상 경로: `Library/component_lab/lib/components/feedback/app_empty_state.dart`
- [ ] `2546:93990` **Modal/Full** (variants: 2)
  - 위치: 📣 Presentation
  - 추정: 풀스크린 모달 (TopBar+Body). 현재 `AppBottomSheet`/`AppModalPopup`만 존재.
  - 예상 경로: `Library/component_lab/lib/components/presentation/app_full_modal.dart`
- [ ] `2546:94872` **Action Sheet** (variants: 2)
  - 위치: 📣 Presentation
  - 추정: iOS 스타일 액션 시트. `AppMenu`/`AppBottomSheet`와 별개.
  - 예상 경로: `Library/component_lab/lib/components/presentation/app_action_sheet.dart`
- [ ] `2546:94667` **Auto Complete** (variants: 10) + Resource Cell (10)
  - 위치: 📣 Presentation
  - 추정: 입력 텍스트 기반 자동완성 드롭다운. `AppSelect`(고정 목록)와 다름.
  - 예상 경로: `Library/component_lab/lib/components/presentation/app_auto_complete.dart`
- [ ] `2523:152041` **Date Picker/Web** (6) + Android (3) + iOS (2) + Resource Knob/Range
  - 위치: ☑️ Selection and 📝 Input
  - 추정: 날짜 선택 컴포넌트. 코드에 일체 없음.
  - 예상 경로: `Library/component_lab/lib/components/selection/app_date_picker.dart`
- [ ] `2523:151660` **Time Picker/Web** (4) + Android (3) + iOS (1) + Common (1)
  - 위치: ☑️ Selection and 📝 Input
  - 추정: 시간 선택 컴포넌트.
  - 예상 경로: `Library/component_lab/lib/components/selection/app_time_picker.dart`
- [ ] `2523:155072` **Searchinput** (variants: 4)
  - 위치: ☑️ Selection and 📝 Input
  - 추정: 검색 전용 텍스트필드. 현재 `AppTextField`로 대체는 가능하지만 별도 디자인 토큰/preset 존재.
  - 예상 경로: `Library/component_lab/lib/components/forms/app_search_input.dart`
- [ ] `2523:153573` **Textinput/Textarea** (variants: 30)
  - 위치: ☑️ Selection and 📝 Input
  - 추정: 멀티라인 텍스트 영역. `AppTextField(maxLines>1)`로 부분 커버되나 Figma는 별도 컴포넌트셋으로 분리.
  - 예상 경로: 신규 위젯 또는 `app_text_field.dart`에 `AppTextArea` 추가

### P1 — 보조 UX

- [ ] `2563:339896` **Progress Tracker/Normal Horizontal** (variants: 24)
- [ ] `2563:340375` **Progress Tracker/Normal Vertical** (variants: 18)
  - 위치: ⏳ Progress Indicators
  - 추정: 단계형 stepper (1→2→3 진행 표시). `AppLinearProgress`/`AppGauge`와 다른 멀티-step UI.
  - 예상 경로: `Library/component_lab/lib/components/indicators/app_progress_tracker.dart`
- [ ] `2411:28628` **Step** (variants: 4) + `2411:28648` Step (single)
  - 위치: ⏳ Progress Indicators
  - 추정: Progress Tracker의 개별 step 셀.
- [ ] `2442:16181` **Indicator** (variants: 57)
  - 위치: 💡 Indicators
  - 추정: 다양한 인디케이터 컬렉션(로딩 스피너 등). 일부는 `AppLinearProgress`/`AppCircularProgress`/`AppBadge`로 매핑되지만 57개 variant 전수 검증 필요.
- [ ] `2523:155563` **Input/Check Mark** (variants: 16) + `2523:155996` Control/Check Mark (16)
  - 위치: ☑️ Selection and 📝 Input
  - 추정: 체크 표시(✓) 아이콘 자체의 시각 토큰. 코드에는 `AppCheckbox` 내부 그리기로 흡수됨 → 별도 노출 안 됨.
- [ ] `2523:156094` **Control/Toggle Icon** (variants: 2)
  - 위치: ☑️ Selection and 📝 Input
  - 추정: 토글 on/off 아이콘. `AppSwitch`에 내장.
- [ ] `2538:36978` **Check Box with img** (variants: 8)
  - 위치: 🕹️ Control Box
  - 추정: 이미지가 포함된 체크박스 셀. `AppControlBox`는 텍스트+subtitle만 받으므로 image variant 추가 필요.
- [ ] `2576:63722` **BottomSheet_CTA** (variants: 7)
  - 위치: ⏹️ Button
  - 추정: BottomSheet 하단의 1~2 버튼 영역 preset. 코드에서는 `AppBottomSheet` + 수동 버튼 조합으로 처리.
  - 예상 경로: `Library/component_lab/lib/components/buttons/app_bottom_sheet_cta.dart` 또는 `AppBottomSheet` factory

### P2 — 브랜드 / 일러스트 / 시스템

- [ ] `2411:28944` **Logo** (variants: 9), `2549:124955` **Logo_Symbol** (2), `2773:35041` **Logo/Cpay** (3)
- [ ] `2562:97631` **Logo_Element**, `3374:17104` **App Icon`
  - 위치: 🏷️ Logo
  - 추정: 브랜드 로고/앱 아이콘. 코드에 widget 없음 (아마 assets/만 보유). 위젯화 여부는 정책 결정 필요.
- [ ] `3382:428` **Illust/3D Icon** (variants: 4), `3385:295` **Illust/Char/Normal** (4)
- [ ] `3385:291` **Illust/Char/Gift**, `3385:293` **Illust/Char/Drink Coffee**
  - 위치: 3️⃣ 3D Illustration
  - 추정: 3D 일러스트 자산. 코드 위젯 없음.
- [ ] `2941:703` **Coffee Draft**
  - 위치: ☕️ Product
  - 추정: 제품 일러스트.
- [ ] `2488:10508` **Price** (variants: 8)
  - 위치: 🔠 Typography
  - 추정: 가격 표기 전용 텍스트 컴포넌트(Tabular numeric 포함). 코드는 `AppTextStyles.bodyXXTabular` 토큰만 노출 — 위젯 없음.
- [ ] `2411:5339` **Decorate** (Colors 페이지, variants: 15)
  - 위치: 🎨 Colors
  - 추정: Color page의 데코레이션 토큰 변형. `AppDecorate`(💅 Decorate 페이지 토큰)와 별도. 검증 필요.
- [ ] `2739:33220` **Background** (6) + `3167:101530` **Background/Liquid Glass** (4)
  - 위치: 💅 Decorate
  - 추정: 배경 효과 (blur/glass) 토큰. 코드에서는 각 버튼/카드에 inline 구현 — 공통 위젯 없음.
- [ ] `3049:35002` **Layout**, `2485:8917` **Safe Area/Status** (3), `2485:8929` **Safe Area/Bottom** (3)
  - 위치: 📐 Space
  - 추정: 레이아웃 가이드/safe area visualizer. 코드는 `AppSpacing` 토큰 + Flutter 기본 `SafeArea` 사용 — 별도 위젯 없음. **위젯화 불필요할 수 있음**.
- [ ] `2639:8659` **Charge_List**, `2639:8636` **Charge**, `2639:8995` **Duration**, `2639:9104` **⭐️ Title** (2), `2697:19419` **Status** (6), `3113:25390` **Background** (2), `3113:25296` **📺 Thunmbnail** (2)
  - 위치: ⚙️ Components 페이지
  - 추정: **디자인 내부 관리용** 컴포넌트(피그마 파일 셀프-라벨링 위젯). 프로덕션 UI가 아닐 가능성 높음 — 위젯화 불필요.
- [ ] `2925:199` **Comments** (variants: 2)
  - 위치: 🗂️ 피그마 파일관리 규칙
  - 추정: 피그마 코멘트 마커. 위젯화 불필요.

### 🔢 누락 누계 (대표 항목만)

| 카테고리 | 대표 누락 컴포넌트 | 합계 (variants) |
|---|---|---:|
| Feedback | Section Message, Empty State | 9 |
| Presentation | Full Modal, Action Sheet, Auto Complete | 14 |
| Selection/Input | Date Picker, Time Picker, Textarea, Searchinput | 88 |
| Progress | Progress Tracker (H/V), Step, Indicator-57 | 103 |
| Control | Check Box with img, Check Mark, Toggle Icon | 42 |
| Brand/Illust | Logo(15), 3D Illust(10), Coffee Draft, App Icon | ~26 |
| Typography 위젯 | Price | 8 |
| Background/Layout 토큰 위젯 | Background(10), Layout, Safe Area | ~15 |

---

## 2. ⚠️ 추가 (코드에 있는데 Figma에 없음)

### 자체 추가/확장으로 추정되는 위젯

- [ ] `components/chips/app_chip.dart` **`AppChip`** (13 colors × 2 sizes)
  - Figma `🍪 Chip` 페이지에는 `Chip/Action`(24), `Chip/Filter`(64)만 존재. 기본 컬러 태그 칩은 Figma에 별도 ComponentSet 없음.
  - 추정 원인: Action/Filter와 별개로 단순 라벨용 칩이 필요해서 자체 추가. **Figma에 reverse-sync 필요** 가능.
- [ ] `components/buttons/app_liquid_glass_button.dart` **`AppLiquidGlassButton`** (3 sizes)
  - Figma에는 별도 `Button/LiquidGlass` ComponentSet이 **없음**. LiquidGlass는 `Button/Solid/*`/`Button/Icon/*`의 tone variant로 통합되어 있음 (`Button/Solid/LiquidGlass Primary`, `LiquidGlass` 등).
  - 추정 원인: Solid 버튼 위에 별도 추상화로 추출한 변형. **`AppSolidButton`의 LiquidGlass tone과 중복** → 통합 후보.
- [ ] `components/indicators/app_progress.dart` **`AppLinearProgress`, `AppCircularProgress`, `AppLabeledProgress`**
  - Figma `⏳ Progress Indicators` 페이지에는 단계형 `Progress Tracker`/`Step`만 있음. 선형/원형 progress bar 컴포넌트셋은 없음.
  - 추정 원인: Material/Cupertino 표준 progress가 필요해서 자체 추가.
- [ ] `components/indicators/app_indicators.dart` **`AppBadgedItem`** (wrapper helper)
  - 단순 child + badge 합성 위젯. Figma에는 layout pattern일 뿐, ComponentSet 없음. **헬퍼 위젯**으로 유지 OK.
- [ ] `components/indicators/app_indicators.dart` **`AppPaginationDot`** (단일)
  - Figma는 `Pagination Dot/Resource/Dot/*` 4종을 노출하지만 `AppPaginationDot` 단일 위젯은 코드만의 추상화. `AppPaginationDots`(복수)가 더 명확한 매칭.

### 헬퍼 / Static 메서드 (Figma 표현 대상 아님)

- `showAppConfirmDialog()` — top-level 함수, `AppConfirmDialog` 사용 위해 존재 → Figma `Alert/*`에 매핑됨.
- `AppToast.show()`, `AppBottomSheet.show()`, `AppModalPopup.show()` — Overlay 헬퍼.
- `Swatch`, `CoflanetIcon`, foundation `_*.dart` use_cases — 내부 토큰 카탈로그 위젯.
- private `_SampleLoginScreenState`, contents의 `_Header`/`_BrandChip`/`_PriceRow` 등 — 위젯 내부 분해.

---

## 3. ⚠️ 이름 불일치

| Figma 이름 | Code 이름 | 파일 | 권장 정렬 방향 |
|---|---|---|---|
| `gauge_txt` | `AppGauge` | `components/gauge/app_gauge.dart` | **Figma → Code**. 코드 이름이 더 명확함. Figma 측 리네이밍 권장. |
| `Recipe/Timmer`, `Recipe/Timmer List` | `AppRecipeStepper`, `AppRecipeCard` | `components/contents/app_recipe_timer.dart` | **Figma → Code**. Figma 오타(`Timmer` → `Timer`) 수정 + 클래스 분리에 맞춰 `Recipe/Stepper`, `Recipe/Card`로 분할 권장. |
| `📺 Thunmbnail` (페이지/노드 다수) | `AppThumbnail` | `components/thumbnails/app_thumbnail.dart` | **Figma → Code**. Figma 오타(`Thunmbnail` → `Thumbnail`) 수정. |
| `banner` (소문자) | `AppBanner` | `components/contents/app_banner.dart` | **Figma → Code**. 다른 컴포넌트 명명 규칙(PascalCase)에 맞춰 `Banner`로 통일. |
| `community` (소문자) | `AppCommunityListItem` | `components/contents/app_community_list.dart` | **Figma → Code**. `List/Community/Item` 같은 명확한 경로로 리네이밍. |
| `TastingNote_Row01` | `AppTastingNote` | `components/contents/app_tasting_note.dart` | **Figma → Code**. `_Row01` 접미사는 디자이너 임시 명명. `Tasting Note` 또는 `TastingNote/Item`으로 통일. |
| `Push Badge` | `AppBadge` (+ `AppBadgeStyle.dot/.count`) | `components/indicators/app_indicators.dart` | **양쪽 검토**. Figma는 푸시 알림 컨텍스트 강조, 코드는 일반 배지. 컨텍스트가 같다면 Figma를 `Badge`로 단순화. |
| `Basic/Divider` | `AppDivider` | `components/dividers/app_divider.dart` | **Figma → Code**. `Basic/` 접두사 제거. |
| `Top Navigation/Top Navigation` | `AppTopNavigation` | `components/navigation/app_top_navigation.dart` | **Figma → Code**. 중복 경로(`Top Navigation/Top Navigation`) 단축. |
| `Modal/Popup` | `AppModalPopup` | `components/presentation/app_bottom_sheet.dart` | **OK** — 의미 동일. |
| `Modal/Bottom Sheet` | `AppBottomSheet` | `components/presentation/app_bottom_sheet.dart` | **OK** — 의미 동일. |
| `Floating Action` | `AppFloatingActionButton` | `components/buttons/app_floating_action_button.dart` | **OK** — 의미 동일. |
| `Tab Bar Buttons` (single component) | (없음 — `AppBottomNavigation`?) | `components/navigation/app_bottom_navigation.dart` | **검증 필요**. Figma의 "Tab Bar Buttons"가 bottom navigation을 의미하는지 별도 컴포넌트인지 확인 필요. |
| `Tab/Tab` (variants: 12) | `AppTabBar` (5 variants) | `components/tabs/app_tab_bar.dart` | **양쪽 검토**. Figma는 size×resize×state 12조합, 코드는 size{3}×resize{2}=6 + Trailing Icon. variant 누락 가능성 ⚠️ |
| `Item/Resource/Heart` | `AppItemHeart` | `components/contents/app_item_list.dart` | **OK** — 의미 동일. |
| `List/Item/Vertical` | `AppItemCard` (`AppItemCardLayout.vertical`) | `components/contents/app_item_list.dart` | **OK** — variant로 통합되어 있음. |
| `List/Coffee List/Accordion` | `AppCoffeeListItem` | `components/contents/app_coffee_list.dart` | **양쪽 검토**. Figma는 "Coffee List" 폴더 하위, 코드는 단일 위젯. |
| `List/Preference/Accordion` | `AppPreferenceItem` | `components/contents/app_preference_list.dart` | **OK** — 의미 동일. |
| `Coffee Profile/Attributes` | `AppCoffeeAttributesChart` | `components/contents/app_coffee_profile.dart` | **OK**. |
| `Coffee Profile/Flavor Notes` | `AppFlavorNotesChips` | `components/contents/app_coffee_profile.dart` | **OK** — 코드가 좀 더 구체적(`Chips` 접미). |
| `GNB` | `AppGnb` | `components/navigation/app_gnb.dart` | **OK**. |
| `Footer/Footer` | `AppFooter` | `components/navigation/app_footer.dart` | **Figma → Code**. 중복 경로 단축. |
| `Alert/Alert` | `AppConfirmDialog` | `components/modals/app_confirm_dialog.dart` | **양쪽 검토**. Figma `Alert/Alert`(3 variants) ↔ Code `AppConfirmDialog`. Alert와 Confirm은 의미가 다를 수 있음(Alert=알림 / Confirm=확인 요청). **추가 검증 필요.** |
| `Pagination Dot` | `AppPaginationDots` (+ `AppPaginationDot`) | `components/indicators/app_indicators.dart` | **OK** — 단/복수 분리 적절. |

---

## 4. ⚠️ Variant 누락

### `AppTopNavigation`
- Figma `Top Navigation/Top Navigation`: **variants 2**
- Code `TopNavigationVariant`: `{normal, extended, floating}` (**3**)
- ⚠️ **Code가 Figma보다 많음**. Figma의 2 variant가 정확히 어떤 것인지 검증 필요. Figma `Top Navigation/Resource/Contents`(3)도 있어 결합 시 6개 조합 가능 — 코드는 부분 커버.

### `AppReview`
- Figma `Review`: **variants 4**
- Code `AppReviewLayout`: `{compact, multiImage, full}` (**3**)
- 🔴 **1개 variant 누락**. Figma의 4번째 variant 확인 필요 (예: `singleImage` 또는 `text-only`).

### `AppBanner`
- Figma `banner`: **variants 5**
- Code `AppBannerLayout`: `{hero, compact}` (**2**)
- 🔴 **3개 variant 누락**. Figma 5종 → 코드 2종으로 축약됨. 누락 variant 후보: `hero-with-image`, `inline`, `stack` 등.

### `AppCard` (vs Figma `Card/Normal` + `Card/List`)
- Figma `Card/Normal`(4) + `Card/List`(4) = **총 8 variants**
- Code `AppCardVariant`: `{flat, elevated, outlined}` (**3**)
- 🔴 **5개 variant 누락**. 특히 `Card/List` (좌-leading + 우-trailing 구조)는 `AppCard`의 단순 child wrapper로는 충분히 표현되지 않음.

### `AppMenu`
- Figma `Menu/Menu`: **variants 6**
- Code `AppMenuVariant`{normal, radio, checkbox} × `AppMenuCellPadding`{px12, px8} = **6 조합** ✓
- ✅ **수량 일치**. 정확한 1:1 매핑은 추가 검증 필요.

### `AppTabBar` (Figma `Tab/Tab`)
- Figma `Tab/Tab`: **variants 12**
- Code: `AppTabBarSize{large, medium, small}` × `AppTabBarResize{hug, fill}` = **6 조합** + 부가 옵션(trailingIcon)
- 🔴 **6개 variant 누락**. Figma 12종이 어떻게 12로 펼쳐지는지 검증 필요 (state 축이 있을 수 있음).

### `AppSegmentedControl`
- Figma `Segmented Control/Segmented Control`: **variants 6**
- Code `AppSegmentedControlSize`: `{large, medium, small}` (**3**)
- 🔴 **3개 variant 누락**. Figma의 추가 축(예: state, full-width) 검증 필요.

### `AppPaginationCounter`
- Figma `Pagination/Counter`: **variants 4**
- Code `AppPaginationCounterSize`{medium, small} × `alternative` bool = **4 조합** ✓
- ✅ **일치**.

### `AppPaginationNavigation`
- Figma `Pagination/Navigation`: **variants 3**
- Code `AppPaginationNavigationVariant`: `{extended, compact, minimize}` (**3**) ✓
- ✅ **일치**.

### `AppCheckbox`
- Figma `Input/Checkbox`: **variants 48** + `Control/Checkbox` (24)
- Code `AppCheckboxSize`{sm, md} × value{true, false, null=indeterminate} × disabled = **~12 조합**
- 🔴 **상당히 부족**. Figma 48 = size × state × focus × shape 등 다축 조합으로 추정. 코드 누락 가능성 큼.

### `AppRadio<T>`
- Figma `Input/Radio` (16) + `Control/Radio` (16) = **32**
- Code: state 추론만 (selected/unselected/disabled), size enum **없음**
- 🔴 **size variant 누락** — Figma는 sm/md 등의 사이즈를 가지나 코드 미반영.

### `AppSwitch`
- Figma `Switch/Switch`: **variants 16**
- Code `AppSwitchSize`{sm, md} × value{on, off} × disabled = **~8 조합**
- 🟡 **부분 부족**. Figma 16 = size × state × focus 추정.

### `AppSlider`
- Figma `Slider/Slider`: **variants 8**
- Code: `divisions`, `label`, `showValue`, `isDisabled` 조합 (boolean) = **~8 조합 표현 가능**
- 🟡 **잠재적 일치**. enum이 아니라 prop 조합이라 동등성 검증 어렵.

### `AppGauge`
- Figma `gauge_txt`: **variants 5** (5단계)
- Code: `value: int (1~5)` — 동일 5단계
- ✅ **일치**.

### `AppCell`
- Figma `Cell/Cell`: **variants 128**
- Code `AppCellVerticalPadding`{3} × `AppCellVerticalAlign`{2} × `fillWidth` × `textEllipsis` × `isActive` × `isDisabled` = **~96 boolean 조합** + leading/trailing slot
- 🟡 **기능적 커버**, 1:1 variant 매핑은 불가. Figma 128 = leading{N} × trailing{M} × padding{3} 등으로 추정.

### `AppAccordion`
- Figma `Accordion/Accordion`: **variants 12**
- Code `AppAccordionPadding`{large, medium} × initiallyExpanded × isComplete × fillWidth = **~16 조합**
- ✅ **기능적 커버**.

### `AppItemCard`
- Figma `List/Item/Vertical`(3) + 별도 horizontal 없음
- Code `AppItemCardLayout`{vertical, horizontal} (**2**)
- ⚠️ Figma는 horizontal layout 별도 ComponentSet 없음 — 코드 `horizontal` variant가 추가됨. **Figma sync 필요**.

### `AppPlayIconBadge`
- Figma `Play Icon Badge/Play Icon Badge`: **variants 6**
- Code `AppPlayIconBadgeSize`{small, medium, large} × `AppPlayIconBadgeVariant`{normal, alternative} = **6 조합** ✓
- ✅ **일치**.

### `AppContentBadge`
- Figma `Content Badge/Content Badge`: **variants 12**
- Code `AppContentBadgeVariant`{solid, outlined} × `AppContentBadgeColor`{neutral, accent} × `AppContentBadgeSize`{xsmall, small, medium} = **12 조합** ✓
- ✅ **일치**.

### `AppRatioBox`
- Figma `Ratio/Horizontal` (17) + `Ratio/Vertical` (2)
- Code `AppRatio` enum: 17 values (square + 8 landscape + 8 portrait) + `AppRatioBoxVertical` widget
- ✅ **일치**.

### `AppScrollBar`
- Figma `Scroll Bar` (24) — 단, Presentation 페이지에도 동일 `Scroll Bar/Scroll Bar` (24) 중복
- Code `AppScrollBarSize`{normal, small} + percent + position
- 🟡 **수량 미스매치**. 24 variants가 어떤 축인지 검증 필요 (size × percent step × position?).

### `AppAvatar`
- Figma `Avatar/Person`(12) + `Company`(12) + `Academic`(12) = 총 **36** (3 types × 12 sizes/states)
- Code `AppAvatarSize`{xSmall, small, medium, large, xLarge} × `AppAvatarType`{person, company, academic} = **15 조합**
- 🟡 **부분 매칭**. Figma의 12 = size(5) × state(?) 또는 size × badge 조합 추정. 코드는 size 5종만.
- 단, `components/contents/` 페이지의 `Avatar/Avatar` (30) 별도 ComponentSet 존재 — 컨텍스트 차이 검증 필요.

---

## 5. ⚠️ 구현 방식 차이

### A) Figma "tone-variant 통합 컴포넌트" → Code "tone enum"
- Figma는 동일 컴포넌트의 색조 별로 **별도 ComponentSet** 생성:
  - `Button/Solid/Primary`, `Button/Solid/Gray Primary`, `Button/Solid/Gray`, `Button/Solid/LiquidGlass Primary`, `Button/Solid/LiquidGlass`, `Button/Solid/Background Blur Primary`, `Button/Solid/Background Blur` → **7개 ComponentSet (각 8 variants)**
- Code는 단일 `AppSolidButton` 클래스 + `AppSolidButtonTone` enum 7종으로 통합.
- ✅ **Flutter 모범 패턴 (단일 위젯 + tone enum)**. 이대로 유지 권장.
- 동일 패턴: Button/Icon (9 ComponentSet → `AppIconButton.tone` 9-enum), Button/Outlined (3 → tone 3), Button/Text (3 → tone 3).

### B) Figma "내부 Resource 노출" → Code "private helper로 흡수"
- Figma는 `Avatar/_Resource/Image/Person`, `Top Navigation/Resource/Tool/Tab` 등 **내부 빌딩 블록**도 ComponentSet으로 노출.
- Code는 동일 기능을 private `_XXX` 위젯이나 inline 위젯으로 처리.
- ✅ **모범 패턴**. Figma는 디자이너 편의용, 코드는 캡슐화. 1:1 매핑 불필요.

### C) Figma "Category × Resource Chip" 분할 → Code "AppCategory" 단일
- Figma `Category/Category` (16) + `Category/Resource/Chip/Normal/XSmall|Small|Normal|Large` (각 2 = 8) + `Category/Resource/Chip/Alternative/XSmall|Small|Normal|Large` (8) = **총 32 추가 Resource ComponentSet**
- Code는 `AppCategory` 단일 위젯 + `AppCategoryVariant{normal, alternative}` × `AppCategorySize{medium, small}` = 4 조합.
- 🔴 **Code가 size variant 부족** (Figma: xsmall/small/normal/large 4종 vs Code: medium/small 2종).

### D) Figma "Pagination/Resource/Navigation/Page|Button" 분할 → Code "AppPaginationNavigation" 단일
- Figma는 페이지 셀과 화살표 버튼을 별도 Resource로 분리.
- Code는 `AppPaginationNavigation`에 내부 렌더링으로 통합.
- ✅ 모범 패턴.

### E) Figma "LiquidGlass 통합" vs Code "AppLiquidGlassButton 분리"
- Figma는 LiquidGlass를 `Button/Solid/LiquidGlass*`, `Button/Icon/LiquidGlass*` 등 **각 카테고리 tone variant**로 흡수.
- Code는 추가로 `AppLiquidGlassButton`(별도 위젯) 존재 → **중복 정의 가능성**.
- ⚠️ **권장**: `AppLiquidGlassButton` 제거 + `AppSolidButton(tone: liquidGlassPrimary)` 사용 통일. 또는 Figma 측에 별도 컴포넌트 추가 후 sync.

### F) Figma "Status (6 variants)" → Code 없음
- Figma `⚙️ Components/Status` (6) — 작업 상태 라벨(예: 대기/진행/완료/실패) 추정.
- Code에는 `AppChip(color: AppChipColor.X)` 또는 `AppContentBadge`로 대체 가능하지만 별도 `AppStatusBadge` 위젯 부재.

### G) Figma "BottomSheet_CTA" → Code "AppBottomSheet + 수동 button row"
- Figma는 BottomSheet 하단 1~2 버튼 영역을 **preset 컴포넌트**(7 variants)로 캡슐화.
- Code는 사용자가 `AppBottomSheet(child: Column(...AppSolidButton))`으로 수동 조립.
- 🟡 **Action API 통일 권장**. `AppBottomSheet.cta(primary: ..., secondary: ...)` 같은 named constructor 추가 고려.

### H) Figma "Charge/Charge_List/Duration" (피그마 내부 관리용) → Code 없음
- 📊 디자인 시스템 내부 관리 라벨 — 프로덕션 미사용 추정. 매핑 불필요.

---

## 6. ✅ 매칭 완료 — 요약 통계

> Figma 페이지 매핑 기준, 대표 컴포넌트 1:1 매칭이 가능한 항목만 카운트.

| 카테고리 | Figma 대표 컴포넌트 | Code 위젯 | 매칭 |
|---|---|---|:---:|
| Foundation (color/radius/spacing/typo/shadow/decorate/gradient) | 7 토큰 | `AppColor`, `AppRadius`, `AppSpacing`, `AppTextStyles`, `AppShadows`, `AppDecorate`, `AppGradient` | ✅ |
| Foundation (icon set) | `CoflanetIcons` (160 SVG) | `CoflanetIcons` + `CoflanetIcon` | ✅ |
| Foundation (theme) | — | `AppTheme` | ✅ |
| Button (Solid/Outlined/Text/Icon/FAB/SectionBottom) | 6 family (24 ComponentSets) | 6 위젯 | ✅ |
| Chip (Action/Filter) | 2 | `AppChipAction`, `AppChipFilter` | ✅ |
| Avatar (Person/Company/Academic/Button/Group) | 5 | `AppAvatar`, `AppAvatarButton`, `AppAvatarGroup` | ✅ |
| Divider | 1 | `AppDivider` | ✅ |
| Ratio | 2 | `AppRatioBox`, `AppRatioBoxVertical` | ✅ |
| Thumbnail | 1 | `AppThumbnail` | ✅ |
| Scroll Bar | 1 | `AppScrollBar`, `AppScrollableScrollBar` | ✅ |
| Indicators (Home Indicator, Grabber) | 2 | `AppHomeIndicator`, `AppGrabber` | ✅ |
| Navigation (Top/GNB/Footer/TabBar/BottomNav) | 5 | 5 위젯 | ✅ |
| Tab (Tab/Category/Segmented Control) | 3 | `AppTabBar`, `AppCategory`, `AppSegmentedControl` | ✅ |
| Pagination (Counter/Navigation/Dot) | 3 | `AppPaginationCounter`, `AppPaginationNavigation`, `AppPaginationDots` | ✅ |
| Input/Selection (Textfield/Select/Slider/Checkbox/Radio/Switch) | 6 | `AppTextField`, `AppSelect`, `AppSlider`, `AppCheckbox`, `AppRadio`, `AppSwitch` | ✅ |
| Control Box | 1 | `AppControlBox` | ✅ |
| Gauge | 1 (이름 차이) | `AppGauge` | 🟡 |
| Feedback (Push Badge/Toast/Snackbar/Tooltip Compact·Extended/Alert) | 6 | `AppBadge`, `AppToast`, `AppSnackbar`, `AppTooltipCompact`, `AppTooltipExtended`, `AppConfirmDialog` | ✅ |
| Presentation (Modal Popup/Bottom Sheet/Menu) | 3 | `AppModalPopup`, `AppBottomSheet`, `AppMenu` | ✅ |
| Contents (Cell/Accordion/Card/Banner/SectionHeader/Table/PlayIconBadge/ContentBadge/Review/CoffeeProfile/CoffeeList/PreferenceList/Community/Item/Recipe/TastingNote) | ~16 | 동수 위젯 | ✅ (이름·variant 일부 차이) |

**매칭 카운트**: 위 카테고리 합계 **약 67개 Figma 대표 컴포넌트 ↔ Code 위젯** 매칭 성립.

---

## 📊 최종 요약 통계

| 지표 | 값 |
|---|---:|
| 전체 Figma Component + ComponentSet | 55 + 378 = **433** |
| 그중 **사용자 노출 1차 컴포넌트** (Resource/Knob/Page 제외, Icon 160 묶음) | **~95** |
| 전체 Code 공개 위젯 (App*) | **76** |
| Figma ↔ Code 직접 매칭 가능 | **~67** |
| Figma 미구현 (코드 누락) — P0 | **9 카테고리** (Section Message, Empty State, Modal/Full, Action Sheet, Auto Complete, Date Picker, Time Picker, Searchinput, Textarea) |
| Figma 미구현 — P1 | **6 카테고리** (Progress Tracker H/V, Step, Indicator-57, Check Mark, Toggle Icon, Check Box with img, BottomSheet_CTA) |
| Figma 미구현 — P2 | **6+ 카테고리** (Logo, 3D Illustration, Coffee Draft, Price typography, Background tokens, Layout helpers, 디자인 내부 관리 컴포넌트) |
| Figma에 없는 Code 추가물 | **5** (`AppChip`, `AppLiquidGlassButton`, `AppLinearProgress`, `AppCircularProgress`, `AppLabeledProgress`) |
| 이름 불일치 항목 | **~15** (`Timmer→Timer` 오타 등 포함) |
| Variant 부족 (Code < Figma) | **~10 컴포넌트** (Cell, Tab, Banner, Card, Avatar, SegmentedControl, Checkbox, Radio, Switch, Category) |
| Variant 초과 (Code > Figma) | **2** (`AppTopNavigation`: 2→3, `AppItemCard.layout`: 1→2) |

### 📈 매칭률
- **대표 컴포넌트 매칭률**: 67 / 95 ≈ **70.5%**
- **누락률**: (9 P0 + 6 P1 + 6+ P2) / 95 ≈ **~22%** (P0 누락만 보면 **9.5%**)
- **변형(variant) 정합률**: 약 **60%** (대부분 컴포넌트는 매칭되나 variant 수 차이 존재)

### 🚨 가장 시급한 누락 Top 5

1. **Section Message** (`2546:37608`, 5 variants) — 폼/리스트 어디서나 쓰이는 인라인 알림 UI. `AppSnackbar`(transient) / `AppToast`(transient)로는 대체 불가능.
2. **Empty State** (`2546:38093`, 4 variants) — 리스트/검색/대시보드 등에서 즉시 필요. 현재 코드에 빈 상태 표준 위젯 없음.
3. **Date Picker / Time Picker** (`2523:152041`, `2523:151660`, 총 ~15 variants) — 폼 입력의 필수 위젯. iOS/Android 플랫폼 분기 포함.
4. **Modal/Full** (`2546:93990`, 2 variants) — 풀스크린 모달은 `showDialog` 기반으로 가능하나 Figma 표준 디자인의 TopBar+Body 구조가 없으면 화면 단위 일관성 무너짐.
5. **Progress Tracker** (`2563:339896`, `2563:340375`, 42 variants 합계) — 회원가입/결제/온보딩 등 멀티스텝 플로우 필수. 현재 `AppLinearProgress`로는 멀티-step 시각화 불가.

### 🔁 양방향 정합 권장 액션

- [ ] **Figma 측 리네이밍 (low-effort)**: `Timmer→Timer`, `Thunmbnail→Thumbnail`, `banner→Banner`, `community→Community`, `gauge_txt→Gauge`, `TastingNote_Row01→TastingNote` 6개 오타/일관성 문제 정정.
- [ ] **Code 측 정리**: `AppLiquidGlassButton` 제거 (또는 Figma에 추가) — `AppSolidButton(tone: liquidGlass...)`과 중복.
- [ ] **Code 측 variant 보강 (high-priority)**: `AppCategory`에 xsmall/large size 추가, `AppRadio<T>`에 size enum 추가, `AppCard`에 list-style variant 추가, `AppBanner` variant 5종 보강.
- [ ] **신규 위젯 5개 (P0)**: `AppSectionMessage`, `AppEmptyState`, `AppFullModal`, `AppActionSheet`, `AppDatePicker` + `AppTimePicker` + `AppAutoComplete`.
- [ ] **Figma 측 추가**: `AppChip`(13 color tag chip), `AppLinearProgress`/`AppCircularProgress`/`AppLabeledProgress` 가 코드에는 있으나 Figma 디자인 토큰화 안 됨 — 디자이너와 reverse-sync 합의 필요.

---

## ⚠️ 추가 검증 필요

- **`Tab Bar Buttons`** (`2967:18633`, Navigation 페이지의 단일 component): Bottom Navigation을 의미하는지, Top Tab Bar의 버튼 행을 의미하는지 모호. 현재 `AppBottomNavigation`(`BottomNavItem`)으로 임시 매핑함.
- **`Vertical Stack`** (`2411:28217`, 2 variants, Navigation 페이지): Layout helper로 추정 — 코드에는 일반적인 `Column` 사용. 위젯화 불필요할 수 있음. 검증 필요.
- **`Indicator`** (`2442:16181`, 57 variants): 57개가 어떤 종류인지(로딩 / 상태 / progress) 미상. 일부는 `AppLinearProgress`/`AppCircularProgress`/`AppBadge`로 흡수되었을 가능성.
- **`Decorate`** (Colors 페이지 `2411:5339`, 15 variants) vs 💅 Decorate 페이지 `Decorate/*` 다수: 두 위치의 Decorate 의미 차이 검증 필요. 코드에는 `AppDecorate` 하나.
- **`Avatar/Avatar`** (📑 Contents 페이지 `2573:407223`, 30 variants) vs `Avatar/Person|Company|Academic` (👤 Avatar 페이지): 동일 컴포넌트의 두 위치 중복인지, 다른 컨텍스트(예: 리스트 셀 내 Avatar)인지 검증 필요.
- **`Scroll Bar`** (🖱️ Scroll 페이지 24 + 📣 Presentation 페이지 24): 동일 ComponentSet 중복으로 보이며, 코드는 단일 `AppScrollBar`. variant 24의 축 분해 필요.
- **`Item/Resource/Heart`** ↔ `AppItemHeart`: 코드의 `AppItemHeart`는 public widget이지만 Figma는 "Resource" 접두 — public/internal 정책 결정 필요.
- **`Modal/Resource/Status Outer Safe Area`** / `Bottom Outer Safe Area` (각 3 variants): 모달 내 safe area 처리 도우미. 코드는 Flutter `SafeArea` 기본 사용 — 별도 위젯 불필요할 가능성.
- **Figma `Card/Resource/Normal/Save`** (2) / `Card/Resource/List/Trailing Content/Save` (2): 카드 내 "저장" 버튼 슬롯. 코드는 `AppCard(child: ...)` 자유 슬롯 — 명시 슬롯 정책 결정 필요.
