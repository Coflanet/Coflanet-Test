# Phase 5 — `buttons` 코드 적용 로그

**상태**: OK
**대상**: `lib/components/buttons/`
**실행 시각**: 2026-05-17

## 결과

| 분류 | 수 |
|---|--:|
| CSV READY 적용 | 10 |
| CSV 매칭 실패 (skip) | 5 |
| 레거시 palette rename (`space{N}`→`s{N}`) | 4 |
| Off-scale 매핑 (34→32 / 36→40 / 56→48, 주석 첨부) | 0 |
| 레거시 semantic → `AppSpacingSemantic.*` | 0 |
| 총 편집 | **14** |
| 변경 파일 | 5 |
| 롤백 파일 | 0 |

## flutter analyze --no-fatal-infos

- baseline errors: 14
- after: 14 (delta +0)
- 본 dir 변경으로 인한 신규 error: 0

## CSV 매칭 실패 (수동 검토 필요)

- `lib/components/buttons/app_floating_action_button.dart:37` curr='space16' → 'AppSpacing.s16'  (needle-not-found)
- `lib/components/buttons/app_section_bottom_button.dart:100` curr='space24' → 'AppSpacing.s24'  (needle-not-found)
- `lib/components/buttons/app_section_bottom_button.dart:100` curr='space4' → 'AppSpacing.s4'  (needle-not-found)
- `lib/components/buttons/app_text_button.dart:43` curr='V=4' → 'AppSpacing.s4'  (numeric-not-found)
- `lib/components/buttons/app_text_button.dart:43` curr='space4' → 'AppSpacing.s4'  (needle-not-found)

