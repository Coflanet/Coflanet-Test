# Coflanet Design System — Action Plan (Phase 5/5)

- **입력**: `MISMATCH_REPORT.md` (Figma↔Code 갭) · `AUDIT_REPORT.md` (Flutter 구조 감사)
- **단위**: 작업 시간은 1인 시니어 Flutter 엔지니어 기준 (디자인 review 대기 시간 제외)
- **표기**: 🟥 P0 즉시 · 🟧 P1 이번 주 · 🟨 P2 나중에
- **공통 검증 게이트**: 모든 P0/P1 작업은 → `cd Library/component_lab && flutter analyze` 0 issue + `flutter test`(있다면) 통과 + Widgetbook(`flutter run -d chrome`) 렌더링 시각 검증

---

# 🟥 P0 — 즉시 (1~2주차)

## 1. 누락된 핵심 위젯 추가 구현 (~ 36 시간)

> Phase 3 MISMATCH_REPORT의 P0 9개 — 사용 빈도 높은 순으로 정렬. Figma 노드 ID는 디자인 spec 참조용.

| # | 위젯 | Figma 노드 | 생성 경로 | 예상 시간 | 의존성 | 검증 방법 |
|---|---|---|---|---:|---|---|
| 1.1 | **`AppSectionMessage`** (5 variants) | `2546:37608` | `lib/components/feedback/app_section_message.dart` + `app_section_message_use_cases.dart` | **2.5h** | — | Widgetbook에 5 variant(info/success/warning/error/neutral) 렌더 + dark mode 토글 |
| 1.2 | **`AppEmptyState`** (4 variants) | `2546:38093` | `lib/components/feedback/app_empty_state.dart` + use_cases | **2h** | `CoflanetIcon` (illust slot) | Widgetbook 4 variant 렌더 (no-data/no-search/no-permission/error) + CTA 슬롯 동작 |
| 1.3 | **`AppFullModal`** (2 variants) | `2546:93990` | `lib/components/presentation/app_full_modal.dart` + static `.show()` 헬퍼 + use_cases | **3h** | `AppTopNavigation` 재사용 | `.show()`로 풀스크린 push/pop + Widgetbook inline preview |
| 1.4 | **`AppActionSheet`** (2 variants) | `2546:94872` | `lib/components/presentation/app_action_sheet.dart` + static `.show()` + use_cases | **2.5h** | `AppMenu` 패턴 재참고 (composition 가능) | iOS 스타일 (cancel 분리), Android 스타일 모두 렌더 |
| 1.5 | **`AppAutoComplete<T>`** (10 variants) | `2546:94667` + Resource Cell (10) | `lib/components/presentation/app_auto_complete.dart` + use_cases | **5h** | `AppSelect<T>` 오버레이 패턴 재사용 (단 텍스트 입력 기반) | 입력 → debounce → 항목 필터 → 선택 콜백; Widgetbook live demo |
| 1.6 | **`AppDatePicker`** (Web 6 + Android 3 + iOS 2 = 11 variants) | `2523:152041`, `2523:152480`, `2523:152522` | `lib/components/selection/app_date_picker.dart` + plat sub-files (`_web/_android/_ios.dart`) + use_cases | **8h** | — | 단일/범위 선택 모두 동작, 플랫폼 자동 분기, locale 한국어 |
| 1.7 | **`AppTimePicker`** (Web 4 + Android 3 + iOS 1 + Common 1) | `2523:151660`, `2523:151843`, `2523:151899` | `lib/components/selection/app_time_picker.dart` + plat sub-files + use_cases | **6h** | 1.6과 동일 패턴 재사용 | 12/24h 토글, 플랫폼 분기 |
| 1.8 | **`AppSearchInput`** (4 variants) | `2523:155072` | `lib/components/forms/app_search_input.dart` + use_cases | **2h** | `AppTextField` composition | 검색 아이콘 + clear 버튼 + onSubmitted 동작 |
| 1.9 | **`AppTextArea`** (30 variants) | `2523:153573` | `lib/components/forms/app_text_field.dart`에 통합 (`isMultiline: true` 또는 `AppTextField.multiline()` factory) | **2h** | `AppTextField` 확장 | min/maxLines, character counter, error 상태 모두 렌더 |
| 1.10 | **`AppProgressTracker`** (Horizontal 24 + Vertical 18 + Step 4) | `2563:339896`, `2563:340375`, `2411:28628` | `lib/components/indicators/app_progress_tracker.dart` + use_cases | **3h** | — | H/V 양방향, current step, complete/active/pending state 렌더 |

