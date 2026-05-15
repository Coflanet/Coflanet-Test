# Semantic Tokens — Phase 2 SoT (Task 05)

**버전**: `1.0.0-pending-1a2` — alias 26 토큰 정의는 확정 (검수 #2). stack/inline 분리는 Phase 1-A-2 (`layoutMode` 사이드카) 완료 후 데이터 재검증.
**입력**: `palette.json` (20 토큰), `semantic-roles-inventory.md` (Part B-0)
**패턴**: 패턴 2 (Palette + 의도 시맨틱) — 컴포넌트별 토큰 없음.

---

## 1. 카테고리 정의 (5)

| 카테고리 | 의미 | 적용 신호 (raw) | 적용 예 |
|---|---|---|---|
| `stack`        | 수직 형제 간 간격 | `itemSpacing`+VERTICAL autoLayout | List item, Card 사이, Heading-Body |
| `inline`       | 수평 형제 간 간격 | `itemSpacing`+HORIZONTAL autoLayout | Icon-text, Chip group |
| `inset`        | 4방향 동일 내부 패딩 | T=R=B=L | Tag, FAB, Card |
| `inset-squish` | T=B, L=R, T≠L | Button 패턴 | Solid/Outlined Button, Section Bottom |
| `layout`       | 페이지 레벨 큰 간격 | itemSpacing(VERTICAL)+section gap | Section/Page gap |

이름 규칙: `spacing/{category}/{role}`. `inset-squish` 는 `{role}/vertical`, `{role}/horizontal` 페어.

---

## 2. 토큰 목록

### 2-1. `stack` (5)

| 토큰 | alias | 값 | 역할 |
|---|---|---:|---|
| `spacing/stack/xs` | `spacing/2` | 2 | Label-Value 미세 세로 간격 |
| `spacing/stack/sm` | `spacing/4` | 4 | Heading-Description 세로 간격 |
| `spacing/stack/md` | `spacing/8` | 8 | List item 사이 세로 간격 |
| `spacing/stack/lg` | `spacing/16` | 16 | Card 사이, Heading-Body 세로 간격 |
| `spacing/stack/xl` | `spacing/24` | 24 | Section 사이 세로 간격 |

### 2-2. `inline` (4)

| 토큰 | alias | 값 | 역할 |
|---|---|---:|---|
| `spacing/inline/xs` | `spacing/2` | 2 | 수평 미세 간격 |
| `spacing/inline/sm` | `spacing/4` | 4 | Icon-text 표준 수평 간격 |
| `spacing/inline/md` | `spacing/8` | 8 | Button/Chip group 수평 간격 |
| `spacing/inline/lg` | `spacing/12` | 12 | 수평 강조 간격 |

### 2-3. `inset` (5)

| 토큰 | alias | 값 | 역할 |
|---|---|---:|---|
| `spacing/inset/xs` | `spacing/4` | 4 | Tag/Badge 4방향 패딩 |
| `spacing/inset/sm` | `spacing/8` | 8 | 작은 컨테이너 4방향 패딩 |
| `spacing/inset/md` | `spacing/12` | 12 | Icon Button 표준 4방향 패딩 |
| `spacing/inset/lg` | `spacing/16` | 16 | FAB / Card 표준 4방향 패딩 |
| `spacing/inset/xl` | `spacing/24` | 24 | Modal 4방향 패딩 |

### 2-4. `inset-squish` (4 페어)

| 토큰 | alias | 값 | 역할 |
|---|---|---:|---|
| `spacing/inset-squish/xs/vertical` | `spacing/2` | 2 | Badge 세로 |
| `spacing/inset-squish/xs/horizontal` | `spacing/6` | 6 | Badge 가로 |
| `spacing/inset-squish/sm/vertical` | `spacing/7` | 7 | Button Small 세로 |
| `spacing/inset-squish/sm/horizontal` | `spacing/14` | 14 | Button Small 가로 |
| `spacing/inset-squish/md/vertical` | `spacing/9` | 9 | Button Medium 세로 |
| `spacing/inset-squish/md/horizontal` | `spacing/20` | 20 | Button Medium 가로 |
| `spacing/inset-squish/lg/vertical` | `spacing/12` | 12 | Button Large 세로 |
| `spacing/inset-squish/lg/horizontal` | `spacing/28` | 28 | Button Large 가로 |

### 2-5. `layout` (4)

| 토큰 | alias | 값 | 역할 |
|---|---|---:|---|
| `spacing/layout/sm` | `spacing/24` | 24 | Section 간격 |
| `spacing/layout/md` | `spacing/32` | 32 | Section 큰 간격 |
| `spacing/layout/lg` | `spacing/40` | 40 | Layout 큰 간격 |
| `spacing/layout/xl` | `spacing/48` | 48 | Layout 최대 간격 |

---

## 3. Alias 관계도 (palette → semantic)

```
spacing/0   (palette 직접 호출만)
spacing/1   (palette 직접 호출만)
spacing/2   →  spacing/stack/xs, spacing/inline/xs, spacing/inset-squish/xs/vertical
spacing/3   (palette 직접 호출만)
spacing/4   →  spacing/stack/sm, spacing/inline/sm, spacing/inset/xs
spacing/6   →  spacing/inset-squish/xs/horizontal
spacing/7   →  spacing/inset-squish/sm/vertical
spacing/8   →  spacing/stack/md, spacing/inline/md, spacing/inset/sm
spacing/9   →  spacing/inset-squish/md/vertical
spacing/10  (palette 직접 호출만)
spacing/12  →  spacing/inline/lg, spacing/inset/md, spacing/inset-squish/lg/vertical
spacing/14  →  spacing/inset-squish/sm/horizontal
spacing/16  →  spacing/stack/lg, spacing/inset/lg
spacing/20  →  spacing/inset-squish/md/horizontal
spacing/24  →  spacing/stack/xl, spacing/inset/xl, spacing/layout/sm
spacing/28  →  spacing/inset-squish/lg/horizontal
spacing/32  →  spacing/layout/md
spacing/40  →  spacing/layout/lg
spacing/44  (palette 직접 호출만)
spacing/48  →  spacing/layout/xl
```

---

## 4. 규칙 준수 확인

| 규칙 | 충족 |
|---|:--:|
| 5 카테고리 (stack/inline/inset/inset-squish/layout) 사용 | ✅ |
| 모든 semantic 의 aliasOf 가 palette 1개 정확히 지칭 | ✅ (26 토큰 전부) |
| 컴포넌트별 시맨틱 (`component-button` 등) 만들지 않음 | ✅ |
| 이름 규칙 `spacing/{category}/{role}` | ✅ |

---

## 5. Sem-mismatch 처리 (Phase 1-C 인계)

- `Spacing/Button/hor` (Figma 16) vs 코드 `buttonPaddingHorizontal=8`: 본 시맨틱에서는 `spacing/inset-squish/md/horizontal = 20`(Button Medium) / `spacing/inset-squish/sm/horizontal = 14` (Button Small) 페어로 정리. 기존 코드의 `space8` 는 작은 Icon Button 등 별도 패턴.
- `Spacing/Button/ver` (Figma 14) vs 코드 `buttonPaddingVertical=12`: `spacing/inset-squish/md/vertical = 9` / `spacing/inset-squish/lg/vertical = 12` 페어로 정리.

