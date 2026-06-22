# 레퍼런스: 토큰 매핑 (AS-IS → TO-BE)

> 좌변 = 현재 앱(`current-design-system.md`), 우변 = component_lab(`component-lab-inventory.md`).
> 로컬 세션이 토큰 마이그레이션을 실행할 때 쓰는 변환표. **값이 다른 항목만 작업 대상**이다.

## 0. 핵심 결론 (먼저 읽기)

1. 현재 앱은 이미 견고한 토큰 시스템을 갖췄다. 마이그레이션은 **"제로에서 도입"이 아니라 "정합·확장·검증"** 이다.
2. **컬러 아키텍처는 앱 쪽(`AppColorScheme` 인스턴스 기반)을 유지**하는 것이 낫다. component_lab의 static+dark프리픽스 구조보다 앞서 있고, ACTION_PLAN P1의 목표(ThemeExtension)와 같은 방향이다. → component_lab foundation의 **값/누락 토큰만 흡수**한다.
3. Spacing/Radius/Typography는 **누락 단계만 추가**하면 거의 호환된다.
4. 가장 큰 신규 작업은 **Static 그룹 추가**(task 4)와 **Shadow 토큰 도입**(현재 앱에 그림자 토큰 없음).

## 1. Color

### 전략
- 앱의 `AppColor`(팔레트) + `AppColorScheme`(시맨틱) 구조 유지.
- component_lab 142색 팔레트와 앱 팔레트를 대조 → 앱에 없는 hue/단계 추가.
- 시맨틱 토큰은 `AppColorScheme`에 필드 추가 형태로 확장.

### 신규/검토 필요 시맨틱 그룹

| component_lab 그룹 | 앱 현황 | 액션 |
|---|---|---|
| Primary | ✅ 있음(5) | 값 대조만 |
| Label | ✅ 있음(6) | 값 대조만 |
| Background | ✅ 있음(5) | **task 4에서 값 변경** |
| Status | ✅ 있음(4) | 값 대조만 |
| Line | ✅ 있음(6) | 값 대조만 |
| Component | ✅ 있음(5) | ⚠️ fill/alternative 네이밍 충돌 해소 |
| Interaction | ✅ 있음(2) | 값 대조만 |
| Inverse | ✅ 있음(8) | 값 대조만 |
| **Accent** | ⚠️ 부분(`accentTasteBanner` 등 산발) | 그룹으로 정리 |
| **Static** | ⚠️ `staticLabelWhite*`만 일부 | **`staticBlack`/`staticWhite` 명시 추가 (task 4 필수)** |
| **Canvas scope** | ❌ | **신규(토큰 아님, 별칭)** — `AppColorScheme.canvas => dark`. 검정 캔버스(카드 밖)는 항상 다크 스킴 사용. 카드 안은 `of(context)`. 방향 B 필수(`04` §2) |
| Opacity(15단계) | 부분(`colorGlobalOpacity*`) | 누락 단계 추가 |

### ⚠️ Component/fill 네이밍 충돌 (HANDOFF 알려진 이슈)
- Figma "Component/fill/alternative" = **8%**, 현재 앱 `componentFillAlternative` = **5%** (`Color(0xFF70737C) @0.05`).
- 디자이너 합의 전까지 **현재 5% 유지 + 주석으로 차이 명시**. 임의 변경 금지.

## 2. Spacing

현재 앱(17단계)이 component_lab(13단계)을 거의 포함한다. **누락 3개만 추가**.

| 값(px) | 앱 `AppSpacing` | component_lab | 액션 |
|---|---|---|---|
| 2 | `space2` | – | 유지 |
| 4 | `space4`(xxs) | ✅ | – |
| 6 | `space6` | – | 유지 |
| 8 | `space8`(xs) | ✅ | – |
| 10 | `space10` | – | 유지 |
| 12 | `space12`(sm) | ✅ | – |
| 14 | `space14` | ✅ | – |
| 16 | `space16`(md) | ✅ | – |
| 20 | `space20`(lg) | ✅ | – |
| 24 | `space24`(xl) | ✅ | – |
| 28 | `space28` | – | 유지 |
| 32 | `space32`(xxl) | ✅ | – |
| **34** | ❌ | ✅ | **추가** |
| **36** | ❌ | ✅ | **추가** |
| 40 | `space40` | ✅ | – |
| **44** | ❌ | ✅ | **추가** |
| 48 | `space48`(xxxl) | ✅ | – |
| 56/64/80 | 있음 | – | 유지 |

- 시맨틱(container/button/item/safe-area)은 앱의 컴포넌트별 상수와 1:1 대응 확인 후 명칭 통일.
- 상세 규칙은 component_lab `docs/spacing-migration/`(01-audit→04-apply-log) 참조. → `03-style-application.md`.
- **iyumi 카드 패턴 시맨틱 spacing(신규 추가)**: `screenTopMargin=32`, `headerHorizontalPadding=20`, `sectionPadding=(24,32)`, `sectionGap=4`, `itemPadding=24`, `itemGap=4`, `cardGap=4`, `bottomDockAllowance=96`, `bottomBreathingRoom=16`, `bottomScrollInset(context)`. → `04` §3-4. (기존 팔레트 값 `space*`는 변경 금지, 시맨틱만 추가.)

