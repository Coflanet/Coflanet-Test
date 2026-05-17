# Phase 4 — Figma Foundation-Space 적용 로그

**대상 파일**: `q7yBPcHrid1CGQqFWEPwnR` (메인, 브랜치 미사용 — Pro 플랜 제약)
**대상 페이지 슬러그**: `foundation-space`
**입력 매핑**: `03-mapping/figma-node-to-token.csv` 중 `pageSlug=foundation-space AND status=READY` (259행 / 115개 distinct node)
**도구**: Figma MCP `use_figma` (Plugin API), 모든 write 작업 직후 read-back 검증
**작업자**: 김택림 (designtr94@gmail.com), Coflanet Pro
**실행 시각**: 2026-05-17

---

## 0. 인계서와 실데이터의 차이 (실데이터 우선)

인계서 Phase 4 절차는 (a) Variable Collection "Spacing" 신규 생성 + (b) palette 20개 + semantic 26개 변수 등록 + (c) 노드 바인딩이었으나, 사전 감사 결과 **(a)·(b)는 이미 완료**된 상태였음.

| 구분 | 인계서 | 실데이터 |
|---|---|---|
| Collection | 신규 `Spacing` | `Palette`(단일 모드) + `Semantic`(Light/Dark) 분산 — 기존 컬렉션 재사용 |
| palette 20개 | 신규 등록 | `Palette` 컬렉션에 `spacing/0..48` 20개 전부 존재, 값 100% 일치 |
| semantic 26개 | 신규 등록 (palette alias) | `Semantic` 컬렉션에 `spacing/{stack,inline,inset,inset-squish,layout}/*` 26개 전부 존재, alias 100% 일치 (Light=Dark) |

→ duplicate 방지를 위해 (a)·(b) 등록 단계는 **스킵**. 본 로그는 (c) 바인딩만 다룸.

근거: [palette.json](../02-tokens/palette.json), [semantic.json](../02-tokens/semantic.json) vs 사전 감사 결과.

---

## 1. 바인딩 사전 감사 (read-only)

259개 binding plan을 4개 카테고리로 분류:

| 분류 | 수 | 의미 |
|---|--:|---|
| **ALIGNED** | 210 | 이미 기대 변수에 바인딩됨 (수정 불필요) |
| **MISALIGNED_SAME_VALUE** | 49 | 다른 변수에 바인딩됨, 단 resolved float 값은 기대값과 동일 → 가시적 변화 없이 변수만 교체 |
| MISALIGNED_DIFF_VALUE | 0 | — |
| UNBOUND_VALUE_MATCH | 0 | — |
| UNBOUND_VALUE_MISMATCH | 0 | — |
| NODE_NOT_FOUND | 0 | — |
| NOT_AUTOLAYOUT | 0 | — |
| PROP_MISSING | 0 | — |

⇒ 실제 write 대상은 **49건**. 미해결 케이스 없음.

### MISALIGNED 패턴 (값 동일, 변수 차이)

| 현재 변수 | 기대 변수 (CSV 권장) | 건수 | 의미 |
|---|---|--:|---|
| `spacing/16` (palette) | `spacing/stack/lg` (semantic) | 17 | itemSpacing=16 의미: vertical stack |
| `spacing/24` (palette) | `spacing/stack/xl` (semantic) | 9 | itemSpacing=24 |
| `spacing/12` (palette) | `spacing/inset-squish/lg/vertical` | 3 | Button Large V |
| `spacing/28` (palette) | `spacing/inset-squish/lg/horizontal` | 3 | Button Large H |
| `spacing/4` (palette) | `spacing/inline/sm` (semantic) | 8 | inline icon-text |
| `spacing/2` (palette) | `spacing/inline/xs` (semantic) | 1 | 미세 inline |
| `Spacing/Padding/16(Box in Box)` (legacy PascalCase) | `spacing/16` (palette) | 2 | 레거시 정리 |
| `Spacing/12` (legacy PascalCase) | `spacing/inline/lg` (semantic) | 1 | 레거시 정리 |
| `Spacing/List/Card/Large` (legacy alias→spacing/4) | `spacing/inline/sm` (semantic) | 1 | 레거시 정리 |
| 기타 squish 페어 | semantic squish | 4 | — |

---

## 2. 적용 결과 (write + post-verify)

49건 `node.setBoundVariable(prop, variable)` 호출 후 즉시 노드 재조회로 검증.

