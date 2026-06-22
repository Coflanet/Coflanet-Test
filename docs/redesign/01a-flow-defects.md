# Task 1a — 인터랙션·데이터 결함 전수 감사

> "플로우상 문제 + 데이터 없이 들어간 영역"을 **새 데이터/기능 만들기 전에** 정리한 목록.
> 전 모듈 코드 직접 확인(`file:line` 증거). `01-user-flow-audit.md`(라우트 레벨)의 후속 — 이건 **탭/버튼/데이터 레벨**.

## 0. 요약

| # | 위치 | 결함 | 상세 대상 존재 | 새 데이터 없이 수리? | 심각도 |
|---|------|------|:---:|:---:|:---:|
| A1 | `home_my_bean_section.dart:101` | 개별 원두 카드 탭 무반응(Container, onTap 없음) | ✅ beanDetail | ✅ 배선만 | P1 |
| A2 | `matching_recommendation_card.dart:11` | "자세히 보기" 칩 탭 무반응(의도적 미추가) | ✅ beanDetail | ✅ 배선/또는 칩 제거 | P1 |
| B1 | `bean_detail`·`recommendation_card.dart:336` | 판매링크 버튼이 URL 안 엶 | ✅ 데이터 `naverLink`/`purchaseUrl` 있음 | ✅ url_launcher 배선 | P1 |
| B2 | `cart_controller.dart:35` | "주문하기" = underConstructionPopup(결제 없음) | ❌ 결제 미구현 | △ 어포던스 정리 | P2 |
| B3 | `survey_result_view.dart:93` | "추천 원두 더 보기" 빈 콜백 `(){}` | △ 쇼핑(숨김 예정) | ✅ 정리 | P2 |
| C1 | `home_product_section.dart:103` | 상품 카드 onTap 미전달 → 탭 무반응 | ❌ **상품 상세 화면 없음** | ❌ 화면 신설 필요 | P1 |
| D1~ | (여러) | 데이터 없이 들어간 영역(placeholder) | — | — | P2 |

> A1은 **에이전트 감사가 놓친 항목**(직접 확인). 사용자가 지적한 "홈 아이템 탭→상세 안 감"의 실제 원인 = A1(원두) + C1(상품).

---

## 1. 그룹 A — 탭 무반응인데 **상세 화면은 이미 있음** → 지금 바로 수리

### A1. 홈 "보유 원두" 개별 카드 (`home_my_bean_section.dart:101-183`)
- `_buildBeanCard(item)`이 `GestureDetector`/`InkWell` 없는 순수 `Container`. 편집하기·전체보기만 동작(둘 다 원두 탭으로).
- `beanDetail` 라우트/화면 존재(`bean_detail_view.dart`) → **연결만 하면 됨**.
- **수리**: `_buildBeanCard`를 `GestureDetector(onTap: () => onItemTap(item))`로 감싸고, 섹션에 `onItemTap` 콜백 추가 → `Get.toNamed(Routes.beanDetail, arguments: {'beanId': item.id})` 또는 원두 탭+해당 원두 확장.

### A2. 매칭 결과 "자세히 보기" 칩 (`matching_recommendation_card.dart:11-14, ~105-120`)
- 칩 텍스트는 "자세히 보기"인데 주석에 *"원본에 탭 동작이 없으므로 onTap 을 추가하지 않는다"* → **의도적 무반응**. 하지만 "자세히 보기"라는 라벨이 탭을 유도해 **오해 소지**.
- `beanDetail` 존재.
- **수리(택1)**: (a) 카드/칩에 `onTap` 추가 → beanDetail 연결, 또는 (b) "자세히 보기" 칩을 제거(탭 의도 없으면 라벨도 빼서 거짓 어포던스 제거).

---

## 2. 그룹 B — 안 먹는 버튼 (대상 기능 자체가 미구현)

