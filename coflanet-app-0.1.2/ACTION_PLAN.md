# Coflanet App — Action Plan

> 대상: `coflanet-app-0.1.2` (Flutter 3.38.x / Dart ^3.9.2, v0.1.2+1)
> 작성일: 2026-05-11
> 목표: 0.1.x 안정화 → 0.2 (백엔드 통합) → 1.0 (스토어 출시)

상위 문서: [`README.md`](README.md), [`docs/SOCIAL_LOGIN_SETUP.md`](docs/SOCIAL_LOGIN_SETUP.md)

---

## 0. 현황 스냅샷

| 영역 | 상태 |
|---|---|
| 모듈 10개 (auth, coffee, extraction, matching, onboarding, planet, profile, shell, splash, tasting) | 8개 프로덕션 수준, 1개 부분(Espresso/Timer), 1개 스텁(Tasting) |
| Repository 레이어 | `Dummy` / `Supabase` / `Api` 3중 구현, 기본값은 `supabase` |
| 백엔드 통합 | `lib/data/repositories/api/*` 약 722 LOC 구현되어 있으나 미활성 (`api.coflanet.com/v1` 하드코딩) |
| 테스트 | 통합 테스트 9개 / 3,238 LOC, 유닛 테스트 2개 / 171 LOC |
| CI/CD | `.github/workflows/`에 ci, e2e, release, deploy, pr-policy-check 5개 워크플로 |
| 빌드 | Android 서명 GitHub Secrets, iOS 프로비저닝 구성, 버전 `0.1.2+1` |

---

## 1. 우선순위 (P0 → P3)

### P0 — 0.1.x 안정화 (2주)

릴리즈 직전 막는 항목. 머지 전 머스트.

- [ ] **Tasting 모듈 구현**
  - `lib/modules/tasting/` 컨트롤러가 placeholder (`"Future: tasting notes, flavor wheel, etc."`).
  - 최소 스코프: 노트 목록 + 작성 폼 (테이스팅 시 저장된 향미를 카드로 표시).
  - Repository는 우선 `Dummy` + `Supabase` 어댑터, API는 P1로 미룸.

- [ ] **Espresso / CoffeeTimer 컨트롤러 마감**
  - `EspressoSettingsController`, `CoffeeTimerController`가 부분 구현.
  - 핸드드립 단계별 타이머와 동일한 패턴으로 추출 단계 → 저장 → 로그 흐름 완결.

- [ ] **Splash 개발 플래그 제거**
  - `splash_controller.dart:37–44`의 `_devForceOnboarding`, `_devForceSignIn`, `_devForceSurveyResult`, `_devForceMainShell`는 릴리즈 빌드에서 제외.
  - `kReleaseMode` 가드 또는 `--dart-define` 기반 토글로 교체.

- [ ] **`ApiClient` 베이스 URL 환경화**
  - `https://api.coflanet.com/v1` 하드코딩 → `.env`의 `API_BASE_URL`로 이전.
  - `.env.example`에 항목 추가.

- [ ] **BrewLog API 어댑터 채우기**
  - `ApiBrewLogRepository`가 현재 `DummyBrewLogRepository()`로 폴백 (repositories/repository_provider.dart:91).
  - 최소한 인터페이스 메서드 시그니처 맞춰 `UnimplementedError`를 명시적으로 던지거나, Supabase 구현 재사용.

### P1 — 0.2 백엔드 통합 (3–4주)

`coflanet-backend-main`이 사이드에 존재하지만 앱에서 연결 안 됨. Supabase RPC에서 자체 REST로 이관.

- [ ] **Repository dataSource 전환 계획 수립**
  - `RepositoryConfig.dataSource`를 모듈 단위로 점진 전환 (Auth → Survey → Coffee → Recipe → UserPrefs → BrewLog).
  - 환경별 토글 (`dev` / `staging` / `prod`) `--dart-define`로.

- [ ] **API 미구현 메서드 채우기**
  - `ApiCoffeeRepository.addToCoffeeList` → `UnimplementedError` 제거.
  - `ApiCoffeeRepository.getCoffeeCatalog` 스텁 → 실제 페이지네이션 구현.
  - 백엔드 OpenAPI 스펙(`coflanet-backend-main/docs/api-specs`)과 시그니처 정합성 점검.

- [ ] **Supabase RPC → 백엔드 REST 매핑 매트릭스**
  - `get_onboarding_status`, `start_survey`, `complete_survey` 등 RPC가 백엔드 어느 엔드포인트에 대응되는지 표로 정리 후 `docs/api-mapping.md` 추가.

- [ ] **토큰 갱신/로그아웃 흐름 검증**
  - `/auth/refresh`, `/auth/logout`, `/auth/delete-account` 401/403 처리 일관성. Dio 인터셉터 (`lib/core/api/`) 단일 책임.

### P2 — 품질 / 테스트 (2주)

- [ ] **유닛 테스트 격차 메우기**
  - 현재 `test/`는 `survey_score_test.dart`, `widget_test.dart` 2개뿐. Controller / Repository 단위 테스트 부재.
  - 우선순위: `SurveyController`, `CoffeeController`, `ExtractionListController` (페이지네이션 로직), `MyPlanetController`.

