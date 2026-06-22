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

→ coflanet은 **자기 토큰 체계를 유지**하며 다음과 같이 매핑한다(권장):

| iyumi 역할 | coflanet 토큰 | 라이트(방향 A) | 다크 |
|---|---|---|---|
| 캔버스(화면 배경) | `backgroundNormalNormal` **및** `backgroundNormalAlternative` | **Static/Black #000000** | **Static/Black #000000** |
| 큰 카드 CardSection | `surfaceCard` | (방향 A) CN15류 다크 표면 | CN15 #1B1C1E (현행) |
| 작은 카드 CardItem(인셋) | `backgroundNormalAlternative`(=캔버스 검정) | 검정 인셋 | 검정 인셋 |
| 작은 카드(레이즈드 대안) | `surfaceCardStrong` | CN20류 | CN20 #292A2D |
| 틴트 카드 | `primaryLight` | (현행) | violet60 @20% |

> 즉 **큰 카드 = `surfaceCard`(CN15), 작은 카드 = 캔버스 검정 인셋**이 기본. iyumi의 "normal 카드 / alternative 인셋" 관계를 coflanet의 "surfaceCard / 캔버스" 로 옮긴 것.

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

### 3-3. 라이트 카드 표면 — 방향 결정(§4)
- **방향 A(권장)**: 라이트 `surfaceCard`/`surfaceCardStrong`/`labelNormal` 등을 다크 값에 수렴 → 통일된 다크 캔버스. 라이트/다크 토글은 사실상 거의 동일.
- **방향 B**: 라이트 `surfaceCard`=#FFFFFF 유지 → 검정 캔버스 + 흰 카드(고대비). 모드 간 외형 차이 큼.

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

## 4. 남은 결정 (1건만)

> iyumi 스펙으로 그림자·radius·구조는 모두 확정. **라이트 카드 톤만** 남음:

- [ ] **방향 A(통일 다크 캔버스, 권장) vs B(검정 위 흰 카드)** — `04` §3-3.
  - 권장 = **A**. 근거: 사용자가 "라이트·다크 모두 검정 캔버스"를 원함 → 일관성·구현 단순성↑, coflanet 셸이 이미 고정 다크, iyumi 프리미엄 톤과 부합.
  - B를 원하면(라이트=흰 카드 강조) 라이트 모드 가독성 별도 검증 필요.

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
3. §3-5 카드 위젯 신설(CardSection/CardItem/ScreenScaffold).
4. §3-3 방향 A 적용(라이트 표면 다크 수렴) — B 선택 시 분기.
5. §5 부작용 전수 점검.
6. 화면을 ScreenScaffold + CardSection/CardItem 패턴으로 재구성(task 3와 통합).

## 7. 검증

- [ ] 라이트·다크 양쪽 모든 화면 캔버스가 검정.
- [ ] 카드 명도 대비로 레이어 구분(아웃라인 없이도 식별) + WCAG AA 텍스트 대비(`ui-detail-check`).
- [ ] 숫자 직접 사용 0(전부 cds 토큰).
- [ ] §5 체크리스트 0 잔존.
- [ ] 셸·모달·스플래시 포함 전 화면 스냅샷(라이트/다크) → `verification/`.