### B1. 판매링크 버튼이 URL을 안 연다 — ✅ 데이터 있음, 배선만 누락
**정정**: "대상 없음"이 아니다. **데이터에 네이버 판매 URL이 이미 있다.**
- 원두(`CoffeeItem`): **`naverLink`**(네이버 판매 URL) + `naverLprice`/`naverHprice`/`naverMallName`. DB→repository 로드됨(`supabase_coffee_repository.dart:223`).
- 추천(`CoffeeRecommendationModel`): **`purchaseUrl`** = `naver_link` 매핑(`supabase_survey_repository.dart:243`).
- 문제: `naverLink`/`purchaseUrl`을 **`launchUrl`로 여는 코드가 어디에도 없다**(전 코드 grep 결과 view/controller 미사용). 원두 상세는 네이버 가격·몰명만 표시(`bean_detail_header.dart:77,112,113,136`)하고 **판매링크 버튼이 없음**. 온보딩 `_buildPurchaseButton`(`recommendation_card.dart:336`)도 죽은 Container.
- **정식 플로우(사용자 확정)**: **원두 리스트 → 상세 페이지 → "판매링크 바로가기" → `naverLink` 외부 열기.**
- **수리**:
  1. **원두 상세**(`bean_detail_view`/`bean_detail_header`)에 "판매링크 바로가기/구매하기" 버튼 추가 → `launchUrl(Uri.parse(bean.naverLink!), mode: LaunchMode.externalApplication)`. `url_launcher` 이미 사용 중(`home_controller.dart:143`).
  2. 온보딩 `_buildPurchaseButton` → `recommendation.purchaseUrl` 열기.
  3. `naverLink`/`purchaseUrl`이 null/빈값이면 버튼 숨김 또는 비활성.

### B2. 장바구니 "주문하기" (`cart_controller.dart:34-37`)
- `checkout()` → `AppUtil.underConstructionPopup()` 만. 결제/주문 플로우 미구현.
- **수리**: 결제가 MVP 밖이면 장바구니/주문 어포던스를 **숨김** 또는 "준비 중" 명시. (쇼핑 탭 숨김 결정과 함께 검토 — §5.)

### B3. 온보딩 결과 "추천 원두 더 보기" (`survey_result_view.dart:93`)
- `onMoreTap: () {}` 빈 콜백.
- **수리**: 의미 있는 목적지로 연결하거나(쇼핑은 숨김 예정 → 원두 탭/매칭 결과 등) 버튼 제거.

---

## 3. 그룹 C — 탭할 곳(상세)이 **아예 없음** (구조적)

### C1. 홈 상품 추천 카드 (`home_product_section.dart:103-113`)
- `ProductCard`는 `onTap`을 **지원**(`product_card.dart:25,53,58`)하지만 홈 섹션이 **안 넘겨줌** → 무반응.
- 더 근본 문제: **상품 상세 화면·라우트가 앱에 없다.** 홈 추천은 `CoffeeRecommendationModel`(쇼핑 상품: 제조사·가격·할인) → 연결할 "상품 상세"가 미존재. (쇼핑 탭도 placeholder)
- **수리(택1, 사용자 결정 §7)**:
  - (a) 상품 상세 화면 신설(쇼핑 부활 시) — 데이터/화면 둘 다 필요.
  - (b) 쇼핑을 MVP에서 빼는 방향(숨김 결정)과 일관되게 **홈 상품 추천 섹션 자체를 재검토**(§5).
  - (c) 임시로 탭 어포던스 제거(눌리는 것처럼 안 보이게).

---

## 4. 그룹 D — 데이터 없이 들어간 영역 (placeholder / 백엔드 대기)

