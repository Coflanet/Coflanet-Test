# Spacing 토큰 사용 가이드 — 디자이너 핵심 문서

**버전**: `1.0.0-pending-1a2` — Phase 1-A-2 (`layoutMode` 사이드카) 완료 후 §2-1/§2-2 의 stack/inline 예시 빈도가 실제 분포로 재검증되면 v1.0 으로 승격.
**대상**: 디자이너 + 프론트엔드 + 바이브 코딩 컨텍스트.
**입력**: `palette.json` (20 토큰), `semantic.json` (5 카테고리).
**Figma 파일**: [📚 Library — fileKey q7yBPcHrid1CGQqFWEPwnR](https://www.figma.com/design/q7yBPcHrid1CGQqFWEPwnR)

---

## 1. 의사결정 트리

```
spacing 이 필요해?
├─ 컨테이너 안 4방향 패딩이야?
│  ├─ 4방향 동일 → spacing/inset/{xs..xl}
│  └─ 수평>수직 (Button 패턴) → spacing/inset-squish/{xs,sm,md,lg}
├─ 컴포넌트 사이 세로 간격? → spacing/stack/{xs..xl}
├─ 가로로 나란히 (icon-text, chip group)? → spacing/inline/{xs..lg}
├─ 페이지/섹션 레벨 큰 간격? → spacing/layout/{sm..xl}
└─ 컴포넌트 고유 보정 (Outlined 1px, Icon Button 6/7 등) → palette 직접
```

---

## 2. 토큰별 1줄 가이드

> Figma 노드 deep-link 표기: `https://www.figma.com/design/q7yBPcHrid1CGQqFWEPwnR?node-id={pageId-with-:replaced-by-dash}`. 노드 단위 적용 링크는 Phase 4 적용 로그(`04-apply-log/`) 에서 확정.

### 2-1. `stack` (세로 간격)

Figma 대표 페이지: [📑 Contents (Card 그리드)](https://www.figma.com/design/q7yBPcHrid1CGQqFWEPwnR?node-id=2573-404660), [📐 Space (Spec)](https://www.figma.com/design/q7yBPcHrid1CGQqFWEPwnR?node-id=2485-8842)

- `spacing/stack/xs` = **2px** — Label–Value, 같은 형식 텍스트 한 묶음
  시각: ▢ Item  ↕2px↕  ▢ Item
- `spacing/stack/sm` = **4px** — Heading–Description 짝 간격
  시각: ▢ Item  ↕4px↕  ▢ Item
- `spacing/stack/md` = **8px** — List 아이템 사이 (검색 결과, 메뉴)
  시각: ▢ Item  ↕8px↕  ▢ Item
- `spacing/stack/lg` = **16px** — Card 사이, Heading–Body 분리
  시각: ▢ Item  ↕16px↕  ▢ Item
- `spacing/stack/xl` = **24px** — Section 간 분리 (페이지 안 큰 블록)
  시각: ▢ Item  ↕24px↕  ▢ Item

### 2-2. `inline` (가로 간격)

Figma 대표 페이지: [🍪 Chip](https://www.figma.com/design/q7yBPcHrid1CGQqFWEPwnR?node-id=2546-166598), [⏹️ Button](https://www.figma.com/design/q7yBPcHrid1CGQqFWEPwnR?node-id=2414-32026)

- `spacing/inline/xs` = **2px** — tag 안의 미세 간격
  시각: 🔘 ←2px→ Text
- `spacing/inline/sm` = **4px** — Icon ↔ 텍스트 표준 (Chip, Button 안)
  시각: 🔘 ←4px→ Text
- `spacing/inline/md` = **8px** — Button group, Chip group 사이
  시각: 🔘 ←8px→ Text
- `spacing/inline/lg` = **12px** — Section 안 큰 가로 간격
  시각: 🔘 ←12px→ Text

### 2-3. `inset` (4방향 동일 패딩)

Figma 대표 페이지: [⏹️ Button (Icon Button)](https://www.figma.com/design/q7yBPcHrid1CGQqFWEPwnR?node-id=2414-32026), [📑 Contents (Card)](https://www.figma.com/design/q7yBPcHrid1CGQqFWEPwnR?node-id=2573-404660), [📣 Presentation (Modal)](https://www.figma.com/design/q7yBPcHrid1CGQqFWEPwnR?node-id=2546-42535)

- `spacing/inset/xs` = **4px** — Tag / Badge 안쪽 (4×4)
- `spacing/inset/sm` = **8px** — 작은 컨테이너 (Tooltip, mini Chip)
- `spacing/inset/md` = **12px** — Icon Button 표준 (12×12)
- `spacing/inset/lg` = **16px** — FAB / Card 표준 (16×16)
- `spacing/inset/xl` = **24px** — Modal 안쪽 (24×24)

### 2-4. `inset-squish` (수평>수직 페어)

Figma 대표 페이지: [⏹️ Button](https://www.figma.com/design/q7yBPcHrid1CGQqFWEPwnR?node-id=2414-32026), [🍪 Chip (Badge)](https://www.figma.com/design/q7yBPcHrid1CGQqFWEPwnR?node-id=2546-166598)

- `spacing/inset-squish/xs` = V**2**px / H**6**px — Badge (V=2, H=6) — 글자 짧게
  Dart: `AppSpacingSemantic.insetSquishXsVertical` + `insetSquishXsHorizontal`
- `spacing/inset-squish/sm` = V**7**px / H**14**px — Button Small (V=7, H=14)
  Dart: `AppSpacingSemantic.insetSquishSmVertical` + `insetSquishSmHorizontal`
- `spacing/inset-squish/md` = V**9**px / H**20**px — Button Medium (V=9, H=20) — 기본
  Dart: `AppSpacingSemantic.insetSquishMdVertical` + `insetSquishMdHorizontal`
- `spacing/inset-squish/lg` = V**12**px / H**28**px — Button Large (V=12, H=28)
  Dart: `AppSpacingSemantic.insetSquishLgVertical` + `insetSquishLgHorizontal`

### 2-5. `layout` (페이지 레벨)

Figma 대표 페이지: [📐 Space (Spec)](https://www.figma.com/design/q7yBPcHrid1CGQqFWEPwnR?node-id=2485-8842), [📑 Contents](https://www.figma.com/design/q7yBPcHrid1CGQqFWEPwnR?node-id=2573-404660)

- `spacing/layout/sm` = **24px** — Section 간격 (24px)
- `spacing/layout/md` = **32px** — Page 큰 섹션 사이 (32px)
- `spacing/layout/lg` = **40px** — App bar 아래, 페이지 시작 여백 (40px)
- `spacing/layout/xl` = **48px** — 랜딩/온보딩 페이지 큰 여백 (48px)

---

## 3. 토큰 사용 우선순위

1순위 **시맨틱 토큰** — 의도가 명확하면 무조건 시맨틱 (`spacing/inset/lg` 등).
2순위 **Palette 직접** — 시맨틱이 안 맞을 때만 (Outlined 1px 보정, Icon Button 6/7 등).
3순위 **컴포넌트 고유 const** — Section Bottom Solid Button 의 28/12 등 컴포넌트 안에서만 쓰는 패턴은 .dart 파일 안 `const` 로.
⛔ **임의 숫자 직접 입력 금지** — `EdgeInsets.all(17)` 같은 off-scale 리터럴.

---

## 4. FAQ

**Q. Card padding 을 늘리고 싶어요.**
A. `spacing/inset/lg` 의 alias 값을 변경하면 됩니다. 단, 같은 토큰을 쓰는 다른 컨테이너(FAB 등)도 함께 영향받습니다. 별도 변경이 필요하면 새 `role` (예: `xxl`) 을 추가하세요.

**Q. Button 만 통통하게.**
A. `spacing/inset-squish/lg` (V=12, H=28) 를 변경하면 Solid Button Large 가 다 변경됩니다. Outlined 1px 보정은 별도이므로 컴포넌트 안 상수로 처리.

**Q. 새 컴포넌트 만들 때 어느 토큰을 써야 하나요?**
A. 비슷한 의도의 기존 컴포넌트가 쓰는 시맨틱 토큰을 그대로 사용하세요. 의도 토큰 이름 = AI/디자이너가 의도를 추론하는 메타데이터.

**Q. Figma 변수 어디에 등록?**
A. Library 파일의 `Spacing` 컬렉션에 slash 구조로 그대로 등록.
```
Spacing/Palette/0..48        ← palette.json 매핑
Spacing/Semantic/Stack/Md    ← semantic.json/stack/md
Spacing/Semantic/Inset-Squish/Md/Vertical
Spacing/Semantic/Inset-Squish/Md/Horizontal
```
각 변수에 description 추가 (`Card padding 표준 - lg=16px` 등).

---

## 5. 바이브 코딩 컨텍스트

시맨틱 토큰 이름 = AI 가 디자인 의도를 추론하는 메타데이터입니다.

- `spacing/inset/lg` 라는 이름은 "보통 카드 안쪽 padding" 이라는 의도를 AI 에게 직접 전달함.
- 임의 숫자 (16) 만 쓰면 AI 는 "16 은 왜 16?" 을 매번 추론해야 함.
- 시맨틱 토큰을 일관되게 쓰면, 새로운 컴포넌트에 AI 가 알아서 같은 토큰을 적용함.

---

## 6. Figma → 코드 동기화 체크리스트

- [ ] Figma `Spacing/Palette/{value}` 20개 등록 (palette.json 1:1)
- [ ] Figma `Spacing/Semantic/{Category}/{Role}` 등록 (semantic.json 1:1)
- [ ] 모든 컴포넌트 인스턴스의 padding/itemSpacing 을 변수 alias 로 전환 (Phase 4 적용)
- [ ] 코드 `AppSpacing` / `AppSpacingSemantic` 클래스 재구성 (Phase 5-Pre)
- [ ] `*_use_cases.dart` 외 모든 컴포넌트에서 임의 숫자 제거 (Phase 5)