**P0 위젯 합계: ~ 36 시간** (5일치)

## 2. P0 Critical 버그 픽스 (~ 6 시간)

> Phase 4 AUDIT_REPORT의 P0 12건. 모두 30분~1시간 내 픽스 가능.

| # | 위젯 / 파일 | 버그 | 수정 방향 | 시간 | 검증 |
|---|---|---|---|---:|---|
| 2.1 | `foundation/app_color.dart` L396 | `darkStatusPositiveBlue` 값이 `colorGlobalGreen60` (이름은 Blue) | 의도된 토큰명 확인 후 (a) 이름을 `darkStatusPositiveGreen`으로 정정 또는 (b) 값을 `colorGlobalBlue60`으로 정정 | 15m | grep으로 사용처 확인 → 한 곳도 호출 없으면 (a), 있으면 (b) |
| 2.2 | `components/buttons/app_floating_action_button.dart` L46–48 | `isDark ? shadowBlackEmphasize : shadowBlackEmphasize` 동일 분기 | dark 분기를 `shadowPrimaryEmphasize` 또는 별도 dark shadow로 변경 | 15m | Widgetbook FAB 케이스 dark/light 토글 시 그림자 차이 확인 |
| 2.3 | `components/tabs/app_category.dart` L105–107 | `isNormal ? coolNeutral10 : coolNeutral10` — alternative variant 활성 색 동일 | Figma 비교 후 alternative 활성 색을 `primaryNormal` 또는 디자이너 지정 색으로 분기 | 30m | Widgetbook category alternative 변형 활성 시 색 구분 |
| 2.4 | `foundation/app_shadow.dart` L20 | `shadowPrimaryNormal`이 단일 `BoxShadow` (형제는 `List<BoxShadow>`) | `[BoxShadow(...)]`로 래핑 + 사용처 (없으면 신규 등록) 갱신 | 20m | `final List<BoxShadow> _ = AppShadows.shadowPrimaryNormal;` 컴파일 확인 |
| 2.5 | `components/buttons/app_outlined_button.dart` L97–105 | `_adjustedPadding()` `EdgeInsets.horizontal` 의미 혼동 (left+right 합) | `EdgeInsets.symmetric(horizontal: base.left, vertical: base.top - 1)`로 재작성 | 20m | tone별 시각 회귀 없음 (Widgetbook 스크린샷 diff) |
| 2.6 | `components/buttons/app_social_button.dart` L13–14 | 브랜드 아이콘이 Material placeholder | `CoflanetIcons.logoKakao/logoNaver/logoApple/logoGoogle` SVG로 교체 | 45m | Widgetbook 4 provider 모두 정확한 브랜드 로고 표시 |
| 2.7 | `components/buttons/app_section_bottom_button.dart` (`solid` variant) + `components/buttons/app_text_button.dart` | Material 부재 → ripple 미표시 | `Material(color: Colors.transparent, child: InkWell(...))` 래핑 추가 | 30m | tap 시 ripple animation 확인 |
| 2.8 | `components/contents/app_review.dart` (`full` layout) | avatar 외부 슬롯 부재 — placeholder `Icon` 강제 | `Widget? avatar` 파라미터 추가, null이면 기존 placeholder fallback | 30m | use_cases에 custom AppAvatar 주입 케이스 추가 |
| 2.9 | Dead variants 4종 제거/구현 | `AppCell.fillWidth`, `AppAccordion.fillWidth`, `AppTable.contentType`, `AppBottomSheet.AppBottomSheetResize` | 각각 build에서 미사용 → (a) 의도된 기능이면 구현 (b) 의도 없으면 필드/enum 삭제. 디자이너에게 의도 확인 후 결정 | 1.5h | 4개 모두: 호출자 영향 없음 (코드 분석) + Widgetbook 회귀 없음 |
| 2.10 | `components/ratio/app_ratio.dart` `AppRatioBoxVertical` | 부모 height unbounded 시 width = infinity (crash) | `LayoutBuilder` 안에서 `if (constraints.maxHeight.isFinite)` 가드 + `assert(constraints.maxHeight.isFinite, '...')` | 30m | unbounded 부모(예: `Column` 직속)에서 사용 시 의미 있는 assertion 메시지 |
| 2.11 | `components/selection/app_select.dart` L60 | `findRenderObject() as RenderBox` unguarded | `if (!mounted) return; final ro = context.findRenderObject(); if (ro is! RenderBox) return;` + null 처리 | 20m | dispose 직후 close 호출 시 crash 없음 (테스트) |

