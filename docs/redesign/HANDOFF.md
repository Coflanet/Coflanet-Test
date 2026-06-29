# 🤝 로컬 세션 인수인계 (Handoff)

> 이 문서 하나로 이어받을 수 있게 정리했다. 먼저 이걸 읽고 → `00-master-plan.md` → 필요한 task 문서 순으로.
> 작성 시점 HEAD: **`5ebefbc`** · 브랜치 **`redesign/magical-cray`** · 리포 **`Coflanet/Coflanet-Test`**

---

## 0. 30초 요약

- **무엇**: Coflanet(커피 Flutter 앱) — ① 유저 플로우 검증·수정 ② Figma(POC) 기준 화면 충실도(정합) ③ **iyumi 카드형 + Static/Black 배경** 디자인 시스템 적용 ④ component_lab 라이브러리 마이그레이션(예정).
- **지금까지**: 주요 화면을 **Figma POC 기준으로 정합**(홈·온보딩 전 단계·타이머·원두/레시피·마이·signin) + **쇼핑 탭 카드 스타일 신규 구현** + **시음노트(커피 저널) 신규 구현** + **4탭 셸**(홈/원두/쇼핑/마이) 확정. `flutter analyze`/`flutter test` 그린.
- **남은 핵심**: ① **신규 이미지 17컷 누끼(배경제거)·반영**(현재 폴백 아이콘 유지) ② **component_lab 라이브러리 마이그레이션(P2)**.
- **첫 명령**: `flutter pub get && flutter analyze && flutter test`.

---

## 1. 현재 상태

| 항목 | 값 |
|------|----|
| 브랜치 | `redesign/magical-cray` |
| 리포 | `Coflanet/Coflanet-Test` (origin) |
| HEAD | `5ebefbc` — `fix(intl): 앱 시작 시 ko 로케일 날짜 포맷 초기화` |
| 버전 | `0.1.2+1` (pubspec) |
| `flutter analyze` | 🟢 0 errors (info/warning은 `integration_test/` 스캐폴딩 잔여 25건뿐) |
| `flutter test` | 🟢 통과 |
| 테스트 APK | `flutter build apk --release` → key.properties 없으면 **debug 서명으로 폴백**(테스트 빌드). `.github/workflows/test-build.yml`로 push마다 자동 빌드도 가능 |
| 릴리즈 | 테스트 프리릴리즈 태그 `v0.1.2-test.1`(prerelease, target=`redesign/magical-cray`)로 APK 배포 |

> 정식 서명 릴리즈는 `release.yml`(workflow_dispatch) 또는 `v*` 태그 push로 가능. 본 테스트 APK는 debug 서명이라 배포 검증용이며 스토어 업로드용 아님.

---

## 2. 이미 끝난 것 (analyze/test 그린)

### Figma(POC) 기준 화면 충실도 — 이번 리디자인 핵심
| 커밋 | 내용 |
|------|------|
| `8699412` | signin Figma 충실도 |
| `8e5741e`·`e56c0f6`·`247495c` | 온보딩 설문 화면 충실도 + CTA pill·진행바 트랙·선택칩/기구카드·마이 보정 |
| `3196332`·`ad4ae4c`·`0a4ad90` | 온보딩 인트로·인덱스·섹션인트로·분석중·완료·결과 화면 충실도 |
| `4cf0e60`·`041b906`·`0918b12` | 온보딩 숙련도 옵션 정리·결과 데드엔드 CTA 연결·분석중 중앙정렬 QA |
| `30cd666`·`09c6ac2` | 홈 Figma 정밀 정합 + 빈 섹션 콘텐츠 채움 |
| `035a104`·`394447a`·`38c9252` | 원두목록·레시피·타이머·마이 충실도 |

### 신규 화면
| 커밋 | 내용 |
|------|------|
| `8be2206` | **쇼핑 탭** Figma 기준 카드 스타일 신규 구현(placeholder → 실제 화면) |
| `8a79a7c` | **시음노트(커피 저널)** 신규 구현 — 타이머 완료/추출 기록 진입 |
| `d4c0178` | 버튼 lg 라벨·공유 헤더·완료화면 타이포/토큰 정리 |
| `5ebefbc` | 앱 시작 시 ko 로케일 날짜 포맷 초기화 |

