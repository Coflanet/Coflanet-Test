# Phase 5 — `navigation` 코드 적용 로그

**상태**: OK
**대상**: `lib/components/navigation/`
**실행 시각**: 2026-05-17

## 결과

| 분류 | 수 |
|---|--:|
| CSV READY 적용 | 8 |
| CSV 매칭 실패 (skip) | 6 |
| 레거시 palette rename (`space{N}`→`s{N}`) | 0 |
| Off-scale 매핑 (34→32 / 36→40 / 56→48, 주석 첨부) | 0 |
| 레거시 semantic → `AppSpacingSemantic.*` | 0 |
| 총 편집 | **8** |
| 변경 파일 | 3 |
| 롤백 파일 | 0 |

## flutter analyze --no-fatal-infos

- baseline errors: 14
- after: 14 (delta +0)
- 본 dir 변경으로 인한 신규 error: 0

## CSV 매칭 실패 (수동 검토 필요)

- `lib/components/navigation/app_bottom_navigation.dart:142` curr='space8' → 'AppSpacing.s8'  (needle-not-found)
- `lib/components/navigation/app_bottom_navigation.dart:142` curr='H=8' → 'AppSpacing.s8'  (numeric-not-found)
- `lib/components/navigation/app_footer.dart:184` curr='space8' → 'AppSpacing.s8'  (needle-not-found)
- `lib/components/navigation/app_top_navigation.dart:232` curr='H=4' → 'AppSpacing.s4'  (numeric-not-found)
- `lib/components/navigation/app_top_navigation.dart:232` curr='space4' → 'AppSpacing.s4'  (needle-not-found)
- `lib/components/navigation/app_top_navigation.dart:286` curr='0' → 'AppSpacing.s0'  (numeric-not-found)