**P0 버그 합계: ~ 6 시간**

---

# 🟧 P1 — 이번 주 (3~4주차)

## 3. 아키텍처 개선 — `ThemeExtension` 도입 (최대 효과의 단일 작업)

| # | 작업 | 시간 | 의존성 | 검증 |
|---|---|---:|---|---|
| 3.1 | `foundation/app_color_theme.dart` 신규 — `class AppColorTheme extends ThemeExtension<AppColorTheme>` 작성. 모든 semantic 토큰(label/component/line/status/background/primary/accent…)을 fields로 노출. `lerp()` / `copyWith()` 구현. | **3h** | — | `Theme.of(context).extension<AppColorTheme>()!.labelNormal` 호출로 토큰 획득 |
| 3.2 | `AppTheme.light` / `AppTheme.dark`에 `extensions: [AppColorTheme.light, AppColorTheme.dark]` 추가 | **30m** | 3.1 | `Theme.of(context).extension<AppColorTheme>()` null 아님 |
| 3.3 | 다크 모드 누락 위젯 일괄 교체 — 21개 컴포넌트의 `Theme.of(context).brightness == Brightness.dark ? darkXxx : xxx` 패턴을 `Theme.of(context).extension<AppColorTheme>()!.xxx`로 치환. (AppSolidButton/Outlined/Text/TabBar/Category/SegmentedControl/BottomNavigation/Footer/Gnb/TopNavigation/PaginationCounter/PaginationNavigation/Menu/BottomSheet/ModalPopup/Snackbar/TooltipExtended/Select/Slider/Gauge/ControlBox) | **6h** | 3.1, 3.2 | Widgetbook에서 ThemeAddon `Dark` 토글 시 21개 모두 다크 색상 자동 반영 |
| 3.4 | (선택) `AppShadowTheme extends ThemeExtension` 동일 패턴 — primary/black 그룹을 brightness별로 노출 | **2h** | 3.1 패턴 재사용 | shadow도 동일하게 ThemeExtension 경유 |

**아키텍처 합계: ~ 11.5 시간** — 이 작업 하나가 P1 항목의 절반 이상을 해결.

## 4. 중복 제거 / 추상화 (~ 7 시간)

