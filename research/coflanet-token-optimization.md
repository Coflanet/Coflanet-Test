# 커플래닛 토큰 최적화 리서치

> Figma → Flutter 바이브 코딩(Claude Code + Figma Dev Mode MCP) 토큰 비용 절감 베스트 프랙티스
> 대상: 커플래닛 (Flutter + Supabase + GetX + 자체 디자인 시스템 `component_lab` 보유) 솔로 개발자
> 작성일: 2026-05-13 · 작업 브랜치: `claude/optimize-flutter-tokens-N4nS4`

---

## 1. TL;DR — 사이드 프로젝트 비용 관점 Top 3

1. **Max $100/월 플랜이 API 종량제 대비 ~93% 절감** — 헤비 사용자(8개월 10B 토큰) API 환산 $15K → Max $800. Coflanet 같은 일일 사용량이면 손익분기 즉시 도달. ([recca0120 빌링 감사](https://recca0120.github.io/en/2026/04/26/claude-code-3-month-billing-postmortem/))
2. **Sonnet 기본 + 변환은 Haiku, 아키텍처만 Opus** — Opus 4.7 새 토크나이저는 같은 텍스트도 **+35% 토큰** 생성. Sonnet/Opus 실효 격차는 ~2.2x. Coflanet의 위젯 변환·Supabase RPC 같은 기계적 작업은 Sonnet/Haiku로 충분. ([Anthropic 가격](https://platform.claude.com/docs/en/about-claude/pricing) · [Finout 분석](https://www.finout.io/blog/claude-opus-4.7-pricing-the-real-cost-story-behind-the-unchanged-price-tag))
3. **`component_lab` 강제 룰 + Figma `nodeId` 스코프 호출** — `lib/widgets/`을 이미 보유한 Coflanet의 최대 무기. CLAUDE.md에 "새 버튼 만들지 말고 `AppSolidButton` 재사용" 룰을 박으면 Claude의 첫 emit이 100~300줄 → 5줄로 줄어듦. 추정 **변환 1회당 60~75% 절감** ([Figma MCP guide](https://github.com/figma/mcp-server-guide))

---

## 2. 검증된 베스트 프랙티스 — 한눈에 보기

| # | 기법 | 설명 | 예상 절감률 | 월 절감($) | 난이도 | 출처 |
|---|---|---|---|---|---|---|
| 1 | Max 플랜 전환 | API 종량제 → Max $100 | **~93%** (heavy user) | $200~$1,200 | 하 | [Verdent 가이드](https://www.verdent.ai/guides/claude-code-pricing-2026) |
| 2 | Sonnet 기본 | `/model sonnet`, Opus는 plan에만 | 40~60% | $30~$60 | 하 | [Anthropic 비용](https://code.claude.com/docs/en/costs) |
| 3 | Extended Thinking 캡 | `MAX_THINKING_TOKENS=8000` | 10~30% | $5~$20 | 하 | [Anthropic 비용](https://code.claude.com/docs/en/costs) |
| 4 | `/clear` 적극 활용 | 기능 1개 끝날 때마다 | 30~50% | $20~$40 | 하 | [MindStudio](https://www.mindstudio.ai/blog/how-to-stop-burning-through-claude-code-tokens-context-management-guide-beginners) |
| 5 | CLAUDE.md < 200줄 | SKILL.md로 분리 | 10~25% (매 턴) | $10~$25 | 중 | [Anthropic best practices](https://code.claude.com/docs/en/best-practices) |
| 6 | 5분 캐시 적중 | 턴 간격 < 5분 유지 | 캐시 읽기 0.1x | $30~$80 | 중 | [Prompt caching](https://platform.claude.com/docs/en/build-with-claude/prompt-caching) |
| 7 | Figma `nodeId` 스코프 | 전체 프레임 X, 노드 단위 O | 50%+ (Figma 턴) | $15~$40 | 중 | [Figma MCP guide](https://github.com/figma/mcp-server-guide) |
| 8 | `get_metadata` 선행 | 가벼운 XML로 구조 먼저 | 30~50% (Figma 턴) | $10~$25 | 중 | [Figma forum](https://forum.figma.com/ask-the-community-7/figma-desktop-mcp-get-metadata-forces-the-get-design-context-which-cannot-be-done-when-targeting-a-node-page-50299) |
| 9 | `figma-flutter-mcp` 도입 | React 출력 우회, Dart 직출력 | 40~60% (변환 턴) | $20~$50 | 중 | [github.com/mhmzdev/figma-flutter-mcp](https://github.com/mhmzdev/figma-flutter-mcp) |
| 10 | `flutter-skill` 스냅샷 | 스크린샷 대비 -87~99% | **87~99%** (UI 디버깅 턴) | $20~$60 | 중 | [github.com/ai-dashboad/flutter-skill](https://github.com/ai-dashboad/flutter-skill) |
| 11 | `component_lab` 매핑 룰 | 새 위젯 금지, 기존 위젯 재사용 | 60~75% (UI 변환) | $30~$80 | 상 | 자체 / [Effective Dart](https://dart.dev/effective-dart) |
| 12 | `ColorScheme.fromSeed` + `ThemeExtension` | 인라인 hex 제거 | 10~20% (스타일) | $5~$15 | 중 | [Flutter API](https://api.flutter.dev/flutter/material/ColorScheme/ColorScheme.fromSeed.html) |
| 13 | `prefer_const_constructors` 활성화 | 라운드트립 1회 제거 | 5~10% | $3~$8 | 하 | [dart.dev linter](https://dart.dev/tools/linter-rules/prefer_const_constructors) |
| 14 | `.claudeignore` + `CLAUDE_CODE_FILE_READ_MAX_OUTPUT_TOKENS` | `*.g.dart`, `build/`, native 폴더 차단 | 15~30% (스캔) | $10~$25 | 하 | [요즘IT](https://yozm.wishket.com/magazine/) |
| 15 | DevContainer 샌드박스 | 권한 프롬프트로 인한 턴 낭비 제거 | 5~15% | $3~$10 | 상 | [Code With Andrea](https://codewithandrea.com/articles/run-ai-agents-inside-devcontainer/) |
| 16 | Sub-agent은 verbose 격리에만 | 일반 작업에 쓰면 ~7x 토큰 | 음수 방지 | — | 중 | [dev.to/onlineeric](https://dev.to/onlineeric/claude-code-sub-agents-burn-out-your-tokens-4cd8) |

> 절감률은 출처별 자체 보고이며 워크로드별로 편차 큼. Coflanet 환경에서의 실측은 7번 섹션 로드맵의 「실험 항목」 참고.

---

## 3. Figma → Flutter 변환 최적화 (★ 핵심 섹션)

### 3.1 도구별 토큰 무게 — 호출 순서가 곧 비용

| 도구 | 반환 | 무게 | 첫 호출에 적합? |
|---|---|---|---|
| `get_metadata` | 레이어 ID·이름·크기만 (sparse XML) | **가벼움** | ✅ 큰 프레임은 항상 이걸로 시작 |
| `get_variable_defs` | 컬러/스페이싱/타이포 변수 목록 | 가벼움~중 | ✅ ThemeData 매핑 시 |
| `get_code_connect_map` | nodeId → 파일 경로 매핑 | 가벼움 | ✅ 항상 |
| `get_design_context` | React+Tailwind 코드 + 스크린샷 | **무거움** | ⚠️ 작은 nodeId만 |
| `get_screenshot` | PNG | **매우 무거움** (이미지 토큰) | ❌ 마지막 수단 |
| `search_design_system` | 라이브러리 매칭 | 중 | 새 컴포넌트 만들기 전 |

**권장 호출 순서 (커플래닛 기준)**:
1. `get_code_connect_map` — 이미 매핑된 위젯 있는지 확인 (있으면 0턴 변환)
2. `get_metadata(nodeId=루트)` — 구조 파악
3. `get_variable_defs(nodeId=루트)` — 토큰 추출 → `app_color.dart`/`app_spacing.dart` 매칭
4. `get_design_context(nodeId=특정 자식 노드)` — 필요한 노드만 타겟
5. `get_screenshot` — 레이아웃 깨졌을 때만

출처: [Figma MCP guide](https://github.com/figma/mcp-server-guide), [Figma forum](https://forum.figma.com/ask-the-community-7/figma-desktop-mcp-get-metadata-forces-the-get-design-context-which-cannot-be-done-when-targeting-a-node-page-50299)

### 3.2 React 출력을 Flutter로 변환할 때 토큰 새는 4 지점

| 새는 지점 | 증상 | 회피법 |
|---|---|---|
| 절대 위치(`Stack`+`Positioned`) 폭주 | Figma의 absolute 좌표가 그대로 변환 | **Figma에서 Auto Layout 강제** + 3.5의 변환 프롬프트 1샷 |
| 원시 hex 색상 산발 | `Color(0xFFAB123)` 인라인 | CLAUDE.md 룰: "raw hex 금지, `AppColorTheme` 또는 `Theme.of(context).colorScheme.*`만" |
| 새 버튼·카드 위젯 신규 생성 | `Container` + `BoxDecoration` 200줄 | CLAUDE.md 룰: "`component_lab` 위젯 우선 검색 → 없으면 PR 제안" |
| `TextStyle` 인라인 | `TextStyle(fontSize: 14, fontWeight: ...)` 반복 | `AppTextStyle.body14Medium` 등 토큰 강제 |

### 3.3 하이브리드 워크플로우 — 비용/품질 3가지 플랜

#### Plan A — 100% 무료 (권장 출발점)
1. **`figma-flutter-mcp` 설치** — 공식 Figma MCP 대신 사용. React+Tailwind 우회, Dart 토큰 직접 출력. ([github.com/mhmzdev/figma-flutter-mcp](https://github.com/mhmzdev/figma-flutter-mcp))
2. **공식 Dart MCP 서버** ([dart.dev/tools/mcp-server](https://dart.dev/tools/mcp-server)) + **`flutter-skill`** ([github.com/ai-dashboad/flutter-skill](https://github.com/ai-dashboad/flutter-skill)) — 스크린샷 대비 87~99% 토큰 절감.
3. **Figma 측에서 Auto Layout 100% 적용** — 단일 최대 절감 레버.
4. **FigmaToCode (Bernaferrari) 플러그인**으로 1차 Dart 초안 → Claude는 다듬기만. ([github.com/bernaferrari/FigmaToCode](https://github.com/bernaferrari/FigmaToCode))
5. **Claude로 리팩터**: hex → `AppColorTheme`, 새 위젯 → `component_lab` 매핑.
- 추정: 화면당 **~5–9k 토큰** vs 라우 워크플로우 **~12–20k** [미검증, 추정]

#### Plan B — $30/월 (Visual Copilot)
- 위 3단계를 **Builder.io Visual Copilot CLI**로 대체. Flutter 1급 지원, CLI로 프로젝트에 직접 드롭. ([builder.io/blog/figma-to-flutter](https://www.builder.io/blog/figma-to-flutter))
- 화면당 ~3–5k까지 추가 절감 가능. 월 10화면 이상 칠 때 ROI.

#### Plan C — `component_lab` 우선 (커플래닛 특화)
- 어차피 `component_lab`이 디자인 토큰을 모두 들고 있음 → Figma → Flutter 변환의 80%는 "어떤 `component_lab` 위젯을 쓸 건지" 매핑 문제.
- 따라서 핵심은 **`figma_node_id ↔ component_lab 위젯 path` 매핑 JSON**을 `.claude/figma-mapping.json`로 유지 + CLAUDE.md에서 강제 참조.

### 3.4 Code Connect를 Flutter에 적용할 수 있나?

- **공식 미지원** (React, RN, HTML, SwiftUI, Compose만). [Code Connect repo](https://github.com/figma/code-connect) · [Figma forum 요청](https://forum.figma.com/suggest-a-feature-11/flutter-as-code-connect-update-2313)
- **워크어라운드** (가능):
  1. **Code Connect의 template files**는 프레임워크 무관 — Dart 스니펫을 직접 작성해서 Dev Mode에 노출 가능.
  2. **`get_variable_defs`의 `code_syntax` 필드**에 Dart 코드(`AppColor.primary500`)를 직접 매핑 — Figma 변수 → Dart 토큰 1:1 매핑이 그대로 LLM에 전달됨.
  3. **자체 `figma-mapping.json` 유지** — `nodeId → component_lab 위젯 경로` 매핑을 레포에 두고 CLAUDE.md에서 grep 강제.
- 커플래닛 권장: **2번 + 3번 병행**. `app_color.dart`의 모든 토큰명을 Figma 변수의 `code_syntax`로 등록.

### 3.5 절대 위치 → Column/Row 변환 1샷 프롬프트

```
다음 Flutter 스니펫의 Stack/Positioned 절대 레이아웃을 의미적 Column/Row/Wrap으로 변환해.
규칙:
1. 자식이 수직 적층 + 비겹침 → Column(mainAxisSize: min) + SizedBox(height: gap)
2. 수평 → Row + 동일 SizedBox
3. z-index 시각적 겹침 있을 때만 Stack+Positioned 유지
4. 모든 raw hex → Theme.of(context).extension<AppColorTheme>()!.<token>
   매칭 토큰 없으면 component_lab/lib/foundation/app_color.dart에 추가하고 diff 표시
5. padding/margin은 component_lab의 AppSpacing.* 만 사용 (4/8/12/16/24/32)
   2px 이상 반올림 발생 시 라인별 명시
6. 출력: (a) 리팩터된 위젯 (b) 신규 색상 토큰 (c) 유지한 Stack 한 줄 정당화
```
출처: Phase B 에이전트 합성

---

## 4. Flutter/Dart 특화 토큰 절감 패턴

### 4.1 ThemeData / TextTheme — 인라인 스타일 박멸

- `ColorScheme.fromSeed(seedColor: ...)`만으로 모든 ColorScheme 역할 자동 생성. 다크 페어는 `brightness: Brightness.dark` 한 줄. ([Flutter API](https://api.flutter.dev/flutter/material/ColorScheme/ColorScheme.fromSeed.html))
- 커플래닛은 이미 `AppColorTheme extends ThemeExtension<AppColorTheme>` 보유 — `Theme.of(context).extension<AppColorTheme>()!.labelNormal` 한 줄로 다크/라이트 분기 제거. CLAUDE.md 룰에 "`isDark = brightness == dark` 패턴 절대 금지" 추가.

### 4.2 const constructor — 라운드트립 제거

- `prefer_const_constructors` lint rule을 `analysis_options.yaml`에 명시 활성화. 빠진 `const`는 분석기 경고 → Claude가 fix하라고 추가 턴 발생. 처음부터 lint pass 코드를 emit하면 라운드트립 1회 절약. ([dart.dev linter](https://dart.dev/tools/linter-rules/prefer_const_constructors))
- 보너스: `prefer_const_constructors_in_immutables` (Effective Dart 권장). ([dart.dev](https://dart.dev/tools/linter-rules/prefer_const_constructors_in_immutables))

### 4.3 공통 위젯 추출 = 토큰 반복 박멸

- 커플래닛의 `Library/component_lab/lib/components/` 21개 카테고리 (`buttons`, `cards`, `chips`, `forms`, `modals`, `navigation`, ...)를 CLAUDE.md에 인덱스로 노출.
- **룰**: "신규 위젯 작성 전 `component_lab/lib/components/` 검색. 매칭 없으면 사용자에게 확인 요청 후 `component_lab`에 추가. 절대 호출 사이트에 ad-hoc 위젯 정의 금지."

### 4.4 Material 3 / Cupertino 기본 위젯

- `useMaterial3`는 Flutter 3.16부터 기본값 true. ([공식 마이그레이션](https://docs.flutter.dev/release/breaking-changes/material-3-migration))
- `FilledButton.tonal`, `NavigationBar` + `NavigationDestination`, `SegmentedButton`, `SearchBar`는 모두 seeded `ColorScheme` 자동 적용 → 인라인 스타일 0줄.
- 커플래닛 룰: "ad-hoc 색상 + `Container` 조합으로 버튼 만들지 말고 `FilledButton` 또는 `AppSolidButton` 재사용."

### 4.5 상태관리가 토큰에 미치는 영향

- 커플래닛은 **GetX** 사용 (`get: ^4.6.6`). GetX는 보일러플레이트 자체는 적지만 (`Obx`, `GetxController`) 매직 의존성 주입 패턴이 LLM에 덜 익숙해 잘못된 import 추가 → 라운드트립 발생 케이스 보고됨. [미검증]
- 권장: CLAUDE.md에 GetX 패턴 예시 5개를 못박아두기 (1) `Get.find<XxxController>()` (2) `Obx(() => ...)` (3) `Get.toNamed('/route', arguments: ...)` (4) `Get.snackbar` (5) `GetView<T>` 패턴.
- Riverpod/Bloc과의 토큰 비교는 객관 데이터 없음 [미검증]. 다만 Riverpod가 LLM 학습 데이터에 더 많이 노출되어 있어 첫 emit 정확도가 높다는 r/FlutterDev 일반론은 존재. 지금 Coflanet은 GetX로 충분히 작동 중이므로 변경 권장 X.

---

## 5. CLAUDE.md 추천 룰셋 — 커플래닛 레포에 바로 붙여넣기

> 아래 블록을 `coflanet-app-0.1.2/CLAUDE.md`로 저장.
> Anthropic 권장 200~500줄 한도 ([best practices](https://code.claude.com/docs/en/best-practices)).
> 더 긴 패턴(Supabase RLS, Naver Shopping API 명세 등)은 `.claude/skills/<name>/SKILL.md`로 분리 — 호출 시점에만 로드.

```markdown
# Coflanet — Claude Code 작업 룰

## 프로젝트 개요
- Flutter 앱 (Dart SDK ^3.9.2), Supabase backend, GetX 상태관리
- 자체 디자인 시스템: `Library/component_lab` (path dep)
- 한국어 UX, 한국 사용자 대상 홈카페·원두 추천

## 비용 절감 룰 (최우선)
1. **모델 기본은 Sonnet**. Opus는 plan 모드의 아키텍처 결정에만. `/model sonnet`으로 바로 전환.
2. **새 기능 시작 시 `/clear`**. 메시지 200개 넘기면 input 토큰이 기하급수.
3. **Extended Thinking은 8K 토큰 캡**. `MAX_THINKING_TOKENS=8000` 환경변수 또는 `/effort low`.
4. **5분 이내 연속 턴 유지** — 캐시 적중 시 input 0.1x. 휴식 후엔 차라리 `/clear`.

## 파일/스캔 절약
- `.claudeignore`로 차단: `build/`, `.dart_tool/`, `*.g.dart`, `*.freezed.dart`, `ios/Pods/`, `android/.gradle/`, `assets/images/*.png`
- 큰 파일 읽기 전 `head`/`grep`으로 범위 확인. 전체 dump 금지.
- `flutter analyze` 결과는 sub-agent로 격리 (verbose 출력)

## Flutter/Dart 코딩 컨벤션
- **신규 위젯 금지 룰**: 새 UI 만들기 전에 `Library/component_lab/lib/components/` (avatars/buttons/cards/chips/contents/control_box/controls/dividers/feedback/forms/gauge/indicators/modals/navigation/pagination/presentation/ratio/scrolls/selection/tabs/thumbnails) 검색. 매칭 있으면 `import 'package:component_lab/component_lab.dart';` 후 사용. 없으면 사용자 확인 후 `component_lab`에 추가, 호출 사이트엔 절대 ad-hoc 정의 금지.
- **색상 룰**: raw `Color(0xFF...)` 절대 금지. `Theme.of(context).extension<AppColorTheme>()!.<토큰>` 또는 `AppColor.<토큰>`만. 매칭 토큰 없으면 `Library/component_lab/lib/foundation/app_color.dart`에 추가하고 diff 보여줘.
- **타이포 룰**: `TextStyle(...)` 인라인 금지. `AppTextStyle.<토큰>`만.
- **간격 룰**: padding/margin은 `AppSpacing.<토큰>` 만 (4/8/12/16/24/32 스케일). 비표준 값은 사용자 승인.
- **다크모드 분기 금지**: `Theme.of(context).brightness == Brightness.dark` 패턴 작성 금지. `AppColorTheme` (ThemeExtension)이 이미 다크/라이트 분기 처리.
- **`const` 강제**: `prefer_const_constructors`, `prefer_const_constructors_in_immutables` lint 활성화 가정. 첫 emit부터 모든 가능 위치에 `const`.
- **GetX 패턴**: `Get.find<XxxController>()` / `Obx(() => ...)` / `Get.toNamed('/route', arguments: ...)` / `Get.snackbar` / `GetView<T>`. import는 `package:get/get.dart` 한 줄.

## Figma MCP 호출 순서 (★ 비용 영향 큼)
1. 먼저 `get_code_connect_map` → 이미 매핑된 위젯 있으면 변환 0턴.
2. 큰 프레임은 `get_metadata(nodeId=...)` 먼저 — 가벼운 XML로 구조 파악.
3. `get_variable_defs(nodeId=...)` — 색상·간격 토큰 추출. `app_color.dart` / `app_spacing.dart` 와 매칭.
4. `get_design_context`는 **항상 nodeId 명시**. 페이지 전체 호출 금지.
5. `get_screenshot`은 레이아웃 디버깅 시에만. UI 검증은 `flutter-skill snapshot()` 우선.
6. React+Tailwind 출력은 그대로 두지 말고 즉시 `component_lab` 위젯으로 매핑.

## Supabase
- Edge Function 코드 생성 시 함께 호출하는 Flutter 측 호출부도 동시 생성 (분리하면 컨텍스트 2배).
- RLS·SQL 마이그레이션 컨벤션은 `.claude/skills/supabase-migrations/SKILL.md` 참조.

## 한국어 UX
- 사용자 노출 문자열은 모두 한국어. 디버그/주석은 한국어 OK.
- 에러 메시지는 사용자에게 보여줄 때 친근체("앗, 다시 시도해주세요"), 로그는 서술형.

## 작업 워크플로우
- 새 기능: (1) plan 모드로 한 번 정리 → (2) 스펙을 `docs/specs/<feature>.md`에 저장 → (3) `/clear` → (4) Sonnet으로 구현
- 변환 작업: 위 "Figma MCP 호출 순서" 따름
- 리팩터: 단일 파일/단일 함수 단위로 명시. "이 코드 개선해줘" 금지, 항상 파일·심볼 명시.

## 금지 사항
- 백워드 호환 셔임 (`@Deprecated` 추가, 미사용 함수 유지) — 솔로 프로젝트라 불필요
- "혹시 모를" 에러 핸들링 — 시스템 경계(Supabase/Naver API)에서만 try/catch
- 긴 docstring·주석 블록. WHY가 비명확할 때만 한 줄 주석
- 새 디렉토리·새 패키지 무단 생성. 항상 사용자 확인
```

> 분리 대상 (`.claude/skills/<name>/SKILL.md`로):
> - `supabase-migrations/SKILL.md` — Edge Functions, RLS 패턴
> - `naver-shopping-api/SKILL.md` — API 명세, rate limit
> - `figma-to-flutter/SKILL.md` — 위 절대→Column 변환 프롬프트, `figma_node_id ↔ component_lab` 매핑 테이블

---

## 6. 실험적 / 논쟁적 기법 (효과 미검증)

| 기법 | 주장 | 출처 | 위험 |
|---|---|---|---|
| `tasks.md` 평면 인덱스 재구조 | **76% 토큰 절감, 4x 처리량** | [velog @bernoyoun](https://velog.io/@bernoyoun/CLAUDE-CODE%EC%9D%98-%ED%86%A0%ED%81%B0%EC%9D%84-%EC%A0%88%EC%95%BD%ED%95%98%EA%B8%B0-tasks.md%EC%9D%98-%EB%AC%B8%EC%84%9C-%EA%B5%AC%EC%A1%B0-%EA%B0%9C%ED%8E%B8) | 자체 보고, 방법론 미공개 |
| LLMLingua-2 압축 적용 | **2~5x 압축, 1.6~2.9x 지연시간 win** | [arXiv:2403.12968](https://arxiv.org/abs/2403.12968) | Claude Code에 직접 통합 어려움. 사전 처리 파이프라인 필요 |
| 코드-컨텍스트 압축 (cross-encoder) | **51.8~71.3% 토큰 절감, 정확도 +5~9pt** | [arXiv:2603.28119](https://arxiv.org/html/2603.28119) | 학술 단계, 실전 적용 도구 부재 |
| Sub-agent 팀 (parallelism) | 빠르긴 함 | [Anthropic 비용](https://code.claude.com/docs/en/costs) | **~7x 토큰 사용**. 솔로 프로젝트는 비추 |
| Hetzner 원격 박스에서 Claude Code | 로컬 부하 0 | [@levelsio](https://x.com/levelsio/status/1953022273595506910) | 토큰엔 무관, 단지 워크플로우 |
| Cursor 병행 | 자동완성은 Cursor, 멀티파일은 Claude | r/FlutterDev | Cursor 별도 비용 (월 $20) |

---

## 7. 단계별 적용 로드맵

### 즉시 (오늘, 1시간 내)
- [ ] `coflanet-app-0.1.2/CLAUDE.md` 생성, 위 5번 룰셋 붙여넣기
- [ ] `.claudeignore` 작성 (`build/`, `.dart_tool/`, `*.g.dart`, `assets/images/*.png`, `ios/Pods/`)
- [ ] `analysis_options.yaml`에 `prefer_const_constructors`, `prefer_const_constructors_in_immutables` 명시 추가
- [ ] `MAX_THINKING_TOKENS=8000` 환경변수 설정
- [ ] `/model sonnet` 기본화 (필요 시 `/model opus`)

### 단기 (1주일 내)
- [ ] `.claude/skills/figma-to-flutter/SKILL.md` 작성 — 호출 순서 + 변환 프롬프트
- [ ] `.claude/skills/supabase-migrations/SKILL.md` 작성
- [ ] `figma-flutter-mcp` 설치 시도 + 1개 화면 테스트 ([github.com/mhmzdev/figma-flutter-mcp](https://github.com/mhmzdev/figma-flutter-mcp))
- [ ] `flutter-skill` 설치 — UI 디버깅 시 스크린샷 대신 사용 ([github.com/ai-dashboad/flutter-skill](https://github.com/ai-dashboad/flutter-skill))
- [ ] `.claude/figma-mapping.json` 초안 — 자주 쓰는 노드 5~10개를 `component_lab` 위젯에 매핑
- [ ] 다음 변환 작업에서 before/after 토큰 측정 (Anthropic 사용량 대시보드)

### 중기 (1개월 내)
- [ ] **Max $100 플랜 전환** — 측정된 월 사용량이 $30 이상이면 즉시 ROI
- [ ] `app_color.dart` 모든 토큰을 Figma 변수의 `code_syntax`로 역등록 (Code Connect 워크어라운드)
- [ ] DevContainer 셋업 — `flutter analyze`/`flutter test` 자동 실행 ([Andrea Bizzotto](https://codewithandrea.com/articles/run-ai-agents-inside-devcontainer/))
- [ ] FigmaToCode 플러그인 vs `figma-flutter-mcp` vs Visual Copilot CLI 1주일 A/B 테스트, 화면당 토큰 측정
- [ ] `tasks.md` 평면 인덱스 실험 (실효성 자체 검증)

---

## 8. Top 3 룰 적용 시 Before / After 토큰 추정 — 실측 시나리오

### 가상 시나리오: "원두 상세 페이지 1개 Figma → Flutter 변환"
- 입력: 원두 카드(이미지+제목+로스터+산미바+가격+CTA 버튼) + 리뷰 섹션 + 추천 원두 캐러셀
- 모델: Opus (before) → Sonnet (after)

#### 적용할 Top 3 룰
1. **Sonnet 기본 + `nodeId` 스코프 호출** (Figma `get_metadata` 선행 → 노드별 `get_design_context`)
2. **`component_lab` 강제 룰** (CLAUDE.md에 박힌 매핑 + 신규 위젯 금지)
3. **`/clear` + 5분 캐시 활용** (변환 작업만 격리, CLAUDE.md는 캐시 적중)

#### Before (룰 적용 전)
| 단계 | 도구 | Input 토큰 | Output 토큰 | 단가 (Opus) | 비용 |
|---|---|---|---|---|---|
| 1. 전체 페이지 `get_design_context` | Figma MCP | 12,000 | — | $5/M | $0.060 |
| 2. React+Tailwind → 첫 변환 시도 | Claude Opus | 14,000 | 8,000 | in $5 / out $25 | $0.270 |
| 3. hex/인라인 스타일 정리 라운드 | Claude Opus | 18,000 | 4,500 | | $0.203 |
| 4. 새로 만든 버튼·카드 위젯 리팩터 | Claude Opus | 16,000 | 5,000 | | $0.205 |
| 5. 다크모드 분기 추가 | Claude Opus | 12,000 | 2,500 | | $0.123 |
| **합계** | | **72,000** | **20,000** | | **$0.861** |

#### After (Top 3 룰 적용)
| 단계 | 도구 | Input 토큰 | 캐시 적중 | Output 토큰 | 단가 (Sonnet) | 비용 |
|---|---|---|---|---|---|---|
| 0. CLAUDE.md (200줄) 첫 로드 | Sonnet | 4,000 | write 1.25x | — | $3/M | $0.015 |
| 1. `get_metadata(루트 nodeId)` | Figma MCP | 800 | — | — | $3/M | $0.002 |
| 2. `get_variable_defs(루트)` | Figma MCP | 600 | — | — | | $0.002 |
| 3. `get_design_context(자식 노드 3개)` | Figma MCP | 5,000 | — | — | | $0.015 |
| 4. `component_lab` 매핑 → 첫 emit | Sonnet | 3,000 + 4,000 캐시 | read 0.1x | 2,500 | | $0.010 + cached |
| 5. 다듬기 (절대→Column 1샷 프롬프트) | Sonnet | 1,500 + cache | read 0.1x | 1,200 | | $0.022 |
| **합계 (캐시 효과 반영)** | | **~14,900 신규 + 8,000 캐시 read** | | **~3,700** | | **~$0.087** |

#### 결과
- **신규 input 토큰**: 72,000 → ~14,900 (**−79%**)
- **output 토큰**: 20,000 → ~3,700 (**−81%**)
- **비용**: $0.861 → ~$0.087 (**−90%**, 약 10배)
- 화면 1개당 절감액: **~$0.77**
- 화면 30개 변환 시: $25.83 → $2.61 = 월 **~$23 절감**

> 모든 수치는 합리적 추정 [미검증]. 실제는 Anthropic 대시보드로 검증 권장 (다음 변환 작업 시 측정 후 본 문서 업데이트).
> 비용은 Opus 4.7 새 토크나이저 +35% 보정 미반영 — 보정 시 before는 **$1.16** 수준으로 더 큰 격차.

---

## 9. 전체 참고 자료

### 공식 (★★★)
- [Anthropic — Prompt caching](https://platform.claude.com/docs/en/build-with-claude/prompt-caching) · 캐시 가격, TTL, 최소 크기, 무효화 규칙
- [Anthropic — Pricing](https://platform.claude.com/docs/en/about-claude/pricing) · 모델별 in/out 가격
- [Claude Code — Best practices](https://code.claude.com/docs/en/best-practices) · CLAUDE.md, sub-agent, /clear /compact
- [Claude Code — Manage costs effectively](https://code.claude.com/docs/en/costs) · 모델 선택, 캐싱, sub-agent 7x 경고
- [Figma — Dev Mode MCP guide](https://github.com/figma/mcp-server-guide) · 도구별 무게, rate limit
- [Figma — Tools and prompts](https://developers.figma.com/docs/figma-mcp-server/tools-and-prompts/) · `get_variable_defs` `code_syntax` 필드
- [Figma — Code Connect docs](https://help.figma.com/hc/en-us/articles/23920389749655-Code-Connect) · 지원 프레임워크 (Flutter 미포함)
- [Figma — Code Connect repo](https://github.com/figma/code-connect) · template files 워크어라운드
- [Flutter — Material 3 migration](https://docs.flutter.dev/release/breaking-changes/material-3-migration) · `useMaterial3` 기본값
- [Flutter — ColorScheme.fromSeed](https://api.flutter.dev/flutter/material/ColorScheme/ColorScheme.fromSeed.html)
- [dart.dev — prefer_const_constructors](https://dart.dev/tools/linter-rules/prefer_const_constructors)
- [dart.dev — Effective Dart: Design](https://dart.dev/effective-dart/design)
- [dart.dev — Dart MCP server](https://dart.dev/tools/mcp-server)

### 도구 (★★)
- [figma-flutter-mcp (mhmzdev)](https://github.com/mhmzdev/figma-flutter-mcp) · Flutter 전용 MCP, React 우회
- [flutter-skill](https://github.com/ai-dashboad/flutter-skill) · 스냅샷으로 87~99% 토큰 절감
- [FigmaToCode (Bernaferrari)](https://github.com/bernaferrari/FigmaToCode) · 무료 Figma 플러그인, Flutter 출력
- [Builder.io Visual Copilot](https://www.builder.io/m/design-to-code) · Flutter 1급 지원, CLI
- [DhiWise / Rocket.new](https://www.dhiwise.com/post/how-to-convert-figma-design-to-flutter-code)
- [FlutterFlow](https://flutterflow.io) · 코드 export 유료, "11k build errors" 케이스 주의
- [Parabeac (archived 2024)](https://github.com/Parabeac/parabeac_core) · 사용 비추

### 한국 (★★)
- [velog @hbcho — 토큰 절약 7가지](https://velog.io/@hbcho/%ED%81%B4%EB%A1%9C%EB%93%9C-%EC%BD%94%EB%93%9CClaude-Code-%ED%86%A0%ED%81%B0%EC%9D%B4-%EC%82%B4%EC%82%B4-%EB%85%B9%EA%B3%A0-%EC%9E%88%EB%8B%A4%EB%A9%B4-%ED%95%84%EC%8A%B9-%EC%A0%88%EC%95%BD-%EC%84%A4%EC%A0%95-7%EA%B0%80%EC%A7%80) · 솔로 개발자 체크리스트
- [velog @takuya — Claude Code vs Cursor 비용](https://velog.io/@takuya/%EC%8B%A4%EC%A0%9C-%EA%B2%BD%ED%97%98-Claude-Code%EC%99%80-Cursor-%EC%9D%BC%EC%A3%BC%EC%9D%BC-%EC%82%AC%EC%9A%A9-%ED%9B%84-%EC%95%8C%EA%B2%8C-%EB%90%9C-%EC%A7%84%EC%A7%9C-%EB%B9%84%EC%9A%A9-%ED%9A%A8%EC%9C%A8) · ~60% 절감 측정, 월 $14 → $6
- [velog @bernoyoun — tasks.md 재구조](https://velog.io/@bernoyoun/CLAUDE-CODE%EC%9D%98-%ED%86%A0%ED%81%B0%EC%9D%84-%EC%A0%88%EC%95%BD%ED%95%98%EA%B8%B0-tasks.md%EC%9D%98-%EB%AC%B8%EC%84%9C-%EA%B5%AC%EC%A1%B0-%EA%B0%9C%ED%8E%B8) · 76% 절감 자체 보고
- [brunch @beingcognitive/32 — Flutter 토이 프로젝트 토큰 한계](https://brunch.co.kr/@beingcognitive/32)
- [요즘IT — 토큰 사용량 최적화](https://yozm.wishket.com/magazine/) · `CLAUDE_CODE_FILE_READ_MAX_OUTPUT_TOKENS`
- [clien — Max 100달러 4일 소진](https://www.clien.net/service/board/park/19046973) · Opus + Flutter 조합 경고
- [toss.tech — 소프트웨어 3.0](https://toss.tech/article/44539) · 문화적 맥락
- [tech.kakao.com — 바이브 코딩 바이블](https://tech.kakao.com/posts/696)
- [SK devocean — Claude Code 도입 후기](https://devocean.sk.com/blog/techBoardDetail.do?id=167718)

### 커뮤니티 (★★)
- [recca0120 — 5분 vs 1시간 캐시 감사](https://recca0120.github.io/en/2026/04/14/claude-code-cache-ttl-audit/) · ★★★ 데이터 기반
- [recca0120 — 3개월 빌링 포스트모템](https://recca0120.github.io/en/2026/04/26/claude-code-3-month-billing-postmortem/) · ★★★ 127K 턴 분석
- [Verdent — Claude Code Pricing 2026](https://www.verdent.ai/guides/claude-code-pricing-2026) · Max vs API 93% 절감 사례
- [dev.to/onlineeric — Sub-agent 7x 경고](https://dev.to/onlineeric/claude-code-sub-agents-burn-out-your-tokens-4cd8)
- [MindStudio — 컨텍스트 관리 가이드](https://www.mindstudio.ai/blog/how-to-stop-burning-through-claude-code-tokens-context-management-guide-beginners) · "메시지 201 = 1-200" 직관
- [Code With Andrea — DevContainer for AI agents](https://codewithandrea.com/articles/run-ai-agents-inside-devcontainer/)
- [Code With Andrea — FlutterFlow 비판](https://codewithandrea.com/articles/flutterflow/)
- [agentictoolkit.dev (Andrea Bizzotto)](https://agentictoolkit.dev/) · 3-folder 전략
- [karpathy — vibe coding](https://x.com/karpathy/status/1886192184808149383) · MenuGen 회고
- [@levelsio — Hetzner Claude Code](https://x.com/levelsio/status/1953022273595506910)
- [Finout — Opus 4.7 토크나이저 +35%](https://www.finout.io/blog/claude-opus-4.7-pricing-the-real-cost-story-behind-the-unchanged-price-tag)
- [zenn — Figma MCP 중간 표현 분석](https://zenn.dev/yokkomystery/articles/932cacd7728188?locale=en)
- [freeCodeCamp — Replicating Figma in Flutter](https://www.freecodecamp.org/news/how-to-replicate-figma-designs-in-flutter/) · Auto Layout 권장
- [Lovable vs Bolt vs v0 비교 (Flutter 미지원 확인)](https://lovable.dev/guides/lovable-vs-bolt-vs-v0)

### 학술 (★)
- [arXiv:2403.12968 — LLMLingua-2](https://arxiv.org/abs/2403.12968) · 2~5x 압축, 1.6~2.9x 지연 win
- [arXiv:2303.12570 — RepoCoder](https://arxiv.org/abs/2303.12570) · 반복 검색이 전체 dump 대비 우수
- [arXiv:2603.28119 — Code-Context Compression](https://arxiv.org/html/2603.28119) · 51.8~71.3% 절감, 정확도 +5~9pt

---

> **다음 액션 (사용자 단)**
> 1. 이 문서 검토
> 2. 위 5번 룰셋을 `coflanet-app-0.1.2/CLAUDE.md`로 적용 (별도 PR 권장)
> 3. 다음 Figma → Flutter 변환 작업에서 토큰 사용량 측정 → 본 문서 8번 섹션 추정치 검증
> 4. 한 달 후: Max 플랜 전환 여부 결정 (실측 사용량 기준)
