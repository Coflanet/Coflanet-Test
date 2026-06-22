# Task 5 — iyumi 문서 레퍼런스

> 목표: `https://github.com/IYUMI-org/iyumi/tree/main/docs`의 디자인 문서를 참고해 카드 디자인·스타일 결정을 정합.

## ⚠️ 현재 상태: 접근 불가 (블로커)

| 시도 | 결과 |
|------|------|
| WebFetch `github.com/IYUMI-org/iyumi/tree/main/docs` | **HTTP 404** |
| WebFetch `github.com/IYUMI-org/iyumi` | **HTTP 404** |
| 웹 검색 "IYUMI-org iyumi flutter design system" | 일치 결과 없음 |
| GitHub MCP | 이 세션은 `planewtech/coflanet-app`로만 스코프 제한 → 타 레포 호출 거부 |

→ **레포가 비공개이거나 URL/이름이 다를 가능성**이 높다. 현재 환경에서 직접 열람 불가.

### 정황상 추정
- HANDOFF.md의 레포 경로가 `/Users/yooju/Desktop/Coflanet-Test`. "이유미"는 디자이너 이름으로 보이며, `IYUMI-org/iyumi`는 그 개인/조직의 디자인 시스템 문서로 추정.
- 따라서 iyumi 문서는 component_lab과 **같은 Figma 디자인 시스템 계보**일 가능성이 크다 → 토큰·카드 언어가 component_lab과 정합할 것으로 예상.

## 해결 방법(택1) — 사용자/소유자 액션 필요

1. **레포 공개 전환** 또는 `docs/`만 공개 → 다시 WebFetch로 수집.
2. **세션 스코프에 추가**: GitHub App 설치/권한에 `IYUMI-org/iyumi` 포함 → MCP로 열람.
3. **문서 내용 직접 전달**: 핵심 문서(카드 사양, 컬러/토큰, 라이트/다크 규칙)를 붙여넣거나 zip 업로드.
4. **대체 진행**: iyumi 없이 component_lab + Figma 토큰만으로 진행하고, iyumi는 추후 정합.

## iyumi에서 확보해야 할 항목 (수령 시 채울 체크리스트)

- [ ] **카드 사양**: 배경색(라이트/다크), 반경, 패딩, 보더, **그림자/글로우 유무·값**, 내부 간격.
- [ ] **Static 정의**: Static/Black = 순검정(#000000)인지 오프블랙인지. Static/White 값.
- [ ] **배경 규칙**: 라이트/다크에서 페이지 배경 처리(검정 고정 근거).
- [ ] **컬러 토큰**: component_lab과 동일/차이 여부(특히 Component/fill 8% vs 5% 충돌 — `token-mapping.md` §1).
- [ ] **타이포/간격/반경** 스케일이 component_lab과 일치하는지.
- [ ] **카드형 레이아웃 패턴**: 리스트/그리드, 카드 간 간격, 섹션 헤더 스타일.
- [ ] **모션/인터랙션** 가이드(있으면).

## 이 블로커가 막는 결정

- `04-static-black-theme.md` §4의 **방향 A vs B**(라이트 카드를 다크에 수렴 vs 검정 위 흰 카드).
- 카드 그림자 → `AppShadow` 토큰 신설 여부(`token-mapping.md` §5).
- Static/Black 정확값.

## 임시 진행 가이드 (iyumi 없이도 가능한 부분)

iyumi 확인 전에도 다음은 진행 가능:
- task 1(플로우 수정) — iyumi 무관.
- task 2 단계 1(토큰 흡수), 단계 2 버튼/폼 등 — component_lab 근거로 진행.
- task 4 §2-1·§2-2(배경 검정 고정) + §3 부작용 점검 — 배경 검정화는 확정 요구사항.
- **보류**: 카드 최종 스타일(그림자/방향 A·B), Static 정확값. → iyumi 수령 후 마무리.