| # | 작업 | 시간 | 의존성 | 검증 |
|---|---|---:|---|---|
| 4.1 | `foundation/_button_metrics.dart` 신규 — `class AppButtonMetrics { final double height, gap, iconSize; final EdgeInsets padding; final TextStyle textStyle; }` + size enum별 룩업 맵. `AppSolidButton`/`AppOutlinedButton`/`AppLiquidGlassButton`에서 채택 (지금 각자 동일 표 보유) | **2h** | — | 세 버튼이 동일 lookup 사용, Widgetbook 시각 회귀 없음 |
| 4.2 | `foundation/_chip_metrics.dart` 신규 — `AppChipAction`/`AppChipFilter` size 매트릭스 통합 | **1h** | — | 두 chip 시각 회귀 없음 |
| 4.3 | `AppLiquidGlassButton` 통폐합 결정 (제거 vs 유지) — Figma는 LiquidGlass를 `AppSolidButton.tone: liquidGlass*`로 가짐. 권장: 위젯 제거하고 Solid의 tone enum 사용 | **1h** | 4.1 | 위젯 삭제 후 사용처 (없음) 확인 → button_use_cases.dart에서 import 제거 |
| 4.4 | `AppControlBox`의 indicator 재구현 제거 — `AppCheckbox`/`AppRadio`를 composition으로 호출 | **1.5h** | — | Widgetbook AppControlBox 시각 회귀 없음 + 인디케이터 드리프트 위험 해소 |
| 4.5 | `AppGnb` + `AppTopNavigation`의 인라인 push badge 제거 → `AppBadge(style: dot)` 재사용 | **45m** | — | Widgetbook GNB/TopNavigation badge 케이스 회귀 없음 |
| 4.6 | `_BrandChip` (`app_coffee_list.dart`) + `_BrandTags` 칩 (`app_item_list.dart`) + `_FlavorChip` (`app_coffee_profile.dart`) + `AppPreferenceFlavorChip` → 단일 `AppMiniChip` 공개 위젯으로 통합. 또는 `AppContentBadge` 재사용 가능 여부 검토 | **1.5h** | — | 4곳에서 동일 위젯 사용, Widgetbook 시각 회귀 없음 |
| 4.7 | `lib/util/format.dart` 신규 — `formatPrice(int won)` 추출. `app_coffee_list.dart`/`app_item_list.dart`의 verbatim 중복 제거 | **30m** | — | grep `_formatPrice` 결과 0건 |

**중복 제거 합계: ~ 8.25 시간**

## 5. Variant 보강 / API 일관성 (~ 6 시간)

| # | 작업 | 시간 | 의존성 | 검증 |
|---|---|---:|---|---|
| 5.1 | `AppCategory`에 size xsmall/large 추가 (현재 medium/small) — Figma 4단계 매칭 | **45m** | 2.3 | Widgetbook 4 size variant 모두 렌더 |
| 5.2 | `AppRadio<T>`에 `AppRadioSize{sm, md}` enum 추가 — Checkbox/Switch와 API 통일 | **30m** | — | radio sm/md 시각 차이 |
| 5.3 | `AppBanner` variant 5종 보강 — Figma 5 variants 확인 후 enum 확장 | **1.5h** | — | Widgetbook 5 variant 렌더 |
| 5.4 | `AppReview`에 4번째 variant 추가 (Figma `Review` 4 variants vs Code 3 layouts) | **1h** | 2.8 (avatar slot) | Widgetbook 4 variant |
| 5.5 | `AppCard`에 list-style variant 추가 (Figma `Card/List` 별도 4 variants) — leading/trailing 슬롯 명시 | **1.5h** | — | Widgetbook list variant 렌더 |
| 5.6 | `AppPreferenceItem`/`AppRecipeCard` children 타입 완화 — `List<AppTasteChip>` → `List<Widget>` 또는 데이터 모델 | **1h** | — | 다른 chip widget 주입 가능, 시각 회귀 없음 |

## 6. 이름 불일치 통일 — Figma 측 정정 권장 목록 (디자이너 협업 필요, ~ 0h Flutter 측)

> 코드는 PascalCase + camelCase 일관 — Figma 측 오타/규칙 정정이 주.

| Figma 현재 | 권장 정정 | 우선순위 |
|---|---|:---:|
| `Recipe/Timmer`, `Recipe/Timmer List` | `Recipe/Timer/Stepper`, `Recipe/Timer/Card` (코드 클래스 분리에 맞춰 분할) | 🟧 |
| `📺 Thunmbnail` (페이지/노드 다수) | `📺 Thumbnail` | 🟧 |
| `banner` (소문자) | `Banner` | 🟧 |
| `community` (소문자) | `Community/Item` | 🟧 |
| `gauge_txt` | `Gauge` | 🟧 |
| `TastingNote_Row01` | `TastingNote/Item` | 🟧 |
| `Footer/Footer`, `Top Navigation/Top Navigation`, `Tab/Tab`, `Category/Category` | 중복 경로 단축 (`Footer`, `TopNavigation`, …) | 🟨 |
| `Time Picker/Resource/Comman/Cell` | `Common/Cell` (오타 정정) | 🟨 |

