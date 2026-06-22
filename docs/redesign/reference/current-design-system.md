# 레퍼런스: 현재 앱 디자인 시스템 스냅샷

> 출처: `lib/constants/`, `lib/core/theme/`, `lib/widgets/` 실제 코드 (2026-06 기준, v0.1.2+1)
> 이 문서는 "지금 무엇이 있는가"를 사실 그대로 기록한다. 마이그레이션 매핑(`token-mapping.md`)의 좌변(AS-IS)이다.

## 1. 토큰 파일 위치

| 파일 | 역할 | 크기 |
|------|------|------|
| `lib/constants/color_constant.dart` | `AppColor` — 원시 팔레트(`colorGlobal*`) + static 시맨틱(`staticLabelWhite*` 등) | ~31KB |
| `lib/constants/app_color_scheme.dart` | `AppColorScheme` — 라이트/다크 인스턴스 기반 시맨틱 스킴 (`AppColorScheme.of(context)`) | ~11KB |
| `lib/constants/style_constant.dart` | `AppTextStyles` — Pretendard 타이포 스케일 | ~18KB |
| `lib/constants/spacing_constant.dart` | `AppSpacing` — 간격 토큰 | ~4KB |
| `lib/constants/radius_constant.dart` | `AppRadius` — 반경 토큰 | ~4KB |
| `lib/constants/asset_constant.dart` | 에셋 경로 | ~2KB |
| `lib/constants/util_constant.dart` | 유틸 상수 | ~8KB |
| `lib/core/theme/app_theme.dart` | `AppTheme.light` / `AppTheme.dark` — 단일 `_build()` 팩토리 | ~6KB |
| `lib/core/theme/theme_controller.dart` | `ThemeController` — 런타임 light/dark/system 전환 | ~3KB |

## 2. 컬러 아키텍처 (핵심)

