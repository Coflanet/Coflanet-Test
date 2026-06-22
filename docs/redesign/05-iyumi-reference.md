# Task 5 — iyumi 문서 레퍼런스

> 목표: iyumi의 디자인 문서를 참고해 카드 디자인·스타일 결정을 정합.
> ✅ **해소됨** — 사용자가 iyumi `docs/`를 zip으로 전달(2026-06-22). 핵심 스펙을 `reference/iyumi/`에 vendoring.

## 1. iyumi의 정체 (중요)

- iyumi(`IYUMI-org/iyumi`)는 **영유아 이유식 케어 앱** — coflanet(커피 앱)과 **별개 제품**.
- 그러나 **같은 디자인 시스템 = Coflanet CDS**를 공유한다. iyumi는 원래 `package:cds`에 의존했고, 독립 빌드를 위해 토큰 5종을 `lib/core/tokens/`로 내재화했다(`app_color`, `app_color_theme`(ThemeExtension), `app_radius`, `app_spacing`(8pt), `app_text_style`).
- 따라서 "이유미 카드형 디자인" = **iyumi가 CDS 위에서 정제한 카드 패턴**(`reference/iyumi/card-design-spec.md`)이며, coflanet과 토큰 계보가 같아 **명칭·구조가 호환**된다.

```
Coflanet CDS  ──┬─ coflanet (커피)
                └─ iyumi (이유식) → 카드 패턴(CardSection/CardItem) 정제
```

## 2. 카드 디자인 스펙 (핵심 — 전문: `reference/iyumi/card-design-spec.md`)

### 레이어 구조 (중첩 카드)
```
화면 배경 (backgroundNormalAlternative)         ← 캔버스
└─ 헤더: 상단 마진 32 + title2Bold 텍스트
└─ 큰 카드 = CardSection   radius 40, 풀폭, bg = backgroundNormalNormal (아웃라인 없음)
   └─ 작은 카드 = CardItem  radius 24, bg = backgroundNormalAlternative(= 캔버스색, 인셋) 또는 primaryLight 틴트
```

### 핵심 토큰 (cds 시맨틱 — 숫자 직접 작성 금지)
| 토큰 | 값 | 용도 |
|---|---|---|
| `AppSpacing.screenTopMargin` | 32 | 화면 최상단 텍스트 위 마진(전 화면 통일) |
| `AppSpacing.headerHorizontalPadding` | 20 | 헤더(카드 밖) 좌우 패딩 |
| `AppTextStyles.title2Bold` | — | 최상단 텍스트(전 화면 동일 사이즈) |
| `AppRadius.sectionRadius` | **40** | 큰 카드 radius |
| `AppSpacing.sectionHorizontalMargin` | 0 | 큰 카드 좌우 마진(풀폭) |
| `AppSpacing.sectionPadding` | (24, 32) | 큰 카드 패딩(좌우24/상하32) |
| `AppSpacing.sectionGap` / `cardGap` | 4 | 카드 사이 간격 |
| `AppRadius.itemRadius` | **24** | 작은 카드 radius |
| `AppSpacing.itemPadding` | 24 | 작은 카드 패딩 |
| `AppSpacing.itemGap` | 4 | 작은 카드 사이 간격 |
| `AppSpacing.bottomDockAllowance` | 96 | OS 독바(홈 인디케이터) 여유 |
| `AppSpacing.bottomBreathingRoom` | 16 | 독바 여유 위 호흡 |
| `AppSpacing.bottomScrollInset(context)` | 동적 | 스크롤 최하단 패딩(콘텐츠가 독바에 안 가리게) |

### 색상 (시맨틱)
| 역할 | 토큰 |
|---|---|
| 화면 배경(캔버스) | `backgroundNormalAlternative` |
| 큰 카드 | `backgroundNormalNormal` (아웃라인 없음) |
| 작은 카드 | `backgroundNormalAlternative`(인셋) 또는 `primaryLight` 틴트 |

> ⚠️ **role 차이 주의**: iyumi는 "normal=카드 표면 / alternative=캔버스(더 어두운/인셋)". coflanet은 "normal=메인 배경 / alternative=보조배경 + 별도 `surfaceCard`". → task 4에서 매핑 규칙 정의(`04-static-black-theme.md` §2).

### 재사용 위젯 (iyumi `lib/widgets/`)
- `CardSection` — 큰 카드(`title`/`trailing`/`padding`/`color`/`onTap`).
- `CardItem` — 작은 카드.
- `CardGap` — 간격(4), Row/Column 공용.
- `ScreenScaffold` — 화면 틀(배경 alternative + 상단 마진 + 통일 타이틀 + back 자동 + bottomScrollInset). 셸 탭 내부 화면은 `useScaffold:false`.
- `SectionBox` — 레거시 호환 래퍼 → `CardSection` 위임(신규는 CardSection 직접).

### 사용 규칙(요약)
1. 숫자 직접 금지 — 전부 cds 시맨틱 토큰.
2. 틴트 카드(코칭 등)는 `CardSection(color: colors.primaryLight)`처럼 **색만** 덮어쓰고 수치는 동일.
3. 자체 스크롤 화면은 `scrollable:false` + 리스트 하단에 `bottomScrollInset(context)` 직접 적용.

## 3. 바텀시트 표준 (`reference/iyumi/bottom-sheet-guide.md`)

`showAppSheet()` + `AppBottomSheet` 하나로 통일. 3축: **상단 노출**(전체 안 덮음, `topReserve` 56) / **버튼 하단 고정**(`footer`) / **스크롤 영역**(`body`, Flexible). 모서리 `AppRadius.top(radius24)`, 드래그 핸들 36×4. → coflanet 모달 7종 마이그레이션(task 2 단계5) 시 이 표준 채택 검토.

## 4. 이 레퍼런스가 푸는 결정

| 결정 | 해소 내용 |
|---|---|
| 카드 방향 A/B (`04` §4) | iyumi 패턴은 "캔버스 + 중첩 카드". coflanet은 캔버스=Static/Black 고정 → **방향 A(통일 다크 캔버스) 권장**으로 구체화(`04` §2). |
| 카드 그림자 | iyumi 카드는 **아웃라인/그림자 없음**, 색 대비(normal vs alternative)로 분리. → **`AppShadow` 신설 불필요**(카드엔). |
| radius/패딩 정확값 | sectionRadius 40 / itemRadius 24 / sectionPadding(24,32) / itemPadding 24 / gap 4 — 확정. |
| Static/Black 정확값 | iyumi 문서엔 "Static/Black" 명시 없음 → coflanet 고유 요구. 순검정(#000000=Common0) 기준(`04` §2). |

## 5. 남은 참고(iyumi 앱 특화, 미vendoring)

flow-audit / userflow-all-cases / ia-structure / ux-design-review-report / qa_* / research-* 등은 이유식 제품 특화. coflanet 직접 이식 X. 단 **플로우 감사·IA 평가 방법론**은 task 1에 참고 가능(원본 zip 보관).
