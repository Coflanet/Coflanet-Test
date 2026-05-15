# Palette Tokens — Phase 2 SoT (Task 05)

**버전**: `1.0.0`
**입력**: `01-audit/gap-analysis.md`, `01-audit/figma-spacing.INDEX.json` (91,882 items / 110 raw part), `01-audit/code-audit.INDEX.json` (22 raw / 927 usage), 검수 #2 확정 (2026-05-14)
**대응 코드**: `lib/foundation/app_spacing.dart` (Phase 5-Pre 에서 재구성 예정)

---

## 1. 확정 스케일 (20 토큰)

정제 정책 적용 후의 Figma / 코드 빈도. 정제 = Platform UI 제외 + Demo 페이지 제외 + `*_use_cases.dart` 제외 + 페이지-직접 frame value>40 제외 + 소수점/음수 제외.

| # | 토큰 (JSON) | Dart | 값 (px) | Figma 빈도 | 코드 빈도 (총) | 코드 (tokenRef / literal) | 분류 |
|---:|---|---|---:|---:|---:|---|---|
|  1 | `spacing/0` | `AppSpacing.s0` | 0 | 0 | 12 | 0 / 12 | core |
|  2 | `spacing/1` | `AppSpacing.s1` | 1 | 1,938 | 3 | 0 / 3 | sub-step |
|  3 | `spacing/2` | `AppSpacing.s2` | 2 | 14,741 | 24 | 0 / 24 | sub-step |
|  4 | `spacing/3` | `AppSpacing.s3` | 3 | 4,383 | 4 | 0 / 4 | sub-step |
|  5 | `spacing/4` | `AppSpacing.s4` | 4 | 13,047 | 91 | 84 / 7 | core |
|  6 | `spacing/6` | `AppSpacing.s6` | 6 | 7,797 | 18 | 0 / 18 | sub-step |
|  7 | `spacing/7` | `AppSpacing.s7` | 7 | 906 | 0 | 0 / 0 | button-pair |
|  8 | `spacing/8` | `AppSpacing.s8` | 8 | 13,921 | 131 | 128 / 3 | core |
|  9 | `spacing/9` | `AppSpacing.s9` | 9 | 3,821 | 1 | 0 / 1 | button-pair |
| 10 | `spacing/10` | `AppSpacing.s10` | 10 | 6,379 | 5 | 0 / 5 | sub-step |
| 11 | `spacing/12` | `AppSpacing.s12` | 12 | 6,687 | 87 | 86 / 1 | core |
| 12 | `spacing/14` | `AppSpacing.s14` | 14 | 343 | 0 | 0 / 0 | button-pair |
| 13 | `spacing/16` | `AppSpacing.s16` | 16 | 3,609 | 87 | 87 / 0 | core |
| 14 | `spacing/20` | `AppSpacing.s20` | 20 | 2,791 | 5 | 2 / 3 | button-pair |
| 15 | `spacing/24` | `AppSpacing.s24` | 24 | 3,296 | 19 | 18 / 1 | core |
| 16 | `spacing/28` | `AppSpacing.s28` | 28 | 605 | 1 | 0 / 1 | button-pair |
| 17 | `spacing/32` | `AppSpacing.s32` | 32 | 130 | 3 | 0 / 3 | layout |
| 18 | `spacing/40` | `AppSpacing.s40` | 40 | 50 | 2 | 0 / 2 | layout |
| 19 | `spacing/44` | `AppSpacing.s44` | 44 | 81 | 0 | 0 / 0 | layout |
| 20 | `spacing/48` | `AppSpacing.s48` | 48 | 0 | 4 | 0 / 4 | layout |

---

## 2. 명명 규칙

| 컨텍스트 | 표기 | 예 |
|---|---|---|
| JSON (W3C DTCG / Figma Variables, slash) | `spacing/{value}` | `spacing/12` |
| Dart 식별자 (camelCase) | `AppSpacing.s{value}` | `AppSpacing.s12` |

---

## 3. 데이터 정제 정책

Phase 1-A/B raw 활용 시 모두 적용. 정제 후 통과한 row 만 본 팔레트 결정의 근거가 됨.

1. **Platform UI 제외**: 부모 체인이나 노드명/usageNote 에 `Platform=iOS|Android`, `Status Bar`, `Dynamic Island`, `Home Indicator`, `Tab Bar`, `Safe Area`, `iPhone|iPad`, `iOS/...`, `Android/...` 포함 시 자식 모두 제외
2. **Demo 페이지 제외**: `foundation-colors`, `foundation-typography`, `foundation-icon`, `foundation-decorate`, `foundation-gradient`, `foundation-logo`, `foundation-3d-illustration`, `foundation-product`
3. **`foundation-space` 예외 포함**: 토큰 정의 spec 페이지 — 포함
4. **Demo 코드 제외**: 모든 `*_use_cases.dart` 파일
5. **페이지 직접 frame 주의**: `sourceNodeId` 가 `I` 로 시작 안 하는 노드 중 큰 spacing(>40) 은 카탈로그 grid → 제외
6. **음수/소수점 제외**: itemSpacing 음수(겹침) / 1.33 같은 소수는 Platform UI 잔존 후처리에서 자동 제거

### 정제 통계

| 단계 | Figma | 코드 |
|---|---:|---:|
| raw row | 91,882 | 927 |
| Demo 제외 | 5,559 | 398 |
| Platform UI 제외 | 537 | — |
| 페이지-grid 제외 | 403 | — |
| 음수/소수점 제외 | 181 | — |
| 비숫자 제외 | — | 82 |
| **accepted** | **85,202** | **511** |

---

## 4. 제외값 사유

### 4-1. 제외 확정 (단발성 또는 grid)

| 값 | Figma 빈도 | 코드 빈도 | 사유 |
|---:|---:|---:|---|
| 5 | 132 | 0 | single-occurrence Filler |
| 11 | 387 | 1 | single-occurrence button bottom |
| 36 | 13 | 0 | Safe Area Android (Dimension 후속 트랙) |
| 60 | 0 | 0 | foundation-space 페이지 카탈로그 grid |
| 64 | 0 | 0 | Avatar overlap grid |
| 80 | 4 | 1 | feedback 단발 |
| 160 | 0 | 0 | page catalog frame |

### 4-2. Spacing 범위 외 (별도 size 토큰 후속 트랙)

- width/height 의 큰 값 (112, 120, 128, 200, 240, 280, 300, 320 등): Dimension/Size 토큰 후속 트랙
- 1px **border** 두께: `AppBorderWidth` 후속 트랙 (단, 1px **padding** 은 본 팔레트 `spacing/1` 에 포함)

### 4-3. Off-scale 잔존 후보 (정제 후 빈도 ≥ 100, 팔레트 미포함)

정제 후에도 Figma 빈도가 일정 이상이나, 검수 #2 에서 별도 토큰화 보류:

(없음)

---

## 5. 제약 준수 확인

| 제약 | 충족 |
|---|:--:|
| Palette `0` 포함 | ✅ `spacing/0` |
| 명명 규칙 `spacing/{value}` | ✅ 20 토큰 |
| 검수 #2 의 20 값 ↔ 본 팔레트 1:1 | ✅ |

