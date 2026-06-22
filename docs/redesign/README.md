# Coflanet 리디자인 & 라이브러리 마이그레이션 — 계획 문서

이 폴더는 **유저 플로우 검증 + component_lab 라이브러리 마이그레이션 + 스타일(Static/Black 카드형) 적용**을 위한 설계·근거·체크리스트 모음이다.

> **역할 분담**: 이 문서들은 *계획/설계*다. **실제 코드 개발은 로컬 세션**이 수행한다.
>
> 👉 **로컬 세션은 [`HANDOFF.md`](./HANDOFF.md) 부터 읽는다** (현재 상태·완료분·다음 할 일·작업법·참고맵 총정리). 이후 `00-master-plan.md` → 해당 task 문서 → `reference/*`.

## 문서 구조

```
docs/redesign/
├── README.md                  ← (이 파일) 인덱스 · 상태판
├── HANDOFF.md                  ★ 로컬 세션 인수인계 — 여기부터 읽기
├── image-production-list.md    이미지 제작 명세(Claude-in-Chrome 생성용)
├── 00-master-plan.md          전체 계획 · 의사결정 · Phase 순서 · 리스크 · DoD
├── 01-user-flow-audit.md      [task 1] 라우트 맵 · E2E 여정 · 블로커 + 수정안
├── 01a-flow-defects.md        [task 1] 인터랙션·데이터 결함 전수 감사(탭 무반응/안 먹는 버튼/빈 데이터) + 수리 우선순위
├── 02-library-migration.md    [task 2] component_lab 흡수 전략 · 단계별 실행
├── 03-style-application.md     [task 3] 간격/타이포/반경/색 전면 적용
├── 04-static-black-theme.md    [task 4] iyumi 카드형 + Static/Black 배경(정확 변경)
├── 05-iyumi-reference.md       [task 5] iyumi docs 참고 — ⚠️ 접근 블로커 + 해결책
└── reference/
    ├── current-design-system.md   현재 앱 토큰/위젯 스냅샷 (AS-IS)
    ├── component-lab-inventory.md  가져올 라이브러리 인벤토리 (TO-BE)
    ├── token-mapping.md            AS-IS→TO-BE 변환표 · 체크리스트
    └── iyumi/                      iyumi 디자인 스펙 vendored (카드/바텀시트/홈IA)
        ├── README.md               iyumi↔coflanet↔CDS 관계 + 수록 안내
        ├── card-design-spec.md     ★ 카드형 패턴 원본 스펙
        ├── bottom-sheet-guide.md   바텀시트 표준
        └── home-restructure.md     IA 결정 기록 예시
```

## 상태판

| Task | 문서 | 상태 | 비고 |
|------|------|------|------|
| 1 유저플로우 | `01` | ✅ 감사 완료, 수정안 제시 | 코드 수정은 로컬 |
| 2 라이브러리 | `02` | ✅ 전략·단계 확정 | 소스 흡수 방식 |
| 3 스타일 | `03` | ✅ 절차·체크리스트 | task2 단계1 의존 |
| 4 Static/Black | `04` | ✅ **방향 B 확정**(라이트 흰 카드/다크 다크 카드) · 토큰·위젯 명세 | iyumi 반영 완료 |
| 5 iyumi 참고 | `05` | ✅ **해소** — docs vendored | `reference/iyumi/` |

## 결정 현황

- 디자인: iyumi 카드 패턴 · Static/Black 캔버스 · 방향 B · 캔버스=다크 스킴/카드=활성 스킴.
- task 1: **쇼핑 탭 유지(취향 추천)** · **커뮤니티 탭 숨김(4탭)** · **장바구니/결제 숨김** · ExtractionList+TastingNotes 활성화(커피 저널) · SurveyReason 항상 노출.
- (선택 미정) 셸 탭 상태 영속화 — 진행에 지장 없음.

## 구현 현황 (이 브랜치에서 직접 수정)

- ✅ **flow 수정** (CI analyze 통과): 홈 원두 카드→상세, 원두 상세 네이버 판매링크, **매칭 카드→판매링크(A2)**, 커뮤니티 탭 숨김, 장바구니 아이콘 숨김. → `01a-flow-defects.md` §0.
- ✅ **카드 패턴 toolkit 구현**(additive, CI analyze 통과): `AppColor.staticBlack/staticWhite`, `AppColorScheme.canvas`, 카드 토큰(`sectionRadius 40`/`itemRadius 24`/`sectionPadding`/`bottomScrollInset` 등), `CardSection`·`CardItem`·`CardGap`·`ScreenScaffold`(`lib/widgets/cards/`). **기존 화면 영향 0** — 이걸로 화면을 점진 마이그레이션.
- 📋 **이미지 제작 리스트**: `image-production-list.md` (Claude-in-Chrome 자동 생성용).
- ⏳ 테스트 릴리즈 APK: 권한상 봇이 트리거 불가 → 사용자가 Actions에서 `Release` 워크플로 실행(브랜치 지정) 필요.
- ⬜ 대형 작업(Static/Black 카드 전면 적용 + 라이브러리 마이그레이션)은 로컬 세션. 디자인 강제는 `coflanet-design-guide` 스킬.

## 근거(외부 소스)

- 라이브러리: `Coflanet/Coflanet-Test` → `Library/component_lab/` (HANDOFF.md, ACTION_PLAN.md, foundation/, components/).
- iyumi: `IYUMI-org/iyumi/docs` — ✅ docs zip 전달받아 `reference/iyumi/`에 vendoring(`05` 참조).
- 현재 앱: `lib/constants/`, `lib/core/theme/`, `lib/routes/`, `lib/modules/`, `lib/widgets/`.
