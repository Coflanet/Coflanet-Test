# Phase 1-A 결과 — Figma 페이지 정찰 & 검수 #1

**브랜치**: `claude/spacing-tokens-organization-NwPFO`
**마지막 커밋**: `312e07e chore(spacing-migration): exclude ⚙️ Components page from audit`
**관련 PR**: #25 (머지됨, 워크스페이스 부트스트랩) / #27 (drafy, ⚙️ Components 제외)

---

## 1. Phase 1-A 범위

- 📚 Library Figma 파일 (`q7yBPcHrid1CGQqFWEPwnR`) 의 전체 페이지 인벤토리 작성
- audit 대상 / 제외 대상 분류
- 코드 디렉터리 ↔ Figma 페이지 매핑 (`codeDirToFigmaPage`)
- 사람 검수 #1 통과

산출물: `01-audit/figma-pages.json`

---

## 2. 검수 #1 — 통과

사용자가 Figma 사이드바에서 직접 copy 한 페이지 링크 RTF 와 JSON 의 `audit:true` 페이지를 1:1 대조.

### 2-1. ID 일치 — 27/27 ✅
사용자 RTF 28개 → ⚙️ Components 제외 후 27개 모두 JSON 과 정확히 일치.

### 2-2. `auditOrder` 우선순위 — ✅
1번 = `foundation-space` (`pageId: 2485:8842`, `priority: CRITICAL`).
토큰 정의 페이지를 가장 먼저 봐야 다른 그룹의 alias 해석 가능.

### 2-3. `codeDirToFigmaPage` 다중매핑 — ✅
페이지 단위에서는 모두 합당:
- `controls` / `forms` / `selection` → `2442:7603` (☑️ Selection and 📝 Input)
- `cards` / `contents` → `2573:404660` (📑 Contents) — MCP `get_metadata` 로 Card/Card-List/Card-Normal/Card-Resource-* 컴포넌트 다수 확인
- `modals` / `presentation` → `2546:42535` (📣 Presentation)
- `indicators` → `2442:16180` + `2449:415` 2개 페이지 (Indicators + Progress Indicators)

> 주의: 여기 매핑은 "페이지 단위" 임. Phase 1-B 이후 컴포넌트 단위 매핑 시에는 같은 페이지 안에서도 코드 디렉터리별로 어느 컴포넌트 프레임이 대응하는지 별도 ID 가 필요.

---

## 3. 검수 결과 반영 변경

### 3-1. ⚙️ Components (`2643:8531`) audit 제외
사유: "Figma 파일 썸네일용 컴포넌트 — 코드/토큰 적용 대상 아님" (사용자 확정).

변경 내용 (`figma-pages.json`):
- `audit: true` → `false`, `skipReason` 추가
- `auditOrder` 에서 `etc-design-components` 제거 (28 → 27)
- `phase4ApplyGroups` 에서 `etc-design-components` 제거 (28 → 27)
- 메타 카운트 보정: `auditTargetCount 30→27`, `skippedCount 9→12`

검증: `jq` 카운트 27/12/27/27 정합.

---

## 4. MCP 로 확인된 사실

### 4-1. 📐 Space 페이지 구조 (`2485:8842`)
`get_metadata` 결과:
- 상위 섹션: `Spacing` (헤더 + Safe Area + Layout)
- `Safe Area`: Status (iOS/Android/Web), Bottom (iOS/Android/Web) 변형
- `Layout`: 좌·중·우 3컬럼 데모 (Container/Box-in-Box 패턴)

### 4-2. Spacing 변수 (`search_design_system`)
Library 의 `Semantic.Spacing/*` 변수 — Flutter `AppSpacing` 직접 매핑:

