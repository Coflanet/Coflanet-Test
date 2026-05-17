# Phase 5 — `controls` 코드 적용 로그

**상태**: PARTIAL
**대상**: `lib/components/controls/`
**실행 시각**: 2026-05-17

## 결과

| 분류 | 수 |
|---|--:|
| CSV READY 적용 | 3 |
| CSV 매칭 실패 (skip) | 0 |
| 레거시 palette rename (`space{N}`→`s{N}`) | 2 |
| Off-scale 매핑 (34→32 / 36→40 / 56→48, 주석 첨부) | 0 |
| 레거시 semantic → `AppSpacingSemantic.*` | 0 |
| 총 편집 | **5** |
| 변경 파일 | 3 |
| 롤백 파일 | 1 |

## flutter analyze --no-fatal-infos

- baseline errors: 14
- after: 14 (delta +2)
- 본 dir 변경으로 인한 신규 error: 0

## 롤백 파일

- `lib/components/controls/app_switch.dart`

