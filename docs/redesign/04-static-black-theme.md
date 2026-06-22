# Task 4 — iyumi 카드형 디자인 + Static/Black 배경(라이트·다크 공통)

> 목표: iyumi의 카드형 패턴(CardSection/CardItem)을 따르되, **페이지 캔버스를 라이트/다크 양쪽 모두 `Static/Black`(#000000)으로 고정**.
> 사전 읽기: `reference/iyumi/card-design-spec.md`(전문), `05-iyumi-reference.md`, `reference/current-design-system.md`(§2 배경/표면).

## 1. 의도 (iyumi 스펙으로 확정)

iyumi의 **중첩 카드 레이어**를 그대로 가져오고, 캔버스만 검정으로 고정한다.

```
캔버스 (Static/Black, 라이트·다크 공통)
└─ 헤더: 상단 마진 32 + title2Bold
└─ 큰 카드 CardSection   radius 40, 풀폭, 표면색 (캔버스보다 밝음)
   └─ 작은 카드 CardItem  radius 24, 인셋(캔버스색) 또는 primaryLight 틴트
```

- iyumi 카드는 **아웃라인/그림자 없음** — 표면 명도 대비로 분리. → coflanet도 카드 그림자 불필요(`AppShadow` 카드엔 미도입).
- 셸 탭바는 이미 고정 다크 글래스 → 검정 캔버스와 일관.

## 2. Role 매핑 — iyumi 토큰 → coflanet `AppColorScheme`

⚠️ iyumi와 coflanet은 normal/alternative의 **의미가 다르다**:
- iyumi: `normal`=카드 표면, `alternative`=캔버스(인셋/더 어두움).
- coflanet: `normal`=메인 배경, `alternative`=보조 배경, **별도 `surfaceCard`/`surfaceCardStrong`** 보유.

→ coflanet은 **자기 토큰 체계를 유지**하며 다음과 같이 매핑한다.

> ✅ **방향 B 확정** (사용자): 캔버스는 양쪽 검정, **라이트=흰 카드 / 다크=다크 카드**.

| iyumi 역할 | coflanet 토큰 | 라이트(B) | 다크(B) |
|---|---|---|---|
| 캔버스(화면 배경) | `backgroundNormalNormal` **및** `backgroundNormalAlternative` | **Static/Black #000000** | **Static/Black #000000** |
| 큰 카드 CardSection | `surfaceCard` | **#FFFFFF (흰 카드)** | **#1B1C1E CN15 (다크 카드)** |
| 작은 카드 CardItem(인셋) | `surfaceCardStrong` | #F4F4F5 CN98(흰 카드 속 미세 인셋) | #292A2D CN20 |
| 틴트 카드 | `primaryLight` | violet95 류 | violet60 @20% |

> ⚠️ **방향 B의 인셋 규칙 변경**: iyumi 원본은 작은 카드 = `alternative`(=캔버스색)로 인셋. 하지만 B는 캔버스가 **검정**이라, 라이트 흰 카드 안에 검정 인셋을 넣으면 과한 대비가 된다. → **작은 카드는 `surfaceCardStrong`**(큰 카드 표면에 가까운 톤)을 써서 라이트·다크 모두 은은한 중첩을 만든다.

### ⚠️ 방향 B의 최대 함정 — "텍스트가 어디 위에 있나"

B에서는 **같은 라이트 모드 안에서도 배경이 두 종류**다: 검정 캔버스 vs 흰 카드. 따라서 텍스트 색을 한 토큰(`labelNormal`)으로 통일할 수 없다.

| 위치 | 라이트 모드 텍스트 | 다크 모드 텍스트 | 규칙 |
|---|---|---|---|
| **카드 밖**(검정 캔버스 위 헤더·섹션 타이틀) | **밝은색**(검정 위) | 밝은색 | 테마 무관 고정 밝은색 |
| **카드 안**(흰/다크 카드 내부 본문) | 어두운색(흰 카드 위) | 밝은색(다크 카드 위) | 일반 테마 토큰 |

- **카드 밖(on-canvas)**: 셸 탭바가 이미 쓰는 방식 그대로 — `staticLabelWhite*`(테마 무관 고정 밝은색) 사용. 라이트에서 `labelNormal`(어두운색)을 검정 캔버스에 쓰면 **검정 위 검정**이 된다.
- **카드 안(in-card)**: `AppColorScheme.of(context).labelNormal` 그대로(라이트=어두움, 다크=밝음) — 카드 표면이 모드별로 흰/다크라 정상 동작.
- 권장: **on-canvas 전용 시맨틱 토큰**(예: `labelOnCanvas`/`labelOnCanvasAssistive` = static white 계열)을 추가하고, `ScreenScaffold` 헤더는 이 토큰을 강제. CardSection/CardItem 내부는 일반 토큰.
- 같은 원리로 **카드 밖 아이콘/디바이더/보조 텍스트**도 on-canvas 토큰을 써야 검정 위에서 보인다.

## 3. 정확한 기계적 변경 (코드)

### 3-1. Static 토큰 명시화 — `lib/constants/color_constant.dart`
```dart
static const Color staticBlack = colorGlobalCommon0;    // #000000
static const Color staticWhite = colorGlobalCommon100;  // #FFFFFF
```

### 3-2. 캔버스를 Static/Black 고정 — `lib/constants/app_color_scheme.dart`
**라이트**(현재 흰색 → 검정):
```dart
backgroundNormalNormal:      AppColor.staticBlack,  // was Common100(#FFF)
backgroundNormalAlternative: AppColor.staticBlack,  // was CoolNeutral99
```
**다크**: 이미 `Common0` → `staticBlack`으로 명칭만 통일.
> `AppTheme._build`의 `scaffoldBackgroundColor: colors.backgroundNormalNormal`이 자동으로 검정이 됨.

### 3-3. 카드 표면 — ✅ 방향 B 확정
- 라이트: `surfaceCard`=#FFFFFF(흰 카드) / `surfaceCardStrong`=#F4F4F5 유지.
- 다크: `surfaceCard`=#1B1C1E / `surfaceCardStrong`=#292A2D 유지.
- **카드 내부** `labelNormal` 등은 현행 유지(라이트=어두움/다크=밝음) — 카드 표면이 모드별로 맞으므로 정상.
- **카드 밖(on-canvas)** 텍스트/아이콘만 static white 계열로 전환(§2 함정 표).

### 3-4. 카드 패턴 토큰 추가 — `AppSpacing`/`AppRadius` (`token-mapping.md` §3·§7)
신규 시맨틱 토큰(iyumi 값):
```
AppRadius.sectionRadius = 40   (신규; 현재 round=32까지)
AppRadius.itemRadius    = 24   (= 기존 xxxl)
AppSpacing.screenTopMargin = 32, headerHorizontalPadding = 20
AppSpacing.sectionPadding = (24,32), sectionGap = 4
AppSpacing.itemPadding = 24, itemGap = 4, cardGap = 4
AppSpacing.bottomDockAllowance = 96, bottomBreathingRoom = 16
AppSpacing.bottomScrollInset(context)  // safe area + 96 + 16
```

### 3-5. 카드 위젯 신설 — `lib/widgets/`
iyumi 위젯을 coflanet 토큰으로 이식:
- `CardSection`(큰 카드: radius 40, surfaceCard, title/trailing/padding/color/onTap)
- `CardItem`(작은 카드: radius 24, 인셋)
- `CardGap`(간격 4)
- `ScreenScaffold`(배경 캔버스 + 상단 마진 32 + 통일 타이틀 title2Bold + back 자동 + bottomScrollInset). 셸 탭 내부는 `useScaffold:false`.
- (선택) `SectionBox` 레거시 래퍼는 도입 불필요 — coflanet 신규 코드는 `CardSection` 직접.

## 4. 결정 완료 ✅

- 캔버스 = Static/Black(양쪽), 카드 = **방향 B**(라이트 흰 카드 / 다크 다크 카드) — **확정**.
- 카드 패턴 = iyumi `CardSection`(40)/`CardItem`(24), 무그림자.
- 남은 작업은 결정이 아니라 **구현·검증**: 특히 §2 "텍스트 위치" 함정(on-canvas vs in-card)과 §5 부작용 점검을 빠짐없이.

## 5. 배경 검정화 부작용 점검 (라이트 "흰 배경 가정" 화면)

- [ ] 흰 배경 위 흰/연한 요소 → 검정 위에서 사라짐.
- [ ] 카드 밖 검정 텍스트 → 검정 위 검정.
- [ ] 이미지/일러스트 흰 여백 → 검정 위 분리됨.
- [ ] 상태바/내비바 오버레이(`main.dart` AnnotatedRegion) — 라이트에서도 밝은 아이콘.
- [ ] 소셜 버튼(Apple 검정) → 검정 위 보더/대비.
- [ ] 모달 딤(`componentMaterialDimmer`) — 검정 위 재확인.
- [ ] 셸 콘텐츠 배경 검정화 + 상단 라운드 40 경계.

## 6. 적용 순서

1. (의존) task 2 단계1 — Static 토큰 + 카드 패턴 토큰 흡수.
2. §3-1·3-2 적용(캔버스 검정) — 최소 변경으로 전체 톤 확인.
3. **on-canvas 라벨 토큰 추가**(§2 함정) + `ScreenScaffold` 헤더가 이를 강제하도록.
4. §3-5 카드 위젯 신설(CardSection/CardItem/ScreenScaffold) — 방향 B 색값(§3-3) 적용.
5. §5 부작용 전수 점검(특히 검정 위 텍스트/아이콘).
6. 화면을 ScreenScaffold + CardSection/CardItem 패턴으로 재구성(task 3와 통합).

## 7. 검증

- [ ] 라이트·다크 양쪽 모든 화면 캔버스가 검정.
- [ ] 카드 명도 대비로 레이어 구분(아웃라인 없이도 식별) + WCAG AA 텍스트 대비(`ui-detail-check`).
- [ ] 숫자 직접 사용 0(전부 cds 토큰).
- [ ] §5 체크리스트 0 잔존.
- [ ] 셸·모달·스플래시 포함 전 화면 스냅샷(라이트/다크) → `verification/`.