| Figma 변수 | Flutter 토큰 | 값 | 용도 |
|---|---|---|---|
| Spacing/4 | AppSpacing.space4 (alias xxs) | 4.0 | 최소 간격 (아이콘-텍스트) |
| Spacing/8 | AppSpacing.space8 (alias xs) | 8.0 | 소간격 (아이콘-텍스트 갭) |
| Spacing/12 | AppSpacing.space12 (alias sm) | 12.0 | 리스트 아이템 간격 |
| Spacing/16 | AppSpacing.space16 (alias md) | 16.0 | 카드 패딩, 기본 간격 |
| Spacing/20 | AppSpacing.space20 (alias lg) | 20.0 | 화면 수평 패딩 |
| Spacing/24 | AppSpacing.space24 (alias xl) | 24.0 | 섹션 간격, 모달 패딩 |
| Spacing/32 | AppSpacing.space32 (alias xxl) | 32.0 | 대간격 (섹션 구분) |
| Spacing/40 | AppSpacing.space40 | 40.0 | 대형 섹션 간격 |
| Spacing/48 | AppSpacing.space48 (alias xxxl) | 48.0 | 최대 간격 |
| Spacing/Button/hor | AppSpacing.buttonPaddingH | 16.0 | 버튼 수평 패딩 |
| Spacing/Button/ver | AppSpacing.buttonPaddingV | 14.0 | 버튼 수직 패딩 |
| Spacing/List/Card/Large | AppSpacing.listItemSpacing | 12.0 | 대형 카드 리스트 간격 |
| Spacing/Padding/16(Box in Box) | AppSpacing.space16 | 16.0 | 중첩 박스 패딩 |
| Spacing/Padding/24(Contetns in Box) | AppSpacing.space24 | 24.0 | 박스 내 콘텐츠 패딩 |

> Figma 변수 description 에 이미 Flutter 매핑이 적혀 있음 → Phase 1-B 매핑 시 1차 근거로 활용 가능.
> Description 에 적힌 `lib/constants/spacing_constant.dart` 는 **앱** 경로 (`coflanet-app-0.1.2/lib/constants/spacing_constant.dart`).
> component_lab 의 대응 파일은 `Library/component_lab/lib/foundation/spacing_use_cases.dart` — Phase 1-B 에서 두 파일의 정의 일치 여부 검증 필요.
> 오타 그대로: `Contetns in Box` → 추후 Figma 변수명 정정 검토 필요.

### 4-3. MCP 호출 시 주의사항
- `get_metadata` 가 큰 페이지(`📑 Contents` 212K chars 등) 에서 응답이 잘림 → tool-results 파일로 저장됨, `jq + grep` 으로 처리
- 일부 페이지(`2442:7603` Selection/Input 등) 에서 "session expired" 반복 발생 — 재시도해도 실패. 다른 페이지는 정상.
- `get_design_context` 는 Figma 데스크톱앱에 노드 선택 필요 (헤드리스 환경에선 거의 불가)

---

## 5. Phase 1-A 산출물 위치

- `Library/component_lab/docs/spacing-migration/01-audit/figma-pages.json` — 페이지 인벤토리 (27 audit + 12 skip)
- `Library/component_lab/docs/spacing-migration/01-audit/phase-1-a-result.md` — 본 문서

---

## 6. Phase 1-B 인계 사항

### 6-1. Phase 1-B 가 받아갈 인풋
- `figma-pages.json` 의 27개 audit 페이지 + 그 `pageId`
- 본 문서 §4-2 의 Spacing 변수 마스터 테이블 (Figma ↔ Flutter 1차 매핑)
- 다중매핑 페이지 4건 (controls/forms/selection, cards/contents, modals/presentation, indicators×2) → 컴포넌트 단위 매핑이 필요

### 6-2. Phase 1-B 에서 새로 수집해야 할 것
- 페이지 안의 **컴포넌트 프레임 ID** — 코드 컴포넌트와 1:1 매핑 (Task 02)
  - 수집 방법 A: 사람이 Figma 에서 컴포넌트 클릭 → URL `node-id` 복사
  - 수집 방법 B: MCP `get_design_context` 로 자동 수집 (Figma 데스크톱앱 필요)
  - 수집 방법 C: `get_metadata` 결과 XML 에서 `<symbol>` / `<instance>` 노드 ID 추출 (헤드리스 가능)
