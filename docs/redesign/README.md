# Coflanet 리디자인 & 라이브러리 마이그레이션 — 계획 문서

이 폴더는 **유저 플로우 검증 + component_lab 라이브러리 마이그레이션 + 스타일(Static/Black 카드형) 적용**을 위한 설계·근거·체크리스트 모음이다.

> **역할 분담**: 이 문서들은 *계획/설계*다. **실제 코드 개발은 로컬 세션**이 수행한다.
> 로컬 세션은 `00-master-plan.md` → 해당 task 문서 → `reference/*` 순으로 읽고 실행한다.

## 문서 구조

```
docs/redesign/
├── README.md                  ← (이 파일) 인덱스 · 상태판
├── 00-master-plan.md          전체 계획 · 의사결정 · Phase 순서 · 리스크 · DoD
├── 01-user-flow-audit.md      [task 1] 라우트 맵 · E2E 여정 · 블로커 + 수정안
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

## 남은 결정 (사용자)

1. **task 1 정책** — 죽은 화면(ExtractionList·TastingNotes)/플레이스홀더 탭(커뮤니티·쇼핑) 처리. (`01` §7) — 유일한 미결.
   - (카드 방향·iyumi·Static/Black·radius·그림자는 모두 확정.)

## 근거(외부 소스)

- 라이브러리: `Coflanet/Coflanet-Test` → `Library/component_lab/` (HANDOFF.md, ACTION_PLAN.md, foundation/, components/).
- iyumi: `IYUMI-org/iyumi/docs` — ✅ docs zip 전달받아 `reference/iyumi/`에 vendoring(`05` 참조).
- 현재 앱: `lib/constants/`, `lib/core/theme/`, `lib/routes/`, `lib/modules/`, `lib/widgets/`.
