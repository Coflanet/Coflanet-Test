# Semantic Tokens — Phase 2 SoT

**버전**: `0.1.0-phase2`
**입력**: `palette.json`, `01-audit/gap-analysis.md`, USER_DECISION 검수 #2
**대응 코드**: `lib/foundation/app_spacing.dart` (SEMANTIC 섹션, l.68-95)

---

## 1. 카테고리 정의

| 카테고리 | 의미 | 적용 예 |
|---|---|---|
| `layout`           | 페이지/뷰포트 단위 외곽 치수. 디바이스 의존 상수 포함. | Safe Area, GNB/탭바 영역 |
| `container`        | 페이지 컨테이너의 outer padding. | 화면 루트 컨테이너 좌우/상하 패딩 |
| `inline`           | **가로** 형제 요소 사이 간격. | 아이콘-텍스트 갭, chip 사이 가로 갭 |
| `stack`            | **세로** 형제 요소 사이 간격. | 리스트 아이템 사이, 텍스트 단락 사이 |
| `inset`            | 임의 박스의 **내부** 패딩 (가로/세로 대칭 또는 단일 면). | 카드 내부 contents 패딩 |
| `component-{name}` | 특정 컴포넌트 내부 토큰 — 다른 카테고리에 일반화하기 어렵거나 컴포넌트별 고유값. | `component-button-padding-*` |

이름 규칙: `spacing-{category}-{role}` (kebab). `component-{name}` 의 경우 `spacing-component-{name}-{role}` (예: `spacing-component-button-padding-horizontal`).

---

## 2. 토큰 목록 (22)

### 2-1. `layout` (6)

| 토큰 | alias | 값 | 역할 |
|---|---|---:|---|
| `spacing-layout-safe-area-status-ios`     | `spacing-44` | 44 | iOS 상태바 영역 |
| `spacing-layout-safe-area-status-android` | `spacing-36` | 36 | Android 상태바 영역 |
| `spacing-layout-safe-area-status-web`     | `spacing-0`  | 0  | Web 상태바 (없음) |
| `spacing-layout-safe-area-bottom-ios`     | `spacing-34` | 34 | iOS 홈 인디케이터 영역 |
| `spacing-layout-safe-area-bottom-android` | `spacing-14` | 14 | Android 하단 제스처 영역 |
| `spacing-layout-safe-area-bottom-web`     | `spacing-0`  | 0  | Web 하단 (없음) |

> Phase 2 Dimension 분리 결정 시 본 6개는 `AppDeviceMetrics.*` 로 이관 예정. 잠정 보존.

### 2-2. `container` (2)

| 토큰 | alias | 값 | 역할 |
|---|---|---:|---|
| `spacing-container-padding-horizontal` | `spacing-24` | 24 | 페이지 루트 가로 패딩 |
| `spacing-container-padding-vertical`   | `spacing-32` | 32 | 페이지 루트 세로 패딩 |

### 2-3. `inline` (1)

| 토큰 | alias | 값 | 역할 |
|---|---|---:|---|
| `spacing-inline-icon-text` | `spacing-8` | 8 | 아이콘-텍스트 가로 갭 |

### 2-4. `stack` (6)

| 토큰 | alias | 값 | 역할 |
|---|---|---:|---|
| `spacing-stack-item`           | `spacing-12` | 12 | 리스트 아이템 간 세로 갭 |
| `spacing-stack-text`           | `spacing-16` | 16 | 텍스트 블록 간 세로 갭 |
| `spacing-stack-text-to-box`    | `spacing-16` | 16 | 텍스트 → 박스 세로 갭 |
| `spacing-stack-between-boxes`  | `spacing-20` | 20 | 박스 형제 간 세로 갭 |
| `spacing-stack-after-box`      | `spacing-16` | 16 | 박스 뒤 trailing 세로 갭 |
| `spacing-stack-after-text`     | `spacing-32` | 32 | 텍스트 뒤 trailing 세로 갭 |

### 2-5. `inset` (4)