- 각 컴포넌트의 현재 spacing 사용 패턴 (raw px vs 토큰 alias)
- Figma 변수 description 의 Flutter 매핑이 실제 코드와 일치하는지 검증

### 6-3. 결정 보류 / 후속
- Figma 변수명 오타 `Contetns in Box` → Phase 02 ~ 03 진행 중 디자이너에게 정정 요청 여부 결정
- 🏷️ Logo 페이지(0:1) 의 spacing 적용 필요성 — Phase 1-B 에서 페이지 내용 확인 후 판정 (현재 audit:true 유지)

### 6-4. 새 세션 시작 시 권장 컨텍스트
1. 본 문서 (`01-audit/phase-1-a-result.md`) 읽기
2. `figma-pages.json` 읽기
3. 두 spacing 정의 파일 양쪽 확인:
   - 앱: `coflanet-app-0.1.2/lib/constants/spacing_constant.dart` (Figma 변수 description 이 가리키는 원본)
   - 라이브러리: `Library/component_lab/lib/foundation/spacing_use_cases.dart`
4. Phase 1-B 시작 시 브랜치 그대로 사용: `claude/spacing-tokens-organization-NwPFO`

---

## 7. Phase 1-A (Task 03..30 + LAST-1A) — Figma 페이지별 spacing 감사 ✅

**완료 일시**: 2026-05-12
**처리 페이지**: 27/27 (실패 0)
**총 spacing occurrences**: 30,879
**산출 파일**: `figma-spacing-raw.{slug}.json` × 27 + `figma-spacing.INDEX.json`

### 7-1. 페이지별 결과 요약

| Page | True occurrences | Items in file | Bound | Strategy |
|---|---:|---:|---:|---|
| foundation-space | 107 | 107 | 1 | full |
| foundation-logo | 45 | 45 | 0 | full |
| foundation-typography | 949 | 949 | 23 | full |
| foundation-colors | 3,133 | 465 | 0 | **dedup** |
| foundation-gradient | 175 | 175 | 2 | full |
| foundation-decorate | 214 | 214 | 0 | full |
| foundation-icon | 894 | 126 | 0 | **dedup** |
| foundation-3d-illustration | 33 | 33 | 0 | full |
| foundation-product | 13 | 13 | 0 | full |
| component-button | 3,243 | 474 | 30 | **dedup** |
| component-chip | 1,449 | 326 | 0 | **dedup** |
| component-ratio | 139 | 139 | 0 | full |
| component-thumbnail | 87 | 87 | 0 | full |
| component-scroll | 177 | 177 | 0 | full |
| component-avatar | 542 | 542 | 0 | full |
| component-indicators | 27 | 27 | 0 | full |
| component-divider | 44 | 44 | 0 | full |
| module-navigation | 495 | 495 | 0 | full |
| module-tab | 1,338 | 376 | 16 | **dedup** |
| module-pagination | 303 | 303 | 0 | full |
| module-progress-indicators | 1,120 | 225 | 1 | **dedup** |
| module-selection-input | 7,401 | 363 | 20 | **dedup** |
| module-control-box | 225 | 225 | 16 | full |
| module-gauge | 49 | 49 | 0 | full |
| module-feedback | 1,532 | 408 | 1 | **dedup** |
| module-presentation | 1,791 | 315 | 58 | **dedup** |
| module-contents | 5,354 | 430 | 99 | **dedup** |

### 7-2. Top spacing values (전체 30,879개 중 빈도 상위)

| Value | Count |
|---:|---:|
| 24 px | 819 |
| 6 px | 771 |
| 20 px | 757 |
| 16 px | 704 |
| 2 px | 578 |
| 12 px | 446 |
| 64 px | 438 |
| 4 px | 431 |
| 8 px | 412 |
| 10 px | 312 |

### 7-3. ⚠️ Dedup 전략 — Phase 1-C/Phase 3/Phase 4 인계 사항

