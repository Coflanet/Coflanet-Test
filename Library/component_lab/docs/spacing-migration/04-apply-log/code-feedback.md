# Phase 5 — `feedback` 코드 적용 로그

**상태**: OK
**대상**: `lib/components/feedback/`
**실행 시각**: 2026-05-17

## 결과

| 분류 | 수 |
|---|--:|
| CSV READY 적용 | 30 |
| CSV 매칭 실패 (skip) | 15 |
| 레거시 palette rename (`space{N}`→`s{N}`) | 6 |
| Off-scale 매핑 (34→32 / 36→40 / 56→48, 주석 첨부) | 0 |
| 레거시 semantic → `AppSpacingSemantic.*` | 0 |
| 총 편집 | **36** |
| 변경 파일 | 9 |
| 롤백 파일 | 0 |

## flutter analyze --no-fatal-infos

- baseline errors: 14
- after: 14 (delta +0)
- 본 dir 변경으로 인한 신규 error: 0

## CSV 매칭 실패 (수동 검토 필요)

- `lib/components/feedback/app_empty_state.dart:135` curr='space20' → 'AppSpacing.s20'  (needle-not-found)
- `lib/components/feedback/app_section_message.dart:117` curr='space12' → 'AppSpacing.s12'  (needle-not-found)
- `lib/components/feedback/app_section_message.dart:219` curr='H=6' → 'AppSpacing.s6'  (numeric-not-found)
- `lib/components/feedback/app_section_message.dart:252` curr='space4' → 'AppSpacing.s4'  (needle-not-found)
- `lib/components/feedback/app_section_message.dart:122` curr='20' → 'AppSpacing.s20'  (numeric-not-found)
- `lib/components/feedback/app_snackbar.dart:34` curr='H=16' → 'AppSpacing.s16'  (numeric-not-found)
- `lib/components/feedback/app_snackbar.dart:34` curr='space16' → 'AppSpacing.s16'  (needle-not-found)
- `lib/components/feedback/app_snackbar.dart:35` curr='space16' → 'AppSpacing.s16'  (needle-not-found)
- `lib/components/feedback/app_toast.dart:72` curr='H=16' → 'AppSpacing.s16'  (numeric-not-found)
- `lib/components/feedback/app_toast.dart:72` curr='space16' → 'AppSpacing.s16'  (needle-not-found)
- `lib/components/feedback/app_toast.dart:73` curr='space16' → 'AppSpacing.s16'  (needle-not-found)
- `lib/components/feedback/app_toast.dart:73` curr='H=16' → 'AppSpacing.s16'  (numeric-not-found)
- `lib/components/feedback/app_tooltip.dart:36` curr='space12' → 'AppSpacing.s12'  (needle-not-found)
- `lib/components/feedback/app_tooltip.dart:36` curr='H=12' → 'AppSpacing.s12'  (numeric-not-found)
- `lib/components/feedback/app_tooltip.dart:79` curr='space16' → 'AppSpacing.s16'  (needle-not-found)

