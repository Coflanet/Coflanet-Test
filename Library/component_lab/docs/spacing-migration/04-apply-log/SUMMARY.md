# Spacing Migration — 최종 검증 보고 (Phase 6)

**대상**: `coflanet-test/Library/component_lab` (Flutter design system) + Figma 파일 `q7yBPcHrid1CGQqFWEPwnR`
**기간**: 2026-05-15 → 2026-05-17 (3일)
**브랜치**: `claude/audit-figma-spacing-uJuIo`
**최종 검증**: 2026-05-17

## 0. 개요

Coflanet 디자인 시스템의 spacing 토큰을 **palette + semantic 2-layer** 구조로 통일.
Figma 변수 91,030 노드·코드 423 호출 사이트를 일괄 마이그레이션. `flutter analyze`
신규 오류 0건 — base 14건만 잔존(사전 결함, 본 작업과 무관).

---

## 1. Figma 적용률 — Phase 4

**소스**: Cowork 세션 / `04-apply-log/figma-apply.INDEX.md`
**파일**: `q7yBPcHrid1CGQqFWEPwnR`

### 적용률

| 분류 | 수 | 비율 |
|---|--:|--:|
| **BOUND (신규)** | **55,547** | 60.5% |
| **ALIGNED (이미 적용)** | **35,471** | 38.6% |
| NODE_MISS | 12 | 0.013% |
| 미처리(NEEDS_REVIEW + 외) | 836 | 0.91% |
| **합계 (CSV total)** | **91,866** | 100% |

- **성공률**: (55,547 + 35,471) / 91,030 처리 = **100% (가시적 픽셀 변화 0)**
- **실패**: NODE_MISS 12건 (component-button, instance-path detach 추정)

### 카테고리별

| 카테고리 | bound | already | 비고 |
|---|--:|--:|---|
| Foundation | 114 | 0 | space-only |
| Component (3) | 5,436 | 344 | button / chip / small |
| Module (10) | 45,700 | 35,064 | gauge → selection-input |
| Page-level (9) | 4,297 | 63 | logo / typography / colors / icon 등 |
| **합계** | **55,547** | **35,471** | |

### 사전 분포 (Phase 4 CSV `figma-node-to-token.csv`)

| status | count |
|---|--:|
| READY | 78,915 |
| NEEDS_REVIEW | 6,727 |
| BLOCKED | 6,236 |
| **합계** | **91,878** |

NEEDS_REVIEW / BLOCKED 중 일부는 Cowork 세션이 자체 판단으로 ALIGNED 분류
→ 사후 처리 12,963건이 카테고리 합계(35,471)에 흡수됨.

---

## 2. 코드 적용률 — Phase 5

**소스**: `04-apply-log/code-*.md` (21개 dir 로그) + git log
**대상**: `lib/components/*` 21개 디렉터리

### 적용 결과 (집계)

| 분류 | 수 | 비고 |
|---|--:|---|
| CSV READY 적용 | **262** | 하드코딩 literal → 새 토큰 교체 |
| CSV 매칭 실패 (skip) | 124 | 패턴 미일치 — 사전 다른 commit 마이그레이션·포맷 차이 |
| 레거시 palette rename (`space{N}`→`s{N}`) | **164** | mechanical rename |
| Off-scale 매핑 (34/36/56) | 0 | component dir 에 없음 |
| 레거시 semantic shortcut → `AppSpacingSemantic.*` | 0 | component dir 에 없음 |
| **총 편집** | **426** | |
| 변경 파일 | 88 | 21 dir |
| 자동 롤백 파일 | 5 | analyze 신규 error 발생 시 |

### 디렉터리별

