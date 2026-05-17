# Phase 5 — `presentation` 코드 적용 로그

**상태**: OK
**대상**: `lib/components/presentation/`
**실행 시각**: 2026-05-17

## 결과

| 분류 | 수 |
|---|--:|
| CSV READY 적용 | 29 |
| CSV 매칭 실패 (skip) | 24 |
| 레거시 palette rename (`space{N}`→`s{N}`) | 12 |
| Off-scale 매핑 (34→32 / 36→40 / 56→48, 주석 첨부) | 0 |
| 레거시 semantic → `AppSpacingSemantic.*` | 0 |
| 총 편집 | **41** |
| 변경 파일 | 9 |
| 롤백 파일 | 0 |

## flutter analyze --no-fatal-infos

- baseline errors: 14
- after: 14 (delta +0)
- 본 dir 변경으로 인한 신규 error: 0

## CSV 매칭 실패 (수동 검토 필요)

- `lib/components/presentation/app_action_sheet.dart:101` curr='space8' → 'AppSpacing.s8'  (needle-not-found)
- `lib/components/presentation/app_action_sheet.dart:161` curr='space8' → 'AppSpacing.s8'  (needle-not-found)
- `lib/components/presentation/app_action_sheet.dart:161` curr='space4' → 'AppSpacing.s4'  (needle-not-found)
- `lib/components/presentation/app_action_sheet.dart:197` curr='space16' → 'AppSpacing.s16'  (needle-not-found)
- `lib/components/presentation/app_action_sheet.dart:197` curr='H=16' → 'AppSpacing.s16'  (numeric-not-found)
- `lib/components/presentation/app_action_sheet.dart:267` curr='H=16' → 'AppSpacing.s16'  (numeric-not-found)
- `lib/components/presentation/app_action_sheet.dart:267` curr='space16' → 'AppSpacing.s16'  (needle-not-found)
- `lib/components/presentation/app_auto_complete.dart:221` curr='space16' → 'AppSpacing.s16'  (needle-not-found)
- `lib/components/presentation/app_auto_complete.dart:233` curr='space16' → 'AppSpacing.s16'  (needle-not-found)
- `lib/components/presentation/app_auto_complete.dart:251` curr='space16' → 'AppSpacing.s16'  (needle-not-found)
- `lib/components/presentation/app_auto_complete.dart:251` curr='H=16' → 'AppSpacing.s16'  (numeric-not-found)
- `lib/components/presentation/app_bottom_sheet.dart:45` curr='space8' → 'AppSpacing.s8'  (needle-not-found)
- `lib/components/presentation/app_bottom_sheet.dart:45` curr='space4' → 'AppSpacing.s4'  (needle-not-found)
- `lib/components/presentation/app_bottom_sheet.dart:59` curr='space16' → 'AppSpacing.s16'  (needle-not-found)
- `lib/components/presentation/app_bottom_sheet.dart:59` curr='H=16' → 'AppSpacing.s16'  (numeric-not-found)
- `lib/components/presentation/app_bottom_sheet.dart:143` curr='space24' → 'AppSpacing.s24'  (needle-not-found)
- `lib/components/presentation/app_bottom_sheet.dart:154` curr='space24' → 'AppSpacing.s24'  (needle-not-found)
- `lib/components/presentation/app_bottom_sheet.dart:154` curr='space24' → 'AppSpacing.s24'  (needle-not-found)
- `lib/components/presentation/app_bottom_sheet.dart:154` curr='space24' → 'AppSpacing.s24'  (needle-not-found)
- `lib/components/presentation/app_bottom_sheet.dart:154` curr='space16' → 'AppSpacing.s16'  (needle-not-found)
- `lib/components/presentation/app_menu.dart:126` curr='space16' → 'AppSpacing.s16'  (needle-not-found)
- `lib/components/presentation/app_menu.dart:126` curr='H=16' → 'AppSpacing.s16'  (numeric-not-found)
- `lib/components/presentation/app_menu.dart:224` curr='H=16' → 'AppSpacing.s16'  (numeric-not-found)
- `lib/components/presentation/app_menu.dart:224` curr='space16' → 'AppSpacing.s16'  (needle-not-found)

