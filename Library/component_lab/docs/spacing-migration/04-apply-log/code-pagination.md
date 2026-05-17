# Phase 5 — `pagination` 코드 적용 로그

**상태**: OK
**대상**: `lib/components/pagination/`
**실행 시각**: 2026-05-17

## 결과

| 분류 | 수 |
|---|--:|
| CSV READY 적용 | 0 |
| CSV 매칭 실패 (skip) | 1 |
| 레거시 palette rename (`space{N}`→`s{N}`) | 1 |
| Off-scale 매핑 (34→32 / 36→40 / 56→48, 주석 첨부) | 0 |
| 레거시 semantic → `AppSpacingSemantic.*` | 0 |
| 총 편집 | **1** |
| 변경 파일 | 1 |
| 롤백 파일 | 0 |

## flutter analyze --no-fatal-infos

- baseline errors: 14
- after: 14 (delta +0)
- 본 dir 변경으로 인한 신규 error: 0

## CSV 매칭 실패 (수동 검토 필요)

- `lib/components/pagination/app_pagination.dart:68` curr='H=3' → 'AppSpacing.s3'  (numeric-not-found)