→ **단일 Notion/Slack 메모로 디자이너에게 전달 (10분)**. 코드 수정은 동반되지 않음 (`MISMATCH_REPORT.md` § 3 참조).

## 7. Widgetbook 누락 컴포넌트 등록 (~ 2 시간)

| # | 작업 | 시간 | 의존성 | 검증 |
|---|---|---:|---|---|
| 7.1 | `components/buttons/button_use_cases.dart`에 `liquidGlassButtonUseCases` 추가 + `main.dart` `Button` 폴더에 마운트 — 단, 4.3에서 제거 결정 시 스킵 | **30m** | 4.3 결정 | Widgetbook `Components/Button/LiquidGlass` 렌더 |
| 7.2 | `components/chips/chip_use_cases.dart`에 `chipBasicUseCases` 추가 — 13 color × 2 size 매트릭스 | **45m** | — | Widgetbook `Components/Chip/Basic` 렌더 |
| 7.3 | foundation Widgetbook 보완 — `main.dart` L134 TODO 코멘트 항목 중 `Gradient`, `Decorate`(toggle) 추가 (Icon/Image/3D/Logo는 P2) | **45m** | `gradientUseCases`/`decorateUseCases` 신규 작성 | Widgetbook `Foundation/Gradient`, `Foundation/Decorate` 렌더 |

**P1 합계: ~ 28 시간** (4일치)

---

# 🟨 P2 — 나중에 (5주차+)

## 8. 미사용 자체 추가 위젯 정리 (~ 2 시간)

| 위젯 | 결정 권장 | 이유 | 시간 |
|---|---|---|---:|
| `AppLiquidGlassButton` | **제거** | `AppSolidButton.tone: liquidGlass*`와 중복 — P1 4.3에서 처리 | (P1 처리) |
| `AppChip` (basic colored tag) | **Figma 추가 후 유지** | 13 color × 2 size, 실용성 큼 — 디자이너에게 Figma `🍪 Chip` 페이지에 `Chip/Basic` 추가 요청 | (디자이너) |
| `AppLinearProgress`/`AppCircularProgress`/`AppLabeledProgress` | **Figma 추가 후 유지** | Material 표준 progress — Figma는 단계형 Tracker만 보유. 디자이너에게 추가 요청 | (디자이너) |
| `AppBadgedItem` (helper wrapper) | **유지** | child + badge 합성 헬퍼, Figma 패턴 아님 | — |
| `AppPaginationDot` (단수) | **유지** | `AppPaginationDots`(복수)와 함께 일관된 atom API | — |

## 9. ThemeExtension 후속 — 하드코딩 magic number 일괄 제거 (~ 8 시간)

| # | 작업 | 시간 |
|---|---|---:|
| 9.1 | grep + 일괄 치환 — `EdgeInsets.all(8/12/16/24)`, `SizedBox(width/height: 2/4/6/8/10)` 등을 `AppSpacing.spaceN`으로. 위젯별 시각 회귀 검증. | **3h** |
| 9.2 | 인라인 `TextStyle(fontSize: ...)` 5종 (e.g. `AppLabeledProgress` L112–124) → `AppTextStyles.xxx`로 치환 | **45m** |
| 9.3 | `Color.fromRGBO(0,0,0,0.06)` 류 인라인 그림자 (e.g. `AppSegmentedControl` L79) → `AppShadows` 토큰 | **45m** |
| 9.4 | 위젯 내 width/height 매직(`width: 56/48/112/88`, `iconSize: 14/18/20/22/24`) → 토큰 또는 사이즈 enum payload로 통일 | **3h** |

## 10. `const` 적용 확대 (~ 3 시간)

