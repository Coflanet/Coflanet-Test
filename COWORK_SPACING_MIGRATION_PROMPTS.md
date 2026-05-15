# Spacing Token Migration - Cowork Dispatch Prompts

> 본 문서는 Claude Code 디스패치 Cowork에 순차 등록할 작업 단위(Task Unit) 묶음입니다.
> 각 Task는 독립 세션을 전제로 자기 완결적이며, 이전 Task의 산출물(JSON/MD/CSV)을 입력으로 사용합니다.
> 📌 = 사람 검수 게이트 / 🆕 = 새 세션 권장 / ⛔ = 작업 금지선

## 진행 방식

**모든 Task 는 Claude Code 단일 세션에서 순차 진행.** Cowork 디스패처는 사용하지 않음.

- 한 Task = 한 세션 (이전 Task 의 산출물을 입력으로 받아 이어 진행)
- 사람 검수 게이트(📌) 에서는 새 세션 시작 권장
- Figma 작업(Task 03..30, 34..61)은 use_figma 단일 세션 제약 — 절대 병렬 금지
- 코드 작업(Task 02, 63..83)도 한 디렉터리씩 순차 처리하여 PR 단위를 작게 유지

### ⚡ Claude Code 서브에이전트 병렬 활용 (Agent 도구)

Claude Code 는 동일 세션 내에서 **서브에이전트를 병렬로 스폰** 할 수 있다 (Cowork 와는 다른 내부 메커니즘). 독립적인 read-only 작업은 Agent 하나씩 담당시켜 시간을 크게 단축.

**병렬 서브에이전트 권장 구간**
- **Task 02 코드 감사 (22 디렉터리)**: Explore 서브에이전트 N개를 동시에 스폰해 디렉터리별로 병렬 Grep. 단일 세션의 메시지 1개에 Agent tool 22회 호출을 한꺼번에 넘김
- **Task 31 갭 분석**: figma 측·코드 측 통계 집계를 각각 다른 general-purpose 서브에이전트로 병렬
- **Task 33 매핑 테이블**: figma 매핑과 코드 매핑 단계를 다른 서브에이전트로 병렬
- **Task 63..83 이전 초기 탐색**: 하나의 세션에서 여러 디렉터리를 이해해야 할 때 Explore 서브에이전트 병렬

**절대 병렬 금지 (충돌 위험)**
- Figma 작업 둘 이상 동시에 (use_figma 단일 세션 점유)
- 동일 파일을 수정하는 Agent 둘 이상
- Task 63..83 의 실제 코드 치환 (디렉터리별 PR 분리 원칙 — 1세션 = 1디렉터리 = 1PR)

### 진행 순서
1. Task 00 → Task 02 (내부에서 Explore 서브에이전트 22개 병렬)
2. Task 03..30 (페이지 1~3개씩 끊어 새 세션, foundation-space 먼저)
3. Task LAST-1A → Task 31 (분석 병렬) → 32 → 33 (매핑 병렬)
4. Task 34..61 (그룹 1~2개씩)
5. Task LAST-4 → Task 62
6. Task 63..83 (디렉터리 1~2개씩 새 세션, PR 분리)
7. Task 84

## 공통 정보

- 저장소: `coflanet/coflanet-test`
- 코드 경로: `Library/component_lab`
- 작업 브랜치: `claude/audit-figma-spacing-uJuIo`
- Figma 파일: https://www.figma.com/file/q7yBPcHrid1CGQqFWEPwnR?node-id=2636:31292
- Figma fileKey: `q7yBPcHrid1CGQqFWEPwnR`
- 산출물 루트: `Library/component_lab/docs/spacing-migration/`

### Figma 사전 조사 결과 (사용자 사전 확인 완료)
- 전체 페이지 수: **39** (콘텐츠 페이지 30 + 빈 헤더 4 + 구분선 4 + Archive 1)
- 감사 대상: **28개 그룹** (FIGMA_INVENTORY.md 기반)
- 파일이 구독 중인 팀 라이브러리: **"📚 Library" (self)** — 본 파일 자체가 토큰 정의 + 컴포넌트 라이브러리
- ⭐ 최우선 페이지: **📐 Space (`2485:8842`)** — 스페이싱 토큰 정의 페이지
- 페이지 인벤토리 원본: `FIGMA_INVENTORY.md` (저장소 루트)
- 변환된 페이지 메타: `Library/component_lab/docs/spacing-migration/01-audit/figma-pages.json` (Task 01 사전완료)

### 페이지 ↔ 코드 디렉터리 매핑 요약
| Figma 페이지 (group) | Code dir |
|---|---|
| component-button | buttons |
| component-chip | chips |
| component-ratio | ratio |
| component-thumbnail | thumbnails |
| component-scroll | scrolls |
| component-avatar | avatars |
| component-indicators + module-progress-indicators | indicators |
| component-divider | dividers |
| module-navigation | navigation |
| module-tab | tabs |
| module-pagination | pagination |
| module-selection-input | selection, forms, controls |
| module-control-box | control_box |
| module-gauge | gauge |
| module-feedback | feedback |
| module-presentation | presentation, modals |
| module-contents | contents, cards |

## 공통 규칙 (모든 Task 적용)

1. 세션 시작 시 `Library/component_lab/docs/spacing-migration/` 의 INDEX/SUMMARY 파일을 먼저 읽어 진행 상태 파악
2. 산출물은 항상 위 경로 하위 폴더에 저장. raw 데이터를 한 파일로 합치지 말 것
3. 한 Task = 한 커밋. 커밋 메시지 접두사: `chore(spacing-migration): `
4. 본 Task에 명시된 입력/대상 외의 파일은 절대 수정하지 말 것
5. 빌드/테스트 명령: `cd Library/component_lab && flutter analyze` (Phase 5에서만)
6. 실패하더라도 부분 산출물은 반드시 저장하고 끝낼 것

## ⚠️ Figma 도구 사용 규칙 (사용자 사전 확인)

**이 파일에서는 `mcp__figma__use_figma` 만 사용 가능. 다른 Figma 도구(`get_metadata`, `get_design_context` 등)는 타임아웃 발생.**

- 페이지/노드 순회는 모두 `use_figma` 의 Plugin API 호출로 처리
- `get_libraries`, `whoami` 등 메타 도구만 보조로 사용
- Plugin API 호출 시 노드 트리 깊이를 제한하고 batch 로 끊어서 처리
- 한 번 호출에 너무 많은 노드를 요청하면 응답이 잘리거나 타임아웃 — 50~100 노드 단위로 분할

---

# Task 00 · Phase 0 — 작업 보드 셋업

## 입력
없음

## 처리
1. 브랜치 `claude/audit-figma-spacing-uJuIo` 가 없으면 생성, 있으면 체크아웃
2. 다음 디렉터리에 `.gitkeep` 을 만들어 빈 상태로 커밋:
   - `Library/component_lab/docs/spacing-migration/01-audit/`
   - `Library/component_lab/docs/spacing-migration/02-tokens/`
   - `Library/component_lab/docs/spacing-migration/03-mapping/`
   - `Library/component_lab/docs/spacing-migration/04-apply-log/`
3. `Library/component_lab/docs/spacing-migration/README.md` 생성: 각 폴더 용도 1~2줄

## 산출물
- 위 폴더 4개 + README.md

## 커밋 & 푸시
`chore(spacing-migration): bootstrap workspace`

## 성공 기준
폴더 4개, README.md, .gitkeep 4개가 브랜치에 커밋되어 푸시 완료

---

# Task 01 · Phase 1-A-0 — Figma 페이지 정찰 [✅ 사전완료]

