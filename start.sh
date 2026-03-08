#!/usr/bin/env bash
# Created by Matthew Valancy
# Copyright 2026 Valpatel Software LLC
# Licensed under AGPL-3.0 — see LICENSE for details.
#
# Start all Tritium services.
#
# Usage:
#   ./start.sh              # Start edge server + SC (default)
#   ./start.sh edge         # Edge server only
#   ./start.sh sc           # SC only
#   ./start.sh all          # Edge + SC + MQTT broker check
#   ./start.sh stop         # Stop all services
#
# The edge server runs on :8080, SC runs on :5000.
# Both bridge automatically via MQTT (Mosquitto on :1884).

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

log() { echo -e "${CYAN}[tritium]${NC} $*"; }
ok()  { echo -e "${GREEN}[tritium]${NC} $*"; }
err() { echo -e "${RED}[tritium]${NC} $*" >&2; }

start_edge() {
    log "Starting Tritium-Edge server (:8080)..."
    if fuser 8080/tcp &>/dev/null; then
        ok "Edge server already running on :8080"
        return
    fi
    cd "$SCRIPT_DIR/tritium-edge/server"
    if [ ! -d ".venv" ]; then
        err "No .venv in tritium-edge/server — run: cd tritium-edge/server && python -m venv .venv && pip install -r requirements.txt"
        return 1
    fi
    source .venv/bin/activate
    nohup uvicorn app.main:app --host 0.0.0.0 --port 8080 &>/tmp/tritium-edge.log &
    sleep 2
    if fuser 8080/tcp &>/dev/null; then
        ok "Edge server started: http://localhost:8080/"
    else
        err "Edge server failed to start — check /tmp/tritium-edge.log"
        return 1
    fi
}

start_sc() {
    log "Starting Tritium-SC server (:5000)..."
    if fuser 5000/tcp &>/dev/null; then
        ok "SC already running on :5000"
        return
    fi
    cd "$SCRIPT_DIR/tritium-sc"
    if [ -x "start.sh" ]; then
        ./start.sh &
        sleep 3
        if fuser 5000/tcp &>/dev/null; then
            ok "SC started: http://localhost:5000/"
        else
            err "SC failed to start — check logs"
            return 1
        fi
    else
        err "tritium-sc/start.sh not found"
        return 1
    fi
}

check_mqtt() {
    if command -v mosquitto_sub &>/dev/null; then
        if systemctl is-active --quiet mosquitto 2>/dev/null; then
            ok "MQTT broker (Mosquitto) running"
        elif fuser 1884/tcp &>/dev/null; then
            ok "MQTT broker running on :1884"
        else
            log "MQTT broker not detected — MQTT bridging disabled"
            log "  Install: sudo apt install mosquitto"
            log "  Config port 1884 for Tritium"
        fi
    else
        log "Mosquitto not installed — MQTT bridging disabled"
    fi
}

stop_all() {
    log "Stopping Tritium services..."
    fuser -k 8080/tcp 2>/dev/null && ok "Edge server stopped" || true
    fuser -k 5000/tcp 2>/dev/null && ok "SC stopped" || true
}

MODE="${1:-all}"

case "$MODE" in
    edge)
        start_edge
        ;;
    sc)
        start_sc
        ;;
    all)
        check_mqtt
        start_edge
        start_sc
        echo ""
        ok "All services started."
        ok "  Edge:  http://localhost:8080/"
        ok "  SC:    http://localhost:5000/"
        ;;
    stop)
        stop_all
        ;;
    *)
        echo "Usage: $0 [edge|sc|all|stop]"
        exit 1
        ;;
esac
