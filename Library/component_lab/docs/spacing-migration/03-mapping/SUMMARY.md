# Phase 3 매핑 SUMMARY (Task 06/33)

**생성 기준**: `01-audit/figma-spacing-raw.*.json` (110 파일), `01-audit/code-hardcoded-usages.*.json` (22 파일)
**토큰 정의**: `02-tokens/palette.json`, `02-tokens/semantic.json`, `02-tokens/name-mapping.csv` (v0.1)

## 1. Figma 매핑

- 총 행 수: **91,878**
- 상태 분포:
  - `READY`: 78,915 (85.9%)
  - `NEEDS_REVIEW`: 6,727 (7.3%)
  - `BLOCKED`: 6,236 (6.8%)

- 토큰 유형 분포 (전체 행 기준):
  - semantic 토큰 매칭: 25,544 (27.8%)
  - palette 직접: 59,035 (64.3%)
  - 미매핑 (빈 토큰): 7,299

- 카테고리별 분포:
  - `padding-other`: 37,870
  - `stack/inline`: 23,293
  - `inset`: 18,188
  - `inset-squish`: 5,752
  - `wrap-counter`: 168

- BLOCKED 사유 Top:
  - Demo 페이지: 5,555
  - Platform UI: 462
  - decimal value: 178
  - negative value (-6): 16
  - negative value (-8): 11
  - decimal value (7.5): 9
  - decimal value (2.7899999618530273): 4
  - negative value (-2): 1

- NEEDS_REVIEW 사유 Top:
  - 페이지 카탈로그 grid 의심: 412
  - 비표준 squish 페어 V6/H8: paddingTop=6px: 272
  - 비표준 squish 페어 V6/H8: paddingRight=8px: 272
  - 비표준 squish 페어 V6/H8: paddingBottom=6px: 272
  - 비표준 squish 페어 V6/H8: paddingLeft=8px: 272
  - 비표준 squish 페어 V8/H20: paddingTop=8px: 188
  - 비표준 squish 페어 V8/H20: paddingRight=20px: 188
  - 비표준 squish 페어 V8/H20: paddingBottom=8px: 188
  - 비표준 squish 페어 V8/H20: paddingLeft=20px: 188
  - 비표준 squish 페어 V4/H7: paddingTop=4px: 168

## 2. Code 매핑

- 총 행 수: **908**
- 상태 분포:
  - `BLOCKED`: 492 (54.2%)
  - `READY`: 386 (42.5%)
  - `NEEDS_REVIEW`: 30 (3.3%)

- 토큰 유형 분포 (전체 행 기준):
  - semantic 토큰 매칭: 39 (4.3%)
  - palette 직접: 364 (40.1%)
  - 미매핑 (빈 토큰): 505

- kind 별 분포:
  - `AppSpacingRef`: 389
  - `SizedBox`: 204
  - `EdgeInsets.symmetric`: 129
  - `EdgeInsets.all`: 89
  - `PropLiteral:spacing`: 33
  - `EdgeInsets.only`: 30
  - `PropLiteral:runSpacing`: 22
  - `EdgeInsets.fromLTRB`: 8
  - `PropLiteral:gap`: 4

- BLOCKED 사유 Top:
  - Demo 화면 (_use_cases.dart): 401
  - non-numeric SizedBox dimension: 48
  - non-numeric EdgeInsets.only: 11
  - non-numeric EdgeInsets.symmetric(horizontal): 10
  - EdgeInsets.only missing literal: 8
  - missing literal: 7
  - non-numeric EdgeInsets.all: 4
  - non-numeric EdgeInsets.symmetric(vertical): 3