## 상태
사용자가 Figma Plugin API 로 사전 수집한 데이터(`FIGMA_INVENTORY.md`)를 기반으로 변환 완료.
산출물: `Library/component_lab/docs/spacing-migration/01-audit/figma-pages.json`

이 산출물에는 다음이 포함되어 있어 Task 02 부터 바로 진입 가능:
- 39개 전체 페이지 메타
- 감사 대상 28개 그룹의 `pageId`, `pageSlug`, `group`, `codeDir`, `suspectedCategory`
- `auditOrder` (1-A 처리 순서)
- `phase4ApplyGroups` (Phase 4 적용 순서 + priority)
- `codeDirToFigmaPage` (Phase 5 에서 사용)

## 📌 사람 검수 #1
- `figma-pages.json` 의 `auditOrder` 확인 — 최우선이 `foundation-space` 인지
- 빠진 페이지가 없는지 (39 = 30 audit + 4 header + 4 separator + 1 archive)
- `codeDirToFigmaPage` 매핑 검토 (특히 `controls`, `forms`, `selection` → 동일 페이지 매핑 적절성)

## 만약 figma-pages.json 이 존재하지 않으면 (재생성 절차)
1. 저장소 루트의 `FIGMA_INVENTORY.md` 를 읽는다
2. 각 `## {emoji} {name}` 헤더 + `**pageId**: ...` 행을 파싱
3. 빈 페이지/구분선은 `audit=false` 로 분류
4. 코드 디렉터리와 매칭되는 페이지는 `codeDir` 필드 부여
5. 본 문서 상단 "페이지 ↔ 코드 디렉터리 매핑 요약" 표 사용

---

# 🆕 Task 02 · Phase 1-B — 코드 spacing 감사 (디렉터리별)

> 이 Task는 **하나의 세션 안에서 22개 서브 작업을 Explore 서브에이전트로 병렬 처리**. 단일 메시지에 Agent tool 22회 호출을 함께 넘긴다. 각 서브에이전트는 1개 디렉터리만 read-only Grep.

## 입력
- `Library/component_lab/lib/foundation/app_spacing.dart` 등 기존 토큰 정의
- 컴포넌트 디렉터리 21개: `avatars, buttons, cards, chips, contents, control_box, controls, dividers, feedback, forms, gauge, indicators, modals, navigation, pagination, presentation, ratio, scrolls, selection, tabs, thumbnails`
- 추가 대상: `foundation` (토큰 정의 자체 감사)

## 처리 — 다음을 22번 반복

각 대상 디렉터리 `{dir}` 에 대해:

### Step 1. 기존 토큰 정의 추출 (foundation 디렉터리만)
- `Library/component_lab/lib/foundation/app_spacing.dart` 의 모든 const/static 값을 추출
- `spacing_use_cases.dart` 의 사용 패턴 분석
- 산출: `01-audit/code-token-defs.foundation.json`
  ```json
  { "tokens": [ { "name": "AppSpacing.x4", "value": 4, "unit": "px", "comment": "괄호 메모", "file": "...", "line": 0 } ] }
  ```

### Step 2. 하드코딩 spacing 사용 추출 (모든 디렉터리)
- `Library/component_lab/lib/{dir}/**/*.dart` 안에서 다음 패턴을 Grep:
  - `EdgeInsets\.(all|symmetric|only|fromLTRB)\(`
  - `Padding\(padding:`
  - `SizedBox\((width|height):`
  - `Gap\(`
  - `margin:`, `padding:` 의 숫자 리터럴
  - `const\s+\w+Spacing` (기존 토큰 참조)
- 각 매치에 대해 추출:
  ```json
  {
    "file": "lib/.../foo.dart",
    "line": 42,
    "snippet": "EdgeInsets.symmetric(horizontal: 12, vertical: 8)",
    "values": [12, 8],
    "unit": "px",
    "kind": "EdgeInsets.symmetric",
    "contextHint": "Button padding | inferred from surrounding widget tree"
  }
  ```
- 산출: `01-audit/code-hardcoded-usages.{dir}.json`
- usage 100개 초과 시 `-part1.json`, `-part2.json` 등으로 분할

### Step 3. 디렉터리 summary 작성
각 파일 끝(또는 별도 `_summary` 필드)에 다음 추가:
```json
{
  "_summary": {
    "dir": "{dir}",
    "fileCount": 12,
    "totalUsages": 47,
    "distinctValues": [2, 4, 8, 12, 16, 20, 24],
    "valueFrequency": { "4": 8, "8": 22, "12": 5, "16": 9, "20": 2, "24": 1 },
    "suspiciousItems": 2
  }
}
```

### Step 4. 디렉터리 단위 커밋
`chore(spacing-migration): audit code spacing - {dir}`

## 최종 산출물 — 22개 디렉터리 처리 후

`Library/component_lab/docs/spacing-migration/01-audit/code-audit.INDEX.json`
```json
{
  "generatedAt": "...",
  "directories": [
    { "dir": "foundation", "tokenDefsFile": "code-token-defs.foundation.json", "usagesFile": null, "summary": {...} },
    { "dir": "avatars", "tokenDefsFile": null, "usagesFile": "code-hardcoded-usages.avatars.json", "summary": {...} },
    ...
  ],
  "totals": { "fileCount": 0, "totalUsages": 0, "globalValueFrequency": {} }
}
```

## ⛔ 금지
- 코드 수정 금지 (read-only)
- 디렉터리 간 결과 병합 금지

## 성공 기준
- 22개 raw 파일 + 1개 INDEX 파일 생성
- INDEX 의 `totals` 가 디렉터리 합과 일치

## 실패 처리
디렉터리 처리 도중 에러 발생 시 해당 디렉터리만 skip 하고 INDEX 에 `"status": "FAILED", "error": "..."` 기록 후 다음 디렉터리 진행

---

# 🆕 Task 03..30 · Phase 1-A — Figma 페이지별 spacing 감사 (28개)

> `figma-pages.json` 의 `auditOrder` 배열에 따라 페이지 1개 = Task 1개. 총 28개 Task.
> 등록 순서(`auditOrder` 그대로):
> 1. foundation-space (pageId `2485:8842`) ⭐ CRITICAL
> 2. foundation-logo (`0:1`)
> 3. foundation-typography (`2414:9843`)
> 4. foundation-colors (`2414:11941`)
> 5. foundation-gradient (`2452:6035`)
> 6. foundation-decorate (`2452:6034`)
> 7. foundation-icon (`2414:34422`)
> 8. foundation-3d-illustration (`2941:667`)
> 9. foundation-product (`2941:684`)
> 10. component-button (`2414:32026`) → buttons
> 11. component-chip (`2546:166598`) → chips
> 12. component-ratio (`2452:6033`) → ratio
> 13. component-thumbnail (`2452:6037`) → thumbnails
> 14. component-scroll (`2452:7600`) → scrolls
> 15. component-avatar (`2452:6039`) → avatars
> 16. component-indicators (`2442:16180`) → indicators
> 17. component-divider (`2452:6032`) → dividers
> 18. module-navigation (`2452:3459`) → navigation
> 19. module-tab (`2414:34400`) → tabs
> 20. module-pagination (`2452:6038`) → pagination
> 21. module-progress-indicators (`2449:415`) → indicators
> 22. module-selection-input (`2442:7603`) → selection,forms,controls
> 23. module-control-box (`2537:62051`) → control_box
> 24. module-gauge (`2442:15568`) → gauge
> 25. module-feedback (`2546:36834`) → feedback
> 26. module-presentation (`2546:42535`) → presentation,modals
> 27. module-contents (`2573:404660`) → contents,cards
> 28. etc-design-components (`2643:8531`)
>
> 아래 템플릿에서 `{pageId}`, `{pageSlug}`, `{group}` 을 페이지마다 치환해 등록.

