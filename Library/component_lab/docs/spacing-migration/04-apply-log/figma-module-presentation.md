# Phase 4 — Figma module-presentation 적용 로그

**대상 파일**: `q7yBPcHrid1CGQqFWEPwnR` (메인)
**대상 그룹**: `group=module-presentation`
**입력**: `03-mapping/figma-node-to-token.csv` 중 `group=module-presentation AND status=READY` (20,803행 / 11,042 distinct node)
**plan**: `03-mapping/plans/figma-module-presentation.json`
**도구**: Figma MCP `use_figma`. 모든 write에 즉시 read-back 검증.
**실행 시각**: TBD
**상태**: PENDING (Figma MCP 부착 대기)

## 정책 (safe-write gate)

`literal/현재 변수의 resolved float` 이 **기대 변수의 resolved float와 정확히 일치**할 때만 `setBoundVariable` 호출. 불일치하면 skip + 보고. → 가시적 픽셀 변화 0 보장.

## 청크 분할

20,803 binding을 42개 청크로 분할 (use_figma 코드 50KB 한계 대응, 각 ≤500 tuples).

| chunk | tuples |
|---|--:|
| 00 | 500 |
| 01 | 500 |
| 02 | 500 |
| 03 | 500 |
| 04 | 500 |
| 05 | 500 |
| 06 | 500 |
| 07 | 500 |
| 08 | 500 |
| 09 | 500 |
| 10 | 500 |
| 11 | 500 |
| 12 | 500 |
| 13 | 500 |
| 14 | 500 |
| 15 | 500 |
| 16 | 500 |
| 17 | 500 |
| 18 | 500 |
| 19 | 500 |
| 20 | 500 |
| 21 | 500 |
| 22 | 500 |
| 23 | 500 |
| 24 | 500 |
| 25 | 500 |
| 26 | 500 |
| 27 | 500 |
| 28 | 500 |
| 29 | 500 |
| 30 | 500 |
| 31 | 500 |
| 32 | 500 |
| 33 | 500 |
| 34 | 500 |
| 35 | 500 |
| 36 | 500 |
| 37 | 500 |
| 38 | 500 |
| 39 | 500 |
| 40 | 500 |
| 41 | 303 |

## 사전 분포 (READY 행 기준)

### property

| property | count |
|---|--:|
| `itemSpacing` | 6,806 |
| `paddingBottom` | 4,548 |
| `paddingTop` | 4,284 |
| `paddingLeft` | 2,973 |
| `paddingRight` | 2,181 |
| `counterAxisSpacing` | 11 |

### suggestedToken (상위 10)

| token | count |
|---|--:|
| `AppSpacing.s2` | 2,928 |
| `AppSpacingSemantic.inlineMd` | 2,433 |
| `AppSpacing.s8` | 2,301 |
| `AppSpacing.s4` | 1,907 |
| `AppSpacing.s10` | 1,841 |
| `AppSpacing.s12` | 1,774 |
| `AppSpacing.s9` | 1,650 |
| `AppSpacingSemantic.inlineSm` | 1,159 |
| `AppSpacing.s6` | 867 |
| `AppSpacing.s3` | 862 |

### reason (상위 10)

| reason | count |
|---|--:|
| directional padding (palette direct) | 8,686 |
| value-based stack/inline (canonical) | 4,638 |
| palette direct (no semantic match for 10px) | 1,799 |
| 4-side equal 9px (no semantic inset match) | 1,640 |
| 4-side equal 2px (no semantic inset match) | 1,256 |
| 4-side equal 3px (no semantic inset match) | 652 |
| 4-side equal 6px (no semantic inset match) | 384 |
| inset-squish Lg (V12/H28) | 364 |
| inset-squish Xs (V2/H6) | 276 |
| inset (4-side equal 24px) | 212 |

## 결과 집계 (실행 후 채움)

| 분류 | 수 | 의미 |
|---|--:|---|
| **ALIGNED** | — | 이미 기대 변수에 바인딩됨 (수정 불필요) |
| **OK (written + verified)** | — | 안전 게이트 통과 후 write 성공, post-verify 통과 |
| ├ UNBOUND_VALUE_MATCH | — | 미바인딩 + literal == expected → palette/semantic 토큰 바인딩 |
| └ MISALIGNED_SAME_VALUE | — | 다른 변수에 바인딩됨, resolved 값 == expected → CSV 권장 변수로 교체 |
| MISALIGNED_DIFF_VALUE_SKIPPED | — | — |
| UNBOUND_VALUE_MISMATCH_SKIPPED | — | — |
| NODE_NOT_FOUND | — | instance child path 미발견 (detach·교체 의심) |
| NOT_AUTOLAYOUT | — | — |
| PROP_MISSING | — | — |
| **FAIL** | — | — |

- **literal 값 변화**: TBD
- **가시적 픽셀 변화**: TBD

### 청크별 상세 (실행 후 채움)

| chunk | aligned | ok | nodeMiss | fail |
|---|--:|--:|--:|--:|
| 00 | — | — | — | — |
| 01 | — | — | — | — |
| 02 | — | — | — | — |
| 03 | — | — | — | — |
| 04 | — | — | — | — |
| 05 | — | — | — | — |
| 06 | — | — | — | — |
| 07 | — | — | — | — |
| 08 | — | — | — | — |
| 09 | — | — | — | — |
| 10 | — | — | — | — |
| 11 | — | — | — | — |
| 12 | — | — | — | — |
| 13 | — | — | — | — |
| 14 | — | — | — | — |
| 15 | — | — | — | — |
| 16 | — | — | — | — |
| 17 | — | — | — | — |
| 18 | — | — | — | — |
| 19 | — | — | — | — |
| 20 | — | — | — | — |
| 21 | — | — | — | — |
| 22 | — | — | — | — |
| 23 | — | — | — | — |
| 24 | — | — | — | — |
| 25 | — | — | — | — |
| 26 | — | — | — | — |
| 27 | — | — | — | — |
| 28 | — | — | — | — |
| 29 | — | — | — | — |
| 30 | — | — | — | — |
| 31 | — | — | — | — |
| 32 | — | — | — | — |
| 33 | — | — | — | — |
| 34 | — | — | — | — |
| 35 | — | — | — | — |
| 36 | — | — | — | — |
| 37 | — | — | — | — |
| 38 | — | — | — | — |
| 39 | — | — | — | — |
| 40 | — | — | — | — |
| 41 | — | — | — | — |
| **합계** | **—** | **—** | **—** | **—** |

## NODE_NOT_FOUND 상세 (실행 후 채움)

(해당 없음 또는 instance-path 패턴 목록)

## NEEDS_REVIEW

`group=module-presentation` 의 `status=NEEDS_REVIEW` 행은 본 작업 범위 밖. 별도 사람 검수 (`03-mapping/REVIEW_QUEUE.md`).

## 한계

- Figma Plugin API에 Version History 명시 commit 없음 → 사람이 UI에서 직접 저장 필요.
- Pro 플랜 — 브랜치 불가, 메인 파일 직접 수정. 모든 변경이 값 보존이므로 시각적 영향 없음. 롤백 필요 시 변경 전 상태로 재바인딩 가능.
