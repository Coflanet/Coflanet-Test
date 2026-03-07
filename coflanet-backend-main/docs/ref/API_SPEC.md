# Coflanet API Specification

프론트엔드 기준 API 엔드포인트 및 데이터 송수신 명세서입니다.

- **Base URL**: `https://api.coflanet.com/v1`
- **인증**: `Authorization: Bearer {accessToken}` 헤더
- **Timeout**: 30초
- **현재 상태**: Dummy 데이터 사용 중 (`RepositoryConfig.useDummyData = true`)

---

## 엔드포인트 요약

| 도메인 | 개수 | 주요 엔드포인트 |
|--------|------|----------------|
| **Auth** | 6 | 소셜 로그인, 토큰 갱신, 로그아웃, 회원탈퇴, 프로필 조회/수정 |
| **Survey** | 10 | 질문 조회, 답변 제출/저장, 분석 결과 CRUD, 선택 원두, 가입 이유 |
| **Coffee** | 8 | 원두 CRUD, 숨김 처리, 정렬 변경, 일괄 저장 |
| **Recipe** | 9 | 레시피 CRUD, 타입별 조회, 즐겨찾기 |
| **User Prefs** | 1 | 사용자 설정 동기화 |
| **합계** | **34** | |

---

## 1. Auth (`/auth`, `/users`)

| Method | Endpoint | 설명 |
|--------|----------|------|
| `POST` | `/auth/social-login` | 소셜 토큰 → 서버 JWT 교환 |
| `POST` | `/auth/refresh` | Access Token 갱신 |
| `POST` | `/auth/logout` | 로그아웃 (토큰 무효화) |
| `DELETE` | `/auth/delete-account` | 회원탈퇴 |
| `GET` | `/users/me` | 현재 사용자 조회 |
| `PATCH` | `/users/me` | 프로필 수정 (이름, 프로필 이미지) |

### 1.1 소셜 로그인 — `POST /auth/social-login`

소셜 SDK에서 받은 토큰을 서버 JWT로 교환합니다.

**Request:**
```json
{
  "provider": "kakao|naver|apple",
  "social_token": "소셜SDK에서_받은_토큰",
  "social_id": "소셜_고유ID",
  "email": "user@example.com",
  "name": "사용자 이름",
  "profile_image_url": "https://..."
}
```

**Response (201 Created):**
```json
{
  "user": {
    "id": "server_user_id",
    "email": "user@example.com",
    "name": "사용자 이름",
    "profile_image_url": "https://...",
    "provider": "kakao"
  },
  "access_token": "jwt_access_token",
  "refresh_token": "jwt_refresh_token"
}
```

**에러:** 400 (잘못된 provider), 401 (소셜 토큰 만료), 500

### 1.2 토큰 갱신 — `POST /auth/refresh`

**Request:**
```json
{
  "refresh_token": "jwt_refresh_token"
}
```

**Response (200):**
```json
{
  "access_token": "new_jwt_access_token",
  "refresh_token": "new_jwt_refresh_token"
}
```

**에러:** 401 (refresh token 만료)

> ApiClient 인터셉터가 401 응답 시 자동으로 호출합니다.

### 1.3 로그아웃 — `POST /auth/logout`

**Request:** 빈 body (Authorization 헤더 사용)

**Response:** 204 No Content

### 1.4 회원탈퇴 — `DELETE /auth/delete-account`

**Request:** 빈 body

**Response:** 204 No Content

> 서버에서 사용자 데이터 전부 삭제. 프론트엔드에서 소셜 연동 해제 + 로컬 데이터 삭제 수행.

### 1.5 현재 사용자 조회 — `GET /users/me`

**Response (200):**
```json
{
  "user": {
    "id": "user_id",
    "email": "user@example.com",
    "name": "사용자 이름",
    "profile_image_url": "https://...",
    "provider": "kakao"
  }
}
```

### 1.6 프로필 수정 — `PATCH /users/me`

**Request:**
```json
{
  "name": "새로운 이름",
  "profile_image_url": "https://..."
}
```

**Response (200):** 수정된 user 객체

---

## 2. Survey (`/survey`)

