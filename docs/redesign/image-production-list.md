# 이미지 제작 리스트 (Claude-in-Chrome 자동 생성용)

> 목적: Static/Black 카드 리디자인 + 빈/플레이스홀더 영역에 필요한 이미지를 한 번에 생성하기 위한 작업 명세.
> 각 항목 = 파일명 · 용도(코드 위치) · 사이즈 · 스타일 · 생성 프롬프트.
> 자동화: 아래 "공통 스타일"을 프롬프트 prefix로 고정하고, 각 항목 프롬프트를 이어붙여 생성 → `assets/images/`에 파일명대로 저장.

## 0. 공통 스타일 가이드 (모든 이미지 prefix)

- **브랜드 컬러**: 바이올렛 Primary `#6541F2`(라이트)·`#7D5EF7`(다크) 포인트.
- **캔버스**: 앱 배경이 **Static/Black(#000000)** 이므로 **배경 투명 PNG**(흰 배경 금지). 검정 위에서 또렷해야 함.
- **톤&매너**: 기존 마스코트(`char_front/sitting/gift/drink_coffee.png`)와 동일 계열 — **부드러운 플랫 일러스트, 소프트 그라데이션, 둥근 형태, 미니멀**. 사진/실사 금지.
- **여백**: 요소가 프레임에 꽉 차지 않게 8~12% 패딩.
- **포맷**: PNG, 투명 배경, 2x 해상도(표기 사이즈의 2배로 생성 후 다운스케일 권장).
- **일관성**: 같은 카테고리는 라인 두께·채도·시점 통일.

---

## 1. 타이머 스텝 일러스트 (P1 — 현재 이모지 폴백)

`lib/modules/coffee/timer/widgets/timer_step_illustration.dart` — 스텝 제목으로 에셋 매핑. 현재 2개만 존재(`timer_step01_grinder`, `timer_step02_pourover`), 나머지는 이모지(`☕`) 폴백.
스텝 출처: `lib/data/dummy/dummy_timer_data.dart`. **표시 사이즈 280×280, 투명 PNG.**

| 파일명(제안) | 스텝 제목(매핑 키) | 생성 프롬프트 |
|---|---|---|
| `timer_step03_bloom.png` | 뜸 들이기 | 드리퍼 위에 부푼 원두 베드에서 김이 오르는 "뜸(bloom)" 순간, 소량의 물방울 |
| `timer_step04_pour1.png` | 1차 추출 | 구즈넥 주전자로 원을 그리며 1차 푸어오버, 물줄기 강조 |
| `timer_step05_pour2.png` | 2차 추출 | 2차 푸어, 드리퍼 안 수위가 차오르는 모습 |
| `timer_step06_drawdown.png` | 추출 완료 대기 | 드립 서버로 커피가 떨어지며 마무리되는 drawdown, 방울 |
| `timer_step_espresso_shot.png` | 추출 중(에스프레소) | 포타필터에서 에스프레소 두 줄기가 잔에 떨어지는 샷, 크레마 |

> 매핑 추가도 필요: 위 파일 생성 후 `timer_step_illustration.dart`의 `_getIllustrationAsset` switch에 제목→경로 case 추가 + `asset_constant.dart`에 상수 추가(코드 작업, 로컬 세션).

## 2. 추출 기구 이미지 (P1 — 현재 단색 아이콘)

`lib/modules/onboarding/widgets/survey_equipment_grid_item.dart:47` — "[백엔드 API 연동 대기] 실제 기구 이미지", 현재 `Icons.coffee_rounded` 단색.
기구 옵션 출처: `lib/data/dummy/dummy_lifestyle_survey_data.dart`(추출 방식). **표시 48×48(고해상 96×96 생성), 투명 PNG, 단일 오브젝트 아이콘 스타일.**

| 파일명(제안) | 라벨(id) | 생성 프롬프트 |
|---|---|---|
| `equip_espresso_machine.png` | 에스프레소 머신(`espresso`) | 가정용 에스프레소 머신 아이콘, 미니멀 플랫 |
| `equip_auto_machine.png` | 자동 커피머신(`auto`) | 전자동 커피머신(빈투컵) 아이콘 |
| `equip_handdrip.png` | 핸드드립(`handdrip`) | 드리퍼+서버+구즈넥 주전자 세트 아이콘 |
| `equip_capsule.png` | 캡슐 머신(`capsule`) | 캡슐 커피머신 + 캡슐 아이콘 |
| `equip_coldbrew.png` | 콜드브루(`coldbrew`) | 콜드브루 드립 타워/카라페 아이콘 |

## 3. 기본/폴백 이미지 (P2)

| 파일명(제안) | 용도(코드) | 사이즈 | 프롬프트 |
|---|---|---|---|
| `bean_default.png` | 원두 이미지 없을 때(`product_card.dart`/`home_my_bean_section.dart`의 `Icons.coffee` 폴백 대체) | 200×200 | 원두 봉투 또는 원두 더미 미니멀 일러스트, 중립 |
| `banner_default.png` | 홈 캐러셀 배너 빈 슬롯(`home_carousel.dart` placeholder) | 686×280(2.45:1) | 바이올렛 그라데이션 + 커피 모티프, 카피 없는 빈 배너 |

## 4. 빈 상태(Empty State) 일러스트 (P2 — 카드 리디자인용)

검정 캔버스 카드 안에 들어갈 빈 상태 일러스트. **표시 120×120, 투명 PNG.** 현재는 `Icon`만 사용(`home_empty_card.dart`, `app_empty_state.dart`, `home_my_bean_section`의 빈 상태 등).

| 파일명(제안) | 용도 | 프롬프트 |
|---|---|---|
| `empty_beans.png` | 보유 원두 없음 | 빈 원두 봉투 + 점선, 마스코트 톤 |
| `empty_recommend.png` | 추천 준비 중 | 돋보기로 원두 탐색하는 미니멀 장면 |
| `empty_records.png` | 추출 기록 없음(커피 저널) | 빈 노트 + 커피잔, 부드러운 톤 |
| `empty_search.png` | 검색 결과 없음 | 돋보기 + 빈 접시 |

## 5. 기존 일러스트 Static/Black 리워크 (P2 — 배경 충돌 점검)

기존 PNG들이 **흰/밝은 배경을 포함하면 검정 캔버스에서 사각형으로 떠 보인다.** 투명 배경 여부 점검 후 필요 시 재생성.

대상: `char_front/sitting/gift/drink_coffee.png`, `aroma_fruit/flower/nut_choco/roasting.png`, `emoji_coffee/beach.png`, `coffee_hand_drip/espresso.png`, `clapping_hands.png`, `completion_clapping_hands.png`.
- 액션: 각 파일을 검정 배경 위에 올려 흰 테두리/박스가 보이면 **투명 배경 + 검정 친화 버전**으로 재생성(동일 구도·색).

---

## 6. 우선순위 요약

| 순위 | 카테고리 | 개수 | 비고 |
|---|---|---|---|
| P1 | 타이머 스텝(§1) | 5 | 추출 화면 품질 직결 |
| P1 | 추출 기구(§2) | 5 | 설문 완성도 |
| P2 | 기본/폴백(§3) | 2 | |
| P2 | 빈 상태(§4) | 4 | 카드 리디자인과 함께 |
| P2 | 기존 리워크(§5) | 점검 후 결정 | Static/Black 필수 점검 |

## 7. Claude-in-Chrome 자동화 절차(제안)

1. §0 공통 스타일을 시스템 프롬프트로 고정.
2. 각 표의 "생성 프롬프트"를 항목별로 입력 → 이미지 생성.
3. 투명 배경 PNG로 저장, **파일명 그대로** `assets/images/`에 배치.
4. §1은 추가로 코드 매핑(switch/asset_constant) 필요 — 로컬 세션이 처리.
5. 생성 후 검정 배경 미리보기로 §0(투명/대비) 합격 여부 확인.