## 입력
- Figma fileKey: `q7yBPcHrid1CGQqFWEPwnR`
- 처리 대상 페이지: `pageId={pageId}`, `pageSlug={pageSlug}`
- `01-audit/figma-pages.json` (대상 페이지의 메타 확인용)

## 처리
1. `mcp__figma__use_figma` (Plugin API 트리 순회) 로 `{pageId}` 의 자식 노드 트리를 얕게 가져와 컴포넌트 단위 노드 ID 목록 확보
2. 노드를 50개씩 배치로 묶어 순회. 각 배치마다:
   - 해당 노드의 spacing 관련 속성 추출
     - `itemSpacing`, `paddingTop|Left|Right|Bottom`, `counterAxisSpacing`
     - Auto Layout gap 값
     - 변수 바인딩이 있는지 (있으면 `variableId` 기록)
   - **(v2 추가)** 해당 노드 자체의 `layoutMode` (`VERTICAL|HORIZONTAL|NONE`) 및 `layoutWrap` (`NO_WRAP|WRAP`) 를 기록 — Auto Layout 프레임 자신의 속성. `itemSpacing` 의 stack(VERTICAL) / inline(HORIZONTAL) 자동 분리에 필수.
3. 각 spacing 발생 지점을 다음 스키마로 기록:
   ```json
   {
     "tokenName": "(있다면 바인딩된 변수 이름, 없으면 null)",
     "value": 12,
     "unit": "px",
     "property": "itemSpacing | padding-x | padding-y | ...",
     "aliasGroup": "(변수 컬렉션 그룹명, 없으면 null)",
     "usageNote": "(괄호 안 메모나 노드 이름에서 추정한 용도)",
     "sourceNodeId": "X:Y",
     "sourceNodeName": "...",
     "pageId": "{pageId}",
     "layoutMode": "VERTICAL | HORIZONTAL | NONE (v2 — itemSpacing 의 stack/inline 분리용)",
     "layoutWrap": "NO_WRAP | WRAP (v2 — Wrap 안 itemSpacing 의 counter axis 판정용, optional)"
   }
   ```

## 산출물
`Library/component_lab/docs/spacing-migration/01-audit/figma-spacing-raw.{pageSlug}.json`
```json
{
  "_summary": {
    "pageId": "{pageId}",
    "pageSlug": "{pageSlug}",
    "totalNodesScanned": 0,
    "spacingOccurrences": 0,
    "distinctValues": [],
    "boundToVariable": 0,
    "rawValues": 0,
    "suspiciousItems": 0
  },
  "items": [ /* 위 스키마 객체 배열 */ ]
}
```

- items 가 1000개 초과 시 `-part1.json`, `-part2.json` 분할

## 커밋 & 푸시
`chore(spacing-migration): audit figma spacing - {pageSlug}`

## 성공 기준
- `figma-spacing-raw.{pageSlug}.json` 파일 1개(또는 파트들) 생성
- `_summary.spacingOccurrences == items.length` (파트 분할 시 합계)

## ⛔ 금지
- Figma 노드 수정 금지 (read-only)
- 페이지 간 데이터 병합 금지

## 실패 처리
- 노드 처리 실패 시 `_summary.suspiciousItems` 증가 + 별도 `figma-spacing-raw.{pageSlug}.errors.json` 에 기록

---

# 🆕 Task LAST-1A · Phase 1-A 통합 색인

> Task 03..N (페이지별 감사) 가 모두 끝난 후 1회 실행

## 처리
모든 `figma-spacing-raw.*.json` 의 `_summary` 만 모아 INDEX 생성:

`Library/component_lab/docs/spacing-migration/01-audit/figma-spacing.INDEX.json`
```json
{
  "generatedAt": "...",
  "pages": [
    { "pageSlug": "...", "files": ["..."], "summary": {...} }
  ],
  "totals": { "spacingOccurrences": 0, "globalValueFrequency": {} }
}
```

## 커밋 & 푸시
`chore(spacing-migration): build figma audit index`

---

# 🆕 Task 31a..31z · Phase 1-A-2 — itemSpacing layoutMode 사이드카 (재크롤)

> **목적**: Phase 1-A v1 raw 에는 `layoutMode` 가 없어 `itemSpacing` 의 stack(VERTICAL) vs inline(HORIZONTAL) 자동 분리 불가. v1 raw 를 덮어쓰지 않고 사이드카 1 파일에 `nodeId → layoutMode` 매핑만 추가.
>
> 본 Task 는 `auditOrder` 27 페이지 중 **`itemSpacing` 발생 페이지** 만 대상. 페이지 1~3개씩 끊어 새 세션.

## 입력
- Figma fileKey: `q7yBPcHrid1CGQqFWEPwnR`
- 처리 대상 페이지: `pageId={pageId}`, `pageSlug={pageSlug}`
- v1 raw 의 itemSpacing sourceNodeId 목록 (해당 페이지의 `figma-spacing-raw.{pageSlug}*.json` 에서 `property=itemSpacing` 행의 `sourceNodeId` 만 추출)

## 처리
1. 대상 페이지에서 itemSpacing sourceNodeId 목록 로드 (메모리에 들고 있을 것 — 외부 파일 만들지 말 것)
2. `mcp__figma__use_figma` 로 노드 100개씩 배치 조회, 각 노드의 `layoutMode` 와 `layoutWrap` 만 추출 (다른 필드 무시 — 응답 크기 절약)
3. 각 결과를 사이드카에 append 합산:
   ```json
   {
     "nodeId": { "layoutMode": "VERTICAL", "layoutWrap": "NO_WRAP", "pageSlug": "{pageSlug}" }
   }
   ```

## 산출물
`Library/component_lab/docs/spacing-migration/01-audit/figma-itemspacing-layoutmode.json`

페이지 단위로 추가됨. 최종 1 파일 (모든 페이지 누적). 파일 사이즈 예상: ~23k 엔트리 × ~80 byte = ~2MB.

## 커밋 & 푸시
`chore(spacing-migration): audit itemSpacing layoutMode - {pageSlug}`

## 성공 기준
- 사이드카 엔트리 수 ≥ 해당 페이지 itemSpacing 노드 수
- `layoutMode` 가 `VERTICAL` 또는 `HORIZONTAL` 인 비율 ≥ 95% (`NONE` 은 layoutMode 가 꺼진 프레임 — 거의 없어야 함)

## ⛔ 금지
- v1 raw (`figma-spacing-raw.*.json` 110개) 변경 금지
- 다른 spacing 필드 재수집 금지 — 본 Task 는 layoutMode 만 대상

## 실패 처리
- 응답 잘림 / 세션 만료 시 페이지 분할 (50개씩 또는 25개씩) 재시도

---

# 🆕 Task LAST-1A-2 · Phase 1-A-2 종료 — Phase 2 산출물 재생성

> Task 31a..31z 모두 완료 후 1회 실행

## 입력
- `01-audit/figma-itemspacing-layoutmode.json` (사이드카)
- 기존 110개 raw 파일
- 기존 `02-tokens/*` (v0.1)

## 처리
1. v1 raw + 사이드카 결합. 각 itemSpacing 행에 `layoutMode` annotate (in-memory, 파일 안 건드림)
2. `semantic-roles-inventory.md` §3 의 itemSpacing 단일 표를 **stack (VERTICAL)** / **inline (HORIZONTAL)** 두 표로 분리
3. `palette.md` / `semantic.md` 의 v0.1 표기 제거
4. `usage-guide.md` 의 stack/inline 예시 값을 실제 분포 Top 으로 검증·갱신
5. `semantic-roles-inventory.md` 헤더에 "Phase 1-A-2 완료 — 자동 분리 100%" 명시

