# Phase 4 — Figma module-feedback 적용 로그

**대상 파일**: `q7yBPcHrid1CGQqFWEPwnR` (메인)
**대상 그룹**: `group=module-feedback`
**입력**: `03-mapping/figma-node-to-token.csv` 중 `group=module-feedback AND status=READY` (3,111행 / 1,393 distinct node)
**plan**: `03-mapping/plans/figma-module-feedback.json`
**도구**: Figma MCP `use_figma`. 모든 write에 즉시 read-back 검증.
**실행 시각**: TBD
**상태**: PENDING (Figma MCP 부착 대기)

## 정책 (safe-write gate)

`literal/현재 변수의 resolved float` 이 **기대 변수의 resolved float와 정확히 일치**할 때만 `setBoundVariable` 호출. 불일치하면 skip + 보고. → 가시적 픽셀 변화 0 보장.

## 청크 분할

3,111 binding을 7개 청크로 분할 (use_figma 코드 50KB 한계 대응, 각 ≤500 tuples).

| chunk | tuples |
|---|--:|
| 00 | 500 |
| 01 | 500 |
| 02 | 500 |
| 03 | 500 |
| 04 | 500 |
| 05 | 500 |
| 06 | 111 |

## 사전 분포 (READY 행 기준)

### property

| property | count |
|---|--:|
| `itemSpacing` | 938 |
| `paddingBottom` | 721 |
| `paddingTop` | 711 |
| `paddingRight` | 362 |
| `paddingLeft` | 362 |
| `counterAxisSpacing` | 17 |

### suggestedToken (상위 10)

| token | count |
|---|--:|
| `AppSpacing.s2` | 442 |
| `AppSpacing.s10` | 295 |
| `AppSpacing.s4` | 254 |
| `AppSpacing.s6` | 244 |
| `AppSpacingSemantic.inlineSm` | 243 |
| `AppSpacingSemantic.insetXl` | 236 |
| `AppSpacingSemantic.insetSquishXsVertical` | 220 |
| `AppSpacingSemantic.insetSquishXsHorizontal` | 220 |
| `AppSpacing.s3` | 164 |
| `AppSpacingSemantic.stackXl` | 120 |

### reason (상위 10)

| reason | count |
|---|--:|
| directional padding (palette direct) | 1,064 |
| value-based stack/inline (canonical) | 610 |
| inset-squish Xs (V2/H6) | 440 |
| inset (4-side equal 24px) | 236 |
| palette direct (no semantic match for 10px) | 215 |
| palette direct (no semantic match for 6px) | 100 |
| inset-squish Lg (V12/H28) | 96 |
| 4-side equal 6px (no semantic inset match) | 80 |
| 4-side equal 10px (no semantic inset match) | 80 |
| inset (4-side equal 12px) | 72 |

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
| **합계** | **—** | **—** | **—** | **—** |

## NODE_NOT_FOUND 상세 (실행 후 채움)

(해당 없음 또는 instance-path 패턴 목록)

## NEEDS_REVIEW

`group=module-feedback` 의 `status=NEEDS_REVIEW` 행은 본 작업 범위 밖. 별도 사람 검수 (`03-mapping/REVIEW_QUEUE.md`).

## 한계

- Figma Plugin API에 Version History 명시 commit 없음 → 사람이 UI에서 직접 저장 필요.
- Pro 플랜 — 브랜치 불가, 메인 파일 직접 수정. 모든 변경이 값 보존이므로 시각적 영향 없음. 롤백 필요 시 변경 전 상태로 재바인딩 가능.
