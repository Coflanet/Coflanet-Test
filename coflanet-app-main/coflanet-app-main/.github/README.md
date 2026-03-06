# GitHub Actions Workflows

## 워크플로우 목록

| 워크플로우 | 파일 | 트리거 | 설명 |
|------------|------|--------|------|
| CI | `ci.yml` | push/PR to `main` | 코드 포맷 검사, 정적 분석, 단위 테스트, 의존성 체크 |
| E2E Test | `e2e.yml` | 수동 실행 | iOS 시뮬레이터에서 통합(E2E) 테스트 실행 |
| Release | `release.yml` | 수동 실행 | Android APK/AAB + iOS IPA 빌드 후 GitHub Release 생성 |
| Deploy | `deploy.yml` | 수동 실행 | Release 아티팩트를 Google Play / TestFlight에 배포 |

---

## CI (`ci.yml`)

**트리거**: `main` 브랜치에 push 또는 PR 생성 시 자동 실행

코드 품질을 자동으로 검증합니다:

- **Format Check** — `dart format --set-exit-if-changed .`
- **Analyze & Test** — `flutter analyze` + `flutter test --coverage`
- **Dependency Check** — `flutter pub outdated`

> 마크다운, 문서, 이미지 등 코드와 무관한 변경은 트리거하지 않습니다.

## E2E Test (`e2e.yml`)

**트리거**: Actions 탭에서 수동 실행 (`workflow_dispatch`)

iOS 시뮬레이터에서 전체 앱 플로우를 검증하는 통합 테스트를 실행합니다.
`--dart-define=CI_TEST=true`로 더미 데이터 모드를 강제합니다.

## Release (`release.yml`)

**트리거**: Actions 탭에서 수동 실행 — 버전 태그 입력 필요 (예: `v1.0.0`)

빌드 및 릴리즈 파이프라인:

1. **Android** — signed APK + AAB 빌드 (키스토어 미등록 시 debug 키 fallback)
2. **iOS** — signed IPA 빌드 (인증서 미등록 시 unsigned fallback)
3. **GitHub Release** — 태그 생성 + 아티팩트 첨부

### 필요한 Secrets
- `ANDROID_KEYSTORE_BASE64`, `ANDROID_KEY_ALIAS`, `ANDROID_KEY_PASSWORD`, `ANDROID_STORE_PASSWORD`
- `IOS_CERTIFICATE_BASE64`, `IOS_CERTIFICATE_PASSWORD`, `IOS_PROVISION_PROFILE_BASE64`

## Deploy (`deploy.yml`)

**트리거**: Actions 탭에서 수동 실행 — 릴리즈 태그, 플랫폼, 트랙 선택

Release 워크플로우에서 생성된 아티팩트를 스토어에 업로드합니다:

- **Google Play** — AAB를 지정한 트랙(internal/alpha/beta/production)에 업로드
- **TestFlight** — IPA를 App Store Connect에 업로드

### 필요한 Secrets
- `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON`
- `APP_STORE_CONNECT_API_KEY_ID`, `APP_STORE_CONNECT_ISSUER_ID`, `APP_STORE_CONNECT_API_KEY_BASE64`

---

## GitHub Secrets 전체 목록

### 앱 환경 변수 (CI + Release + E2E에서 .env 생성용)
| Secret | 용도 |
|--------|------|
| `KAKAO_NATIVE_APP_KEY` | 카카오 로그인 URL scheme |
| `NAVER_CLIENT_ID` | 네이버 로그인 SDK |
| `NAVER_CLIENT_SECRET` | 네이버 로그인 SDK |
| `SUPABASE_URL` | Supabase 프로젝트 URL |
| `SUPABASE_ANON_KEY` | Supabase 익명 API 키 |

### CI/CD 전용 (Release, Deploy에서만 사용)
| Secret | 용도 | 워크플로우 |
|--------|------|-----------|
| `ANDROID_KEYSTORE_BASE64` | Android 서명 키스토어 | Release |
| `ANDROID_KEY_ALIAS` | 키스토어 alias | Release |
| `ANDROID_KEY_PASSWORD` | 키 비밀번호 | Release |
| `ANDROID_STORE_PASSWORD` | 스토어 비밀번호 | Release |
| `IOS_CERTIFICATE_BASE64` | iOS 배포 인증서 | Release |
| `IOS_CERTIFICATE_PASSWORD` | 인증서 비밀번호 | Release |
| `IOS_PROVISION_PROFILE_BASE64` | 프로비저닝 프로파일 | Release |
| `APP_STORE_CONNECT_API_KEY_ID` | ASC API Key ID | Deploy |
| `APP_STORE_CONNECT_ISSUER_ID` | ASC Issuer ID | Deploy |
| `APP_STORE_CONNECT_API_KEY_BASE64` | ASC API Key (.p8) | Deploy |
| `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON` | GCP 서비스 계정 JSON | Deploy |
