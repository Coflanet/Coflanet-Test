---
name: coflanet-design-guide
description: Coflanet 앱의 화면·카드·레이아웃을 "이유미 카드형 + Static/Black 캔버스" 디자인 시스템으로 일관되게 생성·수정하기 위한 가이드. Coflanet 앱에서 화면을 새로 만들거나(스플래시·온보딩·홈·커피·원두·매칭·마이 등) 기존 화면의 여백·간격·카드·색을 손볼 때, "이 화면 만들어줘/스타일 맞춰줘/카드로 바꿔줘/디자인 가이드대로/일관되게/마진 패딩 맞춰" 같은 요청이 오면 반드시 사용한다. 카드 레이어 구조(CardSection 40 / CardItem 24), 마진·패딩·간격 토큰, 색 적용 규칙(캔버스=다크 스킴 고정 / 카드=활성 스킴, 방향 B), 사용 위젯(ScreenScaffold·CardSection·CardItem·showAppSheet)을 강제한다. iyumi 카드 디자인 스펙을 SoT로 참조한다. 숫자 하드코딩을 막고 cds 시맨틱 토큰만 쓰게 한다.
---

# Coflanet 디자인 가이드

Coflanet 화면을 **항상 같은 규칙**으로 만들기 위한 강제 가이드. 출처(SoT)는 iyumi 카드 디자인 스펙(`docs/redesign/reference/iyumi/card-design-spec.md`)과 리디자인 계획(`docs/redesign/04-static-black-theme.md`, `reference/token-mapping.md`).

> 핵심 한 줄: **검정 캔버스 위에 카드가 떠 있고, 모든 수치는 토큰, 카드 밖은 다크 스킴·카드 안은 활성 스킴.**

## 0. 절대 규칙 (먼저 읽기)

1. **숫자 직접 금지** — radius/패딩/마진/간격은 전부 `AppSpacing.*` / `AppRadius.*` 시맨틱 토큰. `EdgeInsets.all(16)`·`BorderRadius.circular(24)`·`SizedBox(height: 32)`처럼 숫자를 쓰지 않는다. 없으면 팔레트(`space*`/`radius*`), 그것도 없으면 시맨틱 토큰을 **추가**한다(`token-mapping.md` 절차).
2. **색은 스킴으로** — `AppColor.시맨틱` 직접 사용 금지. 항상 스킴을 통해 읽어 테마 전환에 반응하게 한다. (어느 스킴인지는 §3.)
3. **카드 그림자 없음** — 카드는 그림자/아웃라인이 아니라 **표면 명도 대비**로 분리한다. (FAB 같은 플로팅 요소만 예외)
4. 토큰/위젯이 아직 코드에 없으면 **계획(`docs/redesign`)대로 추가**하고 절대 하드코딩으로 우회하지 않는다.

## 1. 레이어 구조

```
화면 배경 = 캔버스 (Static/Black, 라이트·다크 공통)
└─ 헤더: 상단 마진 screenTopMargin(32) + 최상단 텍스트 title2Bold (전 화면 통일)
└─ 큰 카드 = CardSection   radius 40, 풀폭, 표면색
   └─ 작은 카드 = CardItem  radius 24, 카드 안 인셋
```

## 2. 마진·패딩·간격 토큰 (이유미 스펙)

> 📐 **수치 SoT(Figma 검증 완료)**: `docs/redesign/spacing-typography-reference.md` — spacing/radius/typography/color를 토큰명+정확한 px+Figma 변수 대조로 정리. **화면 작업 전 이 문서의 §5 빠른 규칙을 먼저 본다.** (Library `q7yBPcHrid1CGQqFWEPwnR` 변수 1:1 검증, 2026-06-23.)
>
> 핵심 검증 결과: 라이트 시맨틱 색·라디우스(8·12·16·20·24·32)·spacing primitive는 **Figma=코드 일치**. `sectionRadius=40`은 📚 Library Foundation엔 없지만 **⭐️ POC 시안엔 `Round/40(Box)`로 실재**(코드 근거 있음 — Library 승격만 디자이너 합의). ⚠️ **타이포 weight 주의**: Figma의 Heading·Headline·Body·Label "Bold"는 SemiBold(600)인데 코드 `*Bold`는 w700 → 해당 계열은 코드가 더 굵음(레퍼런스 §3-1). 디자이너 확정 전까지 임의 변경 금지.

