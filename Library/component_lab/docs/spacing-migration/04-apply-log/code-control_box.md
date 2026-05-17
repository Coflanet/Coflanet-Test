# Phase 5 — `control_box` 코드 적용 로그

**상태**: OK
**대상**: `lib/components/control_box/`
**실행 시각**: 2026-05-17

## 결과

| 분류 | 수 |
|---|--:|
| CSV READY 적용 | 4 |
| CSV 매칭 실패 (skip) | 2 |
| 레거시 palette rename (`space{N}`→`s{N}`) | 7 |
| Off-scale 매핑 (34→32 / 36→40 / 56→48, 주석 첨부) | 0 |
| 레거시 semantic → `AppSpacingSemantic.*` | 0 |
| 총 편집 | **11** |
| 변경 파일 | 2 |
| 롤백 파일 | 0 |

## flutter analyze --no-fatal-infos

- baseline errors: 14
- after: 14 (delta +0)
- 본 dir 변경으로 인한 신규 error: 0

## CSV 매칭 실패 (수동 검토 필요)

- `lib/components/control_box/app_control_box.dart:44` curr='space12' → 'AppSpacing.s12'  (needle-not-found)
- `lib/components/control_box/app_control_box.dart:44` curr='V=12' → 'AppSpacing.s12'  (numeric-not-found)

