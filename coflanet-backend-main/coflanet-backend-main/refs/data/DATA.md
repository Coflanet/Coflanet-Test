# Coflanet App - Backend API Data Structure Specification

## Overview
This document contains the complete data structure specification for the Coflanet coffee app backend. All JSON schemas are designed to be fully compatible with the current Flutter app implementation.

## Table of Contents
1. [User Management](#user-management)
2. [Survey System](#survey-system)
3. [Timer System](#timer-system)
4. [Coffee Recommendations](#coffee-recommendations)
5. [Storage Keys](#storage-keys)

---

## User Management

### User Profile
```json
{
  "id": "string", // UUID or unique identifier
  "name": "string", // User display name
  "email": "string", // User email (optional for social login)
  "accessToken": "string", // JWT token
  "refreshToken": "string", // Refresh token for token renewal
  "onboardingComplete": "boolean", // Whether user completed onboarding
  "darkMode": "boolean", // Theme preference
  "createdAt": "datetime", // ISO 8601 format
  "updatedAt": "datetime" // ISO 8601 format
}
```

### Authentication Response
```json
{
  "success": "boolean",
  "user": {
    "id": "string",
    "name": "string",
    "email": "string"
  },
  "tokens": {
    "accessToken": "string",
    "refreshToken": "string"
  }
}
```

---

## Survey System

### Survey Question Structure
```json
{
  "step": "number", // 1-6 for current survey
  "question": "string", // The main question text
  "description": "string", // Additional description or subtitle
  "allowMultiple": "boolean", // Whether user can select multiple options
  "options": [
    {
      "id": "string", // Unique option identifier
      "label": "string", // Display text for option
      "icon": "string", // Emoji icon (optional)
      "description": "string" // Detailed description (optional)
    }
  ]
}
```

### Complete Survey Questions Data
```json
[
  {
    "step": 1,
    "question": "커피를 마시는 주된 이유가 무엇인가요?",
    "description": "가장 큰 이유를 선택해 주세요",
    "allowMultiple": false,
    "options": [
      {"id": "taste", "label": "맛있어서", "icon": "😋"},
      {"id": "caffeine", "label": "각성 효과", "icon": "⚡"},
      {"id": "habit", "label": "습관", "icon": "🔄"},
      {"id": "mood", "label": "분위기", "icon": "☕"},
      {"id": "health", "label": "건강", "icon": "💪"}
    ]
  },
  {
    "step": 2,
    "question": "어떤 맛을 선호하시나요?",
    "description": "선호하는 맛을 모두 선택해 주세요",
    "allowMultiple": true,
    "options": [
      {
        "id": "acidic",
        "label": "산미",
        "description": "과일 같은 상큼한 맛"
      },
      {
        "id": "sweet",
        "label": "단맛",
        "description": "카라멜, 초콜릿 같은 달콤한 맛"
      },
      {
        "id": "bitter",
        "label": "쓴맛",
        "description": "진하고 깊은 맛"
      },
      {
        "id": "nutty",
        "label": "고소함",
        "description": "견과류 같은 고소한 맛"
      },
      {
        "id": "balance",
        "label": "밸런스",
        "description": "균형 잡힌 맛"
      }
    ]
  },
  {
    "step": 3,
    "question": "커피에서 나는 과일 향을 좋아하시나요?",
    "description": "에티오피아, 케냐 같은 아프리카 원두에서 많이 느껴져요",
    "allowMultiple": false,
    "options": [
      {
        "id": "love",
        "label": "좋아요",
        "icon": "🍊",
        "description": "과일 향이 나는 커피가 좋아요"
      },
      {
        "id": "hate",
        "label": "싫어요",
        "icon": "🚫",
        "description": "커피는 커피 맛이 나야죠"
      }
    ]
  },
  {
    "step": 4,
    "question": "커피 경험 수준은 어느 정도인가요?",
    "description": "",
    "allowMultiple": false,
    "options": [
      {
        "id": "beginner",
        "label": "입문자",
        "icon": "🌱",
        "description": "커피에 관심을 갖기 시작했어요"
      },
      {
        "id": "enthusiast",
        "label": "애호가",
        "icon": "☕",
        "description": "다양한 커피를 즐기고 있어요"
      },
      {
        "id": "home_barista",
        "label": "홈바리스타",
        "icon": "🏠",
        "description": "집에서 직접 추출해요"
      },
      {
        "id": "professional",
        "label": "전문가",
        "icon": "👨‍🍳",
        "description": "커피가 직업이에요"
      }
    ]
  },
  {
    "step": 5,
    "question": "주로 사용하는 커피 기구는?",
    "description": "여러 개를 선택할 수 있어요",
    "allowMultiple": true,
    "options": [
      {"id": "espresso_machine", "label": "에스프레소 머신", "icon": "☕"},
      {"id": "automatic_machine", "label": "자동 커피머신", "icon": "🤖"},
      {"id": "hand_drip", "label": "핸드드립", "icon": "☕"},
      {"id": "capsule_machine", "label": "캡슐 머신", "icon": "💊"},
      {"id": "cold_brew", "label": "콜드브루", "icon": "🧊"},
      {"id": "unknown", "label": "잘 모르겠어요", "icon": "❓"}
    ]
  },
  {
    "step": 6,
    "question": "커피를 주로 마시는 시간대는?",
    "description": "",
    "allowMultiple": false,
    "options": [
      {"id": "morning", "label": "아침", "icon": "🌅"},
      {"id": "afternoon", "label": "오후", "icon": "☀️"},
      {"id": "evening", "label": "저녁", "icon": "🌙"},
      {"id": "anytime", "label": "상관없음", "icon": "🕐"}
    ]
  }
]
```

### Survey Answer Submission
```json
{
  "userId": "string",
  "answers": {
    "1": ["taste"], // step: [selectedOptionIds]
    "2": ["acidic", "sweet"], // Multiple selections for step 2
    "3": ["love"],
    "4": ["enthusiast"],
    "5": ["hand_drip", "espresso_machine"], // Multiple selections for step 5
    "6": ["morning"]
  }
}
```

### Survey Result Structure
```json
{
  "userId": "string",
  "coffeeType": "string", // "산미파", "진한맛파", "달달파", "밸런스파"
  "coffeeTypeDescription": "string",
  "tasteProfile": {
    "acidity": "number", // 0-100 scale
    "sweetness": "number", // 0-100 scale
    "bitterness": "number", // 0-100 scale
    "body": "number", // 0-100 scale
    "aroma": "number" // 0-100 scale
  },
  "flavorDescriptions": [
    {
      "name": "string",
      "emoji": "string",
      "description": "string"
    }
  ],
  "recommendations": [
    {
      "id": "string",
      "name": "string",
      "origin": "string",
      "roastLevel": "string",
      "description": "string",
      "imageUrl": "string", // Optional
      "originalPrice": "number", // Optional
      "discountPrice": "number", // Optional
      "discountPercent": "number", // Optional
      "weight": "string", // Optional
      "tasteProfile": {
        "acidity": "number",
        "sweetness": "number",
        "bitterness": "number",
        "body": "number",
        "aroma": "number"
      }
    }
  ],
  "createdAt": "datetime"
}
```

---

## Timer System

### Timer Recipe Structure
```json
{
  "id": "string",
  "name": "string",
  "coffeeType": "string", // "hand_drip", "espresso_machine"
  "cups": "number", // 1-4
  "coffeeAmount": "number", // in grams
  "waterAmount": "number", // in ml
  "totalDurationSeconds": "number",
  "completionMessage": "string",
  "aromaDescription": "string",
  "aromaTags": [
    {
      "emoji": "string",
      "name": "string"
    }
  ],
  "steps": [
    {
      "stepNumber": "number",
      "title": "string",
      "description": "string",
      "durationSeconds": "number",
      "waterAmount": "number", // Optional, in grams/ml
      "stepType": "string", // "preparation", "brewing", "waiting"
      "illustrationEmoji": "string", // Optional
      "actionText": "string" // Optional
    }
  ]
}
```

### Complete Timer Recipes Data

#### Hand Drip Recipe
```json
{
  "id": "hand_drip_basic",
  "name": "핸드드립 기본",
  "coffeeType": "hand_drip",
  "cups": 1,
  "coffeeAmount": 18,
  "waterAmount": 210,
  "totalDurationSeconds": 150,
  "completionMessage": "맛있는 커피가 완성되었어요!",
  "aromaDescription": "화사한 꽃향과 부드러운 과일의 단맛이 어우러진 커피입니다",
  "aromaTags": [
    {"emoji": "🍑", "name": "복숭아"},
    {"emoji": "🌸", "name": "자스민"},
    {"emoji": "🍯", "name": "꿀"},
    {"emoji": "🍋", "name": "레몬"}
  ],
  "steps": [
    {
      "stepNumber": 1,
      "title": "원두 분쇄",
      "description": "물의 흐름과 추출 시간을 좌우하는 준비 단계예요",
      "durationSeconds": 0,
      "stepType": "preparation",
      "illustrationEmoji": "⚙️",
      "actionText": "원두 18g을 1,000μm 정도로 균일하게 분쇄해주세요"
    },
    {
      "stepNumber": 2,
      "title": "예열하기",
      "description": "추출 온도를 일정하게 유지하기 위한 준비 단계예요",
      "durationSeconds": 0,
      "stepType": "preparation",
      "illustrationEmoji": "♨️",
      "actionText": "서버와 드리퍼를 뜨거운 물로 충분히 예열해주세요"
    },
    {
      "stepNumber": 3,
      "title": "뜸 들이기",
      "description": "주요 향미가 추출되는 핵심 구간이에요",
      "durationSeconds": 30,
      "waterAmount": 30,
      "stepType": "brewing",
      "actionText": "물 30ml을 원두 전체에 골고루 부어주세요"
    },
    {
      "stepNumber": 4,
      "title": "1차 추출",
      "description": "주요 향미가 추출되는 핵심 구간이에요",
      "durationSeconds": 60,
      "waterAmount": 100,
      "stepType": "brewing",
      "actionText": "물 100ml을 중심에서 바깥으로 천천히 부어주세요"
    },
    {
      "stepNumber": 5,
      "title": "2차 추출",
      "description": "밸런스를 맞추는 마지막 추출 단계예요",
      "durationSeconds": 30,
      "waterAmount": 80,
      "stepType": "brewing",
      "actionText": "물 80ml을 같은 방식으로 부어주세요"
    },
    {
      "stepNumber": 6,
      "title": "추출 완료 대기",
      "description": "남은 물이 모두 내려갈 때까지 기다려주세요",
      "durationSeconds": 30,
      "stepType": "waiting",
      "illustrationEmoji": "⏳"
    }
  ]
}
```

#### Espresso Single Shot Recipe
```json
{
  "id": "espresso_single",
  "name": "에스프레소 싱글샷",
  "coffeeType": "espresso_machine",
  "cups": 1,
  "coffeeAmount": 18,
  "waterAmount": null,
  "totalDurationSeconds": 30,
  "completionMessage": "완벽한 에스프레소가 완성되었어요!",
  "aromaDescription": "진하고 묵직한 크레마 위로 초콜릿과 캐러멜 향이 감돕니다",
  "aromaTags": [
    {"emoji": "🍫", "name": "초콜릿"},
    {"emoji": "🍯", "name": "캐러멜"},
    {"emoji": "🌰", "name": "헤이즐넛"}
  ],
  "steps": [
    {
      "stepNumber": 1,
      "title": "추출 중",
      "description": "크레마가 고르게 형성되는지 확인하세요",
      "durationSeconds": 25,
      "stepType": "brewing"
    },
    {
      "stepNumber": 2,
      "title": "마무리",
      "description": "추출이 거의 완료되었습니다",
      "durationSeconds": 5,
      "stepType": "waiting"
    }
  ]
}
```

#### Espresso Double Shot Recipe
```json
{
  "id": "espresso_double",
  "name": "에스프레소 더블샷",
  "coffeeType": "espresso_machine",
  "cups": 2,
  "coffeeAmount": 18,
  "waterAmount": null,
  "totalDurationSeconds": 30,
  "completionMessage": "더블샷 에스프레소가 완성되었어요!",
  "aromaDescription": "두 배로 진한 풍미와 풍성한 크레마를 즐겨보세요",
  "aromaTags": [
    {"emoji": "🍫", "name": "다크초콜릿"},
    {"emoji": "🔥", "name": "스모키"},
    {"emoji": "🌰", "name": "아몬드"}
  ],
  "steps": [
    {
      "stepNumber": 1,
      "title": "추출 중",
      "description": "크레마가 고르게 형성되는지 확인하세요",
      "durationSeconds": 25,
      "stepType": "brewing"
    },
    {
      "stepNumber": 2,
      "title": "마무리",
      "description": "추출이 거의 완료되었습니다",
      "durationSeconds": 5,
      "stepType": "waiting"
    }
  ]
}
```

---

## Coffee Recommendations

### Coffee Recommendation Structure
```json
{
  "id": "string",
  "name": "string",
  "origin": "string",
  "roastLevel": "string", // "라이트", "미디엄", "다크"
  "description": "string",
  "imageUrl": "string", // Optional CDN URL
  "originalPrice": "number", // Optional, in Korean Won
  "discountPrice": "number", // Optional, in Korean Won
  "discountPercent": "number", // Optional
  "weight": "string", // Optional, e.g., "200g"
  "tasteProfile": {
    "acidity": "number",
    "sweetness": "number",
    "bitterness": "number",
    "body": "number",
    "aroma": "number"
  },
  "stock": "number", // Optional, inventory count
  "isAvailable": "boolean", // Optional
  "createdAt": "datetime",
  "updatedAt": "datetime"
}
```

---

## API Endpoints Specification

### Authentication Endpoints
```
POST /api/auth/signin
POST /api/auth/signup
POST /api/auth/refresh
POST /api/auth/logout
```

### Survey Endpoints
```
GET /api/survey/questions
POST /api/survey/submit
GET /api/survey/result/{userId}
```

### Timer Endpoints
```
GET /api/timer/recipes
GET /api/timer/recipe/{coffeeType}
```

### Coffee Endpoints
```
GET /api/coffee/recommendations/{userId}
GET /api/coffee/list
GET /api/coffee/{id}
```

### User Endpoints
```
GET /api/user/profile
PUT /api/user/profile
GET /api/user/survey-result
```

---

## Storage Keys (Client-side)

### User Data
- `access_token`: JWT access token
- `refresh_token`: JWT refresh token
- `user_id`: User unique identifier
- `user_name`: User display name

### App State
- `onboarding_complete`: Boolean flag
- `survey_answers`: User's survey answers
- `survey_result`: User's survey result
- `dark_mode`: Theme preference

---

## Implementation Notes

### 1. Data Validation
- All taste profile values should be 0-100
- Survey steps are numbered 1-6
- Timer step types: "preparation", "brewing", "waiting"
- Coffee types: "hand_drip", "espresso_machine"

### 2. Error Response Format
```json
{
  "success": false,
  "error": {
    "code": "string",
    "message": "string",
    "details": "object" // Optional
  }
}
```

### 3. Success Response Format
```json
{
  "success": true,
  "data": "object",
  "message": "string" // Optional
}
```

### 4. Pagination (for list endpoints)
```json
{
  "success": true,
  "data": {
    "items": "array",
    "pagination": {
      "page": "number",
      "limit": "number",
      "total": "number",
      "totalPages": "number"
    }
  }
}
```

---

## Testing Data

### Test User Creation
```json
{
  "name": "테스트 사용자",
  "email": "test@coflanet.com",
  "password": "test123456"
}
```

### Test Survey Submission
```json
{
  "userId": "test-user-123",
  "answers": {
    "1": ["taste"],
    "2": ["acidic", "sweet"],
    "3": ["love"],
    "4": ["enthusiast"],
    "5": ["hand_drip"],
    "6": ["morning"]
  }
}
```

---

This specification provides complete data structure compatibility with the current Flutter implementation. Backend developers can use this document to implement APIs that will work seamlessly with the existing mobile app.
