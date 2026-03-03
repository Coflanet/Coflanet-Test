#!/usr/bin/env bash
# ============================================================
# Clean for Upstream - vibecraft 파일 제거 후 upstream에 자동 push
# ============================================================
# sync-upstream 워크플로우의 수동 대체 스크립트입니다.
# vibecraft 파일을 삭제하는 커밋을 생성하고 고객사 origin에 push합니다.
#
# 사용법:
#   bash scripts/clean-for-upstream.sh
# ============================================================

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log()   { printf "${GREEN}[vibecraft]${NC} %s\n" "$1"; }
warn()  { printf "${YELLOW}[vibecraft]${NC} %s\n" "$1"; }
error() { printf "${RED}[vibecraft]${NC} %s\n" "$1"; exit 1; }

BRANCH_NAME="sync/upstream-$(date +%Y%m%d-%H%M%S)"

# --- 사전 검증 ---

if [ ! -d ".git" ]; then
  error "Git 레포지터리가 아닙니다."
fi

if [ ! -f "vibecraft.ignore" ]; then
  error "vibecraft.ignore 파일이 없습니다. setup-fork.sh를 먼저 실행하세요."
fi

# git user 미설정 시 기존 커밋에서 자동 설정
if [ -z "$(git config user.name 2>/dev/null)" ]; then
  git config user.name "$(git log -1 --format='%an' 2>/dev/null || echo 'vibecraft-bot')"
fi
if [ -z "$(git config user.email 2>/dev/null)" ]; then
  git config user.email "$(git log -1 --format='%ae' 2>/dev/null || echo 'vibecraft-bot@users.noreply.github.com')"
fi

# --- upstream 정보 감지 ---
# 환경변수로 지정 가능: UPSTREAM_REPO, UPSTREAM_BRANCH, UPSTREAM_TOKEN

UPSTREAM_REPO="${UPSTREAM_REPO:-}"
UPSTREAM_BRANCH="${UPSTREAM_BRANCH:-main}"
UPSTREAM_TOKEN="${UPSTREAM_TOKEN:-}"

# fork repo 정보 감지
FORK_REPO=""
ORIGIN_URL=$(git remote get-url origin 2>/dev/null || true)
if [ -n "$ORIGIN_URL" ]; then
  FORK_REPO=$(echo "$ORIGIN_URL" | sed -E 's#.*github\.com[:/]([^/]+/[^/.]+)(\.git)?$#\1#')
fi
FORK_ORG=$(echo "$FORK_REPO" | cut -d'/' -f1)

if [ -z "$UPSTREAM_REPO" ] && command -v gh &>/dev/null && gh auth status &>/dev/null; then
  if [ -n "$FORK_REPO" ]; then
    UPSTREAM_REPO=$(gh api "repos/$FORK_REPO" --jq '.parent.full_name' 2>/dev/null || true)
  fi
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

# --- clean 브랜치 생성 ---

log "Clean branch 생성: $BRANCH_NAME"
git checkout -b "$BRANCH_NAME"

while IFS= read -r pattern || [ -n "$pattern" ]; do
  [[ "$pattern" =~ ^#.*$ ]] && continue
  [[ -z "$pattern" ]] && continue
  git rm -rf --ignore-unmatch $pattern 2>/dev/null || true
done < vibecraft.ignore

git commit -m "chore: strip vibecraft internal files for upstream"

# --- upstream에 자동 push ---

if [ -n "$UPSTREAM_REPO" ] && [ -n "$UPSTREAM_TOKEN" ]; then
  # gh CLI credential helper 사용 (토큰 URL 노출 방지)
  if command -v gh &>/dev/null; then
    gh auth setup-git 2>/dev/null || true
  fi

  PUSH_SUCCESS=false

  # 1차 시도: upstream에 직접 push
  log "고객사 origin에 push 중... ($UPSTREAM_REPO:$BRANCH_NAME)"
  git remote add upstream "https://github.com/${UPSTREAM_REPO}.git" 2>/dev/null || true

  if git push --no-verify upstream "$BRANCH_NAME" 2>/dev/null; then
    PUSH_SUCCESS=true
    PR_HEAD="$BRANCH_NAME"
  else
    # Fallback: fork에 push 후 cross-fork PR
    warn "upstream 직접 push 실패. fork 경유 PR로 전환합니다."
    if git push --no-verify origin "$BRANCH_NAME" 2>/dev/null; then
      PUSH_SUCCESS=true
      PR_HEAD="${FORK_ORG}:${BRANCH_NAME}"
    else
      error "push 실패. 권한을 확인하세요."
    fi
  fi

  if [ "$PUSH_SUCCESS" = true ]; then
    # PR 생성
    log "PR 생성 중..."
    PR_URL=$(GH_TOKEN="$UPSTREAM_TOKEN" gh pr create \
      --repo "$UPSTREAM_REPO" \
      --base "$UPSTREAM_BRANCH" \
      --head "$PR_HEAD" \
      --title "sync: ${FORK_ORG} → upstream ($(date +%Y-%m-%d))" \
      --body "" \
      2>/dev/null || true)

    log ""
    log "============================================"
    log "  고객사 origin PR 생성 완료!"
    log "============================================"
    if [ -n "$PR_URL" ]; then
      log "  PR: $PR_URL"
    fi
    log "  대상: $UPSTREAM_REPO ($UPSTREAM_BRANCH)"
  fi
else
  log ""
  log "============================================"
  log "  Clean branch 생성 완료 (push 필요)"
  log "============================================"
  log ""
  log "수동으로 push 후 PR을 생성하세요:"
  log "  git remote add upstream https://github.com/<origin-repo>.git"
  log "  git push upstream $BRANCH_NAME"
  log "  → upstream repo에서 $BRANCH_NAME → main PR 생성"
fi
