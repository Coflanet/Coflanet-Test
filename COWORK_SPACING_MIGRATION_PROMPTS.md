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
- 작업 브랜치: `claude/spacing-tokens-organization-NwPFO`
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
1. 브랜치 `claude/spacing-tokens-organization-NwPFO` 가 없으면 생성, 있으면 체크아웃
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

# 🆕 Phase 1-A · Figma 페이지별 spacing 감사 (28개 자동 순차)

> 1세션에 그대로 붙여넣으면 Claude Code 가 `figma-pages.json` 의 `auditOrder` 를 읽어 28개 페이지를 우선순위 순으로 자동 순회. 이미 처리된 페이지는 skip 되므로 중간에 끊겨도 재실행하면 이어 진행.

## 자동 순차 진행 프롬프트

```
Phase 1-A — Figma 페이지별 spacing 감사 (28개 자동 순차)

전제:
- Library/component_lab/docs/spacing-migration/01-audit/figma-pages.json 존재
- 작업 브랜치: claude/spacing-tokens-organization-NwPFO
- 도구: mcp__figma__use_figma 만 사용 (다른 Figma 도구 타임아웃)
- Figma fileKey: q7yBPcHrid1CGQqFWEPwnR

진행 절차:

1. figma-pages.json 의 auditOrder 배열 읽기
2. 각 group 에 대해 pages 배열에서 audit=true 항목 매칭
3. auditOrder 순서대로 페이지 1개씩 다음 반복:

   a. 이미 figma-spacing-raw.{pageSlug}.json 이 존재하면 skip (재개 지원)
   b. use_figma 로 {pageId} 의 자식 노드 트리 얕게 가져와 컴포넌트 노드 ID 목록 확보
   c. 노드 50개 batch 로 순회, 각 노드의 spacing 속성 추출:
      - itemSpacing, paddingTop|Left|Right|Bottom, counterAxisSpacing
      - Auto Layout gap 값
      - 변수 바인딩 여부 (있으면 variableId 기록)
   d. 각 spacing 발생 지점을 다음 스키마로 기록:
      {
        tokenName: (바인딩된 변수명 or null),
        value: 12,
        unit: "px",
        property: "itemSpacing | padding-x | ...",
        aliasGroup: (변수 컬렉션 그룹명 or null),
        usageNote: (괄호 안 메모 or 노드 이름에서 추정),
        sourceNodeId: "X:Y",
        sourceNodeName: "...",
        pageId: "{pageId}"
      }
   e. 저장: 01-audit/figma-spacing-raw.{pageSlug}.json
      {
        _summary: { pageId, pageSlug, totalNodesScanned, spacingOccurrences,
          distinctValues, boundToVariable, rawValues, suspiciousItems },
        items: [ ... ]
      }
      items 1000개 초과 시 -part1.json, -part2.json 분할
   f. git add + commit: chore(spacing-migration): audit figma spacing - {pageSlug}
   g. git push origin claude/spacing-tokens-organization-NwPFO
   h. 진행률 출력: "[X/28] {pageSlug} done — items: N"

4. 28개 완료 후 INDEX 생성:
   01-audit/figma-spacing.INDEX.json
   {
     generatedAt, pages: [{ pageSlug, files, summary }],
     totals: { spacingOccurrences, globalValueFrequency }
   }
   commit: chore(spacing-migration): build figma audit index
   push

5. 최종 상태 보고:
   - 성공 페이지 수 / 실패 페이지 수
   - 실패한 페이지 목록과 원인

⛔ 한 페이지 처리 도중 에러:
   - 부분 산출물 저장
   - figma-spacing-raw.{pageSlug}.errors.json 에 원인 기록
   - 다음 페이지로 계속 진행 (전체 멈추지 말 것)
⛔ Figma 노드 수정 금지
⛔ 페이지 간 데이터 병합 금지
⛔ use_figma 외 Figma 도구 사용 금지 (타임아웃)
```