| 토큰 | alias | 값 | 역할 |
|---|---|---:|---|
| `spacing-inset-contents-in-box`        | `spacing-24` | 24 | 박스 내부 contents 패딩 |
| `spacing-inset-contents-in-box-small`  | `spacing-8`  | 8  | 박스 내부 contents 패딩 (compact) |
| `spacing-inset-box-in-box`             | `spacing-16` | 16 | 박스 내부 박스 패딩 |
| `spacing-inset-top`                    | `spacing-16` | 16 | 박스 상단 내부 패딩 |

### 2-6. `component-button` (2)

| 토큰 | alias | 값 | 역할 |
|---|---|---:|---|
| `spacing-component-button-padding-horizontal` | `spacing-8`  | 8  | 버튼 가로 내부 패딩 — **Sem-mismatch** (Figma=16, 코드=8). Phase 1-D 결정 전. |
| `spacing-component-button-padding-vertical`   | `spacing-12` | 12 | 버튼 세로 내부 패딩 — **Sem-mismatch** (Figma=14, 코드=12). Phase 1-D 결정 전. |

---

## 3. Alias 관계도

```
PALETTE                                SEMANTIC
─────────                              ────────────────────────────────────────────
spacing-0   ──────────────┬─────────►  spacing-layout-safe-area-status-web
                          └─────────►  spacing-layout-safe-area-bottom-web

spacing-8   ──────────────┬─────────►  spacing-inline-icon-text
                          ├─────────►  spacing-inset-contents-in-box-small
                          └─────────►  spacing-component-button-padding-horizontal

spacing-12  ──────────────┬─────────►  spacing-stack-item
                          └─────────►  spacing-component-button-padding-vertical

spacing-14  ──────────────────────►   spacing-layout-safe-area-bottom-android

spacing-16  ──────────────┬─────────►  spacing-stack-text
                          ├─────────►  spacing-stack-text-to-box
                          ├─────────►  spacing-stack-after-box
                          ├─────────►  spacing-inset-box-in-box
                          └─────────►  spacing-inset-top

spacing-20  ──────────────────────►   spacing-stack-between-boxes

spacing-24  ──────────────┬─────────►  spacing-container-padding-horizontal
                          └─────────►  spacing-inset-contents-in-box

spacing-32  ──────────────┬─────────►  spacing-container-padding-vertical
                          └─────────►  spacing-stack-after-text

spacing-34  ──────────────────────►   spacing-layout-safe-area-bottom-ios

spacing-36  ──────────────────────►   spacing-layout-safe-area-status-android

spacing-44  ──────────────────────►   spacing-layout-safe-area-status-ios

(unused as semantic alias targets in this version)
spacing-4, spacing-28, spacing-40, spacing-48, spacing-56
```

### 3-1. Palette → Semantic fan-out

| Palette | Semantic alias 수 | 비고 |
|---|---:|---|
| `spacing-0`  | 2 | web safe-area (status, bottom) |
| `spacing-4`  | 0 | 팔레트로만 직접 사용 |
| `spacing-8`  | 3 | inline + inset-small + button-hor |
| `spacing-12` | 2 | stack-item + button-ver |
| `spacing-14` | 1 | safe-area-bottom-android |
| `spacing-16` | 5 | stack 다수 + inset 다수 — **가장 fan-out 큼** |
| `spacing-20` | 1 | stack-between-boxes |
| `spacing-24` | 2 | container-hor + inset-contents |
| `spacing-28` | 0 | off-scale 통합용 (semantic 미정) |
| `spacing-32` | 2 | container-ver + stack-after-text |
| `spacing-34` | 1 | safe-area-bottom-ios |
| `spacing-36` | 1 | safe-area-status-android |
| `spacing-40` | 0 | 팔레트로만 |
| `spacing-44` | 1 | safe-area-status-ios |
| `spacing-48` | 0 | 팔레트로만 |
| `spacing-56` | 0 | off-scale 통합용 |

palette **alias 없음** 인 5개 (`4, 28, 40, 48, 56`) 은 현 시점 직접 팔레트 호출 또는 마이그레이션 매핑 대상.

---

## 4. 규칙 준수 확인