- **attempted**: 49
- **ok**: 49 (post-verify 통과)
- **fail**: 0
- **literal 값 변경**: 0 (모든 노드에서 변경 전/후 값 동일)
- **가시적 픽셀 변화**: 0

### 상세 (요약)

전체 49건 모두 `before.literal == after.literal`, `after.boundId == expected.id`.

대표 샘플:

| nodeId | property | before var | → after var | value |
|---|---|---|---|--:|
| 3032:20102 | itemSpacing | `spacing/16` | `spacing/stack/lg` | 16 |
| 3032:20176 | paddingTop/Bottom | `spacing/12` | `spacing/inset-squish/lg/vertical` | 12 |
| 3032:20176 | paddingRight/Left | `spacing/28` | `spacing/inset-squish/lg/horizontal` | 28 |
| 3101:2824 | (squish 4면) | palette 12/28 | semantic squish/lg V/H | 12/28 |
| I3049:34927;2576:63728 | paddingR/L | `Spacing/Padding/16(Box in Box)` (legacy) | `spacing/16` (palette) | 16 |
| I3049:34927;2576:63728 | itemSpacing | `Spacing/12` (legacy) | `spacing/inline/lg` (semantic) | 12 |
| I3049:33347;2563:336962;2563:336983 | itemSpacing | `spacing/16` | `spacing/stack/lg` | 16 |
| (× 12개 더 itemSpacing=16 → stack/lg) |  |  |  | 16 |
| 2485:8905/8909/.../3101:2832/2497:5412 | itemSpacing | `spacing/24` | `spacing/stack/xl` | 24 |
| I3049:33347;...;2523:156333..338;...;2523:156449 (6건) | itemSpacing | `spacing/4` | `spacing/inline/sm` | 4 |
| I3049:33347;2563:336962;2563:336988 | itemSpacing | `spacing/4` | `spacing/inline/sm` | 4 |
| I3049:33347;...;1208:9478;1208:9474 | itemSpacing | `spacing/2` | `spacing/inline/xs` | 2 |
| 3032:20100, 3101:2810 | itemSpacing | `Spacing/List/Card/Large` (legacy)·`spacing/4` | `spacing/inline/sm` | 4 |

---

## 3. 한계 / 위험 관리

- **Version History 명시 commit**: Figma Plugin API는 사용자 코드에서 명시적 version 저장 API를 제공하지 않음 (자동 저장만). 인계서의 "스냅샷" 요구는 `use_figma`로 충족 불가. 사람이 Figma UI에서 직접 저장하는 절차 필요.
- **메인 파일 직접 수정** (Pro 플랜 브랜치 불가): 본 작업은 모든 변경에 대해 read-back 검증을 했고, 모든 변경이 *값 보존, 변수 교체*이므로 시각적/배치적 영향 없음. 롤백 필요 시 본 로그의 `before.boundId`를 그대로 재바인딩하면 됨.
- **instance override**: 79개 binding이 instance 자식에 적용됨 (CSV의 `I...;...` 경로). master component까지 전파되지 않으며 instance scope에만 적용됨 — foundation-space 페이지가 토큰 카탈로그/시연 페이지이므로 의도된 범위.

---

## 4. 부수 발견 (별도 처리 권장)

본 Phase 4 범위 밖이지만 감사 중 발견한 이슈:

1. **`Semantic > Spacing/48` Dark mode 값 = 40, Light = 48** (VariableID:2820:124901) — 두 모드 값 불일치. 새 토큰 체계와 무관한 레거시 변수지만 명백한 버그. → 별도 fix task로 spawn 완료.
2. **레거시 PascalCase spacing 변수 다수**: `Spacing/4`, `Spacing/8`, `Spacing/12`, ..., `Spacing/Button/{hor,ver}`, `Spacing/Padding/24(Contetns in Box)` 등이 Semantic 컬렉션에 남아있음. 본 작업으로 foundation-space 페이지에서는 새 체계로 마이그레이션되었으나, 다른 페이지에서 여전히 참조될 가능성. 향후 Phase에서 전수 deprecate 및 제거 권장.

---

## 5. 다음 단계 후보

- Phase 4 잔여 페이지 (`module-*`, `component-*`)에 동일 절차 적용 — CSV READY 78,915행 중 foundation-space 259행만 처리 완료.
- 레거시 spacing 변수 deprecate 계획 (별도 Phase).
