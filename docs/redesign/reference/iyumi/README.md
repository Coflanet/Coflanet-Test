# iyumi 디자인 레퍼런스 (vendored)

> 출처: `IYUMI-org/iyumi` 레포의 `docs/` (사용자가 zip으로 전달, 2026-06-22 수집).
> iyumi는 **영유아 이유식 케어 앱**으로 coflanet과 **별개 제품**이지만, **같은 디자인 시스템(Coflanet CDS)을 공유**한다.
> 여기엔 coflanet 리디자인에 직접 쓰이는 디자인 스펙만 발췌·복사했다.

## iyumi ↔ coflanet ↔ CDS 관계

```
Coflanet CDS (package:cds / component_lab foundation)   ← 공유 디자인 시스템 SoT
   ├─ coflanet  (커피 앱)   — CDS 사용
   └─ iyumi     (이유식 앱) — 원래 CDS 의존 → lib/core/tokens/ 로 내재화(독립 빌드)
                              + 카드형 디자인 패턴(CardSection/CardItem) 정제
```

- 즉 사용자가 말한 "이유미 카드형 디자인"은 = iyumi가 CDS 위에서 만든 **`card-design-spec.md`의 CardSection/CardItem 패턴**이다.
- iyumi의 토큰(`AppSpacing`/`AppRadius`/`AppColorScheme`)은 coflanet과 **같은 계보** → 명칭/구조가 호환된다.

## 수록 파일

| 파일 | 용도(coflanet 적용) |
|------|------|
| `card-design-spec.md` | **task 4 핵심** — 카드 레이어 구조·토큰표·재사용 위젯(CardSection/CardItem/ScreenScaffold) |
| `bottom-sheet-guide.md` | 바텀시트 표준(`showAppSheet`/`AppBottomSheet`) — task 2 모달 마이그레이션 참고 |
| `home-restructure.md` | IA 결정 기록 예시 — task 1 유저플로우/탭 구조 의사결정 방식 참고 |

## 미수록(iyumi 앱 특화 — 필요 시 원본 참조)

flow-audit, userflow-all-cases, ia-structure, ux-design-review-report, qa_*, research-*, monetization, analytics-events, voc-analysis, ai-coaching-plan, image-* 등은 iyumi(이유식) 제품 특화라 coflanet에 직접 이식하지 않음. 단, **플로우 감사·IA 평가 방법론**은 task 1에 참고 가능.