| Method | Endpoint | 설명 |
|--------|----------|------|
| `GET` | `/survey/questions` | 설문 질문 목록 |
| `POST` | `/survey/submit` | 답변 제출 → 분석 결과 반환 |
| `GET` | `/survey/result` | 저장된 분석 결과 조회 |
| `POST` | `/survey/result` | 분석 결과 저장 |
| `DELETE` | `/survey/result` | 분석 결과 삭제 |
| `GET` | `/survey/answers` | 저장된 답변 조회 (중간 저장) |
| `POST` | `/survey/answers` | 답변 저장 (중간 저장) |
| `GET` | `/survey/selected-beans` | 선택한 원두 ID 목록 |
| `POST` | `/survey/selected-beans` | 선택한 원두 저장 |
| `POST` | `/survey/reasons` | 가입 이유 저장 |

### 2.1 설문 질문 조회 — `GET /survey/questions`

**Query Params:** `type=standard|lifestyle` (기본: standard)

**Response (200):**
```json
{
  "questions": [
    {
      "step": 0,
      "question": "어떤 기구로 커피를 마시나요?",
      "description": "중복 선택 가능해요.",
      "questionType": "imageGrid",
      "allowMultiple": true,
      "category": null,
      "options": [
        {
          "id": "espresso",
          "label": "에스프레소 머신",
          "icon": null,
          "description": null
        }
      ],
      "multiRatingItems": null
    },
    {
      "step": 6,
      "questionType": "multiRating",
      "category": "특성 향미 취향",
      "multiRatingItems": [
        {
          "id": "fruit",
          "question": "과일의 향",
          "description": "딸기, 자몽 등",
          "hasNeutral": true
        }
      ]
    }
  ]
}
```

**질문 타입 5가지:**

| questionType | UI | 설명 |
|-------------|-----|------|
| `checkbox` | 텍스트 체크박스 | 기본 텍스트 선택 |
| `checkboxWithIcon` | 이모지 + 텍스트 | 아이콘과 설명 포함 |
| `rating` | 3버튼 평점 | 싫어요/보통/좋아요 |
| `imageGrid` | 2열 이미지 그리드 | 이미지 카드 선택 |
| `multiRating` | 다중 평점 | 여러 항목을 한 화면에서 평가 |

### 2.2 답변 제출 — `POST /survey/submit`

**Request:**
```json
{
  "answers": {
    "0": ["espresso", "handdrip"],
    "1": ["beginner"],
    "2": ["like"],
    "6": {
      "fruit": 1,
      "floral": -1,
      "chocolate": 0
    }
  }
}
```

> multiRating 타입: -1 = 싫어요, 0 = 보통, 1 = 좋아요

**Response (200) — SurveyResultModel:**
```json
{
  "result": {
    "coffeeType": "balanced_acid",
    "coffeeTypeDescription": "산미와 바디감의 균형잡힌 커피를 선호하시네요",
    "tasteProfile": {
      "acidity": 65,
      "sweetness": 55,
      "bitterness": 40,
      "body": 60,
      "aroma": 70,
      "balance": 60
    },
    "flavorDescriptions": [
      {
        "name": "과일향",
        "emoji": "🫐",
        "description": "딸기, 자몽 등의 상큼한 과일 향미"
      }
    ],
    "recommendations": [
      {
        "id": "bean_1",
        "name": "에티오피아 예가체프",
        "manufacturer": "Coflanet",
        "origin": "에티오피아",
        "roastLevel": "Light",
        "description": "밝은 산미와 과일향이 특징",
        "imageUrl": "https://...",
        "originalPrice": 15000,
        "discountPrice": 12000,
        "discountPercent": 20,
        "weight": "200g",
        "tasteProfile": {
          "acidity": 75,
          "sweetness": 50,
          "bitterness": 30,
          "body": 40,
          "aroma": 80,
          "balance": 60
        },
        "matchPercent": 92,
        "flavorTags": ["과일향", "상큼함", "밝음"],
        "purchaseUrl": "https://shop.example.com/bean1"
      }
    ]
  }
}
```

### 2.3 분석 결과 저장 — `POST /survey/result`

**Request:** SurveyResultModel 전체 객체

**Response:** 201 Created

### 2.4 분석 결과 조회 — `GET /survey/result`

**Response:** SurveyResultModel 또는 404

### 2.5 분석 결과 삭제 — `DELETE /survey/result`

**Response:** 204 No Content

### 2.6 답변 저장 (중간 저장) — `POST /survey/answers`

**Request:**
```json
{
  "step_0": ["espresso", "handdrip"],
  "step_1": ["beginner"]
}
```

**Response:** 201 Created

### 2.7 답변 조회 — `GET /survey/answers`

**Response (200):** 저장된 답변 또는 404

### 2.8 선택한 원두 저장 — `POST /survey/selected-beans`

