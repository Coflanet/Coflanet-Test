# Spacing Token Migration - Cowork Dispatch Prompts

> 본 문서는 Claude Code 디스패치 Cowork에 순차 등록할 작업 단위(Task Unit) 묶음입니다.
> 각 Task는 독립 세션을 전제로 자기 완결적이며, 이전 Task의 산출물(JSON/MD/CSV)을 입력으로 사용합니다.
> 📌 = 사람 검수 게이트 / 🆕 = 새 세션 권장 / ⛔ = 작업 금지선

## 진행 방식 (Hybrid 권장)

`use_figma` 가 단일 Figma 데스크톱 세션을 점유하므로 Figma 작업은 병렬화 시 충돌합니다. 따라서 다음과 같이 분배합니다:

| 구간 | 진행 방식 | 이유 |
|---|---|---|
| Task 00 Bootstrap | 어느 쪽이든 | 폴더만 만들면 끝 |
| Task 02 코드 감사 (22개 서브) | **Cowork** | read-only, 병렬 안전 |
| Task 03..30 Figma 감사 (28개) | **단일 채팅창 순차** | use_figma 세션 1개. 병렬 시 타임아웃·경합 |
| Task 31 갭 분석 | 단일 채팅창 | 통계 정리, 짧음 |
| Task 32 토큰 설계 | **단일 채팅창** | 디자인 판단 필요 |
| Task 33 매핑 테이블 | Cowork | 규칙 기반 매칭 |
| Task 34..61 Figma 적용 (28개) | **단일 채팅창 순차** | use_figma 단일 세션 |
| Task 62 Phase 5-Pre 토큰 코드 반영 | 단일 채팅창 | 한 번뿐, 신중 |
| Task 63..83 코드 적용 (21개 디렉터리) | **Cowork** | flutter analyze 독립 검증 가능, 병렬 큰 이득 |
| Task 84 최종 검증 | 단일 채팅창 | 보고서 작성 |

### 시간 절감 효과
- 코드 적용 21개를 단일 채팅창 순차: 약 21회 세션 → Cowork 병렬: 3~5 그룹 동시 → **약 4~5배 빠름**
- Figma 작업은 어차피 순차여야 하므로 Cowork 효과 없음 (오히려 충돌 위험)

### 진행 패턴
1. **Cowork 묶음 1**: Task 00 + Task 02 (코드 감사) — 동시 진행
2. **단일 채팅창**: Task 03..30 Figma 페이지별 감사 — 페이지 1~3개씩 끊어서 새 세션 (foundation-space 먼저)
3. **단일 채팅창**: Task 31 → 32 → 33 (판단 + 매핑)
4. **단일 채팅창**: Task 34..61 Figma 적용 — 그룹 1~2개씩
5. **단일 채팅창**: Task 62 토큰 코드 반영
6. **Cowork 묶음 2**: Task 63..83 코드 적용 — 디렉터리 4~5개씩 묶어서 병렬 PR
7. **단일 채팅창**: Task 84 검증

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

> 이 Task는 **하나의 세션 안에서 22개 서브 작업**을 순차 수행한다. 각 서브 작업은 1개 디렉터리만 처리.

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
     "pageId": "{pageId}"
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

> 21개 컴포넌트 디렉터리 각각에 1개 Task. 아래 목록 그대로 21개 Task 등록.

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
