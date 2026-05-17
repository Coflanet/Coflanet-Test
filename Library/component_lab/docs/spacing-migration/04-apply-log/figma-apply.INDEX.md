# Phase 4 — Figma 바인딩 적용 INDEX

**파일 키**: `q7yBPcHrid1CGQqFWEPwnR`
**소스**: Cowork 세션 (Phase 4 일괄 바인딩)
**완료 시각**: 2026-05-17
**정책**: safe-write gate (literal/resolved float 정확 일치만 바인딩) — 가시적 픽셀 변화 0

## 전체 합계

| 분류 | 수 |
|---|--:|
| **BOUND (신규 바인딩)** | **55,547** |
| **ALIGNED (이미 적용됨)** | **35,471** |
| NODE_MISS | 12 (component-button) |
| **총 처리** | **91,030** |

## Foundation

| group | bound | already | log |
|---|--:|--:|---|
| `foundation-space` | 114 | — | [figma-foundation-space.md](./figma-foundation-space.md) |

## Component

| group | bound | already | nodeMiss | log |
|---|--:|--:|--:|---|
| `component-button` | 3,054 | 331 | 12 | [figma-component-button.md](./figma-component-button.md) |
| `component-chip` | 1,585 | — | — | [figma-component-chip.md](./figma-component-chip.md) |
| `component-small` (avatar+scroll+ratio+thumbnail+divider+indicators) | 797 | 13 | — | [figma-component-small.md](./figma-component-small.md) |
| **소계** | **5,436** | **344** | **12** | |

## Module

| group | bound | already | log |
|---|--:|--:|---|
| `module-gauge` | 1 | — | [figma-module-gauge.md](./figma-module-gauge.md) |
| `module-control-box` | 41 | 177 | [figma-module-control-box.md](./figma-module-control-box.md) |
| `module-progress-indicators` | 1,242 | 25 | [figma-module-progress-indicators.md](./figma-module-progress-indicators.md) |
| `module-pagination` | 2,420 | 144 | [figma-module-pagination.md](./figma-module-pagination.md) |
| `module-feedback` | 2,933 | 350 | [figma-module-feedback.md](./figma-module-feedback.md) |
| `module-tab` | 5,903 | 380 | [figma-module-tab.md](./figma-module-tab.md) |
| `module-navigation` | 1,400 | 4,606 | [figma-module-navigation.md](./figma-module-navigation.md) |
| `module-contents` | 8,752 | 2,909 | [figma-module-contents.md](./figma-module-contents.md) |
| `module-presentation` | 6,800 | 16,869 | [figma-module-presentation.md](./figma-module-presentation.md) |
| `module-selection-input` | 16,208 | 9,604 | [figma-module-selection-input.md](./figma-module-selection-input.md) |
| **소계** | **45,700** | **35,064** | |

## Page-level (그 외)

별도 module 로그 없음 — 본 INDEX가 단일 source of truth.

| group | bound | already |
|---|--:|--:|
| `logo` | 21 | — |
| `typography` | 881 | 23 |
| `colors` | 2,132 | 8 |
| `gradient` | 149 | 2 |
| `decorate` | 174 | 4 |
| `icon` | 873 | — |
| `3d-illustration` | 15 | — |
| `product` | 2 | — |
| `etc-components` | 50 | 26 |
| **소계** | **4,297** | **63** |

## 카테고리별 합계 (sanity check)

| 카테고리 | bound | already |
|---|--:|--:|
| Foundation | 114 | 0 |
| Component | 5,436 | 344 |
| Module | 45,700 | 35,064 |
| Page-level | 4,297 | 63 |
| **합계** | **55,547** | **35,471** |

## 다음 단계

- Phase 5-Pre: `lib/foundation/app_spacing.dart` 리팩토링 (palette/semantic 기반)
- Phase 5: 코드 측 spacing 적용 (`AppSpacing.*` / `AppSpacingSemantic.*` 호출 사이트 마이그레이션)
