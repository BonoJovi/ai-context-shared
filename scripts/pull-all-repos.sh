#!/bin/bash
# pull-all-repos.sh
# Safely pull ai-context-shared updates to all dependent repositories
#
# Usage: ./pull-all-repos.sh [--force]
#   --force: Stash changes, pull, then restore (use with caution)

set -e

# Configuration
BASE_DIR="$HOME/Data1/Linux/Projects/Rust"
REPOS=(
    "Promps"
    "Promps-Pro"
    "Promps-Ent"
    "Promps-Edu"
    "KakeiBonByRust"
    "Baconian"
)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

FORCE_MODE=false
if [[ "$1" == "--force" ]]; then
    FORCE_MODE=true
    echo -e "${YELLOW}Force mode enabled: will stash/restore uncommitted changes${NC}"
fi

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Pull ai-context-shared to all repos  ${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

SUCCESS_COUNT=0
SKIP_COUNT=0
FAIL_COUNT=0

for repo in "${REPOS[@]}"; do
    REPO_PATH="$BASE_DIR/$repo"

    echo -e "${BLUE}--- $repo ---${NC}"

    # Check if repo exists
    if [[ ! -d "$REPO_PATH" ]]; then
        echo -e "${RED}  [SKIP] Directory not found: $REPO_PATH${NC}"
        ((SKIP_COUNT++))
        echo ""
        continue
    fi

    cd "$REPO_PATH"

    # Check for uncommitted changes
    if ! git diff --quiet || ! git diff --cached --quiet; then
        if [[ "$FORCE_MODE" == true ]]; then
            echo -e "${YELLOW}  [STASH] Uncommitted changes found, stashing...${NC}"
            git stash push -m "auto-stash before submodule update"
            STASHED=true
        else
            echo -e "${YELLOW}  [SKIP] Uncommitted changes found${NC}"
            echo -e "${YELLOW}         Run with --force to stash and continue${NC}"
            git status --short
            ((SKIP_COUNT++))
            echo ""
            continue
        fi
    else
        STASHED=false
    fi

    # Get current branch
    BRANCH=$(git branch --show-current)

    # Pull latest
    echo -e "  Pulling $BRANCH..."
    if git pull --rebase origin "$BRANCH" 2>/dev/null; then
        # Update submodule
        if [[ -d ".ai-context/shared" ]]; then
            echo -e "  Updating submodule..."
            git submodule update --remote .ai-context/shared 2>/dev/null || true
        fi
        echo -e "${GREEN}  [OK] Updated successfully${NC}"
        ((SUCCESS_COUNT++))
    else
        echo -e "${RED}  [FAIL] Pull failed${NC}"
        ((FAIL_COUNT++))
    fi

    # Restore stashed changes
    if [[ "$STASHED" == true ]]; then
        echo -e "${YELLOW}  [RESTORE] Restoring stashed changes...${NC}"
        git stash pop || echo -e "${RED}  Warning: stash pop failed, check manually${NC}"
    fi

    echo ""
done

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Summary${NC}"
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}  Success: $SUCCESS_COUNT${NC}"
echo -e "${YELLOW}  Skipped: $SKIP_COUNT${NC}"
echo -e "${RED}  Failed:  $FAIL_COUNT${NC}"