### 디자인 시스템 toolkit / 플로우 (이전 단계)
- Static/Black 카드 toolkit(`AppColor.staticBlack/White`, `AppColorScheme.canvas`, `AppSpacing` 카드 토큰, `AppRadius.sectionRadius(40)/itemRadius(24)`, `lib/widgets/cards/{card_section,screen_scaffold}.dart`).
- 플로우: 커뮤니티 탭 숨김(4탭, 쇼핑 유지)·홈 장바구니 숨김·ExtractionList 활성화·하드코딩 간격 토큰화.

### 문서/스킬
- `.claude/skills/coflanet-design-guide/` — **카드 디자인 강제 스킬**(다음 세션 자동 발동). 화면 작업 전 반드시 참조.
- `docs/redesign/` 전체(아래 §7).

---

## 3. 확정된 결정 (그대로 따른다)

| # | 결정 |
|---|------|
| 디자인 | iyumi 카드 패턴(`CardSection` r40 / `CardItem` r24, **무그림자** — 표면 대비로 분리) |
| 배경 | **Static/Black(#000000) 캔버스 — 라이트·다크 공통** |
| 카드 방향 | **B**: 라이트=흰 카드 / 다크=다크 카드 |
| 색 규칙 | **카드 밖(캔버스)=`AppColorScheme.canvas`(다크 스킴) / 카드 안=`of(context)`(활성 스킴)**. 토글하면 캔버스 불변·카드만 전환 |
| 탭 | 홈/원두/**쇼핑(취향 추천, 유지)**/마이 4탭. 커뮤니티 숨김. 장바구니·결제 숨김(MVP 밖) |
| 추출/시음 | ExtractionList(추출 기록)+TastingNotes를 **"커피 저널"**로: 타이머 완료→시음 노트, 추출 기록 상세에서 노트 보기 |
| SurveyReason | 가입 이유 설문 **항상 노출**(전 가입 경로 공통 단계로 승격) |
| 마이그레이션 방식 | component_lab은 앱을 역의존(순환) → **소스 흡수(vendoring)**. 컬러 아키텍처는 앱의 `AppColorScheme` 유지, 값/컴포넌트만 흡수 |

---

## 4. 다음 할 일 (우선순위)

> 아래 두 항목이 이번 테스트 빌드(`v0.1.2-test.1`)에 **미포함**이며 남은 핵심이다.

### P1 — 신규 이미지 17컷 누끼·반영 (사용자 작업 대기)
- [ ] 흰 배경 생성본 17컷의 **누끼(배경 제거)** — 이건 사용자 수작업이라 이번 빌드 미반영.
- [ ] 누끼 완료분을 `assets/images/`에 배치 + 코드 폴백 아이콘 → 실제 이미지로 교체.
- 현재 상태: **폴백 아이콘 유지**(빌드/화면은 정상). 명세는 `image-production-list.md`.

### P2 — 라이브러리 마이그레이션 (`02-library-migration.md`)
- [ ] component_lab foundation/components를 토큰 매핑(`reference/token-mapping.md`)대로 흡수. 버튼(완전검증)→칩→카드→폼→모달 순. P0 누락 위젯 10종.
- 별도 작업이라 이번 빌드 제외.

### 위생 (선택)
- [ ] `integration_test/` 스캐폴딩 잔여 warning/info 25건 정리(미사용 변수·`avoid_print`). analyze는 이미 0 errors라 빌드엔 영향 없음.

---

## 5. 작업 방법 (어떻게)

- **디자인**: 화면 만들/고칠 때 `coflanet-design-guide` 스킬이 자동 발동 → CardSection/CardItem/ScreenScaffold + 토큰 + 색 규칙 강제. 숫자 하드코딩 금지.
- **toolkit 위젯**:
  - `ScreenScaffold(title:…, useScaffold:false(셸 탭)/true(푸시), scrollable:…, child:…)`
  - `CardSection(title:…, trailing:…, child:…)` (큰 카드) → 안에 `CardItem`(작은 카드) + `CardGap`.
- **색**: 카드 밖 = `AppColorScheme.canvas`, 카드 안 = `AppColorScheme.of(context)`.
- **검증 루프**: 로컬은 `flutter run`으로 즉시 확인(원격 세션은 이게 안 돼서 느렸음). push하면 `test-build`가 APK도 만들어줌.
- **게이트**: `flutter analyze` 0 + `flutter test` 통과 + 라이트/다크 스냅샷.

---

## 6. 함정 / 주의

- **검정 캔버스 위 텍스트**: `labelNormal`(라이트=어두움) 쓰면 검정 위 검정으로 사라짐 → 카드 밖은 반드시 `AppColorScheme.canvas`(다크 스킴). 셸 탭바가 이미 이 방식(고정 다크 글래스).
- **탭 인덱스 보존**: 커뮤니티(2) 숨김은 `shell_tab_bar.dart`에서 렌더만 제외(인덱스·`_buildCurrentTab`·`_resolveTitle`은 5탭 기준 유지). 재인덱싱하지 말 것.
- **`AppShadows` 이미 존재**(예: `shadowBlackEmphasize`). 그림자 신설 불필요. 카드엔 그림자 안 씀.
- **Component/fill 네이밍 충돌**(Figma 8% vs 앱 5%): 값 변경 금지·주석화(디자이너 합의 전).
- **순환 의존**: component_lab을 path 의존으로 끌어오지 말 것(소스 흡수).
- **iyumi**: 별개 이유식 앱이지만 같은 Coflanet CDS 공유 → 토큰 호환. 카드 스펙은 `reference/iyumi/card-design-spec.md`.

---

## 7. 참고 자료 맵

### 계획 문서 (`docs/redesign/`)
| 파일 | 내용 |
|------|------|
| `00-master-plan.md` | 전체 계획·결정·Phase·리스크·DoD |
| `01-user-flow-audit.md` | 라우트 맵·E2E 여정·블로커 + 결정 |
| `01a-flow-defects.md` | 인터랙션/데이터 결함 전수(파일:라인) + 구현현황 |
| `02-library-migration.md` | component_lab 흡수 전략·단계 |
| `03-style-application.md` | 간격/타이포/반경/색 적용 절차 |
| `04-static-black-theme.md` | **Static/Black + 카드 색 매핑·규칙**(필독) |
| `05-iyumi-reference.md` | iyumi 정체·카드 스펙 요약 |
| `image-production-list.md` | 이미지 생성 명세 |
| `reference/current-design-system.md` | 현재 앱 토큰 스냅샷(AS-IS) |
| `reference/component-lab-inventory.md` | 라이브러리 인벤토리(TO-BE) |
| `reference/token-mapping.md` | 토큰 변환표·체크리스트 |
| `reference/iyumi/` | iyumi 카드/바텀시트/홈IA 원본 스펙(vendored) |

### 핵심 코드 위치
| 영역 | 경로 |
|------|------|
| 토큰 | `lib/constants/{color_constant,app_color_scheme,style_constant,spacing_constant,radius_constant}.dart` |
| 테마 | `lib/core/theme/app_theme.dart`, `theme_controller.dart` |
| **카드 toolkit** | `lib/widgets/cards/{card_section,screen_scaffold}.dart` |
| 라우트 | `lib/routes/{app_routes,app_pages}.dart` |
| 셸 | `lib/modules/shell/` |
| 데이터/레포 | `lib/data/` (Dummy/Supabase 전환: `RepositoryConfig.dataSource`) |

### 외부
- 라이브러리: `Coflanet/Coflanet-Test` → `Library/component_lab/` (HANDOFF.md, ACTION_PLAN.md, foundation/, components/)
- 디자인 시스템 스킬: `.claude/skills/coflanet-design-guide/`

---

## 8. 백엔드 / 인프라 메모

- **백엔드 = Supabase**(DB-only 모드, Auth는 소셜로그인 SDK). 스키마/마이그레이션: `supabase/` 디렉터리. 키는 `.env`(`SUPABASE_URL`/`SUPABASE_ANON_KEY` 등, `.env.example` 참고).
- 데이터 소스 전환: `lib/data/repositories/repository_config.dart`(`dataSource` = dummy/supabase). 더미로 UI 개발 가능.
- 소셜 로그인: 카카오/네이버/애플 — 키는 `.env`, 가이드 `docs/SOCIAL_LOGIN_SETUP.md`(레포 로컬).
- CI/CD: `.github/workflows/` — `ci.yml`(format/analyze/test), `release.yml`(태그/dispatch → 서명 APK + Release), `e2e.yml`, `deploy.yml`, `test-build.yml`(브랜치 push → APK 아티팩트, 본 세션 추가).
- (참고) 이 세션에 Supabase MCP(`Supabase_Coflanet`)가 연결돼 있어 스키마 조회/마이그레이션이 MCP로도 가능.

---

### 인수 체크리스트
- [ ] `flutter pub get && dart format . && flutter analyze && flutter test`
- [ ] `coflanet-design-guide` 스킬 + `04-static-black-theme.md` 숙지
- [ ] 대표 화면 1개 Static/Black 카드화 → `flutter run`으로 라이트/다크 확인 → 패턴 확정
- [ ] 화면 점진 롤아웃 + push마다 `test-build` APK로 회귀 확인