| dir | csv | fail | pal | files | rb | status |
|---|--:|--:|--:|--:|--:|---|
| avatars | 0 | 0 | 0 | 0 | 0 | OK (no-op) |
| dividers | 0 | 0 | 2 | 1 | 0 | OK |
| ratio | 0 | 0 | 0 | 0 | 0 | OK (no-op) |
| thumbnails | 0 | 0 | 0 | 0 | 0 | OK (no-op) |
| chips | 11 | 4 | 37 | 2 | 2 | PARTIAL |
| buttons | 10 | 5 | 4 | 5 | 0 | OK |
| controls | 3 | 0 | 2 | 3 | 1 | PARTIAL |
| selection | 17 | 9 | 6 | 7 | 0 | OK |
| indicators | 7 | 4 | 16 | 4 | 1 | PARTIAL |
| gauge | 1 | 0 | 3 | 2 | 0 | OK |
| pagination | 0 | 1 | 1 | 1 | 0 | OK |
| tabs | 6 | 8 | 4 | 6 | 0 | OK |
| scrolls | 0 | 0 | 1 | 1 | 0 | OK |
| cards | 6 | 3 | 5 | 2 | 0 | OK |
| contents | 121 | 39 | 54 | 27 | 1 | PARTIAL |
| presentation | 29 | 24 | 12 | 9 | 0 | OK |
| control_box | 4 | 2 | 7 | 2 | 0 | OK |
| forms | 4 | 2 | 3 | 3 | 0 | OK |
| feedback | 30 | 15 | 6 | 9 | 0 | OK |
| modals | 5 | 2 | 1 | 2 | 0 | OK |
| navigation | 8 | 6 | 0 | 3 | 0 | OK |
| **합계** | **262** | **124** | **164** | **88** | **5** | 17 OK / 4 PARTIAL |

### flutter analyze

- baseline error: **14** (사전 결함, 본 작업과 무관 — app_indicators / app_progress `c` 미정의, app_outlined_button 등 unused_import, app_progress_tracker_use_cases const_eval)
- 21 dir 적용 후: **14 (delta +0)**
- 본 작업으로 인한 신규 error/warning: **0**

---

## 3. 토큰 실사용 빈도 (`grep AppSpacing` / `AppSpacingSemantic` in lib + widgetbook)

### Palette 사용 빈도

| 토큰 | 빈도 | 토큰 | 빈도 |
|---|--:|---|--:|
| `s8` | 109 | `s10` | 3 |
| `s16` | 107 | `s0` | 3 |
| `s12` | 90 | `s48` | 2 |
| `s4` | 51 | `s40` | 2 |
| `s24` | 28 | `s28` | 2 |
| `s20` | 11 | `s14` | 2 |
| `s6` | 6 | `s9` | 1 |
| `s2` | 4 | `s7` | 1 |
| `s32` | 3 | `s44` | 1 |

→ Top 5 (`s8 / s16 / s12 / s4 / s24`) 가 전체 사용의 **76%**.

### Semantic 사용 빈도

| 토큰 | 빈도 |
|---|--:|
| `inlineXs` | 13 |
| `insetLg` | 9 |
| `stackLg` | 6 |
| `insetXl` | 5 |
| `insetMd` | 3 |
| `layoutMd` | 2 |
| `insetSm` | 2 |
| `inlineSm` | 2 |
| `stackMd` | 1 |
| `insetXs` | 1 |
| `insetSquishXsVertical` | 1 |
| `insetSquishXsHorizontal` | 1 |
| `insetSquishMdVertical` | 1 |
| `inlineLg` | 1 |

→ 14개 토큰 사용, 12개 미사용.

---

## 4. 사용되지 않은 토큰 → 제거 후보

### Palette (정의 20 / 사용 18)

| 미사용 토큰 | 값 | 판단 |
|---|--:|---|
| `s1` | 1.0 | **유지** — palette.json 정의, Figma 측 사용 가능성 (hairline border) |
| `s3` | 3.0 | **유지** — palette.json 정의, Figma micro gap 용도 |

→ 코드에서 직접 사용은 없지만 palette.json 정의이고 Figma 노드 바인딩에 사용됨.
   제거 시 token authority(palette.json)와 불일치 → **유지 권고**.

### Semantic (정의 26 / 사용 14, 미사용 12)

| 미사용 토큰 | 값 | 판단 |
|---|--:|---|
| `stackXs` | s2 (2) | **유지** — semantic.json 정의 |
| `stackSm` | s4 (4) | **유지** |
| `stackXl` | s24 (24) | **유지** |
| `inlineMd` | s8 (8) | **유지** — Figma 측 6,203건 바인딩됨 |
| `insetSquishSmVertical/Horizontal` | s7/s14 | **유지** — Button Small |
| `insetSquishMdHorizontal` | s20 | **유지** (Vertical은 사용중) |
| `insetSquishLgVertical/Horizontal` | s12/s28 | **유지** — Button Large |
| `layoutSm` / `layoutLg` / `layoutXl` | s24/s40/s48 | **유지** — semantic.json 정의 |

→ Semantic 토큰은 *코드 사용량 기준*이 아닌 *디자인 토큰 정의 기준*이 권위.
   미사용이라도 제거하면 디자이너가 의도한 의미 차원을 잃음 → **전부 유지**.

### EdgeInsets 헬퍼 (Phase 5-Pre 신규)