| 토큰 | 값 | 용도 |
|---|---|---|
| `AppSpacing.screenTopMargin` | 32 | 화면 최상단 텍스트 위 마진 — **이 값 하나로 전 화면 반영** |
| `AppSpacing.headerHorizontalPadding` | 20 | 헤더(카드 밖) 좌우 패딩 |
| `AppTextStyles.title2Bold` | — | 최상단 텍스트(전 화면 동일 사이즈) |
| `AppRadius.sectionRadius` | **40** | 큰 카드(CardSection) radius |
| `AppSpacing.sectionHorizontalMargin` | 0 | 큰 카드 좌우 마진(풀폭) |
| `AppSpacing.sectionPadding` | (h24, v32) | 큰 카드 패딩 |
| `AppSpacing.sectionGap` / `cardGap` | 4 | 카드 사이 간격 |
| `AppRadius.itemRadius` | **24** | 작은 카드(CardItem) radius |
| `AppSpacing.itemPadding` | 24 | 작은 카드 패딩 |
| `AppSpacing.itemGap` | 4 | 작은 카드 사이 간격 |
| `AppSpacing.bottomDockAllowance` | 96 | OS 독바(홈 인디케이터) 여유 |
| `AppSpacing.bottomBreathingRoom` | 16 | 독바 여유 위 호흡 |
| `AppSpacing.bottomScrollInset(context)` | 동적 | 스크롤 최하단 패딩 — 마지막 콘텐츠가 독바에 안 가리게 |

## 3. 색 적용 규칙 (방향 B + 캔버스=다크 스킴)

