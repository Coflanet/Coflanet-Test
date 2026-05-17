# Phase 5 — `contents` 코드 적용 로그

**상태**: PARTIAL
**대상**: `lib/components/contents/`
**실행 시각**: 2026-05-17

## 결과

| 분류 | 수 |
|---|--:|
| CSV READY 적용 | 121 |
| CSV 매칭 실패 (skip) | 39 |
| 레거시 palette rename (`space{N}`→`s{N}`) | 54 |
| Off-scale 매핑 (34→32 / 36→40 / 56→48, 주석 첨부) | 0 |
| 레거시 semantic → `AppSpacingSemantic.*` | 0 |
| 총 편집 | **175** |
| 변경 파일 | 27 |
| 롤백 파일 | 1 |

## flutter analyze --no-fatal-infos

- baseline errors: 14
- after: 14 (delta +4)
- 본 dir 변경으로 인한 신규 error: 0

## 롤백 파일

- `lib/components/contents/app_content_badge.dart`


## CSV 매칭 실패 (수동 검토 필요)

- `lib/components/contents/app_accordion.dart:133` curr='space8' → 'AppSpacing.s8'  (needle-not-found)
- `lib/components/contents/app_banner.dart:125` curr='space12' → 'AppSpacing.s12'  (needle-not-found)
- `lib/components/contents/app_coffee_list.dart:82` curr='space12' → 'AppSpacing.s12'  (needle-not-found)
- `lib/components/contents/app_coffee_profile.dart:37` curr='V=4' → 'AppSpacing.s4'  (numeric-not-found)
- `lib/components/contents/app_coffee_profile.dart:37` curr='space4' → 'AppSpacing.s4'  (needle-not-found)
- `lib/components/contents/app_coffee_profile.dart:244` curr='space16' → 'AppSpacing.s16'  (needle-not-found)
- `lib/components/contents/app_community_list.dart:43` curr='space16' → 'AppSpacing.s16'  (needle-not-found)
- `lib/components/contents/app_community_list.dart:43` curr='H=16' → 'AppSpacing.s16'  (numeric-not-found)
- `lib/components/contents/app_play_icon_badge.dart:65` curr='left=2' → 'AppSpacing.s2'  (numeric-not-found)
- `lib/components/contents/app_preference_list.dart:83` curr='space8' → 'AppSpacing.s8'  (needle-not-found)
- `lib/components/contents/app_preference_list.dart:189` curr='space16' → 'AppSpacing.s16'  (needle-not-found)
- `lib/components/contents/app_recipe_timer.dart:52` curr='V=6' → 'AppSpacing.s6'  (numeric-not-found)
- `lib/components/contents/app_recipe_timer.dart:68` curr='space4' → 'AppSpacing.s4'  (needle-not-found)
- `lib/components/contents/app_recipe_timer.dart:77` curr='H=4' → 'AppSpacing.s4'  (numeric-not-found)
- `lib/components/contents/app_recipe_timer.dart:77` curr='space4' → 'AppSpacing.s4'  (needle-not-found)
- `lib/components/contents/app_recipe_timer.dart:78` curr='H=10' → 'AppSpacing.s10'  (numeric-not-found)
- `lib/components/contents/app_recipe_timer.dart:156` curr='space16' → 'AppSpacing.s16'  (needle-not-found)
- `lib/components/contents/app_recipe_timer.dart:116` curr='20' → 'AppSpacing.s20'  (numeric-not-found)
- `lib/components/contents/app_recipe_timer.dart:116` curr='20' → 'AppSpacing.s20'  (numeric-not-found)
- `lib/components/contents/app_review.dart:81` curr='space16' → 'AppSpacing.s16'  (needle-not-found)
- `lib/components/contents/app_review.dart:81` curr='H=16' → 'AppSpacing.s16'  (numeric-not-found)
- `lib/components/contents/app_review.dart:108` curr='space16' → 'AppSpacing.s16'  (needle-not-found)
- `lib/components/contents/app_review.dart:108` curr='H=16' → 'AppSpacing.s16'  (numeric-not-found)
- `lib/components/contents/app_review.dart:151` curr='space16' → 'AppSpacing.s16'  (needle-not-found)
- `lib/components/contents/app_review.dart:151` curr='H=16' → 'AppSpacing.s16'  (numeric-not-found)
- `lib/components/contents/app_review.dart:199` curr='space16' → 'AppSpacing.s16'  (needle-not-found)
- `lib/components/contents/app_review.dart:199` curr='H=16' → 'AppSpacing.s16'  (numeric-not-found)
- `lib/components/contents/app_review.dart:341` curr='right=1' → 'AppSpacing.s1'  (numeric-not-found)
- `lib/components/contents/app_review.dart:445` curr='space8' → 'AppSpacing.s8'  (needle-not-found)
- `lib/components/contents/app_review.dart:445` curr='space4' → 'AppSpacing.s4'  (needle-not-found)
- … 외 9건