- **2계층**: 원시 팔레트 `AppColor.colorGlobal*` (예: `colorGlobalViolet50` = #6541F2) → 시맨틱 `AppColorScheme` 인스턴스.
- **인스턴스 기반 라이트/다크**: `AppColorScheme.light` / `AppColorScheme.dark` 두 `const` 인스턴스. 화면은 `AppColorScheme.of(context)`로 읽어 테마 전환 시 자동 리빌드.
  - ⚠️ 이 구조는 component_lab의 foundation(`AppColor` static + `dark` 프리픽스)보다 **아키텍처적으로 앞서 있다**. ACTION_PLAN이 P1으로 제안하는 "ThemeExtension 도입"의 절반은 이미 달성된 상태.
- **시맨틱 그룹**: Primary(5), Label(6), Background(5), Surface(2), Interaction(2), Line(6), Status(4), Component(5), Inverse(8).

### 배경/표면 색 (task 4의 출발점)

| 토큰 | 라이트 | 다크 |
|------|--------|------|
| `backgroundNormalNormal` | `Common100` #FFFFFF | `Common0` #000000 |
| `backgroundNormalAlternative` | `CoolNeutral99` #F7F7F8 | `Common0` #000000 |
| `backgroundElevatedNormal` | `Common100` #FFFFFF | `CoolNeutral22` #2E2F33 |
| `surfaceCard` | `Common100` #FFFFFF | `CoolNeutral15` #1B1C1E |
| `surfaceCardStrong` | `CoolNeutral98` #F4F4F5 | `CoolNeutral20` #292A2D |
| `labelNormal` | `CoolNeutral10` (진회색) | `CoolNeutral99` (밝은회색) |

> **task 4 핵심**: 현재 라이트 배경은 흰색이다. "라이트/다크 모두 Static/Black"으로 바꾸려면 `backgroundNormalNormal`/`backgroundNormalAlternative`를 양쪽 모두 `Common0`(#000000)로 고정해야 한다. → `04-static-black-theme.md` 참조.

## 3. 타이포그래피 (`AppTextStyles`)

- **폰트**: Pretendard (300/400/500/600/700), `assets/fonts/`에 번들. 숫자용 PretendardMono 변형 존재.
- **스케일**: Display(56/40), Title(36/28/24), Heading(22/20), Headline(18/17), Body(16/15, Normal·Reading), Label(14/13), Caption(12/11), Emoji(16~80). Bold/Medium/Regular + Mono 변형.
- 자주 쓰임: `headline1Bold`(18/700) 앱바·섹션, `body1NormalMedium`(16/500) 본문, `caption1Medium`(12/500) 탭 라벨, `label1NormalMedium`(14/500) 폼.

## 4. 간격 (`AppSpacing`)

- **원시값(17단계)**: 2,4,6,8,10,12,14,16,20,24,28,32,40,48,56,64,80.
- **시맨틱 별칭**: xxs=4, xs=8, sm=12, md=16, lg=20, xl=24, xxl=32, xxxl=48.
- **컴포넌트별**: buttonPaddingH=16, buttonPaddingV=14, cardPadding=16, modalPadding=24, screenPaddingH=20, screenPaddingV=16, listItemSpacing=12, iconTextGap=8, sectionSpacing=24.
- **EdgeInsets 헬퍼**: `screenPadding`(20/16), `cardPaddingAll`(16), `modalContentPadding`(24/20), `buttonPadding`(16/14), `listItemPadding`(16/12).

## 5. 반경 (`AppRadius`)

- **원시값**: none=0, xxs=2, xs=4, sm=6, md=8, **lg=12(가장 흔함)**, lgPlus=14, xl=16, xxl=20, xxxl=24, round=32, full=100.
- **컴포넌트별**: button=12, input=12, card=16, modal=20, chip=8, checkbox=6, avatar=100.
- 방향 헬퍼: `top()/bottom()/left()/right()`.

## 6. 테마 (`AppTheme._build`)

- Material3, 단일 빌더로 light/dark 대칭 생성.
- `scaffoldBackgroundColor: colors.backgroundNormalNormal` ← **task 4에서 이 값이 검정으로 바뀜**.
- `ColorScheme`, `appBarTheme`, `textTheme`(13개 매핑), `elevatedButtonTheme`(52h, radius 12), `outlinedButtonTheme`, `textButtonTheme`, `inputDecorationTheme`(filled, radius 12), `checkboxTheme`, `dividerTheme`, `bottomSheetTheme`, `dialogTheme`, `bottomNavigationBarTheme`, 다크 splash/highlight 보정.
- `onPrimary`/`onSecondary`/`onError`에 `AppColor.staticLabelWhiteStrong` 사용 → **static 토큰이 이미 존재**.

## 7. 공유 위젯 (`lib/widgets/`)

buttons(`primary_button.dart`, `social_button.dart`), cards(`product_card.dart`, `recipe_card.dart`), forms(`app_text_field.dart`), navigation(`shell_tab_bar.dart`, `shell_top_navigation.dart`, `app_header.dart`, `app_bottom_bar.dart`), feedback(`app_empty_state.dart`), timer(`circular_timer.dart`), charts(`flavor_radar_chart.dart`), gauge(`app_animated_taste_bar.dart`), checklist(`equipment_checklist.dart`), tags(`flavor_tag.dart`), modals(InputModal/SelectionModal/TimePickerModal/GrindSizeModal/EquipmentSelectionModal/ConfirmModal/UnsavedChangesModal), typography(`section_title.dart`).

### 현재 카드 스타일 (task 4 비교 기준)

| 속성 | 라이트 | 다크 |
|------|--------|------|
| 배경 | `surfaceCard` #FFFFFF | `surfaceCard` #1B1C1E |
| 보더 | `lineNormalNormal` (#70737C @22%) | `lineNormalNormal` (#70737C @32%) |
| 반경 | 12px(product) / 16px(recipe·detail) | 동일 |
| 패딩 | 16 (cardPaddingAll) | 동일 |
| 그림자 | 없음(플랫, 보더 기반 대비) | 없음 |

## 8. 셸 탭바 — 이미 "항상 다크 글래스"

`lib/modules/shell/widgets/shell_tab_bar.dart`는 테마와 무관하게 항상 어두운 글래스(pill 99px, `CoolNeutral15 @72%` 블러 24px, 활성=violet60). → **task 4의 "검정 캔버스" 방향과 이미 일관됨**. Static/Black 배경 위에서 자연스럽게 어울린다.
