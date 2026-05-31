# Survey Result 작업 보고 (작업 C)

## 핑크 할인 배너 추가
`_buildDiscountBanner` 메서드 추가 — Flavor descriptions 와 추천 원두 사이에 배치.
- 핑크 그라데이션 (`#FFB6D1` → `#FF7AA8`)
- "OOO님만을 위한 첫 구매 할인" + "추천 원두 최대 20% 할인 진행중"
- 우측 화살표 (chevron_right)
- [백엔드 API 연동 대기] 실 프로모션 정보 연동 시 동적 텍스트

## 추천 원두 다중 표시
이미 `recommendations.map((rec) => _buildRecommendationCard(rec))` 로 구현됨 확인. 추가 변경 없음.

## 동적 헤더
이미 `${controller.userName}님은` + `${result?.coffeeTypeDescription} 즐기시네요!` 로 구현됨 확인.

## 좋아요 토글 강화
SurveyController에 별도 좋아요 셋 (`_likedBeanIds`) 추가:
- `isBeanLiked(id)` / `toggleBeanLike(id)`
- 기존 선택(`selectedBeanIds`) 과 분리 — 선택은 리스트 추가, 좋아요는 찜.

추천 카드 thumbnail 우하단에 좋아요 버튼 오버레이:
- 28x28 원형 + 흰 배경 + 그림자
- `favorite` / `favorite_border` 토글 (보라색)

## 변경 파일
- `lib/modules/onboarding/result/survey_result_view.dart` — `_buildDiscountBanner` 추가, 카드 thumbnail Stack 으로 변경
- `lib/modules/onboarding/survey_controller.dart` — `_likedBeanIds`, `isBeanLiked`, `toggleBeanLike` 추가

## 검증
- `flutter analyze lib/` → No issues found