**Request:**
```json
{
  "bean_ids": ["bean_1", "bean_2", "bean_3"]
}
```

### 2.9 선택한 원두 조회 — `GET /survey/selected-beans`

**Response:**
```json
{
  "bean_ids": ["bean_1", "bean_2", "bean_3"]
}
```

### 2.10 가입 이유 저장 — `POST /survey/reasons`

**Request:**
```json
{
  "reasons": ["taste", "subscribe", "community"]
}
```

**유효 reason ID:**

| ID | 설명 |
|----|------|
| `taste` | 커피 취향을 찾고 싶어요 |
| `beginner` | 커피는 좋아하지만 추출은 처음이에요 |
| `subscribe` | 원두를 편하게 구독하고 싶어요 |
| `variety` | 다양한 원두를 시도해보고 싶어요 |
| `community` | 사람들과 커피에 대해 소통하고 싶어요 |
| `info` | 커피에 대한 정보를 알고싶어요 |

---

## 3. Coffee (`/coffees`)

| Method | Endpoint | 설명 |
|--------|----------|------|
| `GET` | `/coffees` | 원두 전체 목록 |
| `GET` | `/coffees/{id}` | 단일 원두 조회 |
| `POST` | `/coffees` | 원두 추가 |
| `PUT` | `/coffees/{id}` | 원두 수정 |
| `DELETE` | `/coffees/{id}` | 원두 삭제 |
| `PATCH` | `/coffees/{id}/visibility` | 숨김/표시 전환 |
| `POST` | `/coffees/reorder` | 정렬 순서 변경 |
| `POST` | `/coffees/batch` | 일괄 저장 |

### 3.1 원두 전체 목록 — `GET /coffees`

**Query Params:** `include_hidden=true|false` (기본: false), `sort_by=name|order` (기본: order)

**Response (200):**
```json
{
  "coffees": [
    {
      "id": "coffee_1",
      "name": "에티오피아 예가체프",
      "description": "밝은 산미와 과일향",
      "color": 4285227175,
      "imageUrl": "https://...",
      "brand": "Coflanet Select",
      "flavorProfile": {
        "acidity": 75,
        "body": 40,
        "sweetness": 50,
        "bitterness": 30,
        "balance": 60
      },
      "commonFlavors": ["과일 향", "베리"],
      "characteristicFlavors": ["자스민", "베리"],
      "aromaIntensity": 4.5,
      "origin": "에티오피아",
      "roastLevel": "Light",
      "processMethod": "Washed",
      "isHidden": false,
      "sortOrder": 1
    }
  ]
}
```

**CoffeeItem 필드:**

| 필드 | 타입 | 설명 |
|------|------|------|
| `id` | string | 고유 식별자 |
| `name` | string | 원두 이름 (한국어) |
| `description` | string | 짧은 설명 |
| `color` | int | ARGB 색상값 (UI 배경색) |
| `imageUrl` | string? | 제품 이미지 URL |
| `brand` | string? | 로스터/브랜드명 |
| `flavorProfile` | object? | 맛 레이더 차트 데이터 (0-100) |
| `commonFlavors` | string[] | 공통 향미 태그 |
| `characteristicFlavors` | string[] | 특성 향미 태그 |
| `aromaIntensity` | double? | 향 강도 (0.0-5.0) |
| `origin` | string? | 원산지 |
| `roastLevel` | string? | Light/Medium/Dark |
| `processMethod` | string? | Washed/Natural/Honey |
| `isHidden` | bool | 목록 숨김 여부 |
| `sortOrder` | int? | 표시 순서 (낮을수록 먼저) |

### 3.2 숨김 전환 — `PATCH /coffees/{id}/visibility`

**Request:**
```json
{
  "is_hidden": true
}
```

### 3.3 정렬 변경 — `POST /coffees/reorder`

**Request:**
```json
{
  "ordered_ids": ["coffee_2", "coffee_1", "coffee_3"]
}
```

### 3.4 일괄 저장 — `POST /coffees/batch`

**Request:**
```json
{
  "coffees": [CoffeeItem, CoffeeItem, ...]
}
```

---

## 4. Recipe (`/recipes`)

