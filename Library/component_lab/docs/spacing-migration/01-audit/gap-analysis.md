# Phase 1-C — Figma ↔ 코드 스페이싱 갭 분석

**브랜치**: `claude/spacing-gap-analysis-sy4an`
**입력**:
- Figma 측: `01-audit/figma-pages.json` (27 audit 페이지 인벤토리) + `phase-1-a-result.md §4-2` 의 `Semantic.Spacing/*` 변수 마스터 테이블 (Figma Plugin API 직접 검증)
- 코드 측: `01-audit/code-audit.INDEX.json` (`_aggregate` 블록, 21 디렉터리 집계) + `code-token-defs.foundation.json` (팔레트/시맨틱 정의) + 디렉터리별 `code-hardcoded-usages.*.json` 22 파일

**처리 방식**:
- Raw 파일은 한 번에 1개씩 열어 빈도를 누적 후 닫음 (메모리 누적)
- 22 raw 파일 → 927 usage entry 통합 검증 (`literal` + `expression-with-literal.embeddedLiterals` 합산이 INDEX `_aggregate.topValueFrequency` 와 정합)

> ⚠️ **`figma-spacing.INDEX.json` 부재**: 본 저장소에는 페이지별 Figma raw spacing 분포 파일이 없음. Figma 측 globalValueFrequency 는 (a) Library 파일의 `Semantic.Spacing/*` 변수 정의(Phase 1-A §4-2) 와 (b) 📐 Space 페이지(`2485:8842`) 구조에서 도출. 페이지 단위 *사용* 빈도는 수집 불가 — Phase 1-D 인계.

---

## 1. 요약 통계

| 항목 | Figma (변수 정의) | 코드 (실제 사용) |
|---|---:|---:|
| Spacing 팔레트 정의 값 수 | 10 | 13 |
| 팔레트 값 집합 | 4, 8, 12, 14, 16, 20, 24, 32, 40, 48 | 4, 8, 12, 14, 16, 20, 24, 32, 34, 36, 40, 44, 48 |
| 시맨틱 토큰 수 | 5 | 20 |
| 감사 단위 수 | 27 페이지 | 21 디렉터리 / 119 파일 |
| 총 spacing 사용처 | n/a (페이지별 raw 미수집) | 927 |
| 토큰 참조 사용 | n/a | 702 (`space16` 214, `space8` 185, `space12` 145, `space4` 88, `space24` 52, `space20` 18) |
| 하드코드 리터럴 사용 | n/a | 225 (off-scale 80 + on-scale palette literal 145) |
| 노트마커 의심 항목 | n/a | **0** (`임시│TODO│tmp│fix` 마커 raw 검색 결과) |
| Off-scale 의심 항목 | n/a | 81 건 (14/21 디렉터리) |

### 1-1. Figma ↔ 코드 팔레트 합집합

- ✅ **양쪽 일치**: 4, 8, 12, 14, 16, 20, 24, 32, 40, 48 — 10 값
- 🟡 **코드 단독**: 34, 36, 44 — 전부 디바이스 Safe Area 상수 (iOS 노치 / Android 상태바). Figma 측은 사람-디바이스 상수로 처리.
- 🔴 **Figma 단독**: 없음

### 1-2. 시맨틱 매핑 1차 점검 (Phase 1-A §4-2 ↔ `app_spacing.dart`)

| Figma 변수 | Figma 값 | 코드 `AppSpacing.*` | 코드 resolvedValue | 일치? |
|---|---:|---|---:|:--:|
| Spacing/4 | 4 | `space4` | 4 | ✅ |
| Spacing/8 | 8 | `space8` | 8 | ✅ |
| Spacing/12 | 12 | `space12` | 12 | ✅ |
| Spacing/16 | 16 | `space16` | 16 | ✅ |
| Spacing/20 | 20 | `space20` | 20 | ✅ |
| Spacing/24 | 24 | `space24` | 24 | ✅ |
| Spacing/32 | 32 | `space32` | 32 | ✅ |
| Spacing/40 | 40 | `space40` | 40 | ✅ |
| Spacing/48 | 48 | `space48` | 48 | ✅ |
| Spacing/Button/hor | 16 | `buttonPaddingHorizontal → space8` | **8** | ❌ |
| Spacing/Button/ver | 14 | `buttonPaddingVertical → space12` | **12** | ❌ |
| Spacing/List/Card/Large | 12 | `itemSpacing → space12` | 12 | ✅ |
| Spacing/Padding/Box in Box | 16 | `paddingBoxInBox → space16` | 16 | ✅ |
| Spacing/Padding/Contents in Box | 24 | `paddingContentsInBox → space24` | 24 | ✅ |

