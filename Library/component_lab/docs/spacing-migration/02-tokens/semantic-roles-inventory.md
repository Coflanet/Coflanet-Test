# Semantic Roles Inventory — Part B-0 (Task 05)

**버전**: `v0.1` — itemSpacing 의 stack/inline 자동 분리는 **Phase 1-A-2 (Task 31a..z) 완료 후 v1.0** 으로 승격.
**생성**: Phase 1-A/B raw 스트리밍 + 정제 정책 적용 후 자동 클러스터링.
**입력**: 110 figma-spacing-raw.*.json + 22 code-hardcoded-usages.*.json
**용도**: Part B-1 (역할 확정) 입력. Figma 빈도 / 코드 빈도 / 대표 컴포넌트로 의도 토큰 ID 의 정당성 확인.

> 정제 정책: Platform UI, Demo 페이지, `*_use_cases.dart`, 페이지-직접 frame value>40, 소수점/음수 모두 제외.

> ⚠️ **v0.1 한계**: Phase 1-A v1 raw 스키마에 `layoutMode` 가 없어 §3 의 `itemSpacing` 23,246 노드를 stack(VERTICAL) / inline(HORIZONTAL) 으로 자동 분리 불가. v1.0 (Phase 1-A-2 사이드카 적용 후) 에서 두 표로 분리 예정. semantic.json 의 alias 값 자체는 본 한계와 무관 (검수 #2 사전 확정).

---

## 1. inset — 4방향 동일 padding

Figma 노드 수 (정제 후, 4면 동일): **4,541**

| 값 | Figma 노드 | 대표 컴포넌트 (Top 5) |
|---:|---:|---|
| 1 | 254 | Icon(119), Leading Content(62), Trailing Content(15), Trailing Content 3(14), Trailing Content 2(14) |
| 2 | 934 | Background(420), Tab First(111), Background/Liquid Glass(111), Container(98), Back(65) |
| 3 | 509 | Checkbox(262), Scroll Bar(111), Size Percent Position(48), Control/Checkbox(39), Scroll Bar/Scroll Bar(34) |
| 4 | 188 | Icon(69), Placeholder(50), Switch(23), Scroll Bar(12), Stepper(6) |
| 6 | 775 | Badge/Push(549), Icon(172), Button/Icon/LiquidGlass(19), Size Disable(10), Button/Icon/Background Blur(7) |
| 7 | 25 | Size Disable(10), Button/Icon/Primary(2), Leading Button(2), Trailing Button(2), Active(2) |
| 8 | 41 | List/Preference/Resource/Attributes(16), Content(6), Preference(3), Large Icon(3), Frame 6(2) |
| 9 | 670 | Inactive(670) |
| 10 | 79 | Container(27), Size Disable(10), Button/Icon/Primary(7), Button/Icon/LiquidGlass Primary(7), Button/Icon/Background Blur Primary(7) |
| 12 | 268 | Container(141), Input(69), Menu Action Area(33), Content(18), Searchinput/Searchinput(3) |
| 14 | 31 | Overlay(18), Status(13) |
| 16 | 18 | Button/Floating Action(6), Disable(2), List(2), Handle(2), Container(2) |
| 20 | 208 | Container(11), Modal/Popup(10), Contents(8), Content(8), Progress Tracker/Resource/Normal/Vertica(3) |
| 24 | 524 | Content(332), (unnamed)(113), Case(35), Subproperty(15), Resource(10) |
| 28 | 5 | Information(5) |
| 32 | 6 | column Ratio(2), Contents(2), Content(2) |
| 40 | 6 | Light(4), Dark(2) |

## 2. inset-squish — T=B, L=R, T≠L

Figma 노드 수: **2,929**, 고유 페어: **54**

| 페어 (V/H) | Figma 노드 | 대표 컴포넌트 (Top 5) |
|---|---:|---|
| V=2 / H=6 | 1,037 | Value(628), Variant(286), Badge(123) |
| V=6 / H=8 | 272 | Chip/Action(78), Chip 1(23), Chip 2(23), Chip 3(23), Chip 4(23) |
| V=12 / H=28 | 260 | Button/Solid/LiquidGlass Primary(80), Button/Solid/LiquidGlass(25), Button(24), ┗ Main Action(19), ┗ Alternative Action(19) |
| V=8 / H=20 | 188 | Container(84), Step Select(57), Wrapper(42), Size Disable(2), Button/Outlined/Secondary(1) |
| V=4 / H=7 | 168 | Chip/Action(118), Size Variant Disable Active(6), Chip 1(5), Chip 2(5), Chip 3(5) |
| V=7 / H=14 | 93 | Button(63), Variant Size Disable(14), Size Disable(4), Button/Outlined/Secondary(3), Button/Solid/Primary(1) |
| V=4 / H=8 | 85 | Vertical Stack(80), lable(3), Select(2) |
| V=7 / H=11 | 83 | Chip/Action(33), Size Variant Disable Active(6), Chip 1(5), Chip 2(5), Chip 3(5) |
| V=12 / H=20 | 83 | Container(83) |
| V=20 / H=16 | 60 | Navigation(60) |
| V=9 / H=12 | 51 | Size Variant Disable Active(6), Chip 1(5), Chip 2(5), Chip 3(5), Chip 4(5) |
| V=8 / H=16 | 50 | Navigation(34), Container(16) |
| V=9 / H=20 | 48 | Variant Size Disable(14), Button/Outlined/Assistive(11), Button(5), Size Disable(4), Button/Solid/Primary(3) |
| V=12 / H=16 | 48 | Textinput/Resource/Textfield/Button(22), Trailing Button(21), Variant Disable(3), Tag_List(2) |
| V=4 / H=1 | 45 | Title(43), Auto Complete/Resource/Item/Title(1), Menu/Resource/Item/Title(1) |
| V=10 / H=12 | 44 | Picker Action Area(23), Primary Button(6), Clear Button(5), Seconday Button(4), Check Box with img(2) |
| V=16 / H=20 | 37 | Container(18), Pagination(6), Cell(4), Check Box with img(4), Select Ratio Column(2) |
| V=11 / H=16 | 37 | Container(18), Snackbar/Snackbar(8), Toast/Toast(6), Variant(5) |
| V=7 / H=10 | 20 | Variant Size Disable(14), Size Disable(6) |
| V=5 / H=2 | 19 | Message(19) |
| V=10 / H=16 | 19 | Time(15), Navigation(4) |
| V=11 / H=28 | 17 | Button/Outlined/Secondary(11), Size Disable(6) |
| V=4 / H=6 | 17 | Container(17) |
| V=17 / H=16 | 16 | Button 1(2), Button 2(2), Button 3(2), Button 4(2), Button 5(2) |
| V=24 / H=20 | 13 | Preview(9), Select(4) |
| V=2 / H=12 | 13 | Container(13) |
| V=3 / H=1 | 9 | Size State Tight Disable(6), Control/Checkbox(3) |
| V=6 / H=10 | 8 | Container(8) |
| V=24 / H=16 | 7 | List(5), Size(2) |
| V=3 / H=12 | 7 | Bullet(7) |

## 3. stack / inline — itemSpacing (수직/수평 미구분)

> ⚠️ raw 스키마에 `autoLayoutMode` 가 없어 stack vs inline 자동 분리 불가. Part B-1 에서 디자이너 검수로 분배.

Figma 노드 수: **23,246**

| 값 | Figma 노드 | 대표 컴포넌트 (Top 5) |
|---:|---:|---|
| 1 | 104 | Content(100), Info(2), Input Field(2) |
| 2 | 784 | Content(556), Container(141), List/Preference/Resource/Attributes(16), review(11), price(8) |
| 3 | 374 | Content(147), Badge(123), Vertical Stack(80), Wrapper(19), txt(3) |
| 4 | 4,484 | Content(2698), Value(628), Heading(252), Wrapper(231), Contents(89) |
| 5 | 52 | Content(51), 고객센터(1) |
| 6 | 958 | Content(410), Heading(396), Row(29), Wrapper(23), Key(22) |
| 7 | 6 | Type(1), Hour(1), Minute(1), Hour Input(1), selected(1) |
| 8 | 6,404 | Container(1164), Wrapper(1112), Label(1040), Trailing Content(942), Cell(839) |
| 10 | 5,755 | Container(1091), Divider(1070), Loading(669), Icon Button(469), Selection & Input/Keyboard/Resource/Keyp(309) |
| 12 | 763 | Container(166), Coffee Profile/Attributes/Resource/Gauge(124), Content(92), Contents(77), Input(71) |
| 14 | 11 | Row(11) |
| 16 | 2,044 | Content(432), List(320), Top Navigation/Resource/Action/Normal(120), Section(117), Leading Button(113) |
| 17 | 1 | Date Header(1) |
| 20 | 406 | Content(104), Contents(67), Trailing Content(43), Coffee Profile(6), Wrapper(5) |
| 24 | 1,021 | Content(597), (unnamed)(95), Heading(69), Bottom(69), Case(35) |
| 28 | 6 | Main(2), Description(2), Container(1), Arrows(1) |
| 31 | 5 | bar(5) |
| 32 | 54 | Slider/Slider(14), Heading(8), Snackbar/Snackbar(8), Percent Disable(8), Description(5) |
| 36 | 6 | Header(4), Label and Date(1), Input Selection(1) |
| 40 | 4 | List/Preference/Resource/Profile(1), Cell/Cell(1), Accordion/Accordion(1), Menu(1) |
| 74 | 1 | Local Selection Row(1) |
| 120 | 1 | Actions(1) |
| 121 | 1 | Actions(1) |
| 179 | 1 | Header(1) |

## 4. counterAxisSpacing — Wrap 의 교차축 간격

Figma 노드 수: **168**

| 값 | Figma 노드 | 대표 컴포넌트 (Top 5) |
|---:|---:|---|
| 2 | 7 | Grid(7) |
| 4 | 30 | Coffee Profile/Flavor Notes/Resource(15), Chip(15) |
| 6 | 10 | Container(4), Content(3), Column(2), Heading(1) |
| 8 | 60 | Content(49), List(8), Section(2), Menu(1) |
| 10 | 1 | imgReview_List(1) |
| 16 | 20 | Content(20) |
| 20 | 20 | Navigation(2), Play Icon Badge/Play Icon Badge(1), Avatar/Avatar(1), Cell/Cell(1), Accordion/Accordion(1) |
| 24 | 19 | Content(14), Actions(5) |
| 489 | 1 | Navigation(1) |

## 5. 비대칭 / 단면 padding — palette 직접 사용 후보

- 4면 모두 채워졌으나 비대칭: **186** 노드
- 일부 면만 padding: **31,164** 항목

이 두 부류는 semantic 토큰 후보가 아닌 palette 직접 호출 대상 (Outlined 1px 보정 등 컴포넌트 고유 보정 패턴).

## 6. 코드 측 역할 인벤토리 — kind × dir × value

`*_use_cases.dart` 제외. 토큰 참조 / 리터럴 분리.

| 카테고리 | 합계 | Top 디렉터리 |
|---|---:|---|
| token reference | 225 | contents(102), feedback(29), presentation(29), selection(17), buttons(6) |
| gap (stack 또는 inline) | 155 | contents(87), feedback(22), presentation(9), selection(9), buttons(6) |
| inset-or-inset-squish | 73 | contents(21), feedback(11), chips(8), navigation(6), presentation(6) |
| directional padding (palette 직접) | 30 | contents(10), presentation(8), tabs(5), avatars(2), gauge(2) |
| inset | 19 | contents(5), presentation(4), feedback(3), modals(2), buttons(1) |
| PropLiteral (Wrap spacing/runSpacing 등) | 9 | chips(4), contents(4), navigation(1) |

## 7. 코드 tokenRef 빈도 (현행 AppSpacing.*)

| 토큰 | 빈도 |
|---|---:|
| `AppSpacing.space8` | 128 |
| `AppSpacing.space16` | 87 |
| `AppSpacing.space12` | 86 |
| `AppSpacing.space4` | 84 |
| `AppSpacing.space24` | 18 |
| `AppSpacing.space20` | 2 |

---

## 8. Part B-1 입력 요약 (의사결정 가이드)

위 클러스터에서 다음 신호를 읽음:

- **inset 핵심 값** (Top 6): 2(934), 6(775), 9(670), 24(524), 3(509), 12(268)
- **inset-squish 핵심 페어** (Top 6): V2/H6(1,037), V6/H8(272), V12/H28(260), V8/H20(188), V4/H7(168), V7/H14(93)
- **itemSpacing 핵심 값** (Top 8): 8(6,404), 10(5,755), 4(4,484), 16(2,044), 24(1,021), 6(958), 2(784), 12(763)

Part B-1 의 Semantic 토큰 초안은 이 분포를 반영해 확정함 (semantic.json 참조).