| 영역 | 위치 | 상태 |
|---|---|---|
| 홈 "취향 추천"/"새로운 맛" 상품 | `home_content.dart:98-124`, `home_controller.dart` | 추천 API 비면 "준비 중" 빈 카드 |
| 홈 "커피 메이커" 섹션 | `home_maker_section.dart:46` | "준비 중" 고정 |
| 홈 "커피 기록 커뮤니티" 섹션 | `home_community_section.dart:39` | "준비 중" 고정 |
| 쇼핑 탭 | `shopping_content.dart` | 전체 placeholder — ✅ **숨김 결정**(`01` §4-7) |
| 커뮤니티 탭 | `community_content.dart` | 전체 placeholder — ✅ **숨김 결정** |
| 시음 노트 | `tasting_notes_view.dart` | placeholder — ✅ **활성화 결정**(커피 저널, `01` §4-3) |
| like(찜) 상태 | `home_controller.dart` | 서버 미저장(로컬만) — 영속화 필요 시 백엔드 |

---

## 5. ⚠️ 파급 — 탭 숨김(쇼핑/커뮤니티)이 **홈을 깨뜨림**

커뮤니티·쇼핑 탭 숨김(3탭) 결정의 **연쇄 효과**가 홈에 있다:
- 홈 "취향 추천"/"새로운 맛" 섹션 `onMoreTap → 쇼핑 탭`(숨김) → **갈 곳 없음** + 카드 탭 무반응(C1) + 데이터 빈 상태(D).
- 홈 "커피 기록 커뮤니티" 섹션 `onMoreTap → 커뮤니티 탭`(숨김) → **갈 곳 없음** + "준비 중".
- 홈 "커피 메이커" 섹션 → 빈 데이터.

→ **홈 재구성이 필요**하다. 빈/연결끊긴 섹션을 그대로 두면 검정 캔버스 위에서 더 도드라진다. iyumi가 같은 작업을 한 선례가 있다 → `reference/iyumi/home-restructure.md`(3열 빠른액세스 제거, 탭 4개로 정리, "내가 담은 이유식" 도입). coflanet도 **홈을 원두/추출/취향 중심으로 재구성**하는 결정 필요.

---

## 6. 수리 우선순위 (새 데이터 없이 가능한 것부터)

1. **지금 바로(배선만, 데이터 있음)**: A1(원두 카드→beanDetail), A2(칩 연결 또는 제거), **B1(상세에 판매링크 버튼 추가→`naverLink` 열기)**, B3(빈 콜백 정리).
   - → "**원두 리스트/홈 원두 카드 → 상세 → 네이버 판매링크**" 플로우가 한 번에 완성됨(A1 + B1). 원두 상세가 허브.
2. **거짓 어포던스 제거**: B2·C1 — 대상 없는 버튼/탭은 "준비 중"으로 두지 말고 **노출 자체를 빼거나 비활성 명시**(누르면 아무 일 없는 게 최악).
3. **홈 재구성 결정**(§5): 탭 숨김 파급 + 빈 섹션 정리. iyumi home-restructure 선례 참고.
4. **데이터/화면 신설(별도 트랙)**: 상품 상세, 결제, 판매링크, 추천 API — MVP 범위 결정 후.

> 원칙: 리디자인(task 4 카드화) **전에** 1·2를 끝내 "눌러도 안 되는 것"을 0으로 만든 뒤, 깨끗한 플로우 위에 스타일을 입힌다.

## 7. 미결 (사용자 결정)

- [ ] **홈 상품 추천 섹션(C1·§5)**: 쇼핑 숨김 상태에서 — (a) 섹션 숨김, (b) 원두/취향 중심 콘텐츠로 교체, (c) 추후 쇼핑 부활까지 보류 중 무엇? (참고: 추천 모델에 `purchaseUrl` 있으니 카드 탭→네이버 직접 열기도 가능)
- ✅ **판매링크(B1)**: 원두 상세에 버튼 추가 → `naverLink` 외부 열기로 **확정**.
- [ ] **주문하기/결제(B2)**: 장바구니 결제는 MVP 밖 → 어포던스 숨김 vs "준비 중" 유지?
- [ ] **매칭 "자세히 보기" 칩(A2)**: beanDetail 연결 vs 칩 제거?
- [ ] **홈 재구성(§5)**: 별도 라운드로 진행할지(권장).
