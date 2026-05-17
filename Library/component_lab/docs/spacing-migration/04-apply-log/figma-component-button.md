# Phase 4 — Figma component-button 적용 로그

**대상 파일**: `q7yBPcHrid1CGQqFWEPwnR` (메인)
**대상 그룹**: `group=component-button`
**입력**: `03-mapping/figma-node-to-token.csv` 중 `group=component-button AND status=READY` (3,397행 / 1,331 distinct node)
**도구**: Figma MCP `use_figma`. 모든 write에 즉시 read-back 검증.
**실행 시각**: 2026-05-17

## 정책 (safe-write gate)

`literal/현재 변수의 resolved float` 이 **기대 변수의 resolved float와 정확히 일치**할 때만 `setBoundVariable` 호출. 불일치하면 skip + 보고. → 가시적 픽셀 변화 0 보장.

## 청크 분할

3,397 binding을 7개 청크로 분할 (use_figma 코드 50KB 한계 대응, 각 ~500 tuples / ~20KB).

| chunk | tuples |
|---|--:|
| 00 | 497 |
| 01 | 500 |
| 02 | 499 |
| 03 | 499 |
| 04 | 496 |
| 05 | 500 |
| 06 | 406 |

## 결과 집계

| 분류 | 수 | 의미 |
|---|--:|---|
| **ALIGNED** | 331 | 이미 기대 변수에 바인딩됨 (수정 불필요) |
| **OK (written + verified)** | 3,054 | 안전 게이트 통과 후 write 성공, post-verify 통과 |
| ├ UNBOUND_VALUE_MATCH | 3,028 | 미바인딩 + literal == expected → palette/semantic 토큰으로 바인딩 |
| └ MISALIGNED_SAME_VALUE | 26 | 다른 변수에 바인딩됨, resolved 값 == expected → CSV 권장 변수로 교체 |
| MISALIGNED_DIFF_VALUE_SKIPPED | 0 | — |
| UNBOUND_VALUE_MISMATCH_SKIPPED | 0 | — |
| NODE_NOT_FOUND | 12 | instance child path 미발견 (instance가 detach·교체) |
| NOT_AUTOLAYOUT | 0 | — |
| PROP_MISSING | 0 | — |
| **FAIL** | **0** | — |

- **literal 값 변화**: 0 (모든 write가 값 보존)
- **가시적 픽셀 변화**: 0

### 청크별 상세

| chunk | aligned | ok | nodeMiss | fail |
|---|--:|--:|--:|--:|
| 00 | 0 | 497 | 0 | 0 |
| 01 | 0 | 500 | 0 | 0 |
| 02 | 0 | 499 | 0 | 0 |
| 03 | 0 | 499 | 0 | 0 |
| 04 | 53 | 443 | 0 | 0 |
| 05 | 213 | 287 | 0 | 0 |
| 06 | 65 | 329 | 12 | 0 |
| **합계** | **331** | **3,054** | **12** | **0** |

## NODE_NOT_FOUND 12건 (chunk-06)

모두 instance-path 패턴 `I2414:32xxx;2411:2496` (itemSpacing 바인딩 대상). 해당 instance가 master 변경·detach로 child 경로가 더 이상 유효하지 않은 것으로 추정. 별도 검수 후 처리.

샘플: `I2414:32229;2411:2496`, `I2414:32230;2411:2496`, `I2414:32231;2411:2496`, `I2414:32233;2411:2496`, `I2414:32244;2411:2496`, …

## NEEDS_REVIEW

305건 (group=component-button)은 CSV에서 `status=NEEDS_REVIEW`로 분류되어 본 작업 범위 밖. 별도 사람 검수 (`03-mapping/REVIEW_QUEUE.md`).

## 한계

- Figma Plugin API에 Version History 명시 commit 없음 → 사람이 UI에서 직접 저장 필요.
- Pro 플랜 — 브랜치 불가, 메인 파일 직접 수정. 모든 변경이 값 보존이므로 시각적 영향 없음. 롤백 필요 시 변경 전 상태로 재바인딩 가능.