> Button 패딩 두 건은 **시맨틱 충돌**. Phase 1-A §4-2 가 Figma description 을 그대로 옮긴 값이며, 코드는 코드대로 다른 토큰을 가리킴. 실제 Figma 컴포넌트 인스턴스 패딩 값으로 어느 쪽이 SoT 인지 결정 필요 — Phase 1-D 안건.

---

## 2. 값 분포 히스토그램 (Figma 변수 vs 코드 사용)

코드 측 막대는 토큰 참조 + 하드코드 리터럴(임베디드 포함) 합산. Figma 측은 변수 존재 여부 마크 — 페이지별 사용 빈도는 입력 데이터에 없음.

```
값      Figma 코드 사용량                                                       비고
0       ○                                                                  ░░ 12  zero padding (토큰 없음)
1       ○     █                                                            ░  3   hairline
2       ○     █████████                                                    ░ 24   ★ off-scale 최다
3       ○     █                                                            ░  4
4       ●     █████████████████████████████████████                        █ 96   ★ palette
6       ○     ███████                                                      ░ 18   ★ off-scale 2위
8       ●     ████████████████████████████████████████████████████████████████████████ █ 199 ★ palette
9       ○                                                                  ░  1
10      ○     ██                                                           ░  5
11      ○                                                                  ░  1
12      ●     █████████████████████████████████████████████████████████████ █ 164 ★ palette
14      ●     —                                                            (Safe Area, 사용처 0)
16      ●     ██████████████████████████████████████████████████████████████████████████ █ 233 ★ palette · 최빈
18      ○                                                                  ░  2
20      ●     ████████                                                     █ 21   palette
22      ○     █                                                            ░  3
24      ●     ████████████████████████████████                              █ 88   palette · 리터럴 36회 (토큰화 누락 다수)
28      ○     █                                                            ░  4
32      ●     ██                                                           █ 5    palette · ref 0/literal 전량
34      ○*    —                                                            코드 팔레트 only (iOS Safe Area Bottom)
36      ○*    —                                                            코드 팔레트 only (Android Safe Area Status)
40      ●     █                                                            █ 2    palette · ref 0
44      ○*    —                                                            코드 팔레트 only (iOS Safe Area Status)
48      ●     ██                                                           █ 5    palette · ref 0/literal 전량
56      ○     █                                                            ░  2
80      ○                                                                  ░  1
112     ○                                                                  ░  1
120     ○     █                                                            ░  4   dimension 후보
128     ○                                                                  ░  2
200     ○     █                                                            ░  3
240     ○                                                                  ░  1
280     ○     █                                                            ░  3   dimension 후보
300     ○                                                                  ░  1
320     ○                                                                  ░  2
```

범례: `●` 양쪽 매치 | `○` Figma 미정의 | `○*` 코드 팔레트 단독 | `█` 팔레트 매치 사용 | `░` off-scale 리터럴

---

## 3. 불일치 표

차이유형 정의:
- `P-only` = Figma 팔레트 단독
- `C-only` = 코드 팔레트 단독
- `Off-scale` = 어느 팔레트에도 없으나 코드 리터럴 사용
- `Sem-mismatch` = 같은 시맨틱 토큰이 양쪽에서 다른 숫자값