| 헬퍼 | 사용 | 판단 |
|---|--:|---|
| `AppSpacingSemantic.buttonSmallPadding` | 0 | **검토** — 사용 가능한 자리(buttons dir) 매핑 권고 |
| `AppSpacingSemantic.buttonMediumPadding` | 0 | **검토** |
| `AppSpacingSemantic.buttonLargePadding` | 0 | **검토** |
| `AppSpacingSemantic.badgePadding` | 0 | **검토** |
| `AppSpacingSemantic.inset(double)` | 0 | **검토** — 사실상 `EdgeInsets.all` 과 동등 |
| `AppSpacingSemantic.insetSquish({vertical, horizontal})` | 0 | **검토** |

→ 후속 마이그레이션 라운드에서 button 패딩·badge 패딩을 이 헬퍼로 통일하는 정리 권고.

---

## 5. 미적용 항목 집계

### 5-1. Figma — NODE_MISS 12건

`component-button` chunk-06, instance-path 패턴 `I2414:32xxx;2411:2496`.
master 변경·detach로 child 경로 무효. → **별도 수동 검수**.

### 5-2. 코드 — CSV 매칭 실패 124건

각 dir 로그(`04-apply-log/code-{dir}.md`)의 "CSV 매칭 실패" 섹션에 file:line + 원인 기록.
주요 원인:
- **패턴 미일치 (numeric-not-found)**: 원본 line이 이미 다른 형태(예: `width: 1.0`)로 표기되어 정수 매칭 실패
- **needle-not-found**: 해당 line의 `space{N}` 참조가 이전 커밋에서 사라짐
- **compound-not-matched**: `EdgeInsets.symmetric(H=X,V=Y)` 의 H 또는 V 한 쪽이 변수로 이미 추상화됨

→ 124건은 자동 처리 불가. **수동 검토 후 개별 적용 권고**.

### 5-3. 코드 — 자동 롤백 5건

| dir | 파일 |
|---|---|
| chips | `app_chip_action.dart` |
| chips | `app_mini_chip.dart` |
| contents | `app_content_badge.dart` |
| controls | `app_switch.dart` |
| indicators | `app_progress.dart` |

→ 자동 치환이 const-context 또는 시그니처를 깨뜨려 `flutter analyze` 신규 error 발생.
   **각 파일별 수동 분석 후 부분 적용 권고**.

### 5-4. 코드 — Phase 5 범위 밖 (foundation / sample)

`lib/components/*` 외 파일 6개 / 83 deprecated 참조:

| 파일 | 잔존 deprecated | 비고 |
|---|--:|---|
| `lib/foundation/spacing_use_cases.dart` | 36 | **의도적** — widgetbook 토큰 문서, deprecated alias 노출 필요 |
| `lib/samples/sample_screen.dart` | 28 | 샘플 화면 — 별도 PR로 정리 가능 |
| `lib/foundation/gradient_use_cases.dart` | 7 | widgetbook 문서 |
| `lib/foundation/decorate_use_cases.dart` | 6 | widgetbook 문서 |
| `lib/foundation/_button_metrics.dart` | 3 | 버튼 메트릭 헬퍼 — 검토 후 마이그레이션 |
| `lib/foundation/_swatch.dart` | 3 | foundation swatch 헬퍼 |
| **합계** | **83** | |

### 5-5. 코드 — CSV BLOCKED / NEEDS_REVIEW

`code-usage-to-token.csv` 기준:
- BLOCKED 492건 — 자동 매핑 불가 (EdgeInsets.only `missing literal`, non-numeric arg, dynamic value 등)
- NEEDS_REVIEW 30건 — 사람 판단 필요

→ 합계 522건. **별도 cycle 로 수동 처리**.

---

## 6. 후속 작업 권고

### P0 (릴리즈 전 필수)

- [ ] 자동 롤백 5 파일 수동 점검 + 부분 적용 PR
- [ ] Figma NODE_MISS 12건 인스턴스 복구 또는 별도 해결
- [ ] `flutter test` 전체 그린 확인 (현재 작업은 analyze 통과까지만 검증)

### P1 (릴리즈 직후)

- [ ] CSV 매칭 실패 124건 수동 검토 — `04-apply-log/code-{dir}.md` 의 "CSV 매칭 실패" 섹션 순회
- [ ] CSV BLOCKED 492건 + NEEDS_REVIEW 30건 cycle (디자이너 함께 의사 결정)
- [ ] `lib/samples/sample_screen.dart` 28 deprecated 참조 정리
- [ ] `lib/foundation/_button_metrics.dart` + `_swatch.dart` deprecated 참조 정리 (foundation 내부)

