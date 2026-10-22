#!/usr/bin/env bash
set -euo pipefail

# ============================================================================
# 9router-service.sh — Helper script to manage 9Router background service
# ============================================================================
# Usage:
#   ./9router-service.sh start       # Start 9Router in background
#   ./9router-service.sh stop        # Stop 9Router
#   ./9router-service.sh status      # Check if 9Router is active
#   ./9router-service.sh dashboard   # Open Dashboard in browser
#   ./9router-service.sh logs        # Tail 9Router logs
# ============================================================================

PORT="${PORT:-20128}"
HOST="${HOST:-127.0.0.1}"
PID_FILE="${HOME}/.9router/9router.pid"
LOG_FILE="${HOME}/.9router/9router.log"

mkdir -p "${HOME}/.9router"

start() {
    if is_running; then
        local pid
        pid=$(cat "$PID_FILE")
        echo "✅ 9Router is already running (PID: $pid) at http://${HOST}:${PORT}"
        return 0
    fi

    echo "🚀 Starting 9Router server on http://${HOST}:${PORT} ..."
    nohup 9router --host "$HOST" --port "$PORT" --skip-update -n > "$LOG_FILE" 2>&1 &
    local new_pid=$!
    echo "$new_pid" > "$PID_FILE"
    sleep 2

    if is_running; then
        echo "🎉 9Router started successfully (PID: $new_pid)!"
        echo "👉 Dashboard URL: http://${HOST}:${PORT}/dashboard"
        echo "👉 API Endpoint:  http://${HOST}:${PORT}/v1"
        echo "👉 Default Password: 123456"
    else
        echo "❌ Failed to start 9Router. Check log file at: $LOG_FILE"
        exit 1
    fi
}

stop() {
    if is_running; then
        local pid
        pid=$(cat "$PID_FILE")
        echo "🛑 Stopping 9Router (PID: $pid) ..."
        kill "$pid" 2>/dev/null || true
        rm -f "$PID_FILE"
        echo "✅ 9Router stopped."
    else
        # Also check if any rogue process is on the port
        local rogue
        rogue=$(lsof -ti :"$PORT" 2>/dev/null || true)
        if [[ -n "$rogue" ]]; then
            echo "🛑 Stopping 9Router process on port $PORT (PID: $rogue) ..."
            kill "$rogue" 2>/dev/null || true
            rm -f "$PID_FILE"
            echo "✅ 9Router stopped."
        else
            echo "ℹ️  9Router is not running."
        fi
    fi
}

is_running() {
    if [[ -f "$PID_FILE" ]]; then
        local pid
        pid=$(cat "$PID_FILE")
        if ps -p "$pid" > /dev/null 2>&1; then
            return 0
        fi
    fi
    # Fallback port check
    if lsof -i :"$PORT" > /dev/null 2>&1; then
        return 0
    fi
    return 1
}

status() {
    if is_running; then
        local pid=""
        [[ -f "$PID_FILE" ]] && pid=$(cat "$PID_FILE")
        echo "🟢 9Router is RUNNING ${pid:+(PID: $pid)} at http://${HOST}:${PORT}"
        echo "   Dashboard: http://${HOST}:${PORT}/dashboard"
        echo "   API Base:  http://${HOST}:${PORT}/v1"
    else
        echo "🔴 9Router is STOPPED"
    fi
}

dashboard() {
    if ! is_running; then
        echo "⚠️  9Router is not running. Starting it first..."
        start
    fi
    echo "🌐 Opening Dashboard in browser..."
    open "http://${HOST}:${PORT}/dashboard"
}

logs() {
    if [[ -f "$LOG_FILE" ]]; then
        tail -f "$LOG_FILE"
    else
        echo "ℹ️  No log file found at: $LOG_FILE"
    fi
}

case "${1:-status}" in
    start) start ;;
    stop) stop ;;
    status) status ;;
    dashboard|open) dashboard ;;
    logs) logs ;;
    restart) stop; sleep 1; start ;;
    *)
        echo "Usage: $0 {start|stop|status|dashboard|logs|restart}"
        exit 1
        ;;
esac
