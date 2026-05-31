# 홈 화면 다크 테마 + 로고/아이콘/여백 정리 — 개발 리포트

## 작업 요약
사용자 요구 5건을 홈 화면에 적용. 검은 배경, SVG 로고, 회색 원 아이콘 3개, 카드 좌우 여백 0, 위아래 여백 축소.

## 수정 파일
1. `lib/modules/home/home_content.dart` — 주요 수정 (다크 배경, 로고 SVG, 회색 원 아이콘, 카드 여백 0)
2. `lib/modules/shell/main_shell_view.dart` — 홈 탭 컨텐츠 배경을 검은색으로 분기

## 변경 상세

### 1. 배경 검은색
- `home_content.dart` build 메서드 최외곽에 `Container(color: AppColor.colorGlobalCommon0)` 추가
- `main_shell_view.dart` 홈 탭일 때 `backgroundNormalAlternative` → `colorGlobalCommon0` 으로 분기 (그 외 탭은 기존 유지)

### 2. 로고 처리 — SVG 채택
- `flutter_svg ^2.0.9` 가 `pubspec.yaml` 에 이미 존재. 다른 화면 (survey_result_view 등)에서도 동일 패턴으로 사용 중
- `SvgPicture.asset('assets/images/logo_main.svg', height: 32)` 적용
- `Semantics(label: 'Coflanet', image: true)` 로 접근성 라벨 부여
- 기존 텍스트 "Coflanet" 워드마크 제거

### 3. 우측 액션 3개 — 회색 원 + 흰색 아이콘
- 토큰 선택: `AppColor.colorGlobalCoolNeutral25` (#37383C, 다크 그레이)
  - 사유: 검은 배경 (Common0 #000) 위에서 적절한 대비 + 시인성. 반투명 white 12% 대비 명도 안정적
- 아이콘 색: `AppColor.colorGlobalCommon100` (#FFF)
- 아이콘 사이즈 24 → 20, 컨테이너 40x40 원형
- 아이콘 사이 `SizedBox(width: 8)` 추가

### 4. 카드 좌우 여백 0
- 보유 원두 섹션: `margin: EdgeInsets.symmetric(horizontal: 16)` 제거, `borderRadius` 제거 (모서리 직각)
- 노란 취향 배너: 동일
- 취향 추천 그리드: `Container` margin 제거, 배경색은 `colorGlobalCoolNeutral15` 로 변경 (다크 테마 어울리는 카드 배경)
- 캐러셀: `Padding(horizontal: 16)` 제거, `borderRadius` 제거
- 인기 랭킹/실시간 인기: 섹션 헤더 `Padding(horizontal: 16)` 은 유지 (텍스트 그리드 가독성)

### 5. 위아래 여백 축소
- 캐러셀 높이 220 → 200
- 카드 사이 SizedBox: 20/16/24 → 4/12/8/12/12
- `_buildMyBeanSection` 패딩 20 → 16
- `_buildTasteBanner` vertical 16 → 14
- 섹션 헤더 → 그리드 간격: 12 → 10
- 빈 상태 패딩 32 → 28
- 외곽 SafeArea bottom padding 24 → 16

### 6. 다크 테마 대비 색상 보정
- 캐러셀 placeholder 배경: `colorGlobalCoolNeutral95` (밝은 회색) → `colorGlobalCoolNeutral17` (다크)
- 캐러셀 텍스트 색: `labelNormal` → `colorGlobalCommon100` (흰색)
- 그리드 섹션 헤더 텍스트: `labelNormal` → `colorGlobalCommon100`
- 빈 상태 카드 배경: 흰색 → `colorGlobalCoolNeutral20`, 텍스트 흰색 계열

## 검증 결과

### flutter analyze
```
Analyzing 2 items...
No issues found! (ran in 1.5s)
```

### APK 빌드 + 설치 + 실행
- 빌드: `flutter build apk --debug` → `app-debug.apk` 빌드 성공 (Gradle 8.7s)
- 설치: `adb install -r` → Success
- 실행: `adb shell monkey -p com.coflanet.tech.app` → 정상 실행
- 패키지명: `com.coflanet.tech.app` (Manifest 기준)

### 캡처
- 위치: `verification/home/captures/01_home_main_app_v3.png`
- 확인 사항:
  - 상태바/배경 모두 검은색
  - 좌측 Coflanet 로고 SVG (워드마크) 정상 렌더링
  - 우측 회색 원 3개 (검색/알림/장바구니) 흰색 아이콘
  - 보라 카드/노란 카드 화면 좌우 끝까지 닿음 (여백 0)
  - 카드 사이 간격 축소 확인
  - 카드 모서리는 직각 (좌우 여백 0 → radius 0 시각 일관)

## 디자인 판단 (사용자 명시 외)
- **카드 모서리 radius 제거**: 좌우 여백 0 이면 둥근 모서리가 잘려 보여 직각이 자연스러움. 카드 분리감은 색상 대비로 표현
- **인기 랭킹/실시간 인기 섹션 헤더 좌우 패딩 유지**: 텍스트가 화면 끝에 붙으면 가독성 저하. 카드/그리드는 끝까지 닿게 했지만 단순 헤더 텍스트는 16px 패딩 유지
- **회색 원 색상**: `withValues(alpha: 0.12)` 같은 반투명 대신 `colorGlobalCoolNeutral25` 사용 — 다크 토큰 시스템 활용으로 일관성 확보

## 남은 사항
- 캐러셀 인디케이터 (1/5) 가 어두운 배경에 어두운 반투명이라 대비 약함 — 사용자 명시 없어 미수정
- 캐러셀 placeholder 텍스트가 좌측 끝에 붙음 (20px 내부 패딩 유지) — 의도된 디자인

## 빌드 경고 (참고)
- Gradle/Kotlin/AGP 버전 경고: 빌드 영향 없음, 향후 업그레이드 필요 — 본 작업 범위 외