| Method | Endpoint | 설명 |
|--------|----------|------|
| `GET` | `/recipes` | 전체 레시피 목록 |
| `GET` | `/recipes/type/{type}` | 추출 타입별 레시피 |
| `GET` | `/recipes/{id}` | 단일 레시피 조회 |
| `POST` | `/recipes` | 커스텀 레시피 저장 |
| `PUT` | `/recipes/{id}` | 레시피 수정 |
| `DELETE` | `/recipes/{id}` | 레시피 삭제 |
| `GET` | `/recipes/saved` | 즐겨찾기 레시피 |
| `POST` | `/recipes/saved/{id}` | 즐겨찾기 추가 |
| `DELETE` | `/recipes/saved/{id}` | 즐겨찾기 제거 |

### 4.1 전체 레시피 — `GET /recipes`

**Response (200):**
```json
{
  "recipes": [
    {
      "id": "hand_drip_basic",
      "name": "핸드드립 기본 레시피",
      "coffeeType": "handDrip",
      "coffeeAmount": 18,
      "waterAmount": 300,
      "totalDurationSeconds": 180,
      "completionMessage": "맛있는 커피가 완성되었어요!",
      "aromaDescription": "상큼하고 밝은 향이 돌아요",
      "steps": [
        {
          "stepNumber": 1,
          "title": "뜸 들이기",
          "description": "30ml 붓기",
          "durationSeconds": 30,
          "waterAmount": 30,
          "stepType": "preparation",
          "illustrationEmoji": "☕",
          "actionText": "원두 18g을 균일하게 분쇄"
        },
        {
          "stepNumber": 2,
          "title": "1차 추출",
          "description": "100ml 붓기",
          "durationSeconds": 60,
          "waterAmount": 100,
          "stepType": "brewing"
        }
      ],
      "aromaTags": [
        { "emoji": "🫐", "name": "베리" },
        { "emoji": "🌸", "name": "꽃향" }
      ]
    }
  ]
}
```

**coffeeType 종류 (12가지):**

| coffeeType | 이름 |
|-----------|------|
| `handDrip` | 핸드드립 |
| `espresso` | 에스프레소 |
| `mokaPot` | 모카포트 |
| `frenchPress` | 프렌치프레스 |
| `aeropress` | 에어로프레스 |
| `coldBrew` | 콜드브루 |
| `chemex` | 케멕스 |
| `siphon` | 사이폰 |
| `turkish` | 터키식 |
| `vietnamese` | 베트남식 |
| `cleverDripper` | 클레버 드리퍼 |

**TimerStepModel 필드:**

| 필드 | 타입 | 설명 |
|------|------|------|
| `stepNumber` | int | 1부터 시작하는 단계 번호 |
| `title` | string | 단계 이름 |
| `description` | string | 단계 설명 |
| `durationSeconds` | int | 소요 시간 (초) |
| `waterAmount` | int? | 물 투입량 (ml) |
| `stepType` | enum | `preparation` / `brewing` / `waiting` |
| `illustrationEmoji` | string? | 일러스트 이모지 |
| `actionText` | string? | 강조 안내 문구 |

**stepType:**

| stepType | 동작 | 설명 |
|----------|------|------|
| `preparation` | 수동 진행 | 버튼으로 다음 단계 이동 |
| `brewing` | 카운트다운 | 타이머 표시, 자동 진행 |
| `waiting` | 대기 | 타이머 카운트다운 (사용자 대기) |

### 4.2 커스텀 레시피 저장 — `POST /recipes`

**Request:**
```json
{
  "id": "bean_coffee_1",
  "name": "에티오피아 예가체프 - 내 레시피",
  "coffeeType": "handDrip",
  "coffeeAmount": 20,
  "waterAmount": 320,
  "totalDurationSeconds": 200,
  "steps": [
    {
      "stepNumber": 1,
      "title": "뜸 들이기",
      "description": "30ml 붓기",
      "durationSeconds": 45,
      "waterAmount": 30,
      "stepType": "preparation"
    }
  ],
  "completionMessage": "맛있는 커피가 완성되었어요!",
  "aromaTags": []
}
```

**Response:** 201 Created

---

## 5. User Preferences (`/users/me/preferences`)

| Method | Endpoint | 설명 |
|--------|----------|------|
| `PATCH` | `/users/me/preferences` | 사용자 설정 동기화 |

**Request:**
```json
{
  "onboarding_complete": true,
  "dark_mode": false
}
```

**Response:** 200 OK

> 오프라인 접근을 위해 로컬 GetStorage에도 캐싱됩니다.

---

## 데이터 모델

### UserModel

```dart
class UserModel {
  final String id;
  final String? email;
  final String? name;
  final String? profileImageUrl;
  final String provider;        // "kakao" | "naver" | "apple" | "guest"
  final String accessToken;
  final String? refreshToken;
}
```

