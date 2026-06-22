# Task 3 — 간격·스타일·텍스트 등 스타일 적용

> 목표: 마이그레이션한 라이브러리 토큰(간격/타이포/반경/색)을 **앱 전 화면에 일관 적용**.
> 사전 읽기: `reference/token-mapping.md`, `02-library-migration.md`(단계 1), component_lab `docs/spacing-migration/`.

## 1. 원칙

1. **토큰만 사용**: 하드코딩된 매직넘버(예: `EdgeInsets.all(15)`, `BorderRadius.circular(10)`) 금지 → `AppSpacing`/`AppRadius`/`AppTextStyles`/`AppColorScheme`로 치환.
2. **시맨틱 우선**: `space16`보다 `cardPadding`/`screenPadding` 같은 의미 토큰을 우선.
3. **테마 인지 색**: 색은 항상 `AppColorScheme.of(context)`로 — `AppColor.시맨틱` 직접 사용 지양(테마 전환 미반영).
4. **No-estimation**: 값 변경 시 Figma/HANDOFF 근거 명시.

## 2. component_lab 간격 마이그레이션 워크스페이스 따르기

라이브러리 `docs/spacing-migration/`은 4단계 워크플로를 정의한다. 앱에도 동일 절차 적용:

1. **01-audit** — 현재 간격 사용 전수 조사, 불일치 식별.
   - [ ] `grep`으로 `EdgeInsets`/`SizedBox`/`Padding` 하드코딩 수집 → 빈도표 작성.
2. **02-tokens** — 제안 간격 토큰 스케일·네이밍·정의 확정.
   - [ ] `token-mapping.md` §2의 누락 단계(34/36/44) 반영 + 시맨틱 명칭 통일.
3. **03-mapping** — old→new 변환표.
   - [ ] `15→16`, `10→ (8 또는 12)`, `22→24` 등 근사 규칙 표로 고정.
4. **04-apply-log** — 화면별 롤아웃 기록.
   - [ ] 화면 단위로 적용하며 `docs/redesign/apply-log.md`에 누적.

## 3. 적용 범위 — 모듈별 체크리스트

> 화면 단위로 "간격→타이포→반경→색" 순서로 점검. 라이트/다크 + (task 4 적용 후) Static/Black 배경에서 확인.

- [ ] `splash`
- [ ] `auth/*` (signin, email_login, signup, profile_setup, account_link)
- [ ] `onboarding/*` (intro, reason, section_intro, question, analyzing, complete, result)
- [ ] `shell/*` (탭바·탑내비 — 토큰 정합만, 고정 다크 유지)
- [ ] `home/*`
- [ ] `coffee/*` (main, hand_drip, espresso, settings, select, bean, timer)
- [ ] `matching/*`
- [ ] `planet/*`, `profile/*`
- [ ] `search`, `notification`, `cart`, `community`, `shopping`
- [ ] `extraction`, `tasting` (task 1 결정에 따라)

## 4. 타이포그래피 적용

- 모든 `Text`는 `AppTextStyles.*` 사용. 인라인 `TextStyle(fontSize: ...)` 금지.
- 색은 `.copyWith(color: AppColorScheme.of(context).labelNormal)` 형태로 분리(스타일=크기/가중치, 색=테마).
- 숫자/타이머 표기는 Mono 변형(`*Mono`) 사용 확인.
- `textTheme`(app_theme.dart)와 직접 스타일 사용처의 정합 점검.

## 5. 컴포넌트 표준화

- 버튼: 사이즈 체계 `AppSolidButton`(52/40/32)로 통일. 화면별 임의 높이 제거.
- 카드: `cardPadding`(16) + `radiusCard`(16) 표준. iyumi 카드 디자인(task 4) 반영.
- 입력: `radiusInput`(12) + `componentFillNormal` 배경 + 포커스 `primaryNormal` 2px.
- 모달: `radiusModal`(20) + `backgroundElevatedNormal`.
- 칩/태그: `radiusChip`(8). flavor 색 유지.

## 6. 검증

- [ ] `flutter analyze` 0 이슈.
- [ ] 하드코딩 스캔: `EdgeInsets.` 직접 숫자, `fontSize:`, `BorderRadius.circular(<숫자>)` 잔존 0(토큰 경유 제외).
- [ ] 8pt 그리드 정합(필요 시 `ui-detail-check` 스킬 활용).
- [ ] 라이트/다크/Static-Black 3개 상태 스냅샷 비교.

## 7. 산출물

- 토큰화된 전 화면 + `docs/redesign/apply-log.md`(화면별 적용 기록).
- 하드코딩 잔존 리포트(0 목표).
