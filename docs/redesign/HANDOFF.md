# 🤝 로컬 세션 인수인계 (Handoff)

> 이 문서 하나로 이어받을 수 있게 정리했다. 먼저 이걸 읽고 → `00-master-plan.md` → 필요한 task 문서 순으로.
> 작성 시점 HEAD: **`c7b3732`** · 브랜치 **`claude/magical-cray-8f21va`** · PR **#22**

---

## 0. 30초 요약

- **무엇**: Coflanet(커피 Flutter 앱) — ① 유저 플로우 검증·수정 ② component_lab 라이브러리 마이그레이션 ③ 스타일 적용 ④ **iyumi 카드형 + Static/Black 배경** ⑤ iyumi docs 참고.
- **지금까지**: 플로우 결함 대부분 수정 + **Static/Black 카드 디자인 toolkit(토큰·위젯) 구현 완료**. 전부 **CI analyze/test 통과**.
- **남은 핵심**: toolkit을 **실제 화면에 적용**(검정 캔버스 + 카드화)하는 시각 작업 + 라이브러리 컴포넌트 마이그레이션. → **실기기로 보면서** 진행하는 게 빠르고 안전(원격 봇 세션엔 Flutter가 없어 렌더 확인 불가였음).
- **첫 명령**: `flutter pub get && dart format . && flutter analyze` (format 부채부터 정리).

---

## 1. 현재 상태

| 항목 | 값 |
|------|----|
| 브랜치 | `claude/magical-cray-8f21va` (이걸로 계속 개발) |
| PR | [#22](https://github.com/PlanewTech/coflanet-app/pull/22) (draft) |
| HEAD | `c7b3732` |
| CI `Analyze & Test` | 🟢 통과 (코드 컴파일·테스트 OK) |
| CI `Format Check` | 🔴 실패 — **기존 dart format 부채**(원격 세션에 dart 없어 못 돌림). **`dart format .` 한 번이면 해소** |
| 테스트 APK | `.github/workflows/test-build.yml` — **브랜치 push마다 APK 자동 빌드** → Actions run의 `app-release-apk` 아티팩트 |

> 봇 세션은 워크플로 디스패치/태그 push 권한이 없어(403) 릴리즈를 못 띄웠고, 대신 push-트리거 빌드 워크플로를 넣어둠. 로컬/사용자는 정식 `Release` 워크플로(`release.yml`, workflow_dispatch)나 `v*` 태그 push로 서명 릴리즈 가능.

---

## 2. 이미 끝난 것 (CI analyze 통과)

### 플로우 수정
| 커밋 | 내용 |
|------|------|
| `a45605a` | 홈 보유원두 카드 탭→`beanDetail`(A1) · 원두 상세 가격행 탭→네이버 `naverLink`(B1) · **커뮤니티 탭 숨김(4탭, 쇼핑 유지)** · 홈 장바구니 아이콘 숨김 |
| `a6dadf9` | 매칭 "자세히 보기" 카드 탭→`purchaseUrl`(A2) |
| `da86c94` | **ExtractionList(추출 기록) 활성화** — 라우트 등록 + 마이 탭 "추출 기록" 진입점 |

### Static/Black 카드 디자인 toolkit (additive — 기존 화면 영향 0)
| 커밋 | 내용 |
|------|------|
| `a6dadf9` | `AppColor.staticBlack/staticWhite` · `AppColorScheme.canvas`(=dark) · `AppSpacing` 카드 토큰(`screenTopMargin`,`sectionPadding`,`itemPadding`,`cardGap`,`sectionGap`/`itemGap`,`bottomDockAllowance`,`bottomScrollInset(context)`) · `AppRadius.sectionRadius(40)`/`itemRadius(24)` · `lib/widgets/cards/card_section.dart`(CardSection/CardItem/CardGap) |
| `04a0af4` | `lib/widgets/cards/screen_scaffold.dart`(ScreenScaffold) |

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

### P0 — 위생
- [ ] **`dart format .`** 실행 → Format Check 초록. (원격 세션이 못 한 유일한 것)

### P1 — Static/Black 카드 디자인 화면 적용 (핵심, 시각 검증 필요)
- [ ] 화면을 `ScreenScaffold` + `CardSection`/`CardItem`로 재구성. **`coflanet-design-guide` 스킬**의 규칙·체크리스트 준수.
- [ ] §3 색 규칙(캔버스=canvas/카드=of(context)) 적용 — 특히 **검정 위 텍스트는 `AppColorScheme.canvas`** 사용.
- [ ] 배경 검정화 부작용 점검: `04-static-black-theme.md` §5 체크리스트.
- 권장 순서: 단순/대표 화면(예: 마이, 설정) → 홈 → 원두/추출 → 온보딩.
- 검증: push → `test-build` APK로 라이트/다크 양쪽 스냅샷 확인.

### P1 — 남은 플로우 결함 (`01a-flow-defects.md`)
- [ ] B3: 온보딩 결과 "추천 원두 더 보기" 빈 콜백 → 쇼핑/매칭 연결.
- [ ] C1: 홈 상품 추천 카드 탭 — 쇼핑 페이지 신설 후 연결(또는 `purchaseUrl` 직접). 쇼핑 탭이 현재 placeholder라 **쇼핑(취향 추천) 화면 실제 구현** 필요.
- [ ] TastingNotes 실구현: `TastingNoteModel` + 저장 + 폼(기존 `FlavorRadarChart`/`FlavorTag`/`AppAnimatedTasteBar` 재사용) + 타이머완료/추출기록 진입.
- [ ] 홈 재구성: 빈/placeholder 섹션 정리(`reference/iyumi/home-restructure.md` 선례).

### P2 — 라이브러리 마이그레이션 (`02-library-migration.md`)
- [ ] component_lab foundation/components를 토큰 매핑(`reference/token-mapping.md`)대로 흡수. 버튼(완전검증)→칩→카드→폼→모달 순. P0 누락 위젯 10종.

### P2 — 이미지 생성 (`image-production-list.md`)
- [ ] 타이머 스텝 5종·추출 기구 5종·빈 상태·Static/Black 리워크 — Claude-in-Chrome로 생성 후 `assets/images/`. (§1은 코드 매핑도 필요)

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