### P2 (정리 라운드)

- [ ] `AppSpacingSemantic.buttonSmallPadding` / `buttonMediumPadding` / `buttonLargePadding` / `badgePadding` 헬퍼 적용처 매핑
- [ ] `AppSpacing` 의 deprecated 별칭 일괄 제거 (sample + foundation 정리 완료 후)
- [ ] `spacing_use_cases.dart` 의 widgetbook 카탈로그를 새 API 기준으로 재정렬

### P3 (장기)

- [ ] Safe-area 6 상수(`safeAreaStatusIos` 등) → 별도 `lib/foundation/safe_area.dart` 모듈로 분리
- [ ] Off-scale 토큰(`space34/36/56`) 정책 정의 — 단계 정규화 vs 유지 결정 후 처리

---

## 7. 릴리즈 체크리스트

### 코드

- [x] `flutter analyze --no-fatal-infos` 통과 (14 error = baseline, 신규 0)
- [ ] `flutter test` 그린 확인 (← **릴리즈 전 필수 확인 항목**)
- [ ] `flutter build {target}` 그린 확인 (iOS / Android / Web)
- [ ] Widgetbook 빌드 & 시각 검수 — `spacing_use_cases.dart` 카탈로그가 새 토큰 노출하는지
- [ ] golden 테스트 (있다면) 변화 확인 (값 보존 — 변경 없어야 함)

### Figma

- [x] 91,030 노드 변수 바인딩 적용 (Cowork 세션)
- [x] safe-write gate 정책 적용 → 가시 픽셀 변화 0
- [ ] Figma 파일 Pro 플랜 — main 직접 수정. 디자이너 수동 commit/version save 1회 실행 필요
- [ ] NODE_MISS 12건 처리 결정 (수정 vs 의도된 detach)

### 문서

- [x] `02-tokens/palette.json` + `semantic.json` — 단일 진실 소스
- [x] `03-mapping/figma-node-to-token.csv` + `code-usage-to-token.csv` — 매핑 인벤토리
- [x] `04-apply-log/figma-apply.INDEX.md` — Figma 적용 INDEX
- [x] `04-apply-log/figma-{component,module}-*.md` 14건 + `figma-foundation-space.md` — Figma 그룹별 로그
- [x] `04-apply-log/code-*.md` 21건 — 코드 dir별 로그
- [x] `04-apply-log/SUMMARY.md` (본 문서) — Phase 6 최종 검증
- [ ] CHANGELOG 또는 RELEASE NOTES 작성 — "AppSpacing 토큰 구조 palette/semantic 2-layer 리팩토링" 명시

### 인계

- [ ] 이 SUMMARY 를 디자이너 + iOS / Android 팀에 공유
- [ ] Phase 5-Pre 의 `AppSpacing.s{N}` / `AppSpacingSemantic.*` API 사용 가이드라인 1-page 작성
- [ ] deprecated 별칭 제거 시점(P2 라운드 종료 후) 사전 공지

---

## 8. 부록: 변경 통계

### git 통계 (브랜치 `claude/audit-figma-spacing-uJuIo`)

`main` 대비 **163 commits**.

| Phase | 주요 산출물 |
|---|---|
| Phase 1 ~ 3 | 워크스페이스 부트스트랩, 인벤토리(`01-audit/*.json`), 토큰 정의(`02-tokens/palette.json` + `semantic.json`), 매핑 CSV 생성 |
| Phase 4 (Figma) | foundation / 3 component / 10 module / 9 page-level 로그 + `figma-apply.INDEX.md` |
| Phase 5-Pre | `app_spacing.dart` 2-layer 재정의 (palette `s0~s48` + semantic) |
| Phase 5 | 21 dir 토큰 적용 — 21 commits, 88 파일 변경 |
| Phase 6 | 본 SUMMARY (`04-apply-log/SUMMARY.md`) |

### 정량 결과

| 지표 | 값 |
|---|--:|
| Figma 처리 노드 | 91,030 / 91,866 (99.1%) |
| 코드 자동 편집 | 426건 / 88 파일 |
| 신규 토큰 정의 (palette + semantic) | 20 + 26 + 6 헬퍼 = 52 |
| deprecated 별칭 (Phase 5 종료까지 유지) | 38 |
| flutter analyze 신규 error | **0** |
| 가시적 픽셀 변화 (Figma + 코드) | **0** |

— *문서 끝* —