| 규칙 | 충족 | 검증 |
|---|:--:|---|
| 모든 semantic 은 palette **1개** 정확히 alias | ✅ | 22 토큰 전부 단일 `aliasOf` |
| 동일 역할 → 동일 semantic 재사용 | ✅ | 역할 충돌 없음. `space16` 5회 fan-out 은 서로 다른 역할 |
| 카테고리 6종 (layout/container/inline/stack/inset/component-{name}) 사용 | ✅ | 6 카테고리 전부 ≥1 토큰 |
| 이름 규칙 `spacing-{category}-{role}` | ✅ | 22 토큰 전부 일치 |

---

## 5. 코드 매핑 (Dart 식별자)

USER_DECISION #2 권장 — kebab 은 Dart 식별자 불가능이므로 본 표를 SoT 로 사용. 현재 코드 식별자는 **유지** (camelCase, 변경 시 PR #28 이후 별도 마이그레이션).

| 문서 토큰 | 현재 Dart 식별자 (`AppSpacing.*`) | 권장 신규 식별자 (참고) |
|---|---|---|
| `spacing-layout-safe-area-status-ios`         | `safeAreaStatusIos`         | `layoutSafeAreaStatusIos` |
| `spacing-layout-safe-area-status-android`     | `safeAreaStatusAndroid`     | `layoutSafeAreaStatusAndroid` |
| `spacing-layout-safe-area-status-web`         | `safeAreaStatusWeb`         | `layoutSafeAreaStatusWeb` |
| `spacing-layout-safe-area-bottom-ios`         | `safeAreaBottomIos`         | `layoutSafeAreaBottomIos` |
| `spacing-layout-safe-area-bottom-android`     | `safeAreaBottomAndroid`     | `layoutSafeAreaBottomAndroid` |
| `spacing-layout-safe-area-bottom-web`         | `safeAreaBottomWeb`         | `layoutSafeAreaBottomWeb` |
| `spacing-container-padding-horizontal`        | `containerHorizontalPadding`| `containerPaddingHorizontal` |
| `spacing-container-padding-vertical`          | `containerVerticalPadding`  | `containerPaddingVertical` |
| `spacing-inline-icon-text`                    | *(신설)*                    | `inlineIconText` |
| `spacing-stack-item`                          | `itemSpacing`               | `stackItem` |
| `spacing-stack-text`                          | `textContentsSpacing`       | `stackText` |
| `spacing-stack-text-to-box`                   | `textToBoxSpacing`          | `stackTextToBox` |
| `spacing-stack-between-boxes`                 | `betweenBoxesSpacing`       | `stackBetweenBoxes` |
| `spacing-stack-after-box`                     | `bottomAfterBox`            | `stackAfterBox` |
| `spacing-stack-after-text`                    | `bottomAfterText`           | `stackAfterText` |
| `spacing-inset-contents-in-box`               | `paddingContentsInBox`      | `insetContentsInBox` |
| `spacing-inset-contents-in-box-small`         | `paddingContentsInBoxSmall` | `insetContentsInBoxSmall` |
| `spacing-inset-box-in-box`                    | `paddingBoxInBox`           | `insetBoxInBox` |
| `spacing-inset-top`                           | `inBoxTopPadding`           | `insetTop` |
| `spacing-component-button-padding-horizontal` | `buttonPaddingHorizontal`   | `componentButtonPaddingHorizontal` |
| `spacing-component-button-padding-vertical`   | `buttonPaddingVertical`     | `componentButtonPaddingVertical` |

> 식별자 일괄 rename 은 USER_DECISION #2 §4 **미결 항목** — 본 세션 범위 밖.

---

## 6. 미결 항목 인계

1. **Sem-mismatch 2건** (`spacing-component-button-padding-horizontal/vertical`) — Phase 1-D 에서 Figma 인스턴스 재검증 후 alias 대상 (8 vs 16, 12 vs 14) 정정.
2. **Safe Area 6 토큰의 Dimension 이관** — `AppDeviceMetrics.*` 분리 결정 시 본 카테고리(`layout`) 에서 제거.
3. **Dart 식별자 일괄 rename** — §5 권장 신규 식별자로 변경 여부.
4. **off-scale 통합** (`28`, `56` 의 semantic 부여) — `03-mapping/` 에서 통합 결과를 반영하면 semantic 추가 예정.