## 등록 순서 (참고용 — 프롬프트가 자동 처리)
1. foundation-space (`2485:8842`) ⭐ CRITICAL
2. foundation-logo (`0:1`)
3. foundation-typography (`2414:9843`)
4. foundation-colors (`2414:11941`)
5. foundation-gradient (`2452:6035`)
6. foundation-decorate (`2452:6034`)
7. foundation-icon (`2414:34422`)
8. foundation-3d-illustration (`2941:667`)
9. foundation-product (`2941:684`)
10. component-button (`2414:32026`) → buttons
11. component-chip (`2546:166598`) → chips
12. component-ratio (`2452:6033`) → ratio
13. component-thumbnail (`2452:6037`) → thumbnails
14. component-scroll (`2452:7600`) → scrolls
15. component-avatar (`2452:6039`) → avatars
16. component-indicators (`2442:16180`) → indicators
17. component-divider (`2452:6032`) → dividers
18. module-navigation (`2452:3459`) → navigation
19. module-tab (`2414:34400`) → tabs
20. module-pagination (`2452:6038`) → pagination
21. module-progress-indicators (`2449:415`) → indicators
22. module-selection-input (`2442:7603`) → selection,forms,controls
23. module-control-box (`2537:62051`) → control_box
24. module-gauge (`2442:15568`) → gauge
25. module-feedback (`2546:36834`) → feedback
26. module-presentation (`2546:42535`) → presentation,modals
27. module-contents (`2573:404660`) → contents,cards
28. etc-design-components (`2643:8531`)

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

# 🆕 Task 05 · Phase 2-A + 2-B — 토큰 설계

