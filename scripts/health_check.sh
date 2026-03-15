#!/usr/bin/env bash
# Tritium System Health Check
# Copyright 2026 Valpatel Software LLC / AGPL-3.0

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

WARN=0
FAIL=0

report() {
    local status="$1" msg="$2"
    case "$status" in
        OK)   echo -e "  ${GREEN}[OK]${NC}   $msg" ;;
        WARN) echo -e "  ${YELLOW}[WARN]${NC} $msg"; ((WARN++)) ;;
        FAIL) echo -e "  ${RED}[FAIL]${NC} $msg"; ((FAIL++)) ;;
    esac
}

echo -e "${CYAN}=== Tritium Health Check ===${NC}"
echo "  Timestamp: $(date -Iseconds)"
echo ""

# Disk usage
echo -e "${CYAN}--- Disk ---${NC}"
DISK_PCT=$(df / --output=pcent | tail -1 | tr -d ' %')
DISK_AVAIL=$(df -h / --output=avail | tail -1 | tr -d ' ')
if [ "$DISK_PCT" -ge 95 ]; then
    report FAIL "Root disk ${DISK_PCT}% used (${DISK_AVAIL} free) — critically low"
elif [ "$DISK_PCT" -ge 90 ]; then
    report WARN "Root disk ${DISK_PCT}% used (${DISK_AVAIL} free) — getting full"
elif [ "$DISK_PCT" -ge 80 ]; then
    report WARN "Root disk ${DISK_PCT}% used (${DISK_AVAIL} free)"
else
    report OK "Root disk ${DISK_PCT}% used (${DISK_AVAIL} free)"
fi

# Memory
echo -e "${CYAN}--- Memory ---${NC}"
MEM_FREE_MB=$(free -m | awk '/Mem:/ {print $7}')
MEM_TOTAL_MB=$(free -m | awk '/Mem:/ {print $2}')
MEM_USED_PCT=$((100 - MEM_FREE_MB * 100 / MEM_TOTAL_MB))
if [ "$MEM_FREE_MB" -lt 2048 ]; then
    report FAIL "Available memory: ${MEM_FREE_MB}MB — critically low"
elif [ "$MEM_FREE_MB" -lt 4096 ]; then
    report WARN "Available memory: ${MEM_FREE_MB}MB — low"
else
    report OK "Available memory: ${MEM_FREE_MB}MB (${MEM_USED_PCT}% used of ${MEM_TOTAL_MB}MB)"
fi

SWAP_USED=$(free -m | awk '/Swap:/ {print $3}')
SWAP_TOTAL=$(free -m | awk '/Swap:/ {print $2}')
if [ "$SWAP_TOTAL" -gt 0 ] && [ "$SWAP_USED" -gt $((SWAP_TOTAL * 80 / 100)) ]; then
    report WARN "Swap ${SWAP_USED}MB / ${SWAP_TOTAL}MB used"
else
    report OK "Swap ${SWAP_USED}MB / ${SWAP_TOTAL}MB used"
fi

# Ollama
echo -e "${CYAN}--- Ollama ---${NC}"
if systemctl is-active --quiet ollama 2>/dev/null; then
    OLLAMA_MEM=$(systemctl show ollama --property=MemoryCurrent 2>/dev/null | cut -d= -f2)
    if [ "$OLLAMA_MEM" != "" ] && [ "$OLLAMA_MEM" != "[not set]" ]; then
        OLLAMA_MB=$((OLLAMA_MEM / 1048576))
        report OK "Ollama running (${OLLAMA_MB}MB memory)"
    else
        report OK "Ollama running"
    fi
else
    report WARN "Ollama not running"
fi

# Zombie processes
echo -e "${CYAN}--- Processes ---${NC}"
ZOMBIES=$(ps aux | awk '$8 ~ /^Z/ {count++} END {print count+0}')
if [ "$ZOMBIES" -gt 0 ]; then
    report WARN "${ZOMBIES} zombie process(es) detected"
else
    report OK "No zombie processes"
fi

# Git status
echo -e "${CYAN}--- Git ---${NC}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
if [ -d "$REPO_DIR/.git" ]; then
    BRANCH=$(git -C "$REPO_DIR" branch --show-current 2>/dev/null || echo "unknown")
    DIRTY=$(git -C "$REPO_DIR" status --porcelain 2>/dev/null | wc -l)
    if [ "$DIRTY" -gt 0 ]; then
        report WARN "Git repo has ${DIRTY} uncommitted change(s) on ${BRANCH}"
    else
        report OK "Git repo clean on ${BRANCH}"
    fi
else
    report WARN "Not in a git repository"
fi

# Summary
echo ""
echo -e "${CYAN}=== Summary ===${NC}"
if [ "$FAIL" -gt 0 ]; then
    echo -e "  ${RED}FAILURES: ${FAIL}${NC}  Warnings: ${WARN}"
    exit 2
elif [ "$WARN" -gt 0 ]; then
    echo -e "  ${YELLOW}Warnings: ${WARN}${NC}  All critical checks passed"
    exit 1
else
    echo -e "  ${GREEN}All checks passed${NC}"
    exit 0
fi