## 커밋 & 푸시
`docs(spacing-migration): regenerate Phase 2 with layoutMode-aware stack/inline split`

## 📌 사람 검수 #3 재확인
- stack/inline 분포가 검수 #2 결정 (semantic.json 의 alias 값) 와 정합 → OK 면 v1.0 승격
- 만약 stack 빈도가 너무 낮으면 일부 alias 값 재조정 가능

---

# 🆕 Task 04 · Phase 1-C — 갭 분석

## 입력
- `01-audit/figma-spacing.INDEX.json` + 페이지별 raw (필요 시 부분 로드)
- `01-audit/code-audit.INDEX.json` + 디렉터리별 raw (필요 시 부분 로드)

## ⚠️ 메모리 절약 규칙
- raw 파일은 한 번에 1개씩만 열어 통계 누적 후 닫는다
- 전체 raw 를 한 번에 메모리에 올리지 말 것

## 처리
1. Figma/코드 각각의 globalValueFrequency 병합
2. 값별 양쪽 출현 여부 비교, 일치/불일치 분류
3. 사용 빈도 Top 20 산출
4. 의심 항목 (괄호 메모에 "임시|TODO|tmp|fix" 등 포함된 토큰) 별도 추출

## 산출물
`Library/component_lab/docs/spacing-migration/01-audit/gap-analysis.md`

구성:
1. 요약 통계 표 (총 값 종류, 양쪽 일치 수/비율, 한쪽만 존재 수)
2. 값 분포 히스토그램 (마크다운 표, Figma vs 코드)
3. 불일치 표: `| Value(px) | Figma 출현 | 코드 출현 | 차이유형 | 비고 |`
4. 사용 빈도 Top 20 표
5. 의심 항목 목록
6. **팔레트 스케일 후보안** 섹션:
   - 4의 배수 기준 추천값 (0, 2, 4, 8, 12, 16, 20, 24, 32, 40, 48, 56, 64, 80, 96)
   - 사용 빈도 ≥ 5 인 값은 ★ 표시
   - 사용 빈도 < 2 인 값은 제거 후보로 표시

## 커밋 & 푸시
`docs(spacing-migration): gap analysis between figma and code`

## 📌 사람 검수 #2
- gap-analysis.md 검토
- 팔레트 스케일 후보안 OK/수정 결정 → 결정사항을 사용자가 직접 파일에 기록 또는 다음 Task 프롬프트의 `[USER_DECISION]` 자리에 전달

---

# 🆕 Task 05 · Phase 2 — 토큰 설계 (Palette + Semantic 의도 토큰)

## 결정 사항 (검수 #2 확정 — 2026-05-14)

### Palette (20개 확정)
```
0, 1, 2, 3, 4, 6, 7, 8, 9, 10, 12, 14, 16, 20, 24, 28, 32, 40, 44, 48
```
제외: 5, 11, 36, 60, 64, 80, 160 (단발성 또는 페이지 카탈로그 grid)

### Semantic 패턴 — 패턴 2 (Palette + 의도 시맨틱)
- **5 카테고리**: `stack`, `inline`, `inset`, `inset-squish`, `layout`
- **컴포넌트별 시맨틱 토큰 만들지 않음** (component-button 등 X)
- 모든 시맨틱은 palette 토큰 1개를 alias

### 명명 규칙
**JSON (Figma Variables / W3C DTCG 호환, slash 구조)**:
- Palette: `spacing/{value}` (예: `spacing/12`)
- Semantic: `spacing/{category}/{role}` (예: `spacing/stack/md`, `spacing/inset-squish/md`)

**Dart (camelCase 자동 변환, App prefix 유지)**:
- Palette: `AppSpacing.s{value}` (예: `AppSpacing.s12`)
- Semantic: `AppSpacingSemantic.{category}{Role}` (예: `AppSpacingSemantic.stackMd`)
- inset-squish 페어는 vertical / horizontal 분리: `AppSpacingSemantic.insetSquishMdVertical` 등

### 데이터 정제 정책 (Phase 1-A/B raw 활용 시 모두 적용)
1. **Platform UI 제외**: 부모 체인 어느 위치에라도 `Platform=iOS` / `Platform=Android` / `iOS/...` / `Status Bar` / `Dynamic Island` / `Home Indicator` / `Tab Bar` 등 노드 포함 시 자식 모두 제외
2. **Demo 페이지 제외**: Figma `foundation-colors`, `foundation-typography`, `foundation-icon`, `foundation-decorate`, `foundation-gradient`, `foundation-logo`, `foundation-3d-illustration`, `foundation-product` (라이브러리 컴포넌트가 아님 — 토큰 시연용)
3. **`foundation-space` 만 예외**: 토큰 정의 spec 페이지 — 포함
4. **Demo 코드 제외**: 모든 `*_use_cases.dart` 파일
5. **페이지 직접 frame 주의**: `sourceNodeId` 가 `I` 로 시작 안 하는 노드 중 큰 spacing(>40)은 카탈로그 grid 일 가능성 — 채택 보류

### 음수/소수점/큰값
- **음수**: 토큰화 안 함 (도입 시 정의)
- **소수점**: 토큰화 안 함 (Platform UI 필터로 자동 제거됨)
- **가로/세로 큰 값 (width/height 112/240/280/300/320)**: spacing 범위 외. 별도 size 토큰 후속 트랙

### Border-width
이번 범위 외. 1px **padding** 은 spacing palette 에 포함, 1px **border** 두께는 별도 `AppBorderWidth` 후속 트랙.

## 입력
- `01-audit/gap-analysis.md`
- `01-audit/figma-spacing.INDEX.json` + 페이지별 raw 110 파일
- `01-audit/code-audit.INDEX.json` + 디렉터리별 raw 22 파일
- `01-audit/figma-pages.json` 의 `codeDirToFigmaPage` 매핑

## Part A: Palette

### 산출물
1. `02-tokens/palette.json` (W3C DTCG 형식)
   ```json
   {
     "$schema": "https://design-tokens.github.io/community-group/format/",
     "version": "1.0.0",
     "spacing": {
       "0":  { "$value": 0,  "$type": "dimension", "$description": "Zero spacing" },
       "1":  { "$value": 1,  "$type": "dimension" },
       "2":  { "$value": 2,  "$type": "dimension" },
       "3":  { "$value": 3,  "$type": "dimension" },
       "4":  { "$value": 4,  "$type": "dimension" },
       "6":  { "$value": 6,  "$type": "dimension" },
       "7":  { "$value": 7,  "$type": "dimension" },
       "8":  { "$value": 8,  "$type": "dimension" },
       "9":  { "$value": 9,  "$type": "dimension" },
       "10": { "$value": 10, "$type": "dimension" },
       "12": { "$value": 12, "$type": "dimension" },
       "14": { "$value": 14, "$type": "dimension" },
       "16": { "$value": 16, "$type": "dimension" },
       "20": { "$value": 20, "$type": "dimension" },
       "24": { "$value": 24, "$type": "dimension" },
       "28": { "$value": 28, "$type": "dimension" },
       "32": { "$value": 32, "$type": "dimension" },
       "40": { "$value": 40, "$type": "dimension" },
       "44": { "$value": 44, "$type": "dimension" },
       "48": { "$value": 48, "$type": "dimension" }
     }
   }
   ```
2. `02-tokens/palette.md` — 결정 근거, 제외값 사유 (5/11/36/60/64/80/160), 정제 정책, 사용 빈도 표

## Part B: Semantic (의도 시맨틱)

