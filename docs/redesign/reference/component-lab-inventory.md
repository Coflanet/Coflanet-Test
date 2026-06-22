# 레퍼런스: component_lab 라이브러리 인벤토리

> 출처: `Coflanet/Coflanet-Test` 레포 → `Library/component_lab/`
> (HANDOFF.md, ACTION_PLAN.md, pubspec.yaml, foundation/app_color.dart, GitHub 트리 기반)
> 이 문서는 마이그레이션 매핑의 우변(TO-BE)이자, 가져올 자산의 목록이다.

## 1. 정체성

- **이름**: Coflanet Design System (`component_lab` 패키지, v0.1.0)
- **형태**: Widgetbook 기반 Flutter 컴포넌트 카탈로그. Figma "📚 Library" 디자인 시스템을 코드로 옮긴 것.
- **3계층 구조**: Foundation(토큰) → Components(atoms) → Molecular(복합).
- **검증 원칙(non-negotiable)**: "No estimation" — 모든 값은 Figma `boundVariables`에서 추출. 추정 금지.

## 2. 패키지 메타 (`pubspec.yaml`)

```yaml
name: component_lab
version: 0.1.0
environment: { sdk: ^3.5.0, flutter: ^3.27.0 }
dependencies:
  widgetbook: ^3.11.0
  flutter_svg: ^2.0.10+1
  cached_network_image: ^3.3.1
  shimmer: ^3.0.0
  coflanet: { path: ../../coflanet-app-0.1.2 }   # ⚠️ 앱에 역의존
```

> ⚠️ **순환 의존 경고**: component_lab은 `coflanet` 앱을 path 의존성으로 가진다. 따라서 앱이 component_lab을 다시 path 의존성으로 끌어오면 순환이 된다. → **앱으로 가져올 때는 foundation/components 소스를 앱 내부로 흡수(복사·정리)하는 방식**을 써야 한다. (`02-library-migration.md` 전략 A)

## 3. 디렉터리 구조

```
Library/component_lab/
├── lib/
│   ├── component_lab.dart        # 배럴(barrel) export
│   ├── main.dart                 # Widgetbook 엔트리 (Foundation→Components→Molecular)
│   ├── foundation/               # 토큰
│   ├── components/               # atoms (아래 21개 카테고리)
│   ├── samples/                  # 샘플/예시
│   └── util/                     # 유틸
├── docs/
│   └── spacing-migration/        # 간격 마이그레이션 워크스페이스(01-audit ~ 04-apply-log)
├── assets/icons/
├── HANDOFF.md                    # 세션 인계 문서(필독)
├── icon-naming-guide.md
├── analysis_options.yaml
└── pubspec.yaml
```

루트(레포 최상위)에는 마이그레이션 분석 문서: `ACTION_PLAN.md`, `AUDIT_REPORT.md`, `CODE_INVENTORY.md`, `MISMATCH_REPORT.md`.

## 4. Foundation 토큰

| 영역 | 내용 |
|------|------|
| **Color** | 142색 / 12 hue. 시맨틱: Primary, Label, Background, Status, Line, Component, Interaction, Accent, **Static**(White/Black), Inverse. 라이트=기본명, 다크=`dark` 프리픽스. 15단계 Opacity. |
| **Typography** | 66 스타일 + emoji 변형. Display(2)·Title(3)·Heading(2)·Headline(2)·Body(2)·Label(2)·Caption + 가중치/Reading 변형. |
| **Spacing** | 13단계: 4,8,12,14,16,20,24,32,34,36,40,44,48. 시맨틱: container/button padding, item spacing, iOS/Android safe-area offset. |
| **Radius** | 2~40px + Pill(100). 시맨틱: `radiusButton`, `radiusCard`, `radiusModal`. |
| **Shadow** | Black 계열 + Primary 계열, 각 Normal/Emphasize/Strong/Heavy. (boundVariables 미추적 — 추출값 직접 적용) |

> **Color 구조 주의**: component_lab의 `foundation/app_color.dart`는 `AppColor` **static 클래스 + `dark` 프리픽스**(ThemeExtension 아님). 반면 현재 앱은 인스턴스 기반 `AppColorScheme`. 두 구조가 다르므로 토큰을 단순 복사하면 안 되고 **매핑/병합**이 필요하다. → `token-mapping.md`.

