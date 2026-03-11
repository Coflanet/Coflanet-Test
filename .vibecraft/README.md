# .vibecraft/ 디렉토리

VibeCraft 내부 설정 파일이 위치하는 디렉토리입니다. fork repo에 배포되며, 워크플로우가 런타임에 참조합니다.

## 파일 목록

| 파일 | 역할 |
|------|------|
| `vibecraft-patterns` | 필수 패턴의 **단일 소스(Single Source of Truth)** |
| `secret-patterns` | 절대 push 불가 민감 파일 패턴 목록 |
| `fork-repos` | 자동 배포 대상 fork repo 목록 |
| `config` | fork별 VibeCraft 설정 (SECURE_ENABLED 등) |
| `hooks/pre-commit` | vibecraft.ignore 기반 커밋 차단 hook |
| `README.md` | 이 문서 |

---

## vibecraft-patterns

`vibecraft.ignore`에 반드시 포함되어야 하는 필수 패턴 목록입니다.

**참조하는 워크플로우:**

| 워크플로우 | 방식 | 설명 |
|-----------|------|------|
| `vibecraft-pipeline.yml` | 런타임 파일 읽기 | fork push/PR 시 guard job이 이 파일을 읽어 필수 패턴 검증 |
| `sync-patterns.yml` | 빌드타임 자동 갱신 | 이 파일 변경 시 `pr-policy-check.yml`의 하드코딩 배열을 자동 덮어쓰기 |
| `validate-vibecraft.yml` | CI 검증 | vibecraft.ignore에 모든 필수 패턴이 포함되어 있는지 검증 |

**패턴 추가/제거 방법:**

1. `vibecraft-patterns`만 수정하고 push
2. `sync-patterns.yml`이 자동으로:
   - `vibecraft.ignore`에 누락된 패턴 추가
   - `pr-policy-check.yml`의 `BEGIN/END PATTERNS` 사이를 갱신
3. `deploy-vibecraft.yml`이 변경을 감지하여 fork repo에 배포

> `pr-policy-check.yml`의 패턴을 직접 수정하지 마세요. `sync-patterns.yml`이 덮어씁니다.

**현재 필수 패턴 (10개):**

```
vibecraft.ignore          # 마커 파일
.vibecraft/               # 내부 설정 + 스크립트 디렉토리 (scripts/ 포함)
.claude/                  # Claude Code 메모리
.codex/                   # Codex 설정

.github/workflows/vibecraft-pipeline.yml # 통합 파이프라인 (guard+secure+publish)
.github/workflows/sync-tag-release.yml

CLAUDE.md                 # Claude Code 프로젝트 설정
CHANGELOG.md              # 내부 변경 이력
VIBECRAFT.md              # 내부 문서
```

---

## secret-patterns

어느 remote에도 절대 push되어서는 안 되는 **민감 파일** 패턴 목록입니다.

**동작 방식:**

- `pre-push hook`이 이 파일을 런타임에 읽어 push 대상 커밋의 파일을 검사합니다.
- 매칭되는 파일이 있으면 push를 차단합니다.
- 이 패턴들은 `vibecraft.ignore`에도 반드시 포함되어야 합니다 (superset 관계).

**검증:**

| 워크플로우 | 검증 내용 |
|-----------|----------|
| `validate-vibecraft.yml` | secret-patterns 존재 + 비어있지 않음 + superset 검증 |
| `vibecraft-pipeline.yml` | guard job에서 superset 검증 (없으면 warning만) |
| `sync-patterns.yml` | secret-patterns 패턴도 vibecraft.ignore에 자동 추가 |

**형식:** 정확한 파일명 또는 디렉토리 prefix (glob 미지원)

```
.env
.env.local
.env.production
.env.staging
credentials.json
service-account.json
```

---

## config

fork 레포별 VibeCraft 설정 파일입니다. 최초 배포 시 기본값으로 생성되며, 이후 fork 레포에서 자유롭게 수정할 수 있습니다.

**설정 항목:**

| 항목 | 기본값 | 설명 |
|------|--------|------|
| `VIBECRAFT_VERSION` | (자동) | deploy/setup 시 자동 기록. 수동 수정 불필요 |
| `SECURE_ENABLED` | `true` | AI 분석 방어 레이어(vibecraft-secure) on/off. fork별 독립 설정 |
| `FORCE_SECURE_ENABLED` | `false` | `true` 시 모든 fork의 `SECURE_ENABLED`를 소스 config 값으로 강제 동기화 |

