# Phase 1-C — Figma ↔ 코드 갭 분석

**브랜치**: `claude/gap-analysis-spacing-hJntu`
**입력**:
- Figma 측: `01-audit/figma-pages.json` (27 audit 페이지) + Phase 1-A §4-2 의 `Semantic.Spacing/*` 변수 마스터 테이블 (Figma 플러그인 API 검증)
- 코드 측: `01-audit/code-audit.INDEX.json` (21 디렉터리 집계) + `code-token-defs.foundation.json` (팔레트/시맨틱 정의) + 디렉터리별 `code-hardcoded-usages.*.json` (총 119 파일, 927 사용처)

> 주의: 본 저장소에는 별도의 `figma-spacing.INDEX.json` 이 존재하지 않음. Figma 측 값 집합은 (a) Library 파일의 `Semantic.Spacing/*` 변수 정의와 (b) 📐 Space 페이지(`2485:8842`) 구조에서 도출. 페이지별 raw 데이터는 헤드리스 환경에서 `get_metadata` 응답이 잘리는 한계로 변수 정의를 신뢰 소스로 사용.

---

## 1. 요약 통계

| 항목 | Figma | 코드 |
|---|---|---|
| 팔레트 정의 값 수 | 10 | 13 |
| 팔레트 값 집합 | 4, 8, 12, 14, 16, 20, 24, 32, 40, 48 | 4, 8, 12, 14, 16, 20, 24, 32, 34, 36, 40, 44, 48 |
| 시맨틱 토큰 수 | 5 (Button.hor/ver, List/Card/Large, Padding.Box-in-Box, Padding.Contents-in-Box) | 20 |
| 감사 단위 수 | 27 페이지 | 21 디렉터리 / 119 파일 |
| 총 사용처 | (페이지별 raw 미수집) | 927 |
| 토큰 참조 사용 | n/a | 702 (space16 214, space8 185, space12 145, space4 88, space24 52, space20 18) |
| 하드코드 리터럴 사용 | n/a | 225 (off-scale 80 + on-scale palette literal 145) |
| 의심 항목(off-scale literal) | n/a | 81 건 (21 디렉터리 중 14곳) |

### 1-1. 양쪽 팔레트 합집합

매치 (양쪽 모두 정의): **4, 8, 12, 14, 16, 20, 24, 32, 40, 48** — 10 값
코드 단독 (Figma 팔레트 미정의): **34, 36, 44** — 모두 Safe Area 디바이스 상수(iOS 노치 / Android 상태바)
Figma 단독 (코드 팔레트 미정의): **없음**

### 1-2. 시맨틱 매핑 1차 점검 (Phase 1-A §4-2 ↔ 코드 정의)

| Figma 변수 | Phase 1-A 기록값 | 코드 `AppSpacing.*` | 코드 resolvedValue | 일치? |
|---|---|---|---|---|
| Spacing/4 | 4 | space4 | 4 | ✅ |
| Spacing/8 | 8 | space8 | 8 | ✅ |
| Spacing/12 | 12 | space12 | 12 | ✅ |
| Spacing/16 | 16 | space16 | 16 | ✅ |
| Spacing/20 | 20 | space20 | 20 | ✅ |
| Spacing/24 | 24 | space24 | 24 | ✅ |
| Spacing/32 | 32 | space32 | 32 | ✅ |
| Spacing/40 | 40 | space40 | 40 | ✅ |
| Spacing/48 | 48 | space48 | 48 | ✅ |
| Spacing/Button/hor | 16 | buttonPaddingHorizontal → space8 | **8** | ❌ 8 vs 16 |
| Spacing/Button/ver | 14 | buttonPaddingVertical → space12 | **12** | ❌ 12 vs 14 |
| Spacing/List/Card/Large | 12 | itemSpacing → space12 | 12 | ✅ |
| Spacing/Padding/Box in Box | 16 | paddingBoxInBox → space16 | 16 | ✅ |
| Spacing/Padding/Contents in Box | 24 | paddingContentsInBox → space24 | 24 | ✅ |