| Value | Figma | 코드 (팔레트/사용) | 차이유형 | 비고 |
|---:|---|---|---|---|
| 0   | 정의없음 | 리터럴 12회 | Off-scale | zero padding 명시 의도. `space0=0` 토큰 추가 검토 |
| 1   | 정의없음 | 리터럴 3회 | Off-scale | hairline. `BorderSide` 로 치환 권장 |
| 2   | 정의없음 | **리터럴 24회 ★** | Off-scale | **off-scale 최다**. SizedBox(h:2)/gap:2 등 미세 보정 — chip/contents/cards 광범위 |
| 3   | 정의없음 | 리터럴 4회 | Off-scale | chip gap / pagination padding — 4 통합 가능 |
| 6   | 정의없음 | **리터럴 18회 ★** | Off-scale | chip/banner/preference — 4 또는 8 통합 검토 |
| 9   | 정의없음 | 리터럴 1회 | Off-scale | empty_state vertical — 8 통합 |
| 10  | 정의없음 | 리터럴 5회 | Off-scale | bottom button / mini chip / top nav — 8 또는 12 통합 |
| 11  | 정의없음 | 리터럴 1회 | Off-scale | bottom button vertical — 12 통합 |
| 18  | 정의없음 | 리터럴 2회 | Off-scale | auto_complete SizedBox — 16 또는 20 통합 |
| 22  | 정의없음 | 리터럴 3회 | Off-scale | section_message — 24 통합 |
| 28  | 정의없음 | 리터럴 4회 | Off-scale | bottom button horizontal / gnb logo — 24 또는 32 통합, 또는 `space28` 신규 |
| 34  | 정의없음 | 팔레트 ● (사용 0) | C-only | iOS Safe Area Bottom — Figma 변수화 검토 또는 `AppDeviceMetrics` 이관 |
| 36  | 정의없음 | 팔레트 ● (사용 0) | C-only | Android Safe Area Status — 동상 |
| 44  | 정의없음 | 팔레트 ● (사용 0) | C-only | iOS Safe Area Status — 동상 |
| 56  | 정의없음 | 리터럴 2회 | Off-scale | banner — 48 통합 또는 신규 |
| 80  | 정의없음 | 리터럴 1회 | Off-scale | feedback — 단발 |
| 112 | 정의없음 | 리터럴 1회 | Off-scale | item_list — Dimension(고정 크기)으로 분류 |
| 120 | 정의없음 | 리터럴 4회 | Off-scale | thumbnail use_cases — Dimension 후보 (`thumbnail.lg=120`) |
| 128 | 정의없음 | 리터럴 2회 | Off-scale | empty_state visual — Dimension 후보 |
| 200 | 정의없음 | 리터럴 3회 | Off-scale | indicator/ratio/banner — Dimension 데모 |
| 240 | 정의없음 | 리터럴 1회 | Off-scale | banner_use_cases — 데모용 |
| 280 | 정의없음 | 리터럴 3회 | Off-scale | date/time picker / ratio — Dimension 후보 (`picker.md=280`) |
| 300 | 정의없음 | 리터럴 1회 | Off-scale | select use_cases — 데모용 |
| 320 | 정의없음 | 리터럴 2회 | Off-scale | scroll/banner — Dimension 데모 |
| **Spacing/Button/hor = 16** | 16 | `space8 = 8` | **Sem-mismatch** | Figma description 과 코드 정의 충돌. 컴포넌트 인스턴스 실제값 재검증 필요 |
| **Spacing/Button/ver = 14** | 14 | `space12 = 12` | **Sem-mismatch** | 동상 |

---

## 4. 사용 빈도 Top 20 (코드)

토큰 참조 + 하드코드 리터럴(임베디드 포함) 합산 기준. Figma 팔레트 매치 여부 표기.

| 순위 | Value | Token Ref | Literal | 합계 | Figma | 비고 |
|---:|---:|---:|---:|---:|:--:|---|
|  1 | 16  | 214 | 19 | **233** | ● | `space16` — 카드/콘텐츠 기본 패딩, 최빈 |
|  2 | 8   | 185 | 14 | **199** | ● | `space8` — 아이콘-텍스트 갭 |
|  3 | 12  | 145 | 19 | **164** | ● | `space12` — 리스트 아이템 간격 |
|  4 | 4   |  88 |  8 |  **96** | ● | `space4` — 최소 갭 |
|  5 | 24  |  52 | 36 |  **88** | ● | `space24` — 섹션/모달. **리터럴 36건 토큰화 누락** |
|  6 | 2   |   0 | 24 |  **24** | ○ | off-scale 최다 |
|  7 | 20  |  18 |  3 |  **21** | ● | `space20` |
|  8 | 6   |   0 | 18 |  **18** | ○ | off-scale 2위 |
|  9 | 0   |   0 | 12 |  **12** | ○ | zero padding |
| 10 | 32  |   0 |  5 |   **5** | ● | `space32` 정의 ● / 참조 0 → **전량 리터럴** |
| 10 | 48  |   0 |  5 |   **5** | ● | `space48` 동상 |
| 10 | 10  |   0 |  5 |   **5** | ○ | off-scale |
| 13 | 3   |   0 |  4 |   **4** | ○ | off-scale |
| 13 | 28  |   0 |  4 |   **4** | ○ | off-scale |
| 13 | 120 |   0 |  4 |   **4** | ○ | dimension 후보 |
| 16 | 1   |   0 |  3 |   **3** | ○ | hairline |
| 16 | 22  |   0 |  3 |   **3** | ○ | off-scale |
| 16 | 200 |   0 |  3 |   **3** | ○ | dimension 데모 |
| 16 | 280 |   0 |  3 |   **3** | ○ | dimension 후보 |
| 20 | 18  |   0 |  2 |   **2** | ○ | off-scale |
| 20 | 40  |   0 |  2 |   **2** | ● | `space40` 정의 ● / 참조 0 |
| 20 | 56  |   0 |  2 |   **2** | ○ | off-scale |
| 20 | 128 |   0 |  2 |   **2** | ○ | dimension 후보 |
| 20 | 320 |   0 |  2 |   **2** | ○ | dimension 데모 |

