# 바텀시트 가이드 (이유미)

앱의 모든 슬라이딩 팝업(바텀시트)을 하나의 표준으로 통일하기 위한 가이드.
구현체는 [`lib/widgets/app_bottom_sheet.dart`](../lib/widgets/app_bottom_sheet.dart)의
`showAppSheet()` + `AppBottomSheet` 이다.

## 표준 3축

1. **상단 노출** — 시트는 화면 전체를 덮지 않는다. 높이 상한(`topReserve`, 기본 56)
   + 상단 안전영역만큼 위가 항상 비어, 아래 화면의 **네비게이션·타이틀·탭이 보인다.**
2. **버튼 하단 고정** — 주요 액션 버튼은 `footer` 에 둔다. 스크롤과 분리돼 항상 보이며,
   하단 안전영역(홈 인디케이터)·키보드 여백은 래퍼가 한 번만 처리한다.
3. **스크롤 영역** — 본문은 `body` 에 스크롤 컨테이너(`SingleChildScrollView`/`ListView`)로
   넣는다. `Flexible` 로 감싸 짧으면 줄고, 길면 상한까지 스크롤된다. `mainAxisSize.min`
   단독 사용(오버플로 위험) 금지.

## 사용법

```dart
showAppSheet<T>(
  context: context,
  backgroundColor: ...,            // 생략 시 테마 backgroundElevatedNormal
  builder: (_) => AppBottomSheet(
    header: <고정 헤더(타이틀)>,     // 선택
    body: SingleChildScrollView(...),// 필수, 자체 스크롤
    footer: <하단 고정 버튼>,        // 선택
  ),
);
```

- 모서리: `AppRadius.top(AppRadius.radius24)` (래퍼가 강제)
- 드래그 핸들: 36×4, `AppRadius.fullBorder` (기본 표시, `showHandle: false` 로 끔)
- `showModalBottomSheet` 를 직접 호출하지 말고 항상 `showAppSheet` 를 쓴다.

## 유형별 적용

- **A 입력 폼 / B 목록·선택 피커** → 3축 전체 적용(핸들+상한+하단버튼+스크롤).
- **C 휠/날짜 피커** → 높이 고정, 하단 확인버튼은 `footer`, 핸들만 추가.
- **D 액션·확인 시트(작음)** → 콘텐츠 높이 유지(상한·스크롤 불필요), 핸들·라운드만 표준화.

## 이관 현황

| 단계 | 시트 | 상태 |
|---|---|---|
| P0 | FeedingRecordSheet · CubeAddSheet · RecipeStepEditorSheet | ✅ 이관 완료 |
| P1 | EditRecordSheet · AllergyRecordSheet · IngredientPickerSheet · SavedRecipesPickerSheet | ✅ 이관 완료 |
| P2 | WheelPickerSheet · DatePickerSheet · ProfileSwitchSheet · _ReorderSheet | ⬜ 예정 |
| P3 | QuickRecord · ObservationComplete · RecordPhotoField · baby_avatar · FeedingHistory 액션 | ⬜ 예정(형태 토큰만) |

> 예외: `RecipeCompleteSheet` 는 바텀시트가 아니라 `Dialog.fullscreen` — 본 가이드 범위 밖.