> ⚠️ Button 패딩 두 건은 Figma 변수 description 과 코드의 시맨틱 정의가 어긋남. Phase 1-A §4-2 가 Figma 측 description 을 그대로 옮긴 것이므로, **실제 Figma 컴포넌트의 인스턴스 패딩 값이 어느 쪽을 따르는지** 컴포넌트 단위(Phase 1-D~2) 에서 재확인 필요. 본 갭 분석에서는 ❌ 로 표기.

---

## 2. 값 분포 히스토그램 (Figma 팔레트 vs 코드 사용)

코드 측 사용량은 토큰 참조 + 하드코드 리터럴을 동일 값으로 합산. Figma 측은 변수 존재 여부(●) / 부재(○) 만 표기 — 페이지별 사용 빈도는 입력 데이터에 없음.

```
값      Figma   코드 사용량                                                   비고
0       ○                                                                  ░░ 12  (zero padding — 토큰 없음)
1       ○                                                                  ░  3
2       ○       ███████                                                    ░ 24
3       ○                                                                  ░  4
4       ●       ██████████████████████████████                             █ 96
6       ○       █████                                                      ░ 18
8       ●       ████████████████████████████████████████████████████████████ █ 199
9       ○                                                                  ░  1
10      ○                                                                  ░  5
11      ○                                                                  ░  1
12      ●       ██████████████████████████████████████████████████         █ 164
14      ●       —                                                          (Safe Area, 사용처 0)
16      ●       ███████████████████████████████████████████████████████████████████████ █ 233
18      ○                                                                  ░  2
20      ●       ██████                                                     █ 21
22      ○                                                                  ░  3
24      ●       ███████████████████████████                                █ 88
28      ○                                                                  ░  4
32      ●                                                                  █  5
34      ○*      —                                                          코드 팔레트 only (iOS 하단 Safe Area)
36      ○*      —                                                          코드 팔레트 only (Android 상태바)
40      ●                                                                  ░  2
44      ○*      —                                                          코드 팔레트 only (iOS 상태바)
48      ●                                                                  █  5
56      ○                                                                  ░  2
80      ○                                                                  ░  1
112     ○                                                                  ░  1
120     ○                                                                  ░  4
128     ○                                                                  ░  2
200     ○                                                                  ░  3
240     ○                                                                  ░  1
280     ○                                                                  ░  3
300     ○                                                                  ░  1
320     ○                                                                  ░  2
```
범례: `●` Figma 팔레트 정의 / `○` 미정의 / `○*` 코드만 존재 / `█` 팔레트 매치 사용 / `░` 하드코드(off-scale)

---

## 3. 불일치 표

차이유형: **`P-only`** = Figma 팔레트 단독, **`C-only`** = 코드 팔레트 단독, **`Off-scale`** = 양쪽 팔레트 어디에도 없으나 코드에서 리터럴로 사용, **`Sem-mismatch`** = 동일 시맨틱 토큰이 양쪽에서 다른 숫자값.