### Part B-0: 사전 역할 인벤토리 자동 생성
1. raw 파일을 **1개씩 스트리밍** 처리 (메모리 절약)
2. 위 데이터 정제 정책 모두 적용 후 (Platform/Demo/페이지 grid 제외)
3. Figma items 의 `usageNote` / `sourceNodeName` + 코드 `contextHint`/`kind` 클러스터링
4. 카테고리별 역할 후보 자동 도출
5. 산출: `02-tokens/semantic-roles-inventory.md` — 카테고리/역할별 후보 (Figma 빈도 / 코드 빈도 / 대표 컴포넌트)

### Part B-1: 역할 확정 및 토큰 정의

#### Semantic 토큰 초안 (Part B-0 데이터로 조정)
```
# stack — 세로 간격 (수직 itemSpacing, autoLayoutMode VERTICAL)
spacing/stack/xs    = spacing/2       # Label-Value 미세
spacing/stack/sm    = spacing/4       # Heading-Description
spacing/stack/md    = spacing/8       # List item 사이
spacing/stack/lg    = spacing/16      # Card 사이, Heading-Body
spacing/stack/xl    = spacing/24      # Section 사이

# inline — 가로 간격 (수평 itemSpacing, autoLayoutMode HORIZONTAL)
spacing/inline/xs   = spacing/2
spacing/inline/sm   = spacing/4       # Icon-text 표준
spacing/inline/md   = spacing/8       # Button/Chip group
spacing/inline/lg   = spacing/12

# inset — 4방향 동일 padding
spacing/inset/xs    = spacing/4       # Tag, Badge
spacing/inset/sm    = spacing/8       # 작은 컨테이너
spacing/inset/md    = spacing/12      # Icon Button 표준
spacing/inset/lg    = spacing/16      # FAB, Card padding
spacing/inset/xl    = spacing/24      # Modal padding

# inset-squish — 수평 > 수직 padding 페어 (Button 패턴)
spacing/inset-squish/xs/vertical   = spacing/2,   /horizontal = spacing/6    # Badge
spacing/inset-squish/sm/vertical   = spacing/7,   /horizontal = spacing/14   # Button Small
spacing/inset-squish/md/vertical   = spacing/9,   /horizontal = spacing/20   # Button Medium
spacing/inset-squish/lg/vertical   = spacing/12,  /horizontal = spacing/28   # Button Large

# layout — 페이지 레벨 큰 간격
spacing/layout/sm   = spacing/24      # Section gap
spacing/layout/md   = spacing/32
spacing/layout/lg   = spacing/40
spacing/layout/xl   = spacing/48
```

### Part B-2: 산출물
1. `02-tokens/semantic.json` (W3C DTCG, palette alias)
   ```json
   {
     "$schema": "...",
     "version": "1.0.0",
     "spacing": {
       "stack": {
         "md": { "$value": "{spacing.8}", "$type": "dimension",
                  "$description": "List item 사이 세로 간격" }
       },
       "inset-squish": {
         "md": {
           "vertical":   { "$value": "{spacing.9}",  "$type": "dimension" },
           "horizontal": { "$value": "{spacing.20}", "$type": "dimension" }
         }
       }
     }
   }
   ```
2. `02-tokens/semantic.md` — 카테고리 정의·예시·alias 관계도
3. `02-tokens/name-mapping.csv` — JSON 이름 ↔ Dart 이름 1:1 매핑
   ```
   jsonName,dartClass,dartProperty,value,aliasOf
   spacing/0,AppSpacing,s0,0,
   spacing/12,AppSpacing,s12,12,
   spacing/stack/md,AppSpacingSemantic,stackMd,8,spacing/8
   spacing/inset-squish/md/vertical,AppSpacingSemantic,insetSquishMdVertical,9,spacing/9
   spacing/inset-squish/md/horizontal,AppSpacingSemantic,insetSquishMdHorizontal,20,spacing/20
   ```

## Part C: 디자이너 사용 가이드 (신규)

### 산출물: `02-tokens/usage-guide.md` (디자이너 핵심 문서)

**필수 섹션**:

1. **의사결정 트리** (어떤 토큰 선택할지)
   ```
   spacing 이 필요해?
   ├─ 컨테이너 안 4방향 패딩이야?
   │  ├─ 4방향 동일 → inset/{xs..xl}
   │  └─ 수평>수직 → inset-squish/{xs,sm,md,lg}
   ├─ 컴포넌트 사이 세로 간격? → stack/{xs..xl}
   ├─ 가로로 나란히 (icon-text)? → inline/{xs..lg}
   └─ 페이지 레벨? → layout/{sm..xl}
   ```

2. **각 토큰별 1줄 사용 가이드 + Figma 노드 링크**
   ```
   spacing/stack/lg = 16
     사용: 카드 사이, 헤딩-본문 사이
     시각: ▢ Card  ←16→  Card  ▢
     Figma: [Card 페이지의 grid 보기 링크]
   ```

3. **토큰 사용 우선순위** (코드/디자인 양쪽)
   - 1순위: 시맨틱 토큰 (의도 명확하면 무조건)
   - 2순위: 시맨틱 안 맞으면 palette 직접 (Outlined 1px 보정, Icon Button 별도 크기 등)
   - 3순위: 컴포넌트 고유 패턴은 .dart 안 const (Section Bottom Solid, Banner 등)
   - ⛔ 임의 숫자 직접 입력 금지

4. **FAQ**
   - Q: Card padding 늘리고 싶어요 → A: `inset/xl` 정의 변경 (다른 컨테이너도 영향)
   - Q: Button 만 통통하게 → A: `inset-squish/lg` 변경하면 Solid Button 다 변경. Outlined 1px 보정은 별도
   - Q: 새 컴포넌트 만들 때 → A: 비슷한 의도의 기존 컴포넌트가 쓰는 시맨틱 토큰 그대로 사용

5. **Figma Variables 동기화 가이드**: slash 구조 그대로 Figma 컬렉션에 등록 (`Spacing/Palette/{value}`, `Spacing/Semantic/{Category}/{Role}`), 각 변수에 description 추가

6. **바이브 코딩 컨텍스트**: 시맨틱 토큰 이름 = AI 가 디자인 의도를 추론하는 메타데이터. 임의 숫자 대신 시맨틱 토큰 사용 시 AI 가 신규 컴포넌트에 일관된 spacing 자동 적용 가능

## 검증 규칙
- 모든 semantic 토큰의 `aliasOf` 가 palette 에 존재 (orphan 0)
- palette 의 모든 값이 결정 리스트(20개) 에 있음
- Dart 변수명 중복 0
- name-mapping.csv 가 palette + semantic 전체 커버
- `02-tokens/usage-guide.md` 의 모든 시맨틱 토큰에 사용 예시 + Figma 링크 포함

## 산출물 요약
- `02-tokens/palette.json`
- `02-tokens/palette.md`
- `02-tokens/semantic-roles-inventory.md` ← 신규 (Part B-0)
- `02-tokens/semantic.json`
- `02-tokens/semantic.md`
- `02-tokens/usage-guide.md` ← 신규 (Part C, 디자이너용 핵심)
- `02-tokens/name-mapping.csv` ← 신규

## 커밋 & 푸시
`docs(spacing-migration): define palette and semantic tokens`

## 📌 사람 검수 #3
- Palette 20개 + Semantic 5 카테고리 최종 승인
- `usage-guide.md` 디자이너 사용성 검토
- `inset-squish` 페어 정의 정확성 확인 (Button 적용 시뮬레이션)

## 제약
- ⛔ palette/semantic 외 디렉터리/파일 수정 금지
- ⛔ **컴포넌트 단위 시맨틱 토큰 (`component-button` 등) 만들지 말 것** — 의도 토큰만
- ⛔ 데이터 정제 정책(Platform / Demo / *_use_cases) 반드시 적용
- ⛔ 한 raw 파일은 한 번에 1개씩만 열어 스트리밍 처리

