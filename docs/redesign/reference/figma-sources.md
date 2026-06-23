# 레퍼런스: Figma 소스 (파일 키 · 링크)

> 커플래닛 디자인시스템/시안의 **Figma 원본 출처**. 토큰 검증·시안 대조 시 여기 링크를 SoT로 쓴다.
> **Figma 는 읽기 전용 — 생성/수정/삭제 절대 금지.**
> Figma MCP(`plugin:product-management:figma`, https://mcp.figma.com/mcp) 인증 후 `get_variable_defs`/`get_metadata`/`get_code` 로 읽는다.

## 파일

| 이름 | 파일 키(`file_key`) | 진입 노드 | 링크 |
|---|---|---|---|
| 📚 **Library** (디자인시스템 Foundation/토큰) | `q7yBPcHrid1CGQqFWEPwnR` | `2414-9843` | https://www.figma.com/design/q7yBPcHrid1CGQqFWEPwnR/%F0%9F%93%9A-Library?node-id=2414-9843 |
| ⭐️ **POC** (시안/프로토타입) | `EkpVnNrqyq9Agpy4aymv0j` | `0-1` | https://www.figma.com/design/EkpVnNrqyq9Agpy4aymv0j/%E2%AD%90%EF%B8%8F-POC?node-id=0-1 |
| 🛍️ **쇼핑 — 상세페이지** | `3B84XdpmsEduuvPVJKdTm9` | `0-1` | https://www.figma.com/design/3B84XdpmsEduuvPVJKdTm9/?node-id=0-1 |
| 🛍️ **쇼핑 — 상세페이지(특정 화면)** | `3B84XdpmsEduuvPVJKdTm9` | `1-58513` | https://www.figma.com/design/3B84XdpmsEduuvPVJKdTm9/?node-id=1-58513 |
| 🏠 **Home** (홈 화면 시안, 다크 모드) | `RRCDc6hBHT4usSnD5DXV3Y` | `256-4567` (`Home_Item_yes`) | https://www.figma.com/design/RRCDc6hBHT4usSnD5DXV3Y/%F0%9F%8F%A0-Home?node-id=256-4567 |

## 노드 ID 표기

- 링크의 `node-id=2414-9843` ↔ MCP 호출 시 `2414:9843` (하이픈→콜론).

## 용도 매핑

- **Library** → spacing / radius / typography / color **토큰(variable) 검증의 SoT**(라이트). 코드 `AppSpacing`/`AppRadius`/`AppTextStyles`/`AppColorScheme` 와 1:1 대조.
- **POC** → 재구성 화면(마이 등) 실제 레이아웃·간격 시안 대조. `Round/40(Box)`·카드 패턴 토큰의 근거.
- **쇼핑/상세페이지** → 커머스 상품 상세 화면 시안(코드는 iyumi 카드로 단순화).
- **Home** → 홈 화면(`Home_Item_yes`) 시안 + **다크 모드 변수 검증**(코드 `AppColorScheme.dart` 와 대조). 코드 `lib/modules/home/home_content.dart` 가 이 노드 직접 구현.

> 수집: 사용자 전달 (2026-06-23).
