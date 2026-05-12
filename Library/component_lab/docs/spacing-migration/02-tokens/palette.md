# Palette Tokens — Phase 2 SoT

**버전**: `0.1.0-phase2`
**입력**: `01-audit/gap-analysis.md`, USER_DECISION 검수 #2 (2026-05-12)
**대응 코드**: `lib/foundation/app_spacing.dart` (커밋 `eb79fbb`, PR #28 머지)

---

## 1. 확정 스케일 (16 토큰)

| # | 토큰명 (문서) | 코드 식별자 | 값 (px) | Figma 팔레트 | 코드 빈도 | 분류 | 결정 근거 |
|---:|---|---|---:|:--:|---:|---|---|
| 1  | `spacing-0`  | `space0`  | 0  | ○ | 12 | core      | USER_DECISION #2 신규 승인. zero padding 12회 사용 → `EdgeInsets.zero` 와 분리해 의도 명시. |
| 2  | `spacing-4`  | `space4`  | 4  | ● | 96 | core      | 양쪽 매치, 빈도 4위. |
| 3  | `spacing-8`  | `space8`  | 8  | ● | 199 | core     | 양쪽 매치, 빈도 2위. icon-text gap 기본값. |
| 4  | `spacing-12` | `space12` | 12 | ● | 164 | core     | 양쪽 매치, 빈도 3위. list item 간격. |
| 5  | `spacing-14` | `space14` | 14 | ○ | 0   | safe-area | Safe Area Bottom (Android). **Phase 2 Dimension 분리 후보 — 미결.** |
| 6  | `spacing-16` | `space16` | 16 | ● | 233 | core     | 양쪽 매치, **빈도 1위**. 카드/콘텐츠 기본 패딩. |
| 7  | `spacing-20` | `space20` | 20 | ● | 21  | core     | 양쪽 매치. |
| 8  | `spacing-24` | `space24` | 24 | ● | 88  | core     | 양쪽 매치, 빈도 5위. 섹션/모달 패딩. |
| 9  | `spacing-28` | `space28` | 28 | ○ | 4   | mid-step | USER_DECISION #2 신규 승인. button bottom / GNB logo off-scale 4건 통합용. |
| 10 | `spacing-32` | `space32` | 32 | ● | 5   | core     | 양쪽 매치. 리터럴 전량 → Phase 2 마이그레이션 대상. |
| 11 | `spacing-34` | `space34` | 34 | ○ | 0   | safe-area | Safe Area Bottom (iOS). **Dimension 분리 후보 — 미결.** |
| 12 | `spacing-36` | `space36` | 36 | ○ | 0   | safe-area | Safe Area Status (Android). **Dimension 분리 후보 — 미결.** |
| 13 | `spacing-40` | `space40` | 40 | ● | 2   | core     | 양쪽 매치 (빈도 낮음). |
| 14 | `spacing-44` | `space44` | 44 | ○ | 0   | safe-area | Safe Area Status (iOS). **Dimension 분리 후보 — 미결.** |
| 15 | `spacing-48` | `space48` | 48 | ● | 5   | core     | 양쪽 매치. |
| 16 | `spacing-56` | `space56` | 56 | ○ | 2   | mid-step | USER_DECISION #2 신규 승인. banner off-scale 2건 통합용. |

분류:
- **core** (9개): 4의 배수 + 빈도 ≥2 + 양쪽 매치 또는 신규 승인 (0 포함)
- **mid-step** (2개): 4의 배수, off-scale 통합용 신규 — `28`, `56`
- **safe-area** (4개): 디바이스 상수 — `14`, `34`, `36`, `44` (Dimension 이관 검토 중)

---

## 2. 이름 규칙 매핑

| 컨텍스트 | 표기 | 예 |
|---|---|---|
| 문서 / JSON 토큰 ID | `spacing-{value}` (kebab) | `spacing-16` |
| Figma 변수명 | `Spacing/{value}` | `Spacing/16` |
| Dart 식별자 | `space{N}` (camelCase 호환) | `AppSpacing.space16` |

> USER_DECISION #2 권장: Dart 는 kebab 불가 → **`space{N}` 유지**, 문서/JSON 만 kebab. 매핑 표 (위) 를 SoT 로 사용.

---

## 3. 제외값 사유

### 3-1. 제거 후보 — 팔레트 비포함 확정

| 값 | 빈도 | 사유 |
|---:|---:|---|
| 9   | 1 | empty_state 단발성. `spacing-8` 로 통합. |
| 11  | 1 | bottom button 단발성. `spacing-12` 로 통합. |
| 80  | 1 | feedback 단발성. Dimension 영역 (썸네일/배너) 또는 제거. |
| 112 | 1 | item_list 단발성. Dimension 후보. |
| 240 | 1 | banner_use_cases 데모. 제거 또는 Dimension. |
| 300 | 1 | select_use_cases 데모. 제거 또는 Dimension. |

→ USER_DECISION #2 의 **§6-3 미결 항목**. 본 팔레트는 위 6값을 모두 **포함하지 않음** (Phase 2 마이그레이션 시 통합 매핑은 `03-mapping/` 에서 정의).

### 3-2. Dimension 시스템 이관 후보 — 미결

| 값 | 사용처 | 처리 방향 |
|---:|---|---|
| 14, 34, 36, 44 | Safe Area 디바이스 상수 | `AppDeviceMetrics` 등 별도 시스템으로 분리 검토. |
| 80, 112, 120, 128, 200, 240, 280, 300, 320 | 썸네일/배너/피커 고정 크기 | `AppDimensions` 등 별도 시스템 후보. |

→ USER_DECISION #2 의 **§6-2, §6-4 ⊘ 미결**. 본 버전에서는 **14/34/36/44 만 팔레트에 잔류** (이미 코드에 정의되어 있고 결정 전 제거 시 호환성 깨짐). Component-size 9종은 처음부터 spacing 팔레트에 들어온 적 없음 — 별도 시스템에서 추후 다룸.

### 3-3. Off-scale 통합 대상 (마이그레이션 시 치환)

| 원본 값 | 빈도 | 치환 목표 | 카테고리 |
|---:|---:|---:|---|
| 1   | 3  | BorderSide 로 표현 | hairline |
| 2   | 24 | 4 (또는 BorderSide) | micro-gap |
| 3   | 4  | 4 | micro-gap |
| 6   | 18 | 4 또는 8 | sub-step |
| 10  | 5  | 8 또는 12 | sub-step |
| 18  | 2  | 16 또는 20 | sub-step |
| 22  | 3  | 24 | sub-step |

→ Phase 2 `03-mapping/` 에서 1:1 치환 룰 확정 예정.

---

## 4. 제약 준수 확인

| 제약 | 충족 |
|---|:--:|
| Palette `0` 포함 필수 | ✅ `spacing-0` 1번째 항목 |
| 이름 규칙 `spacing-{value}` | ✅ 16개 전부 일치 |
| 코드 팔레트 (16단계) 와 동기 | ✅ `app_spacing.dart` 와 1:1 |

---

## 5. 미결 항목 인계 (Phase 1-D / Phase 2 본 작업)

1. **Safe Area 4종 (14/34/36/44) Dimension 분리 여부** — 결정 시 본 팔레트에서 제거 후 `AppDeviceMetrics.*` 로 이관.
2. **제거 후보 6값** (9/11/80/112/240/300) — 본 팔레트에 포함하지 않음. Phase 2 마이그레이션에서 통합 매핑 적용.
3. **Sem-mismatch 2건** (Button hor/ver) — 본 팔레트 결정과 무관. `semantic.md` §5 에서 별도 추적.
