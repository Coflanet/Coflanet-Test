# 이유미 카드형 디자인 패턴 스펙

> SoT: cds(`../Coflanet/cds`) 시맨틱 토큰 — `AppSpacing`(`lib/foundation/app_spacing.dart`) / `AppRadius`(`lib/foundation/app_radius.dart`).
> **모든 수치는 cds 토큰으로만 사용한다. 화면 코드에 숫자 직접 작성 금지.**

## 레이어 구조

```
화면 배경 (backgroundNormalAlternative)
└─ 헤더: 상단 마진 32 + 최상단 텍스트 (홈과 동일 title2Bold)
└─ 큰 카드 = 섹션 카드 (CardSection)        ← radius 40, 풀폭, bg normal
   └─ 작은 카드 = 내부 아이템 (CardItem)    ← radius 24, bg alternative
```

## 토큰표

| 토큰 | 값 | 참조 | 용도 |
|---|---|---|---|
| `AppSpacing.screenTopMargin` | 32 | `space32` | 화면 최상단 텍스트 위 마진 — **이 값 하나만 바꾸면 전 화면 반영** |
| `AppSpacing.headerHorizontalPadding` | 20 | `space20` | 헤더(카드 밖 텍스트) 좌우 패딩 (+ Breakpoints horizontalMargin) |
| `AppTextStyles.title2Bold` | title2Bold | — | 최상단 텍스트 — 홈 인사말과 동일 사이즈로 전 화면 통일 |
| `AppRadius.sectionRadius` / `sectionRadiusBorder` | 40 | `radius40` | 큰 카드 radius (Round/40, 1st Box) |
| `AppSpacing.sectionHorizontalMargin` | 0 | `space0` | 큰 카드 좌우 마진 — 풀폭 |
| `AppSpacing.sectionPaddingHorizontal` | 24 | `space24` | 큰 카드 좌우 패딩 |
| `AppSpacing.sectionPaddingVertical` | 32 | `space32` | 큰 카드 상하 패딩 |
| `AppSpacing.sectionPadding` | (24, 32) | 위 두 스칼라 조립 | 큰 카드 EdgeInsets |
| `AppSpacing.sectionGap` | 4 | `space4` | 큰 카드 사이 간격 |
| `AppRadius.itemRadius` / `itemRadiusBorder` | 24 | `radius24` | 작은 카드 radius (Round/24, Box) |
| `AppSpacing.itemPaddingValue` / `itemPadding` | 24 | `space24` | 작은 카드 패딩 |
| `AppSpacing.itemGap` | 4 | `space4` | 작은 카드 사이 간격 |
| `AppSpacing.cardGap` | 4 | = `sectionGap` | 간격 공통 별칭 |
| `AppSpacing.bottomDockAllowance` | 96 | `space80 + space16` | OS 독바(홈 인디케이터) 여유 |
| `AppSpacing.bottomBreathingRoom` | 16 | `space16` | 독바 여유 위 호흡 |
| `AppSpacing.bottomScrollInset(context)` | 동적 | safe area + 96 + 16 | 스크롤 최하단 패딩 — 마지막 콘텐츠가 독바에 안 가리게 |

색상 (시맨틱 — `AppColorScheme.of(context)`):

| 역할 | 토큰 |
|---|---|
| 화면 배경 | `backgroundNormalAlternative` |
| 큰 카드 배경 | `backgroundNormalNormal` (아웃라인 없음) |
| 작은 카드 배경 | `backgroundNormalAlternative` (상위 카드와 구분) 또는 `primaryLight` 틴트 |

## 재사용 위젯

| 위젯 | 파일 | 역할 |
|---|---|---|
| `CardSection` | `lib/widgets/card_section.dart` | 큰 카드. `title`/`trailing`/`padding`/`color`/`onTap` |
| `CardItem` | `lib/widgets/card_section.dart` | 작은 카드. `padding`/`color`/`onTap` |
| `CardGap` | `lib/widgets/card_section.dart` | 카드 간격(4) — Row/Column 공용 |
| `ScreenScaffold` | `lib/widgets/screen_scaffold.dart` | 화면 틀. 배경 alternative + 상단 마진 토큰 + 통일 타이틀 + back 자동 + `bottomScrollInset` 하단 패딩 |
| `SectionBox` | `lib/widgets/section_box.dart` | 레거시 호환 래퍼 → `CardSection` 위임. 신규 코드는 `CardSection` 직접 사용 |

## 사용 규칙

1. **숫자 직접 금지** — radius/패딩/마진/간격은 전부 cds 시맨틱 토큰(`AppSpacing.*`/`AppRadius.*`). 없으면 팔레트(`space*`/`radius*`), 그것도 없으면 cds 시맨틱 섹션에 토큰을 추가.
2. 셸 탭 내부 화면(홈/식재료/마이)은 `ScreenScaffold(useScaffold: false)` — 셸이 Scaffold 를 소유.
   예외: FAB 가 필요한 셸 탭(기록)은 자체 Scaffold 소유를 허용한다 — FAB 는 Scaffold 슬롯이 필요하므로. 그 외 탭은 원칙 유지.
3. 푸시 화면은 `ScreenScaffold` 기본값 — AppBar 대신 back 버튼 자동 헤더.
4. 자체 스크롤(ListView/TabBarView/채팅)을 가진 화면은 `scrollable: false` 로 body 가 스크롤을 소유하고, **리스트 하단 패딩에 `AppSpacing.bottomScrollInset(context)` 를 직접 적용**한다.
5. 틴트 카드(코칭 등)는 `CardSection(color: colors.primaryLight)` 처럼 색만 덮어쓴다 — 수치는 동일.
6. cds 는 Coflanet 과 공유하는 SoT — 카드 패턴 시맨틱 토큰은 cds `AppSpacing`/`AppRadius` 의 시맨틱 섹션에 추가하고, 기존 팔레트 값 변경은 금지(Coflanet 영향).

## 레퍼런스 화면

- `lib/modules/home/home_view.dart` — 패턴 원형 (섹션 스택 + 3열 quick 카드 radius 24/간격 4)
- `lib/modules/my/my_view.dart` — CardItem 행 목록형
- `lib/modules/ai_coach/ai_coach_view.dart` — scrollable:false (채팅) 케이스
