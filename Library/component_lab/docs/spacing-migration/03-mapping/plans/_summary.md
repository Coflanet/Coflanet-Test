# module-* 그룹 바인딩 plan 요약

**파일 키**: `q7yBPcHrid1CGQqFWEPwnR`
**청크 크기**: 500

| 순서 | group | binds | distinct nodes | chunks | 상태 |
|--:|---|--:|--:|--:|---|
| 1 | `module-gauge` | 25 | 11 | 1 | ✅ DONE (commit 82ad362) |
| 2 | `module-control-box` | 161 | 67 | 1 | ✅ DONE (commit 82ad362) |
| 3 | `module-progress-indicators` | 1,004 | 793 | 3 | PENDING |
| 4 | `module-pagination` | 2,467 | 1,445 | 5 | PENDING |
| 5 | `module-feedback` | 3,111 | 1,393 | 7 | PENDING |
| 6 | `module-tab` | 5,123 | 2,589 | 11 | PENDING |
| 7 | `module-navigation` | 5,198 | 2,409 | 11 | PENDING |
| 8 | `module-contents` | 11,107 | 5,933 | 23 | PENDING |
| 9 | `module-presentation` | 20,803 | 11,042 | 42 | PENDING |
| 10 | `module-selection-input` | 23,865 | 10,942 | 48 | PENDING |
| | **합계** | **72,864** | **36,624** | **152** | |
| | **잔여** | **72,678** | — | **150** | |

실행 순서는 작은 그룹 → 큰 그룹 (handoff 지정). 한 그룹 완료 시마다 `04-apply-log/figma-{group}.md` 갱신 + commit + push.

## 핸드오프 노트

- 인계 시점 기준 잔여 작업: **8개 그룹 / 72,678 binds / 150 chunks**.
- `gauge`/`control-box`는 직전 세션(82ad362)에서 이미 완료됨 — 본 prep 작업은 plan JSON만 같이 생성해 보존 (재실행은 불필요).
- 각 그룹의 청크 정의·바인드 목록은 `03-mapping/plans/figma-{group}.json` 참조.
- 로그 템플릿(`04-apply-log/figma-module-{group}.md`)은 사전 분포 표(property/token/reason)까지 미리 채워둠. 실행 후 "결과 집계" 섹션만 갱신.