배경(캔버스)은 라이트·다크 **모두 Static/Black(#000000)**. 카드만 모드에 따라 바뀐다.

| 영역 | 사용 스킴 | 라이트 | 다크 |
|---|---|---|---|
| **캔버스(화면 배경)** | — | Static/Black #000000 | Static/Black #000000 |
| **큰 카드 CardSection** | `of(context).surfaceCard` | #FFFFFF 흰 카드 | #1B1C1E 다크 카드 |
| **작은 카드 CardItem** | `of(context).surfaceCardStrong` | #F4F4F5 | #292A2D |
| **틴트 카드** | `of(context).primaryLight` | (틴트) | violet60 @20% |
| **카드 밖**(헤더·섹션타이틀·캔버스 위 아이콘/디바이더/보조텍스트) | **`AppColorScheme.canvas`(= dark)** | 밝은 텍스트(검정 위) | 밝은 텍스트 |
| **카드 안**(카드 내부 본문/아이콘) | **`AppColorScheme.of(context)`** | 어두운 텍스트(흰 카드) | 밝은 텍스트(다크 카드) |

핵심 멘탈 모델:
- **카드 밖 = 항상 다크 스킴**(`AppColorScheme.canvas`). 검정 캔버스는 어떤 모드에서도 검정이라, 어두운 표면용으로 만든 다크 스킴이 그대로 정답.
- **카드 안 = 활성 스킴**(`AppColorScheme.of(context)`). 카드 표면이 모드별(흰/다크)이라 일반 토큰이 정상 동작.
- **토글하면 캔버스는 불변, 카드만 흰↔다크로 바뀐다.**
- 라이트에서 카드 밖에 `labelNormal`(어두운색)을 쓰면 **검정 위 검정**이 된다 — 반드시 `canvas` 사용.
- 시스템 UI 오버레이(상태바/내비바): 캔버스가 검정이라 **항상 밝은 아이콘**.

## 4. 사용 위젯 (직접 Container 조립 금지)

> ✅ **구현됨**: `CardSection`·`CardItem`·`CardGap` = `lib/widgets/cards/card_section.dart`, `ScreenScaffold` = `lib/widgets/cards/screen_scaffold.dart`. 토큰도 추가됨(`AppRadius.sectionRadius/itemRadius`, `AppSpacing.screenTopMargin/sectionPadding/itemPadding/cardGap/bottomScrollInset`, `AppColor.staticBlack/staticWhite`, `AppColorScheme.canvas`). 그림자는 `AppShadows`(기존) 사용. 화면을 새로 만들거나 고칠 때 이 위젯들로 조립한다.

| 위젯 | 역할 |
|---|---|
| `ScreenScaffold` | 화면 틀. 캔버스 배경 + 상단 마진 + 통일 타이틀(title2Bold) + back 자동 + 하단 `bottomScrollInset`. 셸 탭 내부 화면은 `useScaffold:false`(셸이 Scaffold 소유). |
| `CardSection` | 큰 카드(`title`/`trailing`/`padding`/`color`/`onTap`). 표면 `surfaceCard`. |
| `CardItem` | 작은 카드(인셋). 표면 `surfaceCardStrong`. |
| `CardGap` | 카드 간격(4) — Row/Column 공용. |
| `showAppSheet()` + `AppBottomSheet` | 모든 바텀시트 표준(상단 노출·버튼 하단 고정·스크롤). `showModalBottomSheet` 직접 호출 금지. 모서리 `AppRadius.top(radius24)`. |

규칙:
1. 셸 탭 내부 화면 → `ScreenScaffold(useScaffold:false)`. (FAB 필요한 탭만 자체 Scaffold 허용.)
2. 푸시 화면 → `ScreenScaffold` 기본값(back 버튼 자동 헤더).
3. 자체 스크롤(ListView/TabBarView/채팅) 화면 → `scrollable:false` + 리스트 하단에 `AppSpacing.bottomScrollInset(context)` 직접 적용.
4. 틴트 카드 → `CardSection(color: colors.primaryLight)`처럼 **색만** 덮고 수치는 동일.

## 5. 생성/수정 순서

1. `ScreenScaffold`로 화면 틀을 잡는다(타이틀·배경·하단 인셋 자동).
2. 콘텐츠를 `CardSection`(큰 카드)으로 묶고, 내부 항목은 `CardItem`으로, 사이는 `CardGap`.
3. 수치는 §2 토큰만. 색은 §3 규칙(카드 밖 `canvas` / 카드 안 `of(context)`).
4. 바텀시트는 `showAppSheet`.
5. §6 체크리스트로 자가 검증.

## 6. 검증 체크리스트

수치 기준은 `docs/redesign/spacing-typography-reference.md`(Figma 검증). 핵심 px:
- 최상단 텍스트: 위 마진 **32** / 스타일 **title2Bold(28·Bold)** / 좌우 **20**
- 큰 카드 radius **40**(`sectionRadius`, Figma 미존재 iyumi 토큰) / 패딩 **(24,32)** / 간격 **4**
- 작은 카드 radius **24**(`itemRadius`=Figma `Round/24`) / 패딩 **24** / 간격 **4**
- 버튼·입력 **12** / 카드 **16** / 칩 **8** / 모달 **20** (전부 Figma `Round/*` 일치)

- [ ] 화면 배경이 라이트·다크 모두 **검정**인가.
- [ ] 큰 카드 radius 40 / 작은 카드 radius 24, 패딩·간격이 §2 토큰(위 px)인가.
- [ ] **숫자 하드코딩 0** (`EdgeInsets.`/`circular(`/`SizedBox(height:` 직접 숫자 없음).
- [ ] 카드 밖 텍스트·아이콘이 `AppColorScheme.canvas`(다크 스킴)라 검정 위에서 보이는가.
- [ ] 카드 안 텍스트가 `of(context)`라 라이트(흰 카드=어두운 글자)/다크(다크 카드=밝은 글자) 정상인가.
- [ ] 카드에 그림자/아웃라인이 없는가(표면 대비로만 분리).
- [ ] 리스트 하단에 `bottomScrollInset`이 적용돼 콘텐츠가 독바에 안 가리는가.
- [ ] 새 토큰/위젯이 필요했다면 하드코딩 대신 추가했는가.

## 7. 더 깊이 (SoT)

- iyumi 원본 스펙: `docs/redesign/reference/iyumi/card-design-spec.md`, `bottom-sheet-guide.md`
- 색·배경 상세: `docs/redesign/04-static-black-theme.md`
- 토큰 변환표: `docs/redesign/reference/token-mapping.md`
- 현재 앱 토큰 현황: `docs/redesign/reference/current-design-system.md`
- **수치 레퍼런스(Figma 검증)**: `docs/redesign/spacing-typography-reference.md` — spacing/radius/typography/color 정확한 px + Figma 변수 대조. **수치 의문이 생기면 여기부터.**
- **Figma 원본 출처(파일 키·링크)**: `docs/redesign/reference/figma-sources.md` — Library(토큰 SoT)/POC/쇼핑. 토큰 검증·시안 대조 시 여기 링크 사용. **Figma 읽기 전용.**

> 수치 디테일(8pt 그리드·대비·터치타깃)을 더 깐깐히 보려면 `ui-detail-check`, 인지 부담은 `ux-burden-check`와 함께 쓴다. 이 스킬은 그보다 앞단의 **"Coflanet 카드 디자인 규칙 강제"** 레이어다.
