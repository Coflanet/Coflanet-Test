# 홈 화면 작업 보고 (작업 A + B)

## 작업 A: 5탭 바텀 네비게이션 정합

Figma `Home_Item_yes` 와 `02_home_alt_figma.png` 하단을 분석한 결과 5개 탭 구조 확인:
1. 홈 (home_rounded)
2. 원두 (coffee_rounded)
3. 커뮤니티 (forum_rounded)
4. 쇼핑 (shopping_bag_rounded)
5. 마이 (person_rounded)

기존 앱은 4탭 (원두 / 추출 목록 / 시음 기록 / My 행성). 추출 목록/시음 기록은 Figma 5탭에 부재 → 인앱 다른 영역에서 접근 가능하도록 코드 보존 (라우트 미연결).

### 변경 파일
- `lib/modules/shell/main_shell_view.dart` — `_tabs` 5개로 확장, `_buildCurrentTab` switch 갱신, tabBar width 화면 폭 비례
- `lib/modules/shell/main_shell_controller.dart` — `tabHome/tabBean/tabCommunity/tabShopping/tabMy` 상수화, `_maxTabIndex = 4`
- `lib/modules/shell/main_shell_binding.dart` — HomeController 등록, ExtractionListController/TastingNotesController 제거

## 작업 B: Home_Item_yes UI 작성

Figma `Home_Item_yes` 캡쳐 분석 결과 5섹션 구성:
1. 보유 원두 캐러셀 (보라 카드, 스토어 데이터 사용)
2. 노란 취향 배너 (설문 완료 시)
3. 취향 기반 추천 2열 그리드 (백엔드 미연동 → empty)
4. 카테고리별 베스트 (백엔드 미연동 → empty)
5. 실시간 인기 (백엔드 미연동 → empty)

### 변경 파일
- `lib/modules/home/home_controller.dart` — 신규 (보유 원두 = CoffeeRepository, 추천/카테고리/실시간 = [백엔드 API 연동 대기])
- `lib/modules/home/home_content.dart` — 신규 (5섹션 + empty 분기 + 좋아요 토글)
- `lib/modules/community/community_content.dart` — 신규 (placeholder)
- `lib/modules/shopping/shopping_content.dart` — 신규 (placeholder)

## 결정 사유
- 5번째 탭(홈) 첫 위치 결정: Figma 캡쳐의 활성 상태가 `홈` 이며 보라색으로 강조 → index 0
- `마이` 마지막 위치: 일관성 (대부분 모바일 앱에서 My 가 마지막)
- 라벨 길이: `커뮤니티`(4글자) 가 가장 길어서 폭 비례 + ellipsis 처리
- 추출/시음 코드 보존: 기존 라우트/컨트롤러를 잃지 않도록 (재사용 가능)

## 검증
- `flutter analyze lib/` → No issues found