## 3. Radius

| 값(px) | 앱 `AppRadius` | component_lab / iyumi | 액션 |
|---|---|---|---|
| 2/4/6/8/12/14/16/20/24 | ✅ 다수 | ✅(2~40 연속) | 대조 |
| 32 | `round` | (범위 내) | – |
| **40** | ❌(round=32까지) | ✅ iyumi `sectionRadius` | **추가**(카드 패턴 큰 카드) |
| 100 | `full` | Pill(100) | 동일 |

- 시맨틱: 앱 `button=12/card=16/modal=20` ↔ lib `radiusButton/radiusCard/radiusModal`. **값 동일 가능성 높음** — 명칭만 맞추거나 양쪽 별칭 유지.
- **iyumi 카드 패턴 시맨틱(신규)**: `sectionRadius=40`, `itemRadius=24`(=기존 xxxl). → `04-static-black-theme.md` §3-4.

## 4. Typography

- 둘 다 Pretendard, Display~Caption 동일 골격. 앱은 이미 폭넓은 스케일 보유.
- component_lab 66 스타일과 1:1 대조 → 앱에 **누락된 변형(Reading/Mono/특정 가중치)만 추가**.
- 명칭 규칙 통일(예: `body1NormalRegular` vs Figma `Body/1/normal/regular`).

## 5. Shadow

- ✅ **정정**: 앱에 **`AppShadows` 가 이미 존재**한다(예: `AppShadows.shadowBlackEmphasize`, 매칭 카드에서 사용). 신설 불필요 — 필요한 변형만 확장.
- component_lab은 Black/Primary × Normal/Emphasize/Strong/Heavy 보유.
- ✅ **확인됨**: iyumi 카드 패턴은 **아웃라인·그림자 없이 표면 명도 대비로 레이어 분리**(`reference/iyumi/card-design-spec.md`). → **카드용 `AppShadow`는 불필요**.
- 단, FAB/플로팅 요소(component_lab `AppFloatingActionButton`은 shadow 사용)나 일부 버튼에는 그림자가 필요할 수 있음 → 그 경우에만 한정적으로 `lib/constants/shadow_constant.dart`(`AppShadow`) 신설.

## 6. 위젯 매핑 (앱 위젯 → component_lab 컴포넌트)

| 현재 앱 위젯 | component_lab 대체 | 비고 |
|---|---|---|
| `widgets/buttons/primary_button.dart` | `AppSolidButton`(Primary tone) | 사이즈 체계 재정렬(52/40/32) |
| `widgets/buttons/social_button.dart` | (유지) + IconButton 변형 참고 | 소셜 색은 앱 고유 유지 |
| `widgets/cards/product_card.dart` | `components/cards/*` | iyumi 카드 스타일 반영 |
| `widgets/cards/recipe_card.dart` | `components/cards/*`(gradient) | handDrip/espresso 그라데이션 유지 |
| `widgets/forms/app_text_field.dart` | `components/forms/*` | + AppSearchInput/AppTextArea(신규) |
| `widgets/feedback/app_empty_state.dart` | `AppEmptyState`(P0 신규) | 라이브러리판으로 교체 |
| `widgets/modals/*` | `components/modals/*` + `AppFullModal`/`AppActionSheet`(P0) | 다수 신규 |
| `widgets/tags/flavor_tag.dart` | `components/chips/*`(Action/Filter) | flavor 색 유지 |
| `widgets/navigation/shell_*` | `components/navigation/*` | 셸은 앱 고유 — 신중히 |
| `widgets/timer/circular_timer.dart` | (유지) | 라이브러리에 없으면 앱 유지 |
| `widgets/charts/flavor_radar_chart.dart` | (유지) | 도메인 특화 |

> 원칙: **라이브러리에 동등 컴포넌트가 있으면 교체, 도메인 특화(타이머·레이더차트·셸)는 앱에 유지하되 토큰만 정합**.

## 7. 작업 체크리스트(요약)

- [ ] 팔레트 색 대조 → 앱 누락 색 추가
- [ ] `Static` 그룹 명시화(`staticBlack`/`staticWhite`)
- [ ] **`AppColorScheme.canvas => dark` 별칭 추가** (검정 캔버스=다크 스킴, 카드=`of(context)`; 방향 B)
- [ ] Component/fill 네이밍 충돌 주석 처리(값 변경 금지)
- [ ] Spacing 34/36/44 추가
- [ ] **iyumi 카드 패턴 시맨틱 spacing 추가**(screenTopMargin/sectionPadding/itemPadding/gap/bottomScrollInset 등)
- [ ] **Radius `sectionRadius=40` 추가**, `itemRadius=24` 별칭, 시맨틱 명칭 통일
- [ ] Typography 누락 변형 추가
- [ ] `AppShadow` — 카드엔 불필요(확인됨), FAB/플로팅 한정 검토
- [ ] **카드 위젯 신설**: `CardSection`/`CardItem`/`CardGap`/`ScreenScaffold` (iyumi 이식)
- [ ] 위젯 1:1 교체 매핑 확정
