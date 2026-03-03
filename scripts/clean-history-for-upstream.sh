#!/usr/bin/env bash
# ============================================================
# Clean History for Upstream
# ============================================================
# vibecraft.ignore에 나열된 파일을 모든 커밋 이력에서 완전히 제거합니다.
# git filter-branch (git 내장 명령)를 사용하여 히스토리를 재작성합니다.
#
# 주의: 이 작업은 비가역적입니다. 실행 전 반드시 백업하세요.
#
# 사용법:
#   bash scripts/clean-history-for-upstream.sh
#
# 사전 요구사항: git, gh CLI (자동 감지용)
# ============================================================

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log()   { printf "${GREEN}[vibecraft]${NC} %s\n" "$1"; }
warn()  { printf "${YELLOW}[vibecraft]${NC} %s\n" "$1"; }
error() { printf "${RED}[vibecraft]${NC} %s\n" "$1"; exit 1; }

# --- 사전 검증 ---

if [ ! -d ".git" ]; then
  error "Git 레포지터리가 아닙니다."
fi

if [ ! -f "vibecraft.ignore" ]; then
  error "vibecraft.ignore 파일이 없습니다. setup-fork.sh를 먼저 실행하세요."
fi

# git user 미설정 시 기존 커밋에서 자동 설정
if [ -z "$(git config user.name 2>/dev/null)" ]; then
  git config user.name "$(git log -1 --format='%an' 2>/dev/null || echo 'VibeCraft2204')"
fi
if [ -z "$(git config user.email 2>/dev/null)" ]; then
  git config user.email "$(git log -1 --format='%ae' 2>/dev/null || echo 'noreply@github.com')"
fi

# --- 경고 및 확인 ---

if [ "${1:-}" != "--yes" ]; then
  warn ""
  warn "============================================"
  warn "  경고: 히스토리 재작성 (비가역적 작업)"
  warn "============================================"
  warn ""
  warn "이 스크립트는 vibecraft.ignore에 나열된 파일을"
  warn "모든 커밋 이력에서 완전히 제거합니다."
  warn ""
  warn "실행 후:"
  warn "  - 커밋 해시가 모두 변경됩니다."
  warn "  - upstream에 force push됩니다."
  warn "  - 다른 팀원의 로컬 레포와 동기화가 깨집니다."
  warn ""

  printf "${YELLOW}[vibecraft]${NC} 계속하시겠습니까? (yes/no): " < /dev/tty
  read CONFIRM < /dev/tty

  if [ "$CONFIRM" != "yes" ]; then
    log "취소되었습니다."
    exit 0
  fi
fi

# --- upstream 정보 저장 ---
# 환경변수로 지정 가능: UPSTREAM_REPO, UPSTREAM_BRANCH, UPSTREAM_TOKEN

UPSTREAM_REPO="${UPSTREAM_REPO:-}"
UPSTREAM_BRANCH="${UPSTREAM_BRANCH:-main}"
UPSTREAM_TOKEN="${UPSTREAM_TOKEN:-}"

if [ -z "$UPSTREAM_REPO" ] && command -v gh &>/dev/null && gh auth status &>/dev/null; then
  FORK_REPO=$(gh repo view --json nameWithOwner -q '.nameWithOwner' 2>/dev/null || true)
  UPSTREAM_REPO=$(gh api "repos/$FORK_REPO" --jq '.source.full_name' 2>/dev/null || true)
  # fork가 아니면 현재 레포 자체를 대상으로 사용
  if [ -z "$UPSTREAM_REPO" ]; then
    UPSTREAM_REPO="$FORK_REPO"
  fi
  if [ -n "$UPSTREAM_REPO" ]; then
    UPSTREAM_BRANCH=$(gh api "repos/$UPSTREAM_REPO" --jq '.default_branch' 2>/dev/null || echo "main")
  fi
fi

if [ -z "$UPSTREAM_TOKEN" ] && command -v gh &>/dev/null && gh auth status &>/dev/null; then
  UPSTREAM_TOKEN=$(gh auth token 2>/dev/null || true)
fi

if [ -n "$UPSTREAM_REPO" ]; then
  log "고객사 origin: $UPSTREAM_REPO ($UPSTREAM_BRANCH)"
else
  error "고객사 origin을 감지할 수 없습니다. gh CLI 로그인 또는 UPSTREAM_REPO 환경변수를 설정하세요."
fi

# --- 제거 대상 패턴 수집 ---

log "vibecraft.ignore에서 제거 대상 수집 중..."

PATTERNS=()
while IFS= read -r pattern || [ -n "$pattern" ]; do
  [[ "$pattern" =~ ^#.*$ ]] && continue
  [[ -z "$pattern" ]] && continue
  # trailing slash 제거
  pattern="${pattern%/}"
  PATTERNS+=("$pattern")
done < vibecraft.ignore

PATTERN_COUNT=${#PATTERNS[@]}
log "제거 대상: ${PATTERN_COUNT}개 패턴"

# git rm 인자 문자열 생성
RM_ARGS=""
for p in "${PATTERNS[@]}"; do
  RM_ARGS="$RM_ARGS '$p'"
done

# --- git filter-branch 실행 ---

# unstaged changes가 있으면 filter-branch가 거부하므로 미리 정리
if ! git diff --quiet 2>/dev/null || ! git diff --cached --quiet 2>/dev/null; then
  git add -A
  git commit -m "chore: pre-filter snapshot" --allow-empty 2>/dev/null || true
fi
# untracked 파일도 정리 (filter-branch 요구사항)
git clean -fd 2>/dev/null || true

log "히스토리 재작성 시작..."

# FILTER_BRANCH_SQUELCH_WARNING: git filter-branch 경고 메시지 숨김
export FILTER_BRANCH_SQUELCH_WARNING=1

eval git filter-branch --force --index-filter \
  "\"git rm -rf --cached --ignore-unmatch $RM_ARGS\"" \
  --prune-empty -- --all

# filter-branch 백업 ref 정리
git for-each-ref --format='%(refname)' refs/original/ | while read ref; do
  git update-ref -d "$ref"
done

# reflog 및 gc로 완전 정리
git reflog expire --expire=now --all
git gc --prune=now --aggressive

log ""
log "히스토리 재작성 완료 (제거된 패턴: ${PATTERN_COUNT}개)"

# --- upstream에 자동 push ---

if [ -n "$UPSTREAM_REPO" ] && [ -n "$UPSTREAM_TOKEN" ]; then
  log "고객사 origin에 push 중... ($UPSTREAM_REPO:$UPSTREAM_BRANCH)"
  git remote add upstream "https://x-access-token:${UPSTREAM_TOKEN}@github.com/${UPSTREAM_REPO}.git" 2>/dev/null || true
  if ! git push --no-verify upstream HEAD:"$UPSTREAM_BRANCH" --force 2>&1 | grep -v 'x-access-token'; then
    error "push 실패. 권한을 확인하세요."
  fi

  log ""
  log "============================================"
  log "  고객사 origin push 완료!"
  log "============================================"
  log "  대상: $UPSTREAM_REPO ($UPSTREAM_BRANCH)"
  warn "  이 로컬 clone은 재작성된 상태입니다."
  warn "  VibeCraft2204 fork에는 영향 없습니다."
else
  log ""
  log "============================================"
  log "  히스토리 재작성 완료 (push 필요)"
  log "============================================"
  log ""
  log "수동으로 push하세요:"
  log "  git remote add upstream https://github.com/<origin-repo>.git"
  log "  git push upstream HEAD:main --force"
fi