| Value | Figma | 코드 (팔레트/사용) | 차이유형 | 비고 |
|---:|---|---|---|---|
| 0   | ○ 미정의 | △ 리터럴 12회 | Off-scale | zero padding 의도. 토큰 `space0` 추가 검토 |
| 1   | ○ | △ 3 | Off-scale | hairline (border 흉내). EdgeInsets 가 아닌 BorderSide 로 처리 권장 |
| 2   | ○ | △ 24 ★ | Off-scale | **빈도 최상위 off-scale.** SizedBox(h:2), gap:2 다수 — 미세 보정 |
| 3   | ○ | △ 4 | Off-scale | chip gap / pagination padding — 6 또는 4 로 통합 가능 |
| 6   | ○ | △ 18 ★ | Off-scale | chip / banner / preference list — 4 또는 8 로 통합 검토 |
| 9   | ○ | △ 1 | Off-scale | empty_state vertical pad — 8 로 통합 |
| 10  | ○ | △ 5 | Off-scale | bottom button, mini chip, top nav — 8 또는 12 통합 |
| 11  | ○ | △ 1 | Off-scale | bottom button vertical — 12 로 통합 |
| 18  | ○ | △ 2 | Off-scale | auto_complete SizedBox — 16 또는 20 통합 |
| 22  | ○ | △ 3 | Off-scale | section_message dimension — 24 통합 |
| 28  | ○ | △ 4 | Off-scale | bottom button horizontal, gnb logo — 24 또는 32 통합 |
| 34  | ○ | ● 팔레트 정의 (사용 0) | C-only | iOS Safe Area Bottom — Figma 변수화 검토 (또는 코드도 dynamic 으로 전환) |
| 36  | ○ | ● 팔레트 정의 (사용 0) | C-only | Android Safe Area Status — 동상 |
| 44  | ○ | ● 팔레트 정의 (사용 0) | C-only | iOS Safe Area Status — 동상 |
| 56  | ○ | △ 2 | Off-scale | banner — 48 통합 또는 신규 토큰 |
| 80  | ○ | △ 1 | Off-scale | feedback — 단발성 |
| 112 | ○ | △ 1 | Off-scale | item_list — 단발성, Dimension(고정 크기)으로 분류 |
| 120 | ○ | △ 4 | Off-scale | thumbnail use_cases — Dimension 토큰 후보 (`thumbnail.lg=120`) |
| 128 | ○ | △ 2 | Off-scale | empty_state visual — Dimension 토큰 후보 |
| 200 | ○ | △ 3 | Off-scale | indicator/ratio/banner — Dimension (use_cases 데모) |
| 240 | ○ | △ 1 | Off-scale | banner_use_cases — 데모용 |
| 280 | ○ | △ 3 | Off-scale | date/time picker, ratio — Dimension 토큰 후보 (`picker.md=280`) |
| 300 | ○ | △ 1 | Off-scale | select use_cases — 데모용 |
| 320 | ○ | △ 2 | Off-scale | scroll/banner — Dimension (use_cases 데모) |
| **Spacing/Button/hor** | 16 | space8 = **8** | Sem-mismatch | Phase 1-A §4-2 의 description 과 코드 정의 충돌 → 컴포넌트 인스턴스 재검증 필요 |
| **Spacing/Button/ver** | 14 | space12 = **12** | Sem-mismatch | 동상 |

> △ = 코드 측 하드코드 리터럴 사용 (off-scale). ● = 팔레트 정의 존재. ○ = 정의 없음.

---

## 4. 사용 빈도 Top 20 (코드 측)

토큰 참조 + 하드코드 리터럴 합산 기준. Figma 팔레트 매치 여부(`F?`) 함께 표기.

| 순위 | 값 | Token Ref | Literal | 합계 | F? | 비고 |
|---:|---:|---:|---:|---:|:--:|---|
| 1   | 16  | 214 | 19 | **233** | ● | space16 — 가장 빈번. 카드/콘텐츠 기본 패딩 |
| 2   | 8   | 185 | 14 | **199** | ● | space8 — 아이콘-텍스트 갭 |
| 3   | 12  | 145 | 19 | **164** | ● | space12 — 리스트 아이템 간격 |
| 4   | 4   | 88  | 8  | **96**  | ● | space4 — 최소 갭 |
| 5   | 24  | 52  | 36 | **88**  | ● | space24 — 섹션/모달. **리터럴 36회**가 비정상적으로 높음 → 토큰화 누락 다수 |
| 6   | 2   | 0   | 24 | **24**  | ○ | off-scale 최다 |
| 7   | 20  | 18  | 3  | **21**  | ● | space20 |
| 8   | 6   | 0   | 18 | **18**  | ○ | off-scale 2위 |
| 9   | 0   | 0   | 12 | **12**  | ○ | zero padding |
| 10  | 10  | 0   | 5  | **5**   | ○ | off-scale |
| 11  | 32  | 0   | 5  | **5**   | ● | space32 — 토큰 정의 있으나 ref 사용 0 (전량 리터럴) |
| 12  | 48  | 0   | 5  | **5**   | ● | space48 — 동상 (ref 사용 0) |
| 13  | 3   | 0   | 4  | **4**   | ○ | off-scale |
| 14  | 28  | 0   | 4  | **4**   | ○ | off-scale |
| 15  | 120 | 0   | 4  | **4**   | ○ | dimension 후보 |
| 16  | 1   | 0   | 3  | **3**   | ○ | hairline |
| 17  | 22  | 0   | 3  | **3**   | ○ | off-scale |
| 18  | 200 | 0   | 3  | **3**   | ○ | dimension 데모 |
| 19  | 280 | 0   | 3  | **3**   | ○ | dimension 후보 |
| 20  | 18  | 0   | 2  | **2**   | ○ | off-scale |
| 20  | 40  | 0   | 2  | **2**   | ● | space40 — ref 사용 0 (리터럴 전량) |
| 20  | 56  | 0   | 2  | **2**   | ○ | off-scale |
| 20  | 128 | 0   | 2  | **2**   | ○ | off-scale |
| 20  | 320 | 0   | 2  | **2**   | ○ | dimension 데모 |

