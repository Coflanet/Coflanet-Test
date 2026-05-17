# Phase 5 — `chips` 코드 적용 로그

**상태**: PARTIAL
**대상**: `lib/components/chips/`
**실행 시각**: 2026-05-17

## 결과

| 분류 | 수 |
|---|--:|
| CSV READY 적용 | 11 |
| CSV 매칭 실패 (skip) | 4 |
| 레거시 palette rename (`space{N}`→`s{N}`) | 37 |
| Off-scale 매핑 (34→32 / 36→40 / 56→48, 주석 첨부) | 0 |
| 레거시 semantic → `AppSpacingSemantic.*` | 0 |
| 총 편집 | **48** |
| 변경 파일 | 2 |
| 롤백 파일 | 2 |

## flutter analyze --no-fatal-infos

- baseline errors: 14
- after: 14 (delta +8)
- 본 dir 변경으로 인한 신규 error: 0

## 롤백 파일

- `lib/components/chips/app_chip_action.dart`
- `lib/components/chips/app_mini_chip.dart`


## CSV 매칭 실패 (수동 검토 필요)

- `lib/components/chips/app_chip.dart:129` curr='space8' → 'AppSpacing.s8'  (needle-not-found)
- `lib/components/chips/app_chip.dart:129` curr='space4' → 'AppSpacing.s4'  (needle-not-found)
- `lib/components/chips/app_chip.dart:131` curr='space12' → 'AppSpacing.s12'  (needle-not-found)
- `lib/components/chips/app_chip.dart:157` curr='space4' → 'AppSpacing.s4'  (needle-not-found)

