# VibeCraft 내부 구조 가이드

이 문서는 `.vibecraft/` 및 `scripts/` 디렉토리의 역할과 워크플로우 간 관계를 설명합니다.

## `.vibecraft/` 디렉토리

| 파일 | 역할 |
|------|------|
| `required-patterns.txt` | 필수 패턴의 **단일 소스(Single Source of Truth)**. `vibecraft-guard.yml`이 런타임에 읽고, `sync-patterns.yml`이 `pr-policy-check.yml`에 자동 동기화 |
| `fork-repos.txt` | `deploy-vibecraft.yml`의 배포 대상 목록. `OWNER/REPO` 형식, `#` 주석 지원 |
| `README.md` | 이 문서 |

## `scripts/` 디렉토리

| 스크립트 | 용도 | 실행 방법 |
|----------|------|-----------|
| `setup-fork.sh` | fork 프로젝트 초기 설정 (워크플로우, vibecraft.ignore, GitHub 설정) | `bash .vibecraft-setup/scripts/setup-fork.sh` |
| `clean-for-upstream.sh` | upstream push 전 VibeCraft 파일 제거 | `bash scripts/clean-for-upstream.sh` |
| `clean-history-for-upstream.sh` | upstream push 전 VibeCraft 파일 히스토리 제거 | `bash scripts/clean-history-for-upstream.sh` |

## 워크플로우 관계도

```
required-patterns.txt 변경
        │
        ├──▶ sync-patterns.yml (자동 트리거)
        │       ├── vibecraft.ignore에 누락 패턴 추가
        │       └── pr-policy-check.yml BEGIN/END PATTERNS 갱신
        │               │
        │               ▼
        ├──▶ deploy-vibecraft.yml (변경 감지 → fork 배포)
        │       └── fork repo에 워크플로우, 스크립트, required-patterns.txt 배포
        │
        └──▶ validate-vibecraft.yml (PR/push 시 검증)
                ├── vibecraft.ignore 구문 검증
                ├── fork-repos.txt 형식 검증
                ├── YAML 워크플로우 문법 검증
                └── 필수 패턴 포함 여부 검증

vibecraft-guard.yml (fork repo에서 실행)
        └── required-patterns.txt를 읽어 vibecraft.ignore 필수 패턴 검증

pr-policy-check.yml (upstream repo에서 실행)
        └── 하드코딩된 패턴으로 내부 파일 변경 차단 (vibecraft 파일 없는 환경)
```

## 패턴 관리 방법

1. **패턴 추가/제거**: `.vibecraft/required-patterns.txt`만 수정
2. **자동 동기화**: push 시 `sync-patterns.yml`이 `pr-policy-check.yml`과 `vibecraft.ignore`를 자동 갱신
3. **배포**: 변경이 감지되면 `deploy-vibecraft.yml`이 fork repo에 자동 배포

> `pr-policy-check.yml`의 패턴을 직접 수정하지 마세요. `sync-patterns.yml`이 덮어씁니다.