---

# 🆕 Task 06 · Phase 3 — 매핑 테이블

## 입력
- `02-tokens/palette.json`, `02-tokens/semantic.json`, `02-tokens/name-mapping.csv`
- `02-tokens/semantic-roles-inventory.md` (자동 매핑 규칙 참고)
- `01-audit/figma-spacing-raw.*.json` (페이지별)
- `01-audit/code-hardcoded-usages.*.json` (디렉터리별)
- `01-audit/figma-pages.json` 의 `codeDirToFigmaPage` 매핑

## 매핑 우선순위 (모든 항목 공통)
1. **1순위**: 시맨틱 토큰 매칭 → `suggestedToken = AppSpacingSemantic.*`, `status = READY`
2. **2순위**: 시맨틱 안 맞으면 palette 직접 → `suggestedToken = AppSpacing.s{value}`, `status = READY` (단, 시맨틱화 가능한 후보면 `NEEDS_REVIEW`)
3. **3순위**: 데이터 정제 정책에 걸리거나 라이브러리 컴포넌트가 아닌 경우 → `status = BLOCKED` + reason

## 처리

### 1. Figma 매핑 — 모든 raw item 순회

**자동 BLOCKED 규칙** (라이브러리 컴포넌트 아님):
- 부모 체인에 `Platform=iOS` / `Platform=Android` / iOS Status Bar / Dynamic Island / Home Indicator / Tab Bar 등 포함 → `reason="Platform UI"`
- 페이지가 `foundation-colors/typography/icon/decorate/gradient/logo/3d-illustration/product` 중 하나 → `reason="Demo 페이지"`
- 페이지 직접 frame (`sourceNodeId` 가 `I` 로 시작 안 함) + value > 40 → `reason="페이지 카탈로그 grid 의심"` (NEEDS_REVIEW 로)

**자동 시맨틱 매핑 규칙**:
- `property === 'itemSpacing'` + parent `autoLayoutMode === 'VERTICAL'` → `stack` 후보, 가장 가까운 단계(xs/sm/md/lg/xl) 선택
- `property === 'itemSpacing'` + parent `autoLayoutMode === 'HORIZONTAL'` → `inline` 후보
- 4방향 padding 모두 같음 (T=R=B=L) → `inset` 후보
- T = B, L = R, T ≠ L → `inset-squish` 후보 (페어로 매핑)
- 그 외 비대칭 → palette 직접 (2순위)

**Outlined / Icon Button 특수 패턴**:
- Outlined 1px 보정 (8/9, 11/12 페어) → 시맨틱 매칭 안 됨. palette 직접 + `NEEDS_REVIEW` (디자인 정리 검토)
- Icon Button 의 6/7/10 padding → palette 직접

**출력**: `03-mapping/figma-node-to-token.csv`
```
pageId,pageSlug,nodeId,nodeName,property,currentValue,suggestedToken,group,status,reason
```
- `group` 컬럼은 Phase 4 슬라이싱 키. Foundation 페이지는 `foundation`, Component/Module 페이지는 해당 컴포넌트 이름 (avatars/buttons/...) — `codeDirToFigmaPage` 역매핑

### 2. 코드 매핑 — 모든 usage 순회

**자동 BLOCKED 규칙**:
- `file` 이 `*_use_cases.dart` → `reason="Demo 화면"`

**자동 시맨틱 매핑 규칙**:
- `kind === 'EdgeInsets.symmetric'` + horizontal === vertical → `inset` 단계 매칭
- `kind === 'EdgeInsets.symmetric'` + horizontal ≠ vertical → `inset-squish` 페어
- `kind === 'EdgeInsets.all'` → `inset`
- `kind === 'EdgeInsets.only'` (한 방향) → palette 직접 또는 NEEDS_REVIEW
- `kind === 'SizedBox'` + height + parent Column → `stack`
- `kind === 'SizedBox'` + width + parent Row → `inline`
- `kind === 'Gap'` → autoLayoutMode 추정 (Row/Column 부모) → `stack`/`inline`
- 기존 `tokenRef` (`AppSpacing.space12` 등) → 신규 palette/semantic 으로 매핑

**non-numeric / expression-with-literal**:
- non-numeric → `BLOCKED` (변수/함수 호출, 토큰 적용 어려움)
- expression-with-literal → embeddedLiterals 단위로 매핑 시도 + `NEEDS_REVIEW`

**출력**: `03-mapping/code-usage-to-token.csv`
```
file,line,dir,kind,currentValue,suggestedToken,status,reason
```

### 3. 검수 큐
- `03-mapping/REVIEW_QUEUE.md`
- `NEEDS_REVIEW` + `BLOCKED` 항목만 표로 정리
- 컬럼: `source | id | currentValue | suggestion | reason | action(체크박스)`
- 정렬: `NEEDS_REVIEW` 먼저 (실제 결정 필요), 그 다음 `BLOCKED` (참고용)

### 4. 매핑 통계 산출
- `03-mapping/SUMMARY.md`
- 항목별: 총수, READY 비율, NEEDS_REVIEW 수, BLOCKED 수
- 시맨틱 vs palette 매핑 비율
- 카테고리별(stack/inline/inset/inset-squish/layout) 매핑 분포

## 산출물 요약
- `03-mapping/figma-node-to-token.csv`
- `03-mapping/code-usage-to-token.csv`
- `03-mapping/REVIEW_QUEUE.md`
- `03-mapping/SUMMARY.md`

## 커밋 & 푸시
`docs(spacing-migration): generate token mapping tables`

## 📌 사람 검수 #4
- `REVIEW_QUEUE.md` 항목을 직접 결정
- CSV 파일의 `status`/`suggestedToken` 을 수동 수정 후 commit
- 모든 항목이 `READY` 또는 `BLOCKED` 가 되면 Phase 4 진입

## 제약
- ⛔ 데이터 정제 정책(Platform / Demo / *_use_cases) 모든 raw 파일에 적용
- ⛔ 한 raw 파일은 한 번에 1개씩만 열어 스트리밍 처리
- ⛔ 매핑 규칙은 결정론적으로 — 같은 입력은 같은 출력

---

# 🆕 Task 07..34 · Phase 4 — Figma 적용 (28개 그룹)

> `figma-pages.json` 의 `phase4ApplyGroups` 우선순위에 따라 28개 Task 등록.
>
> **Priority 1 (먼저 적용 — 토큰 소스)**
> - foundation-space (`2485:8842`)
>
> **Priority 2 (Component — 코드 디렉터리 1:1 매칭)**
> - component-button, component-chip, component-ratio, component-thumbnail, component-scroll, component-avatar, component-indicators, component-divider
>
> **Priority 3 (Module — 코드 디렉터리 1:N 매칭)**
> - module-navigation, module-tab, module-pagination, module-progress-indicators, module-selection-input, module-control-box, module-gauge, module-feedback, module-presentation, module-contents
>
> **Priority 4 (다른 Foundation — 스페이싱 사용 적음)**
> - foundation-logo, foundation-typography, foundation-colors, foundation-gradient, foundation-decorate, foundation-icon, foundation-3d-illustration, foundation-product
>
> **Priority 5 (Etc)**
> - etc-design-components
>
> 한 Task = 한 그룹.

## 입력
- `03-mapping/figma-node-to-token.csv`
- 처리 대상 그룹: `{group}`

## 처리
1. CSV 에서 `group={group}` 이면서 `status=READY` 인 행만 필터링
2. 행 수와 대상 nodeId 목록을 콘솔에 출력 (먼저 보여주기)
3. 노드 1개씩 순회:
   - `mcp__figma__use_figma` 또는 변수 바인딩 도구로 `suggestedToken` 을 노드 속성에 적용
   - 결과: `success | already-applied | failed`