| # | 작업 | 시간 |
|---|---|---:|
| 10.1 | `AppColor`의 semantic `static Color get` getter 9개 → `static final Color` 메모이즈 (호출당 알로케이션 제거) | **45m** |
| 10.2 | `AppGradient` `solidBottom()` 등 list 리턴 함수 → `static final` 캐시 | **30m** |
| 10.3 | `flutter analyze --no-fatal-warnings` lint 적용 + `prefer_const_constructors`/`prefer_const_literals_to_create_immutables` 권장 사항 일괄 fix | **1.5h** |
| 10.4 | `package:flutter_lints` 도입 (없다면) + analysis_options.yaml 강화 | **15m** |

## 11. 접근성 & UX 보강 (~ 6 시간)

| # | 작업 | 시간 |
|---|---|---:|
| 11.1 | `Semantics` 라벨 추가 — `AppAvatar`/`AppSwitch`(toggled)/`CoflanetIcon`/`AppChip onDelete`/`AppItemHeart`/`AppItemCard onLikeTap` | **2h** |
| 11.2 | Tap target 48dp 보강 — `AppChipAction.xsmall`/`AppChipFilter.xsmall`/`AppRecipeStepper._StepperButton`/`AppRecipeCard delete icon`/`AppChip.onDelete` GestureDetector → `MaterialTapTargetSize.padded` 또는 `Padding` 래핑 | **1.5h** |
| 11.3 | `AppAvatar`/`AppThumbnail` `Image.network` → `CachedNetworkImage` 패키지 도입 + loading shimmer | **1.5h** |
| 11.4 | `AppAvatarGroup`에 max-count + "+N more" 인디케이터 | **1h** |
| 11.5 | `AppAccordion`/`AppPreferenceItem` expand 애니메이션 일관화 (후자에 추가) | **45m** |

## 12. perf / 안정성 잔여 (~ 4 시간)

| # | 작업 | 시간 |
|---|---|---:|
| 12.1 | `AppScrollableScrollBar` — setState 대신 `ValueListenableBuilder` scoping | **45m** |
| 12.2 | `AppToast.show()` — `entry.remove()` 이중 호출 방지 (`bool _removed` 가드) | **20m** |
| 12.3 | `AppContentBadgeColor` 확장 — `success/warning/info` 추가 | **45m** |
| 12.4 | `AppCard.elevated` shadow 파라미터화 — `List<BoxShadow>? shadow` | **30m** |
| 12.5 | `AppFooter` expand/collapse `AnimatedSize` 적용 | **45m** |
| 12.6 | `AppItemCard` 고정 width(112/88) → `AppItemCardSize` enum 또는 LayoutBuilder | **45m** |
| 12.7 | `AppTopNavigation._buildFloating`의 `SizedBox(height: 0) + OverflowBox` hack 대체 (Positioned 사용) | **30m** |
| 12.8 | `AppShadows`에서 `backgroundBlur30` 분리 → `foundation/app_background.dart` 또는 `AppDecorate` 이전 | **15m** |

## 13. 누락 P2 위젯 (~ 16 시간, 정책 결정 후)

> Phase 3 MISMATCH P2 — production blocker 아닌 브랜드/일러스트/시스템 위젯.

| 위젯 | 결정 필요 | 예상 시간 |
|---|---|---:|
| `AppLogo`/`AppLogoSymbol`/`AppAppIcon` (9+2+3 variants) | 위젯화 vs assets/만 유지 — 위젯화 선택 시 | 4h |
| `AppIllustration3D` (3D Icon 4 + Char Normal 4 + Gift/Drink Coffee 2) | 위젯 vs `CoflanetIcon`-style asset registry | 3h |
| `AppCoffeeDraft` (Product page) | 단일 위젯 vs 일러스트 자산 | 1h |
| `AppPriceTypography` (`Price` 8 variants) | 위젯 vs `AppTextStyles` 신규 토큰 (`priceLarge`, `priceCompact` 등) | 2h |
| `AppBackgroundEffect` (`Background/Liquid Glass` 등) | 인라인 구현 통합 vs 위젯화 | 3h |
| `AppLayoutGuide`/`AppSafeAreaIndicator` | 디자이너 가이드 위젯이라 production 불필요 — 스킵 권장 | — |
| Figma 내부 관리 컴포넌트 (`Charge_List`/`Status` 등) | 프로덕션 미사용 — 스킵 | — |

