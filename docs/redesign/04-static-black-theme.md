# Task 4 — iyumi 카드형 디자인 + Static/Black 배경(라이트·다크 공통)

> 목표: iyumi의 카드형 디자인 언어를 따르되, **페이지 배경색을 라이트/다크 양쪽 모두 `Static/Black`(#000000)으로 고정**한다.
> 사전 읽기: `reference/current-design-system.md`(§2 배경/표면, §7 카드, §8 셸), `05-iyumi-reference.md`(레퍼런스 상태).

## 1. 의도 해석

"검정 캔버스 위에 카드가 떠 있는" 단일 미감. 테마(light/dark)는 **배경이 아니라 카드·텍스트·컴포넌트의 톤**에만 영향을 준다. 페이지 배경은 항상 검정.

- 셸 탭바는 **이미 고정 다크 글래스** → 검정 배경과 자연스럽게 일관(`reference/current-design-system.md` §8).
- 즉 다크 모드는 거의 그대로, **라이트 모드의 흰 배경을 검정으로 전환**하는 것이 변화의 핵심.

## 2. 정확한 기계적 변경 (코드 레벨)

### 2-1. Static 토큰 명시화 — `lib/constants/color_constant.dart`
```dart
// AppColor에 추가 (이미 staticLabelWhite* 존재 → 짝으로 명시)
static const Color staticBlack = colorGlobalCommon0;    // #000000
static const Color staticWhite = colorGlobalCommon100;  // #FFFFFF
```

### 2-2. 배경 토큰을 Static/Black으로 고정 — `lib/constants/app_color_scheme.dart`
**라이트 스킴**(현재 흰색 → 검정):
```dart
// AS-IS (light)
backgroundNormalNormal: AppColor.colorGlobalCommon100,      // #FFFFFF
backgroundNormalAlternative: AppColor.colorGlobalCoolNeutral99,
// TO-BE (light)
backgroundNormalNormal: AppColor.staticBlack,               // #000000
backgroundNormalAlternative: AppColor.staticBlack,          // #000000
```
**다크 스킴**: 이미 `Common0`(#000000) → **변경 없음**. (`staticBlack`으로 명칭만 통일 권장.)

> `AppTheme._build`의 `scaffoldBackgroundColor: colors.backgroundNormalNormal`이 자동으로 검정이 됨 — 추가 작업 불필요.

### 2-3. 표면/카드 정합 (라이트 모드 재설계 — 핵심 결정 지점)
배경이 검정이 되면 **라이트 모드의 흰 카드/진한 텍스트 가정이 깨진다**. 두 방향 중 택1(→ §4 미결):

- **방향 A — "다크 우선 단일 톤"(권장 시작점)**: 라이트 모드도 다크에 가까운 카드/텍스트 톤 사용.
  - `surfaceCard`(light): `Common100`(#FFF) → `CoolNeutral15`(#1B1C1E) 류로 하향(다크 값에 수렴).
  - `labelNormal`(light): 진회색 → 밝은회색(다크 값에 수렴).
  - 사실상 라이트/다크 차이를 최소화한 "올웨이즈 다크 캔버스".
- **방향 B — "검정 위 라이트 카드"**: 배경만 검정, 라이트 카드는 흰색 유지(고대비 플로팅 카드).
  - `surfaceCard`(light) = #FFFFFF 유지. 검정 배경 + 흰 카드 + 검정 텍스트.
  - 강한 명암 대비. iyumi 카드가 이 룩이면 채택.

> iyumi 카드 디자인의 실제 톤(카드 배경/텍스트/그림자)을 확인해야 A/B 확정 가능 → `05-iyumi-reference.md`.

### 2-4. 카드 스타일 (iyumi 카드형)
`reference/current-design-system.md` §7 현재 카드 → iyumi 사양으로:
- 반경: `radiusCard`(16) 기준(iyumi 값 확인).
- 패딩: `cardPadding`(16) 기준(iyumi 값 확인).
- 그림자: 현재 앱은 그림자 없음. iyumi가 그림자/글로우를 쓰면 `AppShadow` 도입(→ `token-mapping.md` §5).
- 보더: 검정 배경 위 카드 윤곽 확보 — `lineNormalNormal` 또는 미세 글로우.

## 3. 영향 점검 체크리스트 (배경 검정화 부작용)

라이트 모드에서 "흰 배경 가정"으로 작성된 곳을 전수 점검:
- [ ] 흰 배경 위에 흰/연한 요소를 둔 화면 → 검정 위에서 사라짐.
- [ ] 검정 텍스트를 배경에 직접 올린 화면(카드 밖) → 검정 위 검정.
- [ ] 이미지/일러스트의 흰 여백 → 검정 위에서 분리됨.
- [ ] 상태바/내비바 오버레이(`main.dart` AnnotatedRegion) — 라이트에서도 밝은 아이콘 필요(검정 배경).
- [ ] 소셜 로그인 버튼(Apple 검정) → 검정 배경 위 보더/대비 확보.
- [ ] 스플래시/모달 딤(`componentMaterialDimmer`) — 검정 위에서 딤 효과 재확인.
- [ ] 셸 콘텐츠 배경(`backgroundNormalAlternative`) 검정화 → 상단 라운드 40px 경계 시각 확인.

## 4. 미결 — iyumi 확인 후 확정 (⚠️ 블로커)

> **현재 `IYUMI-org/iyumi` 레포 접근 불가(404/비공개)** → 아래는 iyumi 원본 확인 후 결정. `05-iyumi-reference.md` 참조.

- [ ] **방향 A vs B** (§2-3): 라이트 모드 카드/텍스트를 다크에 수렴시킬지, 검정 위 흰 카드로 둘지.
- [ ] iyumi 카드 정확 사양: 배경색, 반경, 패딩, **그림자/글로우 유무**, 보더.
- [ ] "Static/Black"이 순검정(#000000)인지, 약간의 오프블랙(예: #0A0A0B)인지.
- [ ] 라이트/다크 토글을 **유지**할지(배경만 고정), 아니면 사실상 단일 테마로 갈지.

## 5. 적용 순서

1. (의존) task 2 단계 1 — Static 토큰 흡수 완료.
2. §2-1, §2-2 적용(배경 검정 고정) — 가장 작은 변경으로 전체 톤 확인.
3. §3 부작용 전수 점검·수정.
4. iyumi 확인 후 §2-3 방향 확정 → 표면/카드 토큰 보정.
5. §2-4 카드 스타일 iyumi 정합.
6. task 3 스타일 적용과 통합 검증.

## 6. 검증

- [ ] 라이트·다크 양쪽에서 모든 화면 배경이 검정.
- [ ] WCAG 대비: 검정 배경 위 텍스트/카드 AA 충족(`ui-detail-check`).
- [ ] §3 체크리스트 0 잔존.
- [ ] 셸·모달·스플래시 포함 전 화면 스냅샷(라이트/다크) → `verification/`.