### Static 그룹 (task 4 직결)
- `Static/White` ≈ `staticLabelWhiteStrong` (#FFFFFF) — 테마 무관 고정 흰색.
- `Static/Black` (#000000) — 테마 무관 고정 검정. **task 4의 배경색이 이것.**

## 5. Components — 21개 카테고리

`avatars`, `buttons`, `cards`, `chips`, `contents`, `control_box`, `controls`, `dividers`, `feedback`, `forms`, `gauge`, `indicators`, `modals`, `navigation`, `pagination`, `presentation`, `ratio`, `scrolls`, `selection`, `tabs`, `thumbnails`.

### ✅ Figma 완전검증 — Button (6종)
1. **AppSolidButton** — 7 tone × 4 size (Large52/Medium40/Small32/XSmall32). tone: Primary, GrayPrimary, Gray, LiquidGlassPrimary, LiquidGlass, BackgroundBlurPrimary, BackgroundBlur.
2. **AppOutlinedButton** — 3 tone(Primary/Secondary/Assistive) × 4 size, stroke 1px.
3. **AppTextButton** — 3 tone × 2 size(Medium/Small), 배경 없음 + 아이콘 지원.
4. **AppIconButton** — 9 tone × 3 size(Normal40/Small32/Custom).
5. **AppFloatingActionButton** — 56×56, radius 1000, shadow + disable.
6. **AppSectionBottomButton** — 3 variant(TopLine / Solid+fade gradient / Fold).

### ⚠️ 코드 존재 · Figma 검증 대기
Chips, Avatars, Cards, Ratio, Thumbnail, Scroll, Indicators, Divider, 그리고 Molecular(Navigation, Progress, Controls, Forms, Modals 등).

### ❌ 미착수 / 보류
Molecular 전반, Icons, Gradients, Illustrations.

## 6. 토큰↔코드 매핑 (HANDOFF 발췌)

| Figma 변수 | 앱 토큰 | 용도 |
|---|---|---|
| Primary/normal | `primaryNormal` | 브랜드 바이올렛 |
| Static/White | `staticLabelWhiteStrong` | 강조 흰 텍스트 |
| Label/normal | `labelNormal` | 본문(검정) |
| Label/assistive | `labelAssistive` | 보조 텍스트(35%) |
| Component/fill/alternative | `componentFillNormal` | ⚠️ 네이밍 불일치 경보 |
| interaction/disable | `interactionDisable` | 비활성(50%) |

## 7. 알려진 이슈 (그대로 승계됨 — 마이그레이션 시 함께 처리)

1. **시맨틱 네이밍 충돌**: Figma "Component/fill/alternative(8%)" ≠ 우리 `componentFillAlternative(5%)`. 디자이너 합의 필요.
2. **Shadow boundVariables 미추적** — 추출값 직접 적용.
3. **삭제 대상 deprecated 파일**: `app_button.dart`, `icon_button_use_cases.dart`, `app_chip.dart`(추정 기반 → Action/Filter 변형으로 교체됨).
4. **Section Bottom gradient** 근사 구현 — 정확 색 보정 대기.
5. **Widgetbook v3.11.0** — 메이저 업그레이드 시 마이그레이션 경로 확인.

## 8. ACTION_PLAN 요약 (Phase 5)

- 현재 완성도 **74%** (디자인-코드 매칭 70.5%, 코드 등급 B). 누락 고빈도 위젯 10개, 크리티컬 버그 12개, 다크모드 미지원 21개.
- **P0(2주)**: 누락 위젯 9개 구현(AppSectionMessage, AppEmptyState, AppFullModal, AppActionSheet, AppAutoComplete, AppDatePicker, AppTimePicker, AppSearchInput, AppTextArea, AppProgressTracker) ~36h + 버그 12개 ~6h.
- **P1(2주)**: ThemeExtension 패턴 도입(~11.5h, 21개 컴포넌트 다크 분기 제거), 공유 metrics 클래스 통합(~8h), 변형/API 표준화(~6h), Widgetbook 등록(~2h).
- **P2(주5+)**: 미사용 위젯 제거, 매직넘버 토큰화, const 정합성, 접근성(시맨틱 라벨·48dp 터치), P2 위젯 정책 결정 후 구현. ~43h.
- 검증 게이트: `flutter analyze` 0 이슈 + 테스트 통과 + Widgetbook 라이트/다크 시각 검증.
- 총량 추정 **~113h** → 완성도 74%→95%.