> 인사이트: `space32 / space40 / space48` 은 팔레트로 정의되어 있지만 **토큰 참조로 사용된 적이 없음** (전량 하드코드 리터럴). Phase 2 마이그레이션 시 리터럴 → `AppSpacing.spaceN` 단순 치환만으로도 큰 진척.

---

## 5. 의심 항목 목록

> "괄호 메모에 임시/TODO/tmp/fix 포함" 기준으로 raw 파일과 코드 주석을 grep 한 결과 **해당 메모 없음**. 대신 코드 audit 단계에서 분류한 **off-scale 리터럴 81 건** 을 의심 항목으로 간주.

### 5-1. 디렉터리별 의심 건수

| 디렉터리 | 의심 건수 | 대표 값 | 대표 파일 |
|---|---:|---|---|
| contents | 30 | 2, 6, 56, 112, 200, 240, 320 | app_banner, app_item_list, app_review |
| chips | 9 | 2, 3, 6, 10 | app_chip, app_chip_action, app_mini_chip |
| feedback | 8 | 6, 9, 22, 128 | app_empty_state, app_section_message |
| buttons | 6 | 6, 10, 11, 28 | app_section_bottom_button |
| navigation | 4 | 10, 28 | app_gnb_use_cases, app_top_navigation |
| thumbnails | 4 | 120 | thumbnail_use_cases |
| indicators | 3 | 2, 6, 200 | app_progress, app_progress_tracker, indicator_use_cases |
| selection | 3 | 280, 300 | app_date_picker, app_time_picker, app_select_use_cases |
| presentation | 2 | 18 | app_auto_complete |
| ratio | 2 | 200, 280 | ratio_use_cases |
| cards | 1 | 2 | app_card |
| control_box | 1 | 2 | app_control_box |
| controls | 1 | 2 | app_switch |
| pagination | 1 | 3 | app_pagination |
| scrolls | 1 | 320 | scroll_use_cases |
| tabs | 1 | 2 | app_segmented_control |

### 5-2. 의심 항목 카테고리

| 카테고리 | 값 | 처리 방향 |
|---|---|---|
| **Micro-gap** | 1, 2, 3 | 빈도 높지만 디자인 의도 약함. 4 로 통합 또는 BorderSide 로 표현 |
| **Sub-step** | 6, 9, 10, 11, 18, 22 | 4의 배수 인근으로 통합 (6→4/8, 9→8, 10→8/12, 11→12, 18→16/20, 22→24) |
| **Mid-step** | 28, 56 | 4의 배수이나 팔레트 미정의. `space28`, `space56` 신규 토큰 후보 |
| **Dimension (고정 크기)** | 80, 112, 120, 128, 200, 240, 280, 300, 320 | Spacing 토큰이 아닌 별도 Dimension 시스템으로 분리 (썸네일/배너/피커 크기) |
| **Zero** | 0 | `space0 = 0` 또는 `EdgeInsets.zero` 명시 사용 |

### 5-3. Sem-mismatch (시맨틱 충돌 — 우선 해결)

| 항목 | 위치 | 충돌 |
|---|---|---|
| Button horizontal padding | `lib/foundation/app_spacing.dart:77` `buttonPaddingHorizontal = space8` | Figma description 은 16, 코드는 8 → Figma 컴포넌트 인스턴스 실제값 확인 후 한쪽 정정 |
| Button vertical padding | `lib/foundation/app_spacing.dart:78` `buttonPaddingVertical = space12` | Figma description 은 14, 코드는 12 → 동상 |

---

## 6. 팔레트 스케일 후보안

