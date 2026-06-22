# 이론적 배경과 출처

오케스트레이션을 설계할 때 근거로 삼을 정의·패턴·연구를 정리합니다. 인용은 의사결정의 "왜"를
이해하는 데 쓰고, 맹목적으로 따르지 마세요.

## 1. 오케스트레이션의 정의 (산업 1차 자료)

**Anthropic, "Building Effective Agents" (2024)** — 에이전트 워크플로를 다섯 패턴으로 정리합니다:
prompt chaining, routing, parallelization, **orchestrator-workers**, evaluator-optimizer.
orchestrator-workers는 "중앙 LLM이 태스크를 **동적으로 분해**해 워커 LLM들에게 위임하고 결과를
종합하는" 패턴입니다. parallelization과의 결정적 차이는 **하위 태스크가 사전 정의되지 않고**
입력에 따라 조정자가 결정한다는 점입니다. 어떤 하위 단계가 필요할지 예측할 수 없는 복잡 작업
(여러 파일에 걸친 코드 변경, 다중 소스 정보 수집)에 적합합니다.
출처: https://www.anthropic.com/research/building-effective-agents

**Anthropic, "How we built our multi-agent research system" (2025)** — orchestrator-worker를
프로덕션에서 구현한 사례. 핵심 구조와 교훈:

- 구조: **LeadResearcher(조정자)** 가 질의를 분석·전략수립 → 계획을 **메모리에 저장**(200K 토큰
  초과 시 잘리므로) → 전문화된 **Subagent들을 병렬 생성** → 각 서브에이전트가 독립 컨텍스트·도구로
  탐색하고 interleaved thinking으로 결과를 평가 → LeadResearcher가 종합, 더 필요하면 추가 생성 →
  충분하면 루프 종료 → **CitationAgent**가 인용을 부착 → 사용자에게 반환.
- 검색의 본질은 **압축**: 서브에이전트가 병렬로 방대한 코퍼스를 탐색한 뒤 핵심 토큰만 올림.
  각 서브에이전트는 별도 도구·프롬프트·궤적으로 **관심사 분리(separation of concerns)** 를 제공.
- 비용: 에이전트는 채팅 대비 ~4배, 멀티 에이전트는 ~15배 토큰. → **가치 높은 작업에만**.
- 위임 원칙: 각 서브에이전트에게 **목표·출력형식·도구/소스 가이드·명확한 경계**를 줘야 함.
  모호한 지시는 중복·누락·동일 검색 반복을 부름.
- 노력 스케일링: 단순=1에이전트 3~10호출 / 비교=2~4에이전트 각 10~15호출 / 복합=10+에이전트.
- 병렬화로 복잡 질의 리서치 시간 최대 90% 단축.
- 평가: 정답이 free-form이라 LLM-as-judge(루브릭: 사실/인용 정확성·완전성·소스품질·도구효율)와
  인간 검토 병행. 상태 변경 작업은 **end-state 평가**.
- 신뢰성: 에이전트는 stateful → 에러 누적. 체크포인트·재시도·우아한 적응으로 대응.
출처: https://www.anthropic.com/engineering/multi-agent-research-system

## 2. 계층적 멀티 에이전트 / 플래너-실행자 (학술)

- **AgentOrchestra: A Hierarchical Multi-Agent Framework for General-Purpose Task Solving (2025)** —
  중앙 **planning agent**가 고수준 의사결정(태스크 분해·자원 배분)을 하고, 전문화된 하위
  에이전트들이 하위 태스크를 실행하는 2계층(혹은 그 이상) 구조. 이 스킬의 PM↔PL↔플레이어 매핑의
  학술적 근거. 출처: https://arxiv.org/html/2506.12508v1
- **플래너-실행자(Plan-and-Act 류)** — Planner LLM이 고수준 계획을 만들고 Executor LLM이 단계별
  실행과 **국소 재계획(localized replanning)** 을 수행하는 2단계 파이프라인. 전역 계획 에이전트와
  지역 실행 에이전트로 나누는 것이 표준 패턴.
- **태스크 분해 전략** — (a) 먼저 분해 후 각 하위태스크 계획, (b) 분해와 계획/실행을 인터리브.
  Meta-Task Planning, Planning with Multi-Constraints 등 하위 태스크 계층으로 쪼개는 기법.
- **Survey on Multi-Agent Cooperative Decision-Making (2025)** — LLM 기반 시스템에서 에이전트의
  계층적 조직화를 정리한 종합 서베이. 출처: https://arxiv.org/pdf/2503.13415

## 3. 검증(Verification) 패턴 (학술)

- **Reflexion** — 에이전트를 **Actor / Evaluator / Self-Reflection** 세 모듈로 분리. 언어적
  강화(verbal reinforcement)로 그래디언트 없이 정책을 반복 개선. 평가자를 분리하라는 근거.
- **Multi-agent critique** — 서로 다른 평가 관점을 가진 여러 critic 에이전트가 독립적으로 제안을
  검증. 단일 에이전트 self-correction보다 포괄적 오류 탐지. 출처(서베이):
  https://arxiv.org/pdf/2503.24047
- **Reflective Multi-Agent Collaboration (NeurIPS 2024)** — 공유 reflector가 actor 프롬프트를
  자동 조정. 출처: https://proceedings.neurips.cc/paper_files/paper/2024/file/fa54b0edce5eef0bb07654e8ee800cb4-Paper-Conference.pdf
- 요지: **실행자와 평가자를 분리**하면 신뢰성이 오른다. evaluator-optimizer(Anthropic 5패턴 중 하나)와
  동일한 직관.

## 4. 소프트웨어 조직론 매핑 (PM / PL / IC)

멀티 에이전트 분업은 사람 조직의 분업과 같은 제약을 받습니다.

- **Conway's Law** — 시스템 설계는 그것을 만든 조직의 **커뮤니케이션 구조를 닮는다**. 프론트/백/DB로
  나뉜 조직은 3-tier 아키텍처를 낳음. → **에이전트 분업 구조가 곧 산출물의 구조**가 되므로, 원하는
  산출물 구조에 맞춰 섹션(=팀 경계)을 먼저 설계하라("inverse Conway maneuver").
  출처: https://itrevolution.com/articles/conways-law/
- **PM/PL/IC 대응** — 총괄 PM = lead orchestrator(전략·분해·종합), 섹션 PL/tech lead =
  sub-orchestrator(섹션 내 조율·1차 검증), IC/플레이어 = worker(단일 태스크 실행). 사람 팀에서
  좋은 위임이 "명확한 목표·산출물·경계"를 요구하듯, 에이전트 위임도 동일합니다.
- 한계 인식: LLM 에이전트는 아직 실시간 상호 조율·동적 위임에 약함. 그래서 현재는 조정자가
  **동기적으로** 서브에이전트를 띄우고 기다리는 구조가 흔함(조율 단순화 ↔ 병목). 의존이 강한
  작업을 무리하게 병렬화하지 말 것.

## 한 줄 요약

> 가치가 높고 폭이 넓은 작업을, 경계가 분명한 섹션으로 나눠, 명확히 위임하고, 압축해 보고받고,
> 분리된 평가자로 검증하고, 예산·중단 조건으로 폭주를 막는다.