4. 결과 로그: `04-apply-log/figma-{group}.md`
   ```
   | nodeId | nodeName | property | from | to | result |
   ```
5. 실패 노드만: `04-apply-log/figma-{group}-failed.json`

## 커밋 & 푸시
`refactor(figma-spacing): apply tokens to {group}`

## ⛔ 금지
- `status` 가 READY 가 아닌 행 처리 금지
- 다른 그룹 노드 건드리지 말 것
- 한 Task = 한 그룹 = 한 커밋

## 📌 사람 검수 #5 (그룹마다)
- Figma 비주얼 스폿체크
- failed.json 처리 방침 결정
- 다음 그룹 Task 진행 OK

---

# 🆕 Task LAST-4 · Phase 4 종료 — Figma 결과 INDEX

## 처리
모든 `figma-{group}.md` 와 `figma-{group}-failed.json` 를 모아 INDEX 작성:

`04-apply-log/figma-apply.INDEX.md`
- 그룹별 처리 노드 수, 성공/실패 수, 미적용 사유 요약

## 커밋 & 푸시
`docs(spacing-migration): figma apply summary`

---

# 🆕 Task 08 · Phase 5-Pre — 토큰 정의 코드 반영

> Phase 5 의 시작. 토큰 정의를 코드에 먼저 반영한 후에야 디렉터리별 치환을 진행할 수 있다.

## 입력
- `02-tokens/palette.json`, `02-tokens/semantic.json`

## 처리
1. `Library/component_lab/lib/foundation/app_spacing.dart` 갱신:
   - 기존 const 들을 Palette 토큰(`AppSpacing.s0, s2, s4, ...`) 로 재구성
   - Semantic 클래스 `AppSpacingSemantic` (또는 기존 네이밍 컨벤션) 추가
     - 예: `static const insetMd = AppSpacing.s12;`
   - 기존 이름은 backwards-compat 없이 새 이름으로 교체 (사용처는 Phase 5 의 디렉터리별 Task에서 일괄 치환)
2. `Library/component_lab/lib/foundation/spacing_use_cases.dart` 의 표시용 데이터도 새 토큰 기준으로 업데이트
3. `flutter analyze` 실행 → 컴파일은 깨질 수 있음(사용처가 아직 안 고쳐졌으니까). 실패해도 OK. 다만 **app_spacing.dart 자체의 문법 에러는 0** 이어야 한다.

## 산출물
- 수정된 `app_spacing.dart`, `spacing_use_cases.dart`
- `04-apply-log/code-foundation.md` — 변경 요약 + analyze 출력 캡처

## 커밋 & 푸시
`refactor(spacing): redefine palette and semantic tokens in foundation`

## ⛔ 금지
- foundation 외 디렉터리 수정 금지

## 📌 사람 검수 #6
- app_spacing.dart diff 검토 — 토큰 누락 없는지

---

# 🆕 Task 09..29 · Phase 5 — 코드 디렉터리별 적용

> 21개 컴포넌트 디렉터리 각각에 1개 Task = 1 세션 = 1 PR. 실제 코드 치환은 직렬(Agent 병렬 금지). 단, 디렉터리 진입 직전 컨텍스트 파악용 Explore 서브에이전트는 병렬 가능.

## 디렉터리 목록 (Task 등록 순서 — 의존도 낮은 순, 총 21개)
각 항목 옆은 해당 Figma 페이지 (`figma-pages.json` 의 `codeDirToFigmaPage` 기준)

1. avatars → `2452:6039` 👤 Avatar
2. dividers → `2452:6032` ➗ Divider
3. ratio → `2452:6033` 📏 Ratio
4. thumbnails → `2452:6037` 🖼️ Thumbnail
5. chips → `2546:166598` 🍪 Chip
6. buttons → `2414:32026` ⏹️ Button
7. controls → `2442:7603` ☑️ Selection and Input
8. selection → `2442:7603` ☑️ Selection and Input
9. indicators → `2442:16180` 💡 Indicators + `2449:415` ⏳ Progress Indicators
10. gauge → `2442:15568` 🌡️ Gauge
11. pagination → `2452:6038` 🔢 Pagination
12. tabs → `2414:34400` 📑 Tab
13. scrolls → `2452:7600` 🖱️ Scroll
14. cards → `2573:404660` 📑 Contents
15. contents → `2573:404660` 📑 Contents
16. presentation → `2546:42535` 📣 Presentation
17. control_box → `2537:62051` 🕹️ Control Box
18. forms → `2442:7603` ☑️ Selection and Input
19. feedback → `2546:36834` 🪞 Feedback
20. modals → `2546:42535` 📣 Presentation
21. navigation → `2452:3459` 🧭 Navigation

## 공통 입력
- `03-mapping/code-usage-to-token.csv`
- 처리 대상 디렉터리: `{dir}`
- Phase 5-Pre 가 머지된 최신 브랜치 상태

## 처리
1. CSV 에서 `file LIKE 'Library/component_lab/lib/{dir}/%'` 이면서 `status=READY` 인 행만 필터
2. 행 수와 대상 파일 목록 출력
3. 파일 1개씩 순회하여 `Edit` 도구로 hardcoded value → `AppSpacing.{token}` 또는 `AppSpacingSemantic.{token}` 으로 치환
4. 디렉터리 전체 처리 끝나면:
   - `cd Library/component_lab && flutter analyze --no-fatal-infos`
   - 분석 에러 0개여야 함
5. (있는 경우) 골든/위젯 테스트 실행: `flutter test test/{dir}/`
6. 결과 로그: `04-apply-log/code-{dir}.md`
   ```
   | file | line | from | to | result |
   ```
7. 실패 항목: `04-apply-log/code-{dir}-failed.json`

## 커밋 & 푸시
`refactor(spacing): apply tokens to {dir}`

## ⛔ 금지
- `{dir}` 외 디렉터리 수정 금지
- foundation/ 재수정 금지 (Task 08 의 결과 사용)
- analyze 실패한 채로 커밋 금지 — 실패 시 해당 파일 롤백 후 failed.json 에 기록
- 한 PR = 한 디렉터리

## 📌 사람 검수 #7 (디렉터리마다)
- diff 리뷰
- 비주얼 회귀(스토리북/샘플 스크린)
- 다음 디렉터리 Task 진행 OK

## 실패 처리
analyze 실패 / 테스트 실패:
- 실패 원인이 명백한 단일 파일이면 그 파일만 롤백 후 failed.json 기록
- 광범위 실패면 디렉터리 전체 롤백, 사용자에게 보고

---

# 🆕 Task 30 · Phase 6 — 최종 검증 보고

## 입력
- `04-apply-log/figma-apply.INDEX.md`
- `04-apply-log/code-{dir}.md` (전체)
- `01-audit/`, `02-tokens/`, `03-mapping/` 산출물 전체

## 처리
1. 적용률 계산:
   - Figma: `applied / total` (노드 수 기준, group 별 + 전체)
   - 코드: `applied / total` (usage 수 기준, dir 별 + 전체)
2. 미적용 항목 집계: 모든 `failed.json` + CSV 의 `BLOCKED` 항목
3. 토큰 사용 빈도: `grep AppSpacing` / `grep AppSpacingSemantic` 으로 코드 내 실사용 카운트
4. 사용되지 않은 토큰 (사용 횟수 0) → 제거 후보로 표시
5. 후속 작업 권고: BLOCKED 처리안