## 입력
- `01-audit/gap-analysis.md`
- 사용자 결정사항 `[USER_DECISION]` (검수 #2 결과)

## 처리 - Part A: Palette
1. 검수 결정 반영하여 Palette 스케일 확정
2. 이름 규칙: `spacing-{value}` (예: spacing-0, spacing-2, spacing-4, spacing-8)
3. 0은 항상 포함
4. 산출:
   - `02-tokens/palette.json`
     ```json
     {
       "version": "1.0.0",
       "tokens": [
         { "name": "spacing-0", "value": 0, "unit": "px" },
         { "name": "spacing-2", "value": 2, "unit": "px" }
       ]
     }
     ```
   - `02-tokens/palette.md` — 결정 근거, 제외값 사유, 사용 빈도 표

## 처리 - Part B: Semantic
1. 카테고리:
   - `layout` (페이지/섹션 간격)
   - `container` (컨테이너 내부 padding)
   - `inline` (수평 요소 간격)
   - `stack` (수직 요소 간격)
   - `inset` (전방향 padding)
   - `component-{name}` — 실제 컴포넌트 디렉터리명과 일치 (avatars, buttons, cards, chips, ...)
2. 이름 규칙: `spacing-{category}-{role}`
   - 예: `spacing-inset-md`, `spacing-stack-lg`, `spacing-button-padding-x`
3. 규칙:
   - 모든 semantic 토큰은 palette 토큰 정확히 1개를 alias
   - 동일 역할에는 동일 semantic 토큰 재사용
4. 산출:
   - `02-tokens/semantic.json`
     ```json
     {
       "version": "1.0.0",
       "tokens": [
         { "name": "spacing-inset-md", "aliasOf": "spacing-12", "category": "inset", "role": "md" }
       ]
     }
     ```
   - `02-tokens/semantic.md` — 카테고리 정의·예시·alias 관계도(palette→semantic 표)

## 커밋 & 푸시
`docs(spacing-migration): define palette and semantic tokens`

## 📌 사람 검수 #3
- Palette/Semantic 승인
- 누락된 컴포넌트 카테고리 없는지 확인

---

# 🆕 Task 06 · Phase 3 — 매핑 테이블

## 입력
- `02-tokens/palette.json`, `02-tokens/semantic.json`
- `01-audit/figma-spacing-raw.*.json`
- `01-audit/code-hardcoded-usages.*.json`

## 처리
1. **Figma 매핑** — 모든 figma raw item 순회:
   - `value` + `property` + `usageNote` + `sourceNodeName` 으로 가장 적절한 semantic 토큰 선택
   - 자신 있으면 `status=READY`, 모호하면 `NEEDS_REVIEW` + reason, 매칭 불가하면 `BLOCKED` + reason
   - 출력: `03-mapping/figma-node-to-token.csv`
     ```
     pageId,pageSlug,nodeId,nodeName,property,currentValue,suggestedToken,group,status,reason
     ```
   - `group` 컬럼은 Phase 4 슬라이싱 키. Foundation 페이지는 `foundation`, Component 페이지의 노드는 해당 컴포넌트 이름(avatars/buttons/...), 그 외는 페이지 카테고리 그대로

2. **코드 매핑** — 모든 code usage 순회:
   - `kind` + `values` + 파일 경로의 디렉터리로 semantic 토큰 선택
   - 동일 status 규칙 적용
   - 출력: `03-mapping/code-usage-to-token.csv`
     ```
     file,line,dir,kind,currentValue,suggestedToken,status,reason
     ```

3. **검수 큐**:
   - `03-mapping/REVIEW_QUEUE.md`
   - `NEEDS_REVIEW` + `BLOCKED` 항목만 표로 정리
   - 컬럼: `source | id | currentValue | suggestion | reason | action(체크박스)`

## 커밋 & 푸시
`docs(spacing-migration): generate token mapping tables`

## 📌 사람 검수 #4
- `REVIEW_QUEUE.md` 항목을 직접 결정
- CSV 파일의 status/suggestedToken 을 수동 수정 후 commit
- 모든 항목이 READY 또는 BLOCKED 가 되면 Phase 4 진입

---

# 🆕 Phase 4 · Figma 적용 (28개 그룹 자동 순차)

> 1세션에 그대로 붙여넣으면 Claude Code 가 `phase4ApplyGroups` 우선순위 순으로 28개 그룹을 자동 적용. 이미 처리된 그룹은 skip.

## 자동 순차 진행 프롬프트

```
Phase 4 — Figma 토큰 적용 (28개 그룹 자동 순차)

전제:
- 03-mapping/figma-node-to-token.csv 존재 (Phase 3 완료)
- 01-audit/figma-pages.json 의 phase4ApplyGroups 존재
- 도구: mcp__figma__use_figma 만 사용

진행 절차:

1. figma-pages.json 의 phase4ApplyGroups 배열 읽기 (priority 오름차순)
2. 각 group 에 대해:

   a. 이미 04-apply-log/figma-{group}.md 가 존재하면 skip (재개 지원)
   b. CSV 에서 group={group} AND status=READY 인 행만 필터링
   c. 행 수와 nodeId 목록 먼저 콘솔 출력
   d. 노드 1개씩 순회:
      - use_figma 로 suggestedToken 을 노드 속성에 변수 바인딩으로 적용
      - 결과 기록: success | already-applied | failed
   e. 04-apply-log/figma-{group}.md 작성
      | nodeId | nodeName | property | from | to | result |
   f. 실패 노드 → 04-apply-log/figma-{group}-failed.json
   g. commit: refactor(figma-spacing): apply tokens to {group}
   h. push
   i. 진행률 출력: "[X/28] {group} — success: N, failed: M"

3. 28개 완료 후 INDEX 생성:
   04-apply-log/figma-apply.INDEX.md
   - 그룹별 처리 노드 수, 성공/실패 수, 미적용 사유 요약
   commit: docs(spacing-migration): figma apply summary
   push

4. 최종 보고: 성공/실패 그룹 수, 주요 실패 원인

📌 그룹 1개 단위로 사람 검수 가능: 특정 그룹만 실행하려면 "only={group}" 인자 추가.

⛔ status 가 READY 가 아닌 행 처리 금지
⛔ 다른 그룹 노드 건드리지 말 것
⛔ 한 그룹 = 한 커밋
⛔ use_figma 외 Figma 도구 사용 금지
```

## 적용 우선순위 (참고 — 프롬프트가 자동 처리)
- **Priority 1**: foundation-space (`2485:8842`)
- **Priority 2** (Component): button, chip, ratio, thumbnail, scroll, avatar, indicators, divider
- **Priority 3** (Module): navigation, tab, pagination, progress-indicators, selection-input, control-box, gauge, feedback, presentation, contents
- **Priority 4** (다른 Foundation): logo, typography, colors, gradient, decorate, icon, 3d-illustration, product
- **Priority 5**: etc-design-components

## 📌 사람 검수 #5
- 28개 완료 후 Figma 비주얼 스폿체크
- 중간에 멈추고 싶으면 진행률 보고 후 사용자 컨펌

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

## 자동 순차 진행 프롬프트

```
Phase 5 — 코드 디렉터리별 적용 (21개 자동 순차)

전제:
- 03-mapping/code-usage-to-token.csv 존재 (Phase 3 완료)
- Task 62 (Phase 5-Pre) 머지된 최신 브랜치 상태

처리 순서 (의존도 낮은 순):
avatars, dividers, ratio, thumbnails, chips, buttons, controls,
selection, indicators, gauge, pagination, tabs, scrolls, cards,
contents, presentation, control_box, forms, feedback, modals, navigation

각 디렉터리마다:

   a. 이미 04-apply-log/code-{dir}.md 가 존재하면 skip (재개 지원)
   b. CSV 에서 file LIKE Library/component_lab/lib/{dir}/% AND status=READY 인 행만 필터
   c. 대상 파일 목록 먼저 출력
   d. 파일 1개씩 Edit 도구로 hardcoded value 를
      AppSpacing.{token} 또는 AppSpacingSemantic.{token} 으로 치환
   e. cd Library/component_lab && flutter analyze --no-fatal-infos
      → 분석 에러 0개여야 함
   f. (있는 경우) flutter test test/{dir}/
   g. 결과 로그: 04-apply-log/code-{dir}.md
      | file | line | from | to | result |
   h. 실패 항목: 04-apply-log/code-{dir}-failed.json
   i. commit: refactor(spacing): apply tokens to {dir}
   j. push
   k. 진행률 출력: "[X/21] {dir} — changed: N, analyze: pass"

⚠️ analyze 실패 시:
   - 원인 명확한 단일 파일이면 그 파일만 롤백 후 failed.json 기록, 다음 파일 계속
   - 광범위 실패면 해당 디렉터리 전체 롤백, 대기 목록에 추가하고 다음 디렉터리로

최종 보고:
- 성공 디렉터리 수 / 실패 디렉터리 수
- 다음 세션에서 재시도해야 할 디렉터리 목록

📌 디렉터리 1개 단위로 사람 검수 가능: "only={dir}" 인자 추가하면 1개만 처리.

⛔ 하나의 디렉터리 처리 중에 다른 디렉터리 수정 금지
⛔ foundation/ 재수정 금지
⛔ analyze 실패한 채로 커밋 금지
⛔ 한 디렉터리 = 한 커밋 (1세션에서 21개 커밋이 생성됨)
```

## 디렉터리 ↔ Figma 페이지 매핑 (참고 — 프롬프트가 자동 처리)
1. avatars → `2452:6039` 👤 Avatar
2. dividers → `2452:6032` ➗ Divider
3. ratio → `2452:6033` 📏 Ratio
4. thumbnails → `2452:6037` 🖼️ Thumbnail
5. chips → `2546:166598` 🍪 Chip
6. buttons → `2414:32026` ⏹️ Button
7. controls → `2442:7603` ☑️ Selection and Input
8. selection → `2442:7603` ☑️ Selection and Input
9. indicators → `2442:16180` 💡 Indicators + `2449:415` ⏳ Progress
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

## 📌 사람 검수 #7
- 21개 완료 후 PR diff 리뷰
- 디렉터리별 비주얼 회귀 (sample_screen / 위젯 테스트)

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
[ ] Task 00  — Phase 0  Bootstrap
[✅] Task 01 — Phase 1-A-0 (사전완료, figma-pages.json 존재)
    📌 검수 #1: figma-pages.json 의 auditOrder/codeDirToFigmaPage 확인
[ ] Task 02  — Phase 1-B (코드 감사, 22개 서브 작업 1세션)
[ ] Task 03..30 — Phase 1-A (Figma 페이지별, 총 28개)
[ ] Task LAST-1A — Phase 1-A INDEX
[ ] Task 31  — Phase 1-C 갭 분석
    📌 검수 #2: gap-analysis.md → palette 후보안 결정
[ ] Task 32  — Phase 2 토큰 설계
    📌 검수 #3: palette/semantic 승인
[ ] Task 33  — Phase 3 매핑
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

총 84개 Task. 사람 검수 게이트 8개.

# 부록 B · 의존성 그래프

```
Task 00 ──┬─► Task 01 ──📌──► Task 03..N ──► LAST-1A ──┐
          │                                              │
          └─► Task 02 ───────────────────────────────────┼──► Task 04 ──📌──► Task 05 ──📌──► Task 06 ──📌──► Task 07..N ──📌──► LAST-4 ──► Task 08 ──📌──► Task 09..29 ──📌──► Task 30 ──📌
```

Task 01 과 Task 02 는 병렬 가능. Task 03..N 은 Task 01 종료 후 병렬 가능. Task 07..N 과 Task 09..29 는 검수 #5/#7 통과한 단위만 다음 그룹/디렉터리로 진행.