## 14. Material 3 / forui 패턴 정렬 (선택, ~ 4 시간)

| # | 작업 | 시간 |
|---|---|---:|
| 14.1 | M3 `Card.filled`/`Card.outlined`/`Card.elevated` 명명 vs 현재 `AppCardVariant{flat, elevated, outlined}` — `flat`을 `filled`로 리네이밍 검토 | 30m |
| 14.2 | M3 `Chip` 패턴 (`ActionChip`/`FilterChip`/`ChoiceChip`) vs 현재 `AppChipAction`/`AppChipFilter` — 이미 정렬되어 있음, 검증만 | 15m |
| 14.3 | `AppRadio` Material 3 / Cupertino split 검토 — 현재 단일 클래스, M3 표준 가깝게 | 30m |
| 14.4 | forui 스타일 가이드와 본 라이브러리 차이 분석 (선택) | 2h |

**P2 합계: ~ 43 시간** (정책 결정 위젯 포함 시)

---

# 📋 의존성 그래프

```
P0:
  1.1~1.10 (신규 위젯) ─┐
                       ├─→ P1: 5.3, 5.4, 5.5 (variant 보강)
  2.1~2.11 (버그) ─────┘
                       
P1:
  3.1 ThemeExtension ──→ 3.2 ──→ 3.3 (21개 위젯 일괄)
  4.1 ButtonMetrics ───────────→ 4.3 (LiquidGlass 통폐합)
  4.4 ControlBox ←─────────────── (Checkbox/Radio composition)
  6 Figma 리네이밍 (Flutter blocker 아님 — 병렬 진행)
  7 Widgetbook (4.3 후행)
                       
P2:
  8 (P1 4.3 의존)
  9 ThemeExtension 후행 (3 의존)
  10 const 일괄 (전체 P1 후행)
  11~12 (병렬 가능)
  13~14 (정책 결정 후)
```

---

# 📊 권장 실행 순서 (sprint별)

| Sprint | 목표 | 주요 작업 | 예상 시간 |
|:---:|---|---|---:|
| **W1** | 버그 박멸 + 첫 신규 위젯 | 2.1~2.11 P0 버그 11건, 1.1 SectionMessage, 1.2 EmptyState | ~ 11h |
| **W2** | Picker 라인 + Aux 위젯 | 1.6 DatePicker, 1.7 TimePicker, 1.8 SearchInput, 1.9 TextArea | ~ 18h |
| **W3** | 모달 + Auto Complete + Progress Tracker | 1.3 FullModal, 1.4 ActionSheet, 1.5 AutoComplete, 1.10 ProgressTracker | ~ 13.5h |
| **W4** | 아키텍처 — ThemeExtension | 3.1~3.4 (단일 PR 권장), 6 Figma 리네이밍 메모 | ~ 11.5h |
| **W5** | 중복 제거 + variant 보강 + Widgetbook | 4.1~4.7, 5.1~5.6, 7.1~7.3 | ~ 16.25h |
| **W6+** | P2 잔여 | 8~14 (정책 결정 + 우선순위 재조정) | ~ 43h |

**총 권장 commitment: 약 113시간 (~ 14일치 시니어 풀타임)** — production-ready B+급 라이브러리로 끌어올리는 데 필요한 합계.

---

# 🎯 한 줄 요약

> **현재 라이브러리 완성도 74%** (Figma↔Code 매칭 70.5% × Phase 4 위젯 등급 가중 평균 77.1%), **구조 품질 등급 B** (A 22 / B 44 / C 11 / D 0). **다음 우선순위 1개 = `AppTheme`에 `ThemeExtension` 도입 (P1 작업 3.1~3.3)** — 21개 위젯의 다크 모드 누락을 단일 아키텍처 변경으로 일괄 해결하며, 향후 모든 신규 위젯의 dark 분기 패턴을 자동화한다.