> 인사이트: `space32 / space40 / space48` 은 팔레트 정의는 있지만 **AppSpacing 토큰 참조로 사용된 적 0회**. 전부 리터럴. Phase 2 마이그레이션 시 리터럴 → 토큰 단순 치환만으로 진척 가능.

---

## 5. 의심 항목 목록

### 5-1. 노트마커 검색 결과 — **0 건**

`임시 | TODO | tmp | fix` 토큰을 22개 raw `code-hardcoded-usages.*.json` 의 `snippet` / `usages[].*` 필드 전체에서 case-insensitive 검색. **일치 0건**.

> 본 audit raw 데이터에는 "괄호 메모" 필드가 없음 (구조: `{file, line, snippet, values[], kind, contextHint[]}`). 메모 기반 의심 추출이 불가하므로, 대체 기준으로 **off-scale 리터럴 81 건** 을 의심 항목으로 사용 (5-2).

### 5-2. Off-scale 리터럴 — 디렉터리별 의심 81건

| 디렉터리 | 의심 건수 | 대표 값 | 대표 파일 |
|---|---:|---|---|
| contents      | 30 | 2, 6, 56, 112, 200, 240, 320 | `app_banner`, `app_item_list`, `app_review`, `app_preference_list` |
| chips         |  9 | 2, 3, 6, 10 | `app_chip`, `app_chip_action`, `app_mini_chip` |
| feedback      |  8 | 6, 9, 22, 128 | `app_empty_state`, `app_section_message` |
| buttons       |  6 | 6, 10, 11, 28 | `app_section_bottom_button` |
| navigation    |  4 | 10, 28 | `app_gnb_use_cases`, `app_top_navigation` |
| thumbnails    |  4 | 120 | `thumbnail_use_cases` |
| indicators    |  3 | 2, 6, 200 | `app_progress`, `app_progress_tracker`, `indicator_use_cases` |
| selection     |  3 | 280, 300 | `app_date_picker`, `app_time_picker`, `app_select_use_cases` |
| presentation  |  2 | 18 | `app_auto_complete` |
| ratio         |  2 | 200, 280 | `ratio_use_cases` |
| cards         |  1 | 2 | `app_card` |
| control_box   |  1 | 2 | `app_control_box` |
| controls      |  1 | 2 | `app_switch` |
| pagination    |  1 | 3 | `app_pagination` |
| scrolls       |  1 | 320 | `scroll_use_cases` |
| tabs          |  1 | 2 | `app_segmented_control` |
| (avatars/dividers/forms/gauge/modals — 0) | — | — | — |
| **합계**      | **81** |  |  |

### 5-3. 의심 카테고리화

| 카테고리 | 값 | 처리 방향 |
|---|---|---|
| **Micro-gap** | 1, 2, 3 | 빈도 높지만 디자인 의도 약함. 4 로 통합 또는 `BorderSide` 로 표현 |
| **Sub-step** | 6, 9, 10, 11, 18, 22 | 4 배수 인근으로 통합 (6→4/8, 9→8, 10→8/12, 11→12, 18→16/20, 22→24) |
| **Mid-step** | 28, 56 | 4 배수이나 팔레트 미정의. `space28`, `space56` 신규 토큰 후보 |
| **Dimension (고정 크기)** | 80, 112, 120, 128, 200, 240, 280, 300, 320 | Spacing 이 아닌 별도 Dimension 시스템 (썸네일/배너/피커 크기) |
| **Zero** | 0 | `space0=0` 추가 또는 `EdgeInsets.zero` 명시 |

### 5-4. Sem-mismatch — 우선 해결 안건

| 항목 | 위치 | 충돌 |
|---|---|---|
| Button horizontal padding | `lib/foundation/app_spacing.dart:77` (`buttonPaddingHorizontal = space8`) | Figma description 은 16, 코드는 8 — 실제 Figma 컴포넌트 인스턴스값 확인 필요 |
| Button vertical padding | `lib/foundation/app_spacing.dart:78` (`buttonPaddingVertical = space12`) | Figma description 은 14, 코드는 12 — 동상 |

---

## 6. 팔레트 스케일 후보안 (4의 배수 기준)

표기: ★ = 빈도 ≥5 (유지/코어), — = 빈도 <5 (검토), ⊘ = 빈도 <2 (제거 후보).