**동작 방식:**

- `SECURE_ENABLED`: fork 레포의 config 값을 존중. deploy 시 덮어쓰지 않음
- `FORCE_SECURE_ENABLED`: 소스(`vibecraft.ignore`) config에서만 의미 있음. `true`로 설정하면 다음 deploy 시 모든 fork의 `SECURE_ENABLED`를 소스 값으로 강제 변경. 일회성 강제 적용 후 `false`로 되돌리는 것을 권장

**예시:**

```
# fork별 자율 설정 (기본)
SECURE_ENABLED=true
FORCE_SECURE_ENABLED=false

# 모든 fork에 SECURE_ENABLED=true 강제 적용
SECURE_ENABLED=true
FORCE_SECURE_ENABLED=true
```

---

## fork-repos

`deploy-vibecraft.yml`이 읽는 자동 배포 대상 목록입니다.

**형식:** 한 줄에 하나의 `OWNER/REPO`, `#`으로 시작하는 줄은 주석

```
# 예시
VibeCraft2204/syc-fe
VibeCraft2204/syc-be
# VibeCraft2204/archived-repo  ← 주석으로 비활성화
```

**배포 대상 추가 방법:**

1. 이 파일에 `OWNER/REPO` 추가 후 push
2. `deploy-vibecraft.yml`을 수동 실행 (Actions → Run workflow) 또는 vibecraft 파일 변경 시 자동 배포

**DEPLOY_TOKEN 설정 (최초 1회):**

배포에는 fork repo push 권한이 있는 PAT가 필요합니다.

1. GitHub → Settings → Developer settings → [Personal access tokens](https://github.com/settings/tokens) → **Generate new token**
2. 권한: `repo` (Full control of private repositories)
3. [vibecraft.ignore repo Settings](https://github.com/VibeCraft2204/vibecraft.ignore/settings/secrets/actions) → Secrets → **New repository secret**
   - Name: `DEPLOY_TOKEN`
   - Value: 생성한 토큰

---

## vibecraft-pipeline.yml 실행 흐름

단일 워크플로우 내 4개 job이 `needs:` 의존성으로 순차 실행됩니다.

```
push/PR → guard (필수 패턴 검증)
              │
              ├── PR인 경우 → 여기서 끝 (Required Status Check만)
              │
              └── push to main / dispatch
                    │
                    ▼
              check-config (SECURE_ENABLED 읽기)
                    │
          ┌─────────┴──────────┐
          │                    │
   SECURE_ENABLED=true  SECURE_ENABLED=false
          │                    │
          ▼                    │
   Apply Defense Layers    (SKIPPED)
   (obfuscation + build)       │
          │                    │
          ▼                    ▼
      Publish to Origin    Publish to Origin
   (보호된 코드 사용)     (raw 코드, vibecraft 파일 제거)
```

**사용 GitHub Actions 버전:**

| Action | 버전 | Node.js |
|--------|------|---------|
| `actions/checkout` | `@v5` | 24 |
| `actions/setup-node` | `@v5` | 24 |
| `actions/upload-artifact` | `@v6` | 24 |
| `actions/download-artifact` | `@v7` | 24 |
| `subosito/flutter-action` | `@v2` | 20 (업데이트 미제공) |

---

## 워크플로우 관계도 (패턴 동기화)

```
vibecraft-patterns / secret-patterns 변경
        │
        ├──▶ sync-patterns.yml (자동 트리거)
        │       ├── vibecraft.ignore에 누락 패턴 추가
        │       └── pr-policy-check.yml BEGIN/END PATTERNS 갱신
        │
        ├──▶ deploy-vibecraft.yml (변경 감지 → fork 배포)
        │       └── fork repo에 워크플로우, 스크립트, vibecraft-patterns, secret-patterns 배포
        │
        └──▶ validate-vibecraft.yml (PR/push 시 검증)
                ├── vibecraft.ignore 구문 검증
                ├── fork-repos 형식 검증
                ├── secret-patterns 존재 + superset 검증
                ├── YAML 워크플로우 문법 검증
                └── 필수 패턴 포함 여부 검증
```