- [ ] **Repository 추상화 계약 테스트**
  - `Dummy` / `Supabase` / `Api` 3구현이 같은 인터페이스를 따르는지 셰어드 테스트 슈트.

- [ ] **분석/포맷팅 게이트 강화**
  - `analysis_options.yaml`에 `prefer_const_constructors`, `avoid_print`, `unawaited_futures` 등 lint 추가.
  - CI `ci.yml`의 `flutter analyze`가 fatal-warnings로 실패하도록.

- [ ] **통합 테스트 안정화**
  - 9개 통합 테스트 (3,238 LOC)가 CI 환경 (`CI_TEST=true`)에서 Dummy로 동작하는지 정기 실행.
  - flaky 케이스 격리.

### P3 — 출시 준비 (스토어 이전 1–2주)

- [ ] **앱 메타 정리**
  - iOS `CFBundleDisplayName`, Android `android:label`, 앱 아이콘 (`App Icon/`, `Icon/`, `Logo/` 활용) 최종 일치.
  - `pubspec.yaml` 버전 `0.1.2+1` → `1.0.0+1` 정책.

- [ ] **법적 문서 / 권한 고지**
  - `docs/legal/` 내용을 인앱 표기 (Settings → 약관/개인정보) 연결 확인.
  - iOS `Info.plist` 권한 사유 문자열, Android `AndroidManifest.xml` 권한 최소화.

- [ ] **딥링크 / 소셜 로그인 콜백 검증**
  - Kakao / Naver / Apple 콜백 URL, 패키지명, 키 해시 운영 환경 값 점검.

- [ ] **스토어 등록 자산**
  - Play Store / App Store 스크린샷, 설명, 키워드 — `assets/` 정리.

---

## 2. 모듈별 작업 추적

| 모듈 | 상태 | 다음 액션 | 우선 |
|---|---|---|---|
| auth | ✅ Supabase + 3-social OAuth | API 어댑터 토큰 갱신 통합 | P1 |
| coffee (handdrip) | ✅ 추출/저장/로그 | — | — |
| coffee (espresso) | ⚠ 부분 | 컨트롤러 완성 | P0 |
| coffee (timer) | ⚠ 부분 | 컨트롤러 완성 | P0 |
| extraction | ✅ 페이지네이션/통계 | — | — |
| matching | ✅ Survey 결과 표시 | — | — |
| onboarding | ✅ 8 서브페이지 | — | — |
| planet | ✅ 프로필/로그아웃/탈퇴 | `savedRecipes` 호환 코드 제거 검토 | P2 |
| profile | ✅ 테이스트 차트 | — | — |
| shell | ✅ 4탭 + 테마 스위칭 | — | — |
| splash | ✅ + dev 플래그 | dev 플래그 가드 | P0 |
| tasting | ⛔ 스텁 | 노트 목록 + 작성 폼 구현 | P0 |

---

## 3. 기술 부채 / 청소 항목

- **하드코딩된 베이스 URL**: `ApiClient`의 `https://api.coflanet.com/v1` → `.env` 기반.
- **Dev-only 토글 4종**: `SplashController` 정리.
- **`savedRecipes` (MyPlanetController) backward-compat 필드**: 사용처 확인 후 제거.
- **Backend 디렉토리 위치**: `coflanet-backend-main/coflanet-backend-main/` 이중 중첩 — 리포 정리 시 평탄화 후보 (별도 PR).

---

## 4. 의존성 / 환경

- Flutter `3.38.x` stable, Dart `^3.9.2` 유지. 다음 stable 픽업은 P3 이후 별도 검토.
- 주요 의존성 핀 변경 시:
  - `get ^4.6.6` — 5.x 마이그레이션은 별도 RFC.
  - `dio ^5.4.0` — 인터셉터 API 호환성 점검.
  - `supabase_flutter ^2.8.4` — REST 전환 후 의존성 제거 가능 여부 평가.
- `.env` 누락 시 빌드 실패 메시지 명확화.

---

## 5. 마일스톤

| 마일스톤 | 범위 | 종료 조건 |
|---|---|---|
| **M1: 0.1.3** | P0 전체 | Tasting/Espresso/Timer 머지, dev 플래그 제거, API URL 환경화 |
| **M2: 0.2.0-beta** | P1 + P2 일부 | dev 환경에서 `dataSource = api`로 풀 플로우 통과 |
| **M3: 0.2.0** | P1 잔여 + P2 전체 | staging에서 통합 테스트 9개 + 유닛 테스트 통과 |
| **M4: 1.0.0** | P3 | 스토어 심사 통과, prod 트래픽 받기 |

---

## 6. 추적 / 갱신 규칙

- 본 문서는 **머지 단위로 갱신**. 항목 완료 시 체크박스 변경 + 짧은 PR 링크.
- 새 작업은 P0–P3 중 분류 후 모듈 표에 반영.
- 분기마다 (3개월) 마일스톤 재조정.