### 6-1. 4 배수 권장 스케일

| 값 | 빈도 합산 | Figma | 코드 팔레트 | 권고 | 마크 |
|---:|---:|:--:|:--:|---|:--:|
| 0   | 12  | ○ | ○ | **신규** `space0` 추가 (zero padding 명시) | ★ |
| 4   | 96  | ● | ● | **유지** | ★ |
| 8   | 199 | ● | ● | **유지** | ★ |
| 12  | 164 | ● | ● | **유지** | ★ |
| 16  | 233 | ● | ● | **유지** | ★ |
| 20  | 21  | ● | ● | **유지** | ★ |
| 24  | 88  | ● | ● | **유지** | ★ |
| 28  | 4   | ○ | ○ | **신규 검토** (button/gnb 통합) | — |
| 32  | 5   | ● | ● | **유지** (전량 리터럴 → 토큰화 필요) | ★ |
| 36  | 0   | ○ | ● | **이동** → Dimension (Safe Area Status Android) | — |
| 40  | 2   | ● | ● | **유지 (관찰)** 빈도 낮음 주의 | — |
| 44  | 0   | ○ | ● | **이동** → Dimension (Safe Area Status iOS) | — |
| 48  | 5   | ● | ● | **유지** (전량 리터럴 → 토큰화 필요) | ★ |
| 56  | 2   | ○ | ○ | **신규 검토** (banner) | — |

### 6-2. 4 배수가 아닌 현재 팔레트 — 예외

| 값 | 출처 | 처리 |
|---:|---|---|
| 14 | Safe Area Bottom (Android) | Dimension 시스템으로 분리 |
| 34 | Safe Area Bottom (iOS) | Dimension 시스템으로 분리 |

> Safe Area 4종(14, 34, 36, 44) 모두 디바이스 상수. Phase 2 에서 `AppDeviceMetrics` (또는 동등) 로 이관, Spacing 팔레트는 순수 4-배수만 남기는 안 추천.

### 6-3. 제거 후보 (빈도 < 2)

| 값 | 빈도 | 비고 | 마크 |
|---:|---:|---|:--:|
| 9   | 1 | empty_state — 8 통합 | ⊘ |
| 11  | 1 | bottom button — 12 통합 | ⊘ |
| 80  | 1 | feedback 단발 — 제거 | ⊘ |
| 112 | 1 | item_list — Dimension 으로 | ⊘ |
| 240 | 1 | banner_use_cases 데모 — 제거 또는 Dimension | ⊘ |
| 300 | 1 | select_use_cases 데모 — 제거 또는 Dimension | ⊘ |

### 6-4. 최종 권장 Spacing 팔레트 (Phase 2 가이드)

```
★ 코어 (빈도 ≥5, 양쪽 매치):
   space0    0      (신규, zero padding 명시)
   space4    4
   space8    8
   space12   12
   space16   16
   space20   20
   space24   24
   space32   32
   space48   48

· 보조 (빈도 <5, 4 배수, 유지):
   space40   40

· 신규 검토 (off-scale 통합 대상, 4 배수):
   space28   28   (button/gnb 4건)
   space56   56   (banner 2건)

⊘ Dimension 시스템으로 이관 (Spacing 팔레트 제거):
   Safe Area      : 14, 34, 36, 44
   Component size : 80, 112, 120, 128, 200, 240, 280, 300, 320
```

---

## 7. Phase 1-D 인계 사항

1. **Sem-mismatch 우선 해결**: Button hor/ver 두 건. Figma 컴포넌트 인스턴스(예: `2414:32026` Primary Button) 의 padding 을 `get_metadata` 또는 디자이너 확인으로 SoT 결정.
2. **`figma-spacing.INDEX.json` 부재 해소**: 페이지별 spacing raw 수집이 없음. Phase 1-B 의 컴포넌트 프레임 ID 수집과 병행하여 페이지별 사용 빈도 확보 시 §2 히스토그램의 Figma 측 막대를 채울 수 있음.
3. **Dimension 시스템 분리 결정**: Safe Area 4종 + Component-size 9종 합계 13건을 `AppSpacing` 에서 분리할지 검수 안건.
4. **Off-scale 81 건의 토큰 치환 매핑**: §5-3 카테고리 표 기준으로 1:1 치환 후보 자동 생성 — Phase 2 마이그레이션 PR 사이즈 산정 입력.
5. **신규 토큰 후보 확정**: `space0`, `space28`, `space56` — 디자이너와 4 배수 스케일 정합성 합의 필요.
