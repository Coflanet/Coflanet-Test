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

## 3. Radius

| 값(px) | 앱 `AppRadius` | component_lab | 액션 |
|---|---|---|---|
| 2/4/6/8/12/14/16/20/24 | ✅ 다수 | ✅(2~40 연속) | 대조 |
| 32 | `round` | (범위 내) | – |
| **34/36/40** | ❌(round=32까지) | ✅(~40) | 필요 시 **추가** |
| 100 | `full` | Pill(100) | 동일 |

- 시맨틱: 앱 `button=12/card=16/modal=20` ↔ lib `radiusButton/radiusCard/radiusModal`. **값 동일 가능성 높음** — 명칭만 맞추거나 양쪽 별칭 유지.

## 4. Typography

- 둘 다 Pretendard, Display~Caption 동일 골격. 앱은 이미 폭넓은 스케일 보유.
- component_lab 66 스타일과 1:1 대조 → 앱에 **누락된 변형(Reading/Mono/특정 가중치)만 추가**.
- 명칭 규칙 통일(예: `body1NormalRegular` vs Figma `Body/1/normal/regular`).

## 5. Shadow (신규)

- **현재 앱에 그림자 토큰이 없다**(카드 플랫 디자인). component_lab은 Black/Primary × Normal/Emphasize/Strong/Heavy 보유.
- task 4의 "검정 캔버스 위 카드" 디자인에서는 **그림자보다 보더/표면 대비**가 핵심일 수 있으나, iyumi 카드 디자인이 그림자를 쓴다면 Shadow 토큰 도입이 필요. → iyumi 레퍼런스 확인 후 결정(`05-iyumi-reference.md`).
- 도입 시 `lib/constants/shadow_constant.dart`(`AppShadow`) 신설 권장.

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
- [ ] Component/fill 네이밍 충돌 주석 처리(값 변경 금지)
- [ ] Spacing 34/36/44 추가
- [ ] Radius 34/36/40 필요 시 추가, 시맨틱 명칭 통일
- [ ] Typography 누락 변형 추가
- [ ] `AppShadow` 신설 여부 결정(iyumi 확인 후)
- [ ] 위젯 1:1 교체 매핑 확정
