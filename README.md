# Coflanet App

커피 레시피 탐색 및 테이스트 매칭을 위한 Flutter 모바일 앱입니다.
취향 설문을 완료하면 커피 프로필 타입에 매칭되고, 핸드드립/에스프레소 단계별 추출 타이머를 사용할 수 있습니다.

## 환경 요구사항

| 항목 | 버전 |
|------|------|
| Flutter | 3.38.x (stable) |
| Dart SDK | ^3.9.2 |
| Xcode | 16.x+ (iOS/macOS 빌드) |
| Android SDK | minSdk 21+ |

## 프로젝트 구조

```
lib/
├── constants/           # 디자인 토큰 (색상, 텍스트 스타일, 에셋 경로)
├── core/
│   ├── api/             # Dio HTTP 클라이언트
│   ├── base/            # BaseController (로딩/에러/성공)
│   ├── storage/         # GetStorage 래퍼
│   └── theme/           # 라이트/다크 테마
├── data/
│   ├── dummy/           # 더미 데이터
│   ├── models/          # 데이터 모델
│   └── repositories/    # Repository 패턴 (Dummy/API 추상화)
├── modules/             # 기능 모듈 (화면 + 컨트롤러 + 바인딩)
│   ├── auth/            # 로그인 (카카오, 네이버, 애플), 계정 연동
│   ├── coffee/          # 핸드드립, 에스프레소, 타이머, 설정, 원두 선택
│   ├── extraction/      # 추출 목록
│   ├── matching/        # 매칭 결과
│   ├── onboarding/      # 설문 (인트로, 질문, 분석, 결과)
│   ├── planet/          # 마이 플래닛
│   ├── profile/         # 프로필, 마이테이스트
│   ├── shell/           # 메인 셸 (탭 네비게이션)
│   ├── splash/          # 스플래시
│   └── tasting/         # 테이스팅 노트
├── routes/              # GetX 라우트 정의
└── widgets/             # 공유 위젯 (버튼, 모달, 타이머)
```

## 아키텍처

**MVVM + GetX** 패턴을 사용합니다.

```
View (GetView<Controller>) → Controller (GetxController) → Repository → Model
                              ↕ Binding (Get.lazyPut)
```

- **View**: `GetView<XController>` — UI만 담당, `Obx()`로 반응형 렌더링
- **Controller**: `GetxController` — 비즈니스 로직, `.obs` 옵저버블
- **Binding**: 컨트롤러 등록 (`Get.lazyPut` / `Get.put`)
- **Repository**: `Dummy`/`API` 구현체 전환 (`RepositoryConfig.useDummyData`)

## 주요 의존성

| 패키지 | 용도 |
|--------|------|
| `get` | 상태관리, 라우팅, DI |
| `dio` | HTTP 클라이언트 |
| `get_storage` | 로컬 저장소 |
| `flutter_svg` | SVG 렌더링 |
| `cached_network_image` | 이미지 캐싱 |
| `shimmer` | 로딩 시머 효과 |
| `intl` | 국제화/포맷팅 |
| `uuid` | 고유 ID 생성 |
| `kakao_flutter_sdk_user` | 카카오 로그인 |
| `flutter_naver_login` | 네이버 로그인 |
| `sign_in_with_apple` | 애플 로그인 |

## 빌드 및 실행

```bash
# 의존성 설치
flutter pub get

# macOS (디버그)
flutter run -d macos

# iOS 시뮬레이터
flutter run -d <simulator-id>

# Android 에뮬레이터
flutter run -d emulator-5554

# 웹
flutter run -d chrome
```

### 릴리즈 빌드

```bash
# Android APK
flutter build apk --release

# iOS (코드사인 없이 디버그)
flutter build ios --debug --no-codesign

# Web
flutter build web --no-tree-shake-icons
```

## 테스트

```bash
# 전체 E2E 통합 테스트 (20개 화면)
flutter test integration_test/app_test.dart -d <device-id>

# 레시피 저장 통합 테스트
flutter test integration_test/recipe_save_test.dart -d <device-id>

# 예시: macOS에서 실행
flutter test integration_test/app_test.dart -d macos

# 예시: iOS 시뮬레이터에서 실행
flutter test integration_test/recipe_save_test.dart -d 96CA9BEF-37CF-4492-BD79-FBCEFD4877CB
```

## 환경 설정

소셜 로그인 SDK 키는 `.env` 파일에 설정합니다. 상세 가이드: `docs/SOCIAL_LOGIN_SETUP.md`

```env
KAKAO_NATIVE_APP_KEY=...
NAVER_CLIENT_ID=...
NAVER_CLIENT_SECRET=...
```
