# Aggregate V/H Stats — Phase 1-A-2 종결 근거

**작성 시점**: Phase 3 (Task 06/33) 진입 직전.
**관련**: `Library/component_lab/docs/spacing-migration/02-tokens/semantic-roles-inventory.md` §3 ⚠️ 박스에서 보류됐던 `itemSpacing` stack/inline 자동 분리 결정.

## 결정

Phase 1-A-2 (sidecar 크롤링)을 **aggregate 통계로 종결**. 노드별 layoutMode 추출 대신, 페이지 단위 V/H 비율 + semantic 토큰의 동일 palette 값 특성을 근거로 **값 기반 canonical 매핑** 채택.

## 근거 1 — aggregate V/H 비율 (3개 대표 페이지)

| 페이지 | V (VERTICAL / stack) | H (HORIZONTAL / inline) |
|---|---:|---:|
| 📣 Presentation | 25% | 75% |
| ☑️ Selection and 📝 Input | 24% | 76% |
| 📑 Contents | 29% | 71% |

→ 세 페이지 모두 **H 70% 내외 우세**. 노드별 정확 분리 없이도 ambiguous value (2/4/8) 의 canonical 을 `inline` 으로 두면 다수 케이스에 부합.

## 근거 2 — semantic.json 의 stack/inline 동일 palette 값

`02-tokens/semantic.json` 에서 stack 과 inline 의 t-shirt 단계가 동일 palette 별칭을 공유:

| 단계 | stack | inline | 동일 여부 |
|---|---:|---:|---|
| xs | `spacing.2` | `spacing.2` | ✅ |
| sm | `spacing.4` | `spacing.4` | ✅ |
| md | `spacing.8` | `spacing.8` | ✅ |
| lg | `spacing.16` | `spacing.12` | ❌ (값 다름) |
| xl | `spacing.24` | — | inline 미정의 |

→ xs/sm/md 는 stack/inline 어느 쪽이든 **동일 palette 값 (2/4/8)** 으로 해석되므로, 디자이너 검수 없이도 토큰 적용 시 픽셀 차이 없음.
→ lg/xl 은 value 가 다르므로 (12 = inline 전용, 16 = stack 전용, 24 = stack 전용) **value 만 보고 canonical 결정 가능**.

## 적용된 canonical 룰

```
value 2  → AppSpacingSemantic.inlineXs   (stack.xs 와 동일 palette)
value 4  → AppSpacingSemantic.inlineSm   (stack.sm 와 동일 palette)
value 8  → AppSpacingSemantic.inlineMd   (stack.md 와 동일 palette)
value 12 → AppSpacingSemantic.inlineLg   (inline 전용)
value 16 → AppSpacingSemantic.stackLg    (stack 전용)
value 24 → AppSpacingSemantic.stackXl    (stack 전용)
그 외    → AppSpacing.s{value} (palette 직접) 또는 NEEDS_REVIEW
```

## 위험 / 잔여 이슈

- xs/sm/md ambiguous value 의 canonical 선택은 **의미론적 차이를 토큰 이름으로 전달하지 못함**. 코드 리뷰 시 "stackXs 가 맞는데 inlineXs 로 매핑됨" 류 지적 발생 가능.
  - 완화: Phase 4 Figma 적용 시점에 디자이너가 컴포넌트 단위로 토큰 이름 교정 가능 (semantic.json 의 palette 값은 동일하므로 픽셀 영향 없음).
- 32/40/48 의 layout.md/lg/xl 후보 여부는 자동 결정 불가 → NEEDS_REVIEW 로 남김.

## v1.0 승격 결정

본 문서 기준으로 `semantic-roles-inventory.md` §3 의 v0.1 한계 박스는 **v1.0 으로 종결**. 이후 sidecar (layoutMode) 재크롤링은 별도 트리거가 있을 때만 수행 (현재 계획 없음).