### 6-1. 4의 배수 기준 권장 스케일

| 값 | 빈도 (코드 합산) | Figma | 코드 | 권고 | 마크 |
|---:|---:|:--:|:--:|---|:--:|
| 0   | 12  | ○ | ○ | **신규** `space0` 추가 (zero padding 명시) | ★ |
| 4   | 96  | ● | ● | **유지** | ★ |
| 8   | 199 | ● | ● | **유지** | ★ |
| 12  | 164 | ● | ● | **유지** | ★ |
| 16  | 233 | ● | ● | **유지** | ★ |
| 20  | 21  | ● | ● | **유지** | ★ |
| 24  | 88  | ● | ● | **유지** | ★ |
| 28  | 4   | ○ | ○ | **신규 검토** (현재 4건, button/nav 통합) | — |
| 32  | 5   | ● | ● | **유지** | ★ |
| 36  | 0   | ○ | ● | **이동** → Dimension 시스템 (Safe Area Status Android) | — |
| 40  | 2   | ● | ● | **유지** (빈도 낮음 주의) | — |
| 44  | 0   | ○ | ● | **이동** → Dimension 시스템 (Safe Area Status iOS) | — |
| 48  | 5   | ● | ● | **유지** | ★ |
| 56  | 2   | ○ | ○ | **신규 검토** (banner) | — |

### 6-2. 4의 배수가 아닌 현재 팔레트 — 예외 처리

| 값 | 출처 | 처리 |
|---:|---|---|
| 14 | Safe Area Bottom (Android) | Dimension 시스템으로 분리 |
| 34 | Safe Area Bottom (iOS) | Dimension 시스템으로 분리 |

> Safe Area 4종(14/34/36/44)은 모두 디바이스 상수. Phase 2 에서 `AppDeviceMetrics` (또는 동등) 로 이관하고 Spacing 팔레트는 순수 4-배수만 남기는 방안을 추천.

### 6-3. 제거 후보 (빈도 < 2)

| 값 | 빈도 | 비고 |
|---:|---:|---|
| 9   | 1 | empty_state — 8 로 통합 |
| 11  | 1 | bottom button — 12 로 통합 |
| 80  | 1 | 단발 — 제거 |
| 112 | 1 | item_list — Dimension 으로 |
| 240 | 1 | 데모용 — 제거 또는 Dimension |
| 300 | 1 | 데모용 — 제거 또는 Dimension |

### 6-4. 최종 권장 Spacing 팔레트 (Phase 2 가이드)

```
★ 코어 (빈도 ≥5, 양쪽 매치):
   space0    0      (신규)
   space4    4
   space8    8
   space12   12
   space16   16
   space20   20
   space24   24
   space32   32
   space48   48

· 보조 (빈도 <5, 4-배수, 유지):
   space40   40

· 신규 검토 (off-scale 통합 대상):
   space28   28   (현재 4건 — button/gnb)
   space56   56   (현재 2건 — banner)

⊘ Dimension 시스템으로 이관:
   Safe Area: 14, 34, 36, 44
   Component size: 80, 112, 120, 128, 200, 240, 280, 300, 320
```

---

## 7. Phase 1-D 인계 사항

1. **Sem-mismatch 우선 해결**: Button hor/ver 두 건. 실제 Figma 컴포넌트 인스턴스(예: `2414:32026` 페이지의 Primary Button 노드) 의 padding 값을 `get_metadata` 로 확인 후 디자이너 또는 코드 어느 쪽이 sot 인지 결정.
2. **Figma 측 페이지별 raw 수집 완성**: 현재 `figma-spacing.INDEX.json` 부재. Phase 1-B 인계 사항 §6-2 의 컴포넌트 프레임 ID 수집과 병행하여 페이지별 spacing 사용 분포 확보 필요.
3. **Dimension 시스템 분리 결정**: Safe Area + Component-size 14건을 `AppSpacing` 에서 분리할지 여부는 사람 검수 #2 안건.
4. **off-scale 81건의 토큰 치환 매핑**: 본 문서 §5-2 카테고리 표를 기준으로 1:1 치환 후보 자동 생성 — Phase 2 마이그레이션 PR 사이즈 산정 입력.
