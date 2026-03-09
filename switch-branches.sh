#!/usr/bin/env bash
# Switch all Tritium submodules to the specified branch (dev by default).
# Usage: ./switch-branches.sh [branch]
#   ./switch-branches.sh        # switch all to dev
#   ./switch-branches.sh main   # switch all to main

set -euo pipefail

BRANCH="${1:-dev}"
SUBMODULES=(tritium-edge tritium-lib tritium-sc)

echo "=== Switching all submodules to '$BRANCH' ==="
echo

for sub in "${SUBMODULES[@]}"; do
    if [ ! -d "$sub" ]; then
        echo "  SKIP  $sub (directory not found)"
        continue
    fi

    echo "  [$sub]"

    # Fetch latest
    git -C "$sub" fetch origin --quiet

    # Check if branch exists on remote
    if ! git -C "$sub" rev-parse --verify "origin/$BRANCH" &>/dev/null; then
        echo "    WARNING: branch '$BRANCH' not found on remote, skipping"
        echo
        continue
    fi

    # Check for uncommitted changes
    if ! git -C "$sub" diff --quiet || ! git -C "$sub" diff --cached --quiet; then
        echo "    WARNING: uncommitted changes — switch manually"
        echo
        continue
    fi

    # Checkout and pull
    git -C "$sub" checkout "$BRANCH" --quiet 2>/dev/null || git -C "$sub" checkout -b "$BRANCH" "origin/$BRANCH" --quiet
    git -C "$sub" pull --ff-only origin "$BRANCH" --quiet
    echo "    → $(git -C "$sub" log --oneline -1)"
    echo
done

echo "=== Done ==="