## 산출물
`Library/component_lab/docs/spacing-migration/04-apply-log/SUMMARY.md`
- 적용률 표
- 미적용 항목 표
- 토큰 실사용 빈도 표
- 사용되지 않은 토큰 목록
- 후속 작업 권고
- **릴리즈 체크리스트** (사람이 머지 전 확인할 항목들)

## 커밋 & 푸시
`docs(spacing-migration): final verification summary`

## 📌 사람 검수 #8 (최종)
- SUMMARY.md 승인
- main 머지 / 디자인 시스템 문서 업데이트 결정

---

# 부록 A · Task 등록 체크리스트 (Cowork 운영자용)

```
[✅] Task 00  — Phase 0  Bootstrap
[✅] Task 01  — Phase 1-A-0 (사전완료, figma-pages.json 존재)
    📌 검수 #1: figma-pages.json 의 auditOrder/codeDirToFigmaPage 확인 (완료)
[✅] Task 02  — Phase 1-B (코드 감사, 22개 디렉터리)
[✅] Task 03..30 — Phase 1-A v1 (Figma 페이지별, 27개 audit + 1 skip, schema v1 — `layoutMode` 없음)
[✅] Task LAST-1A — Phase 1-A INDEX
[✅] Task 31  — Phase 1-C 갭 분석
[✅] 📌 검수 #2: gap-analysis.md → palette 후보안 결정 (2026-05-14, 본 파일 Task 05 의 '결정 사항' 섹션 참조)
[✅] Task 32 / 본 파일 Task 05 — Phase 2 토큰 설계 v0.1 (PR #34, 2026-05-15)
    ⚠️ stack/inline 자동 분리는 Task 31a..z 사이드카 도착 후 v1.0 승격
[ ] Task 31a..31z — Phase 1-A-2 itemSpacing layoutMode 사이드카 (페이지별, ~10 세션)
    *itemSpacing 발생 페이지만 대상. v1 raw 변경 금지, 사이드카 1 파일만 누적.*
[ ] Task LAST-1A-2 — Phase 2 산출물 v1.0 재생성 (사이드카 적용 후 1회)
    📌 검수 #3: palette/semantic v1.0 승인 + usage-guide.md stack/inline 검증
[ ] Task 33 / 본 파일 Task 06 — Phase 3 매핑 (⚠️ Task 32 v1.0 승격 후 시작 권장)
    📌 검수 #4: REVIEW_QUEUE.md 해소
[ ] Task 34..61 — Phase 4 Figma 적용 (28개 그룹)
    📌 검수 #5 (그룹마다)
[ ] Task LAST-4 — Phase 4 INDEX
[ ] Task 62  — Phase 5-Pre 토큰 코드 반영
    📌 검수 #6: app_spacing.dart diff
[ ] Task 63..83 — Phase 5 디렉터리별 적용 (21개)
    📌 검수 #7 (디렉터리마다)
[ ] Task 84  — Phase 6 최종 검증
    📌 검수 #8: SUMMARY.md 최종 승인
```

총 84개 Task + Task 31a..z (Phase 1-A-2 사이드카) + Task LAST-1A-2 (v1.0 재생성). 사람 검수 게이트 8개. (현재 진행 위치: **Task 32 v0.1 산출 완료 (PR #34). Task 31a..z 디스패치 대기**)

---

# 🔴 부록 C · 세션 시작 전 필수 확인 (모든 Task 공통)

새 Claude Code 세션에서 Task 시작 전 **반드시 입력 파일 존재 여부를 먼저 확인**. 부재 시 바로 중단하고 이전 Task 부터 진행.

## Task 별 필수 입력

| Task | 필수 입력 |
|---|---|
| Task 04 / 31 (Phase 1-C) | `01-audit/figma-spacing.INDEX.json`, `01-audit/figma-spacing-raw.*.json` (110개 part), `01-audit/code-audit.INDEX.json`, `01-audit/code-hardcoded-usages.*.json` (22개), `01-audit/code-token-defs.foundation.json` |
| **Task 05 / 32 (Phase 2)** | 위 모두 + `01-audit/gap-analysis.md`, `01-audit/figma-pages.json` |
| **Task 31a..z (Phase 1-A-2)** | Figma fileKey + 대상 페이지 itemSpacing sourceNodeId 목록 (해당 `figma-spacing-raw.{pageSlug}*.json` 에서 추출). 사이드카 누적 파일 `01-audit/figma-itemspacing-layoutmode.json` (없으면 생성) |
| **Task LAST-1A-2 (Phase 2 v1.0 재생성)** | `01-audit/figma-itemspacing-layoutmode.json` (완성본) + 기존 110 raw + 02-tokens/* (v0.1) |
| **Task 06 / 33 (Phase 3)** | 위 모두 + `02-tokens/palette.json`, `02-tokens/semantic.json`, `02-tokens/name-mapping.csv`, `02-tokens/semantic-roles-inventory.md` (v1.0 권장) |
| Task 07..34 (Phase 4) | 위 모두 + `03-mapping/figma-node-to-token.csv` (status=READY 필터 가능) |
| Task 08 / 62 (Phase 5-Pre) | `02-tokens/palette.json`, `02-tokens/semantic.json` |
| Task 09..29 (Phase 5) | `03-mapping/code-usage-to-token.csv`, Task 08 머지 후 `lib/foundation/app_spacing.dart` 신버전 |

## Figma raw 파일 이름 패턴 (검색 시 주의)

저장소의 figma raw 는 두 패턴이 섞임:
- `figma-spacing-raw.{slug}.json` (단일 파일, 작은 페이지)
- `figma-spacing-raw.{slug}-part{N}.json` (분할 파일, 큰 페이지)

예시:
```
figma-spacing-raw.foundation-space.json
figma-spacing-raw.module-tab-part1.json
figma-spacing-raw.module-tab-part2.json
... 모듈 페이지는 보통 part1~part23 까지 분할
```

INDEX 는 단 1개: `figma-spacing.INDEX.json` (마침표 두 개).

`.errors.json` 파일은 이전 부분 완료 시점 흔적이며 **현재 모두 제거됨** (0개). 보이면 outdated.

## Code raw 파일 이름 패턴

```
code-hardcoded-usages.{dir}.json (22개)
code-hardcoded-usages.{dir}-part{N}.json (일부 디렉터리 분할)
code-audit.INDEX.json
code-token-defs.foundation.json
```

## 입력 부재 시 처리 (자동 분기 의무)

```
if (입력 파일 X 부재) {
  console.log('❌ 입력 부재:', X)
  console.log('→ 먼저 <이전 Task> 를 완료하세요.')
  return  // 현 세션 종료. 추정/빈 출력으로 진행 금지.
}
```

## 절대 하지 말 것

- 입력 부재를 이유로 "추정값" 또는 "빈 CSV" 같이 진행
- 이전 Task 의 일부만 명시적 확인하고 다음 Task 시작
- `gap-analysis.md` 의 옛 문구 ("figma-spacing.INDEX.json 부재" 같은 자가 진단) 를 현재 상태로 오해 — 현재 gap-analysis.md 는 91,882 items 캡처 완료된 신버전

---

# 부록 D · 의존성 그래프

```
Task 00 ──┬─► Task 01 ──📌──► Task 03..N ──► LAST-1A ──┐
          │                                              │
          └─► Task 02 ───────────────────────────────────┼──► Task 04 ──📌──► Task 05 ──📌──► Task 06 ──📌──► Task 07..N ──📌──► LAST-4 ──► Task 08 ──📌──► Task 09..29 ──📌──► Task 30 ──📌
```

Task 01 과 Task 02 는 병렬 가능. Task 03..N 은 Task 01 종료 후 병렬 가능. Task 07..N 과 Task 09..29 는 검수 #5/#7 통과한 단위만 다음 그룹/디렉터리로 진행.