13개 큰 페이지(>600 occurrences)는 Figma plugin output 20KB 제한으로 **전체 occurrence 를 capture 하지 못함**. 대신 deduplicated 형태로 저장:

- **Schema 변경**: 각 item 에 `occurrenceGroupCount` (해당 (property, value, varId) 조합의 실제 발생 횟수) + `isSampleOfDedupGroup: true` 필드 추가
- **Sample 보존**: (property, value, variableId) 그룹별로 5~8개의 sourceNodeId만 items 에 포함
- **_summary 보존**: `spacingOccurrences` 는 진짜 총 개수, `valueFrequency` 도 진짜 빈도 → **Task 31 통계 분석에는 영향 없음**
- **Sampling limit 명시**: dedup 페이지의 `_summary` 에 `dedupStrategy`, `samplingLimit` 필드 포함

### 7-4. 🚨 Task 33/34 시점 주의사항 (Phase 3 매핑 / Phase 4 적용)

- **Task 33 (figma-node-to-token.csv)**: dedup 페이지의 경우 sample nodeId만 CSV 행으로 들어감. 각 행은 실제로는 N개 노드를 대표함 → `count` 컬럼을 추가하거나 별도 dedupStrategy 처리 로직 필요.
- **Task 34 (Figma 적용)**: sample node 만 변수 바인딩하면 나머지 그룹 노드는 미적용 상태로 남음. 적용 스크립트가 (property, value) 패턴으로 페이지를 다시 스캔해 같은 그룹 노드를 일괄 적용하도록 설계해야 함.
- 권장 보강: Task 34 프롬프트에 다음 추가
  > "dedup 페이지의 경우, CSV 의 sample nodeId 만 처리하지 말고, 같은 페이지 내 동일 (property, value) 패턴 노드를 use_figma 로 다시 찾아 일괄 적용한다."

### 7-5. 그 외 처리 결정

- **Instance subnode 제외**: nodeId 에 `;` 포함된 노드(instance descendants) 는 모든 페이지에서 audit 에서 제외. 사유: 이들의 spacing 은 master component 에서 상속 → 해당 component 페이지에서 audit 됨. (예: `2546:166613;...` 같은 instance 자식)
- **0 값 + variable bind 없음**: 의미 없는 0 padding 은 제외 (variable bind 가 있으면 0이어도 포함)
- **Variable resolution 시 timeout**: `module-selection-input`, `module-contents` 등 너무 큰 페이지는 variable resolve 단계 분리 호출 필요했음
- **node name truncation**: 길이 30~40 chars 로 truncate 하여 CSV 호환성 확보

### 7-6. 산출물 위치 (Phase 1-A 추가)

- `Library/component_lab/docs/spacing-migration/01-audit/figma-spacing-raw.{27 slugs}.json`
- `Library/component_lab/docs/spacing-migration/01-audit/figma-spacing.INDEX.json` — 전체 색인 + globalValueFrequency

### 7-7. ⚠️ 다음 세션을 위한 사전 준비 (Task 31 시작 전 필수)

**현재 NwPFO 브랜치에는 Task 02 (코드 감사) 결과 파일이 없음**. 코드 감사는 `claude/audit-figma-spacing-Uj2RM` 브랜치에 있음.

```bash
# Task 31 진행 전 코드 감사 파일들을 NwPFO 로 가져와야 함
git checkout claude/audit-figma-spacing-Uj2RM -- \
  Library/component_lab/docs/spacing-migration/01-audit/code-*.json \
  COWORK_SPACING_MIGRATION_PROMPTS.md
git commit -m "chore(spacing-migration): bring code audit files from Uj2RM branch"
git push origin claude/spacing-tokens-organization-NwPFO
```

가져와야 할 파일들:
- `code-audit.INDEX.json`
- `code-hardcoded-usages.{22 dirs}.json` (avatars, buttons, cards, chips, contents-part1/part2, control_box, controls, dividers, feedback, forms, gauge, indicators, modals, navigation, pagination, presentation, ratio, scrolls, selection, tabs, thumbnails)
- `code-token-defs.foundation.json`
