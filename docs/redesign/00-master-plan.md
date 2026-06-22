# Coflanet 리디자인 · 라이브러리 마이그레이션 — 마스터 플랜

> 이 문서는 전체 작업의 상위 계획서다. 세부는 각 task 문서로 분기.
> **개발 실행은 로컬 세션**이 담당. 이 폴더는 그 실행을 위한 설계·근거·체크리스트다.

## 0. 요청 요약 (사용자 5개 항목)

1. **유저 플로우** 전체 정리·검증 + 막히는 부분 수정 → `01-user-flow-audit.md`
2. **라이브러리 마이그레이션** (`Coflanet/Coflanet-Test`의 component_lab) → `02-library-migration.md`
3. **간격·스타일·텍스트 등 스타일 적용** → `03-style-application.md`
4. **iyumi 카드형 디자인 + 배경 Static/Black(라이트·다크 공통)** → `04-static-black-theme.md`
5. **iyumi docs 참고** → `05-iyumi-reference.md`

## 1. 현황 한눈에

- **앱**: Flutter + GetX(MVVM), Supabase(DB-only), 소셜로그인, Pretendard. v0.1.2+1.
- **이미 보유**: 견고한 디자인 시스템(`AppColor`·`AppColorScheme` 라이트/다크, `AppTextStyles`, `AppSpacing`, `AppRadius`, `AppTheme`), 30+ 라우트, 5탭 셸, 통합 테스트.
- **가져올 것**: component_lab(Coflanet Design System) — Figma 검증된 컴포넌트 21 카테고리(버튼 완전검증) + foundation 토큰 + Widgetbook. 완성도 74%.
- **핵심 통찰**: 마이그레이션은 "제로 도입"이 아니라 **정합·확장·검증**. 컬러 아키텍처는 앱 쪽이 더 앞서 있어 유지, 값/컴포넌트만 흡수.

## 2. 핵심 의사결정 (확정/권장)

| # | 결정 | 상태 |
|---|------|------|
| D1 | 마이그레이션 방식 = **소스 흡수(Vendoring)** (path 의존은 순환이라 불가) | ✅ 권장 확정 |
| D2 | 컬러 아키텍처 = **앱의 `AppColorScheme` 유지**, component_lab 값만 흡수 | ✅ 권장 확정 |
| D3 | 타깃 구조 = 토큰 `lib/constants/` 병합 + 컴포넌트 `lib/widgets/<category>/` | ✅ 권장 |
| D4 | 배경 = 라이트/다크 모두 `Static/Black`(#000000) 고정 | ✅ 요구사항 |
| D5 | 라이트 카드 방향 A(다크 수렴) vs B(검정 위 흰 카드) | ⛔ **iyumi 확인 필요** |
| D6 | `AppShadow` 토큰 신설 여부 | ⛔ **iyumi 확인 필요** |

## 3. 권장 실행 순서 (Phase)

```
Phase A. 유저 플로우 안정화 (task 1)        [독립·선행]
   └ P0 라우트/인자 수정 → P1 죽은화면 결정 → 분기 명확화

Phase B. Foundation 토큰 흡수 (task 2 단계1 + task 3 단계1)
   └ 팔레트 대조 · Static 그룹 · spacing 34/36/44 · 타이포 누락 · (Shadow 보류)

Phase C. Static/Black 배경 적용 (task 4 §2-1·2-2·3)
   └ 배경 검정 고정 + 부작용 전수 점검  [iyumi 없이 가능]

Phase D. 컴포넌트 마이그레이션 (task 2 단계2~4)
   └ 버튼→칩→카드→폼→모달→피드백→나머지 + P0 위젯 10종

Phase E. 스타일 전면 적용 (task 3 단계2~4)
   └ 화면별 토큰화(간격/타이포/반경/색) · 하드코딩 제거

Phase F. iyumi 정합 마무리 (task 4 §2-3·2-4, task 5)
   └ 방향 A/B 확정 · 카드 그림자 · Static 정확값  [iyumi 수령 후]

Phase G. 통합 검증
   └ flutter analyze 0 · 통합테스트 · 라이트/다크/Static-Black 스냅샷
```

> 병렬화 힌트: Phase A는 B~E와 독립적으로 먼저/동시 진행 가능. iyumi 블로커는 Phase F만 막으므로 **A~E를 먼저 끝내고 F를 대기**하는 것이 최적.

## 4. 블로커 / 리스크

| 리스크 | 영향 | 완화 |
|--------|------|------|
| **iyumi 접근 불가** | 카드 최종 스타일·Static 정확값 확정 불가(D5/D6) | A~E 선행, iyumi 수령 시 F 마무리. `05-iyumi-reference.md` 해결책 4안 |
| 배경 검정화 부작용 | 라이트 "흰 배경 가정" 화면 깨짐 | `04` §3 전수 체크리스트 |
| Component/fill 8% vs 5% 충돌 | 색 미세 불일치 | 값 변경 금지·주석화, 디자이너 합의 |
| 순환 의존 | 빌드 불가 | 소스 흡수(D1) |
| 회귀 | 플로우/시각 깨짐 | 통합테스트 + 스냅샷 게이트 |
| **CI Format Check 선행 부채** | `dart format` 미적용 Dart 31개로 CI 빨강(문서 PR과 무관) | 로컬 세션이 **첫 단계로 `dart format .` 실행** 후 작업 시작 |

## 5. 완료 기준 (Definition of Done)

- [ ] task 1 블로커 P0/P1 해소, 통합테스트 통과.
- [ ] component_lab foundation 토큰 흡수 + 검증된 컴포넌트 이관.
- [ ] 전 화면 토큰화(하드코딩 0), 라이트/다크/Static-Black 일관.
- [ ] 배경 Static/Black 양쪽 적용 + 부작용 0.
- [ ] iyumi 정합(수령 시) 또는 미수령 사유·대체안 기록.
- [ ] `flutter analyze` 0 이슈 · 라이트/다크 스냅샷 `verification/` 첨부.

## 6. 미결 질문 (사용자/기획 확인)

1. **iyumi 접근**: 공개 전환 / 스코프 추가 / 내용 전달 / 없이 진행 중 무엇? (`05` 참조)
2. 라이트 카드 방향 **A vs B**? (`04` §4)
3. task 1: ExtractionList·TastingNotes / 커뮤니티·쇼핑 탭 / SurveyReason 처리 방침? (`01` §7)
4. 라이트/다크 토글 **유지**(배경만 고정) vs 단일 테마화?