- NEEDS_REVIEW 사유 Top:
  - 비표준 squish 페어 V4/H8 (Outlined 1px 보정 의심 가능): 2
  - SizedBox(width=)→inline palette 32 — Section gap 후보 (AppSpacingSemantic.layoutMd 가능): 2
  - SizedBox(width=)→inline palette 48 — Section gap 후보 (AppSpacingSemantic.layoutXl 가능): 2
  - SizedBox(height=)→stack palette 48 — Section gap 후보 (AppSpacingSemantic.layoutXl 가능): 2
  - 비표준 squish 페어 V4/H6 (Outlined 1px 보정 의심 가능): 2
  - SizedBox(height=)→stack off-scale literal 22px (closest palette: 20): 2
  - SizedBox(height=)→stack off-scale literal 280px (closest palette: 48): 2
  - symmetric V11/H28 off-scale: 1
  - 비표준 squish 페어 V4/H24 (Outlined 1px 보정 의심 가능): 1
  - 비표준 squish 페어 V6/H12 (Outlined 1px 보정 의심 가능): 1

## 3. 매핑 규칙 요약

### Figma itemSpacing 값 → Semantic 토큰 (값 기반 매핑)

Phase 1-A-2 sidecar 종결 결정에 따라 stack/inline 자동 분리 대신 **값 기반 canonical 매핑** 사용:

| value | suggestedToken | 비고 |
|---:|---|---|
| 2 | `AppSpacingSemantic.inlineXs` | stack.xs / inline.xs 동일값 — 집계 H>V 따라 inline 우선 |
| 4 | `AppSpacingSemantic.inlineSm` | stack.sm / inline.sm 동일값 |
| 8 | `AppSpacingSemantic.inlineMd` | stack.md / inline.md 동일값 |
| 12 | `AppSpacingSemantic.inlineLg` | inline 전용 |
| 16 | `AppSpacingSemantic.stackLg` | stack 전용 |
| 24 | `AppSpacingSemantic.stackXl` | stack 전용 |
| 32 / 40 / 48 | `AppSpacing.s32/40/48` + NEEDS_REVIEW | `layout.md/lg/xl` 후보 — Section gap 여부 검수 필요 |
| 1, 3, 6, 7, 9, 10, 14, 20, 28, 44 | `AppSpacing.s{value}` | palette 직접 (semantic 매칭 없음) |
| off-scale (5, 11, 13, 17, 31, 36, …) | NEEDS_REVIEW | 가장 가까운 palette 제안 |

### Padding 분류

- 4-side equal (T=R=B=L) + value ∈ {4, 8, 12, 16, 24} → `AppSpacingSemantic.inset{Xs..Xl}`
- T=B, L=R, T≠L + (V,H) ∈ {(2,6), (7,14), (9,20), (12,28)} → `AppSpacingSemantic.insetSquish*Vertical/Horizontal`
- (V,H) ∈ {(8,9), (9,8), (11,12), (12,11)} → palette 직접 + NEEDS_REVIEW (Outlined 1px 보정 의심)
- 그 외 비대칭/단면 → 개별 edge 별 palette 직접

### 자동 BLOCKED

- Figma: Demo 페이지 (`foundation-colors/typography/icon/decorate/gradient/logo/3d-illustration/product`)
- Figma: Platform UI 패턴 (`Platform=iOS`, `Platform=Android`, `iOS Status Bar`, `Dynamic Island`, `Home Indicator`, `Tab Bar` — usageNote/nodeName 기준)
- Figma: 음수 / 소수 값
- Figma: 페이지 직접 frame (sourceNodeId가 `I`로 시작하지 않음) + value > 40 → NEEDS_REVIEW (카탈로그 grid 의심)
- Code: `*_use_cases.dart` 파일
- Code: non-numeric expression

## 4. Phase 1-A-2 (sidecar) 종결 근거

→ `_aggregate-stats.md` 참고. V/H 집계 통계가 Presentation V25%/H75%, Selection V24%/H76%, Contents V29%/H71% 로 합치하여, **노드별 V/H 구분 없이 값 기반 canonical 매핑으로 v1.0 승격 결정.**