### SurveyResultModel

```dart
class SurveyResultModel {
  final String coffeeType;
  final String coffeeTypeDescription;
  final TasteProfileModel tasteProfile;
  final List<FlavorDescriptionModel> flavorDescriptions;
  final List<CoffeeRecommendationModel> recommendations;
}

class TasteProfileModel {
  final int acidity;      // 0-100
  final int sweetness;    // 0-100
  final int bitterness;   // 0-100
  final int body;         // 0-100
  final int aroma;        // 0-100
  final int balance;      // 0-100
}

class FlavorDescriptionModel {
  final String name;
  final String emoji;
  final String description;
}

class CoffeeRecommendationModel {
  final String id;
  final String name;
  final String? manufacturer;
  final String origin;
  final String roastLevel;
  final String description;
  final String? imageUrl;
  final int? originalPrice;
  final int? discountPrice;
  final int? discountPercent;
  final String? weight;
  final TasteProfileModel tasteProfile;
  final int matchPercent;    // 0-100
  final List<String> flavorTags;
  final String? purchaseUrl;
}
```

### CoffeeItem

```dart
class CoffeeItem {
  final String id;
  final String name;
  final String description;
  final int color;               // ARGB int
  final String? imageUrl;
  final String? brand;
  final FlavorProfile? flavorProfile;
  final List<String>? commonFlavors;
  final List<String>? characteristicFlavors;
  final double? aromaIntensity;  // 0.0-5.0
  final String? origin;
  final String? roastLevel;
  final String? processMethod;
  final bool isHidden;
  final int? sortOrder;
}

class FlavorProfile {
  final double acidity;    // 0-100
  final double body;       // 0-100
  final double sweetness;  // 0-100
  final double bitterness; // 0-100
  final double balance;    // 0-100
}
```

### TimerRecipeModel

```dart
class TimerRecipeModel {
  final String id;
  final String name;
  final String coffeeType;
  final int coffeeAmount;         // grams
  final int waterAmount;          // ml
  final int totalDurationSeconds;
  final List<TimerStepModel> steps;
  final String? completionMessage;
  final String? aromaDescription;
  final List<AromaTagModel> aromaTags;
}

class TimerStepModel {
  final int stepNumber;
  final String title;
  final String description;
  final int durationSeconds;
  final int? waterAmount;
  final TimerStepType stepType;   // preparation | brewing | waiting
  final String? illustrationEmoji;
  final String? actionText;
}

class AromaTagModel {
  final String emoji;
  final String name;
}
```

---

## 인증 플로우

### 소셜 로그인

```
1. 사용자가 카카오/네이버/애플 버튼 탭
   ↓
2. 프론트: 소셜 SDK에서 토큰 획득
   ↓
3. POST /auth/social-login (provider, social_token, user_info)
   ↓
4. 서버: 소셜 프로바이더에 토큰 검증
   ↓
5. 서버: 신규 사용자면 생성, JWT 발급
   ↓
6. 프론트: LocalStorage에 토큰 저장
   ↓
7. 프로필 설정 화면 → PATCH /users/me
   ↓
8. 온보딩 완료
```

### 토큰 갱신

```
1. API 요청 → Authorization: Bearer {accessToken}
   ↓
2. 401 Unauthorized 응답
   ↓
3. ApiClient 인터셉터 → POST /auth/refresh
   ↓
4. 새 토큰 발급 → LocalStorage 업데이트
   ↓
5. 원래 요청 재시도
```

---

## 공통 규칙

### 에러 응답 코드

| 코드 | 의미 |
|------|------|
| 400 | 잘못된 요청 |
| 401 | 인증 필요 (토큰 만료/무효) |
| 403 | 권한 없음 |
| 404 | 리소스 없음 |
| 422 | 유효성 검증 실패 |
| 500 | 서버 오류 |

### 맛 프로필 스케일

모든 맛 차원 (산미, 단맛, 쓴맛, 바디감, 향, 밸런스): **0–100 스케일**

- 0 = 없음 / 싫어함
- 50 = 보통
- 100 = 강함 / 좋아함

### 날짜 형식

ISO 8601 (`2026-02-20T14:30:00Z`)

권장 필드: `created_at`, `updated_at`

### Dummy → API 전환

```dart
// lib/data/repositories/repository_config.dart
class RepositoryConfig {
  static const bool useDummyData = false;  // true → false
}
```

---

*Generated: 2026-02-20*
