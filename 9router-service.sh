#!/usr/bin/env bash
set -euo pipefail

# ============================================================================
# 9router-service.sh — Helper script to manage 9Router background service
# ============================================================================
# Usage:
#   ./9router-service.sh start              # Start 9Router in background
#   ./9router-service.sh stop               # Stop 9Router
#   ./9router-service.sh status             # Check if 9Router is active
#   ./9router-service.sh dashboard          # Open Dashboard in browser
#   ./9router-service.sh logs               # Tail 9Router logs
#   ./9router-service.sh enable-autostart   # Auto-run on macOS boot/login
#   ./9router-service.sh disable-autostart  # Remove auto-run on boot/login
# ============================================================================

PORT="${PORT:-20128}"
HOST="${HOST:-127.0.0.1}"
PID_FILE="${HOME}/.9router/9router.pid"
LOG_FILE="${HOME}/.9router/9router.log"
LAUNCH_AGENT_DIR="${HOME}/Library/LaunchAgents"
LAUNCH_AGENT_PLIST="${LAUNCH_AGENT_DIR}/com.9router.daemon.plist"

mkdir -p "${HOME}/.9router"

start() {
    if is_running; then
        local pid=""
        [[ -f "$PID_FILE" ]] && pid=$(cat "$PID_FILE")
        echo "✅ 9Router is already running ${pid:+(PID: $pid)} at http://${HOST}:${PORT}"
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
        local pid=""
        [[ -f "$PID_FILE" ]] && pid=$(cat "$PID_FILE")
        echo "🛑 Stopping 9Router ${pid:+(PID: $pid)} ..."
        [[ -n "$pid" ]] && kill "$pid" 2>/dev/null || true
        rm -f "$PID_FILE"
        # Also clean up any rogue process on the port
        local rogue
        rogue=$(lsof -ti :"$PORT" 2>/dev/null || true)
        if [[ -n "$rogue" ]]; then
            kill "$rogue" 2>/dev/null || true
        fi
        echo "✅ 9Router stopped."
    else
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
    local autostart_status="Disabled"
    if [[ -f "$LAUNCH_AGENT_PLIST" ]]; then
        autostart_status="Enabled (macOS LaunchAgent)"
    fi

    if is_running; then
        local pid=""
        [[ -f "$PID_FILE" ]] && pid=$(cat "$PID_FILE")
        echo "🟢 9Router is RUNNING ${pid:+(PID: $pid)} at http://${HOST}:${PORT}"
        echo "   Dashboard:    http://${HOST}:${PORT}/dashboard"
        echo "   API Base:     http://${HOST}:${PORT}/v1"
        echo "   Auto-start:   ${autostart_status}"
    else
        echo "🔴 9Router is STOPPED"
        echo "   Auto-start:   ${autostart_status}"
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

enable_autostart() {
    echo "⚙️  Configuring macOS LaunchAgent for 9Router auto-start..."
    mkdir -p "$LAUNCH_AGENT_DIR"
    mkdir -p "${HOME}/.9router"

    local node_path
    node_path=$(which node)
    local router_path
    router_path=$(which 9router)

    # Stop manual instance first
    stop > /dev/null 2>&1 || true

    cat <<EOF > "$LAUNCH_AGENT_PLIST"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.9router.daemon</string>
    <key>ProgramArguments</key>
    <array>
        <string>${node_path}</string>
        <string>${router_path}</string>
        <string>--host</string>
        <string>${HOST}</string>
        <string>--port</string>
        <string>${PORT}</string>
        <string>--skip-update</string>
        <string>--log</string>
        <string>-n</string>
    </array>
    <key>EnvironmentVariables</key>
    <dict>
        <key>PATH</key>
        <string>$(dirname "$node_path"):$PATH</string>
        <key>HOME</key>
        <string>${HOME}</string>
        <key>ENABLE_REQUEST_LOGS</key>
        <string>true</string>
    </dict>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>${HOME}/.9router/9router.log</string>
    <key>StandardErrorPath</key>
    <string>${HOME}/.9router/9router.error.log</string>
    <key>WorkingDirectory</key>
    <string>${HOME}</string>
</dict>
</plist>
EOF

    # Unload first if previously loaded
    launchctl unload "$LAUNCH_AGENT_PLIST" 2>/dev/null || true
    # Load and start via launchctl
    launchctl load -w "$LAUNCH_AGENT_PLIST"
    sleep 2

    if is_running; then
        echo "🎉 Auto-start enabled successfully via macOS LaunchAgent!"
        echo "   9Router will now run automatically on login and restart if closed."
        echo "   Plist: $LAUNCH_AGENT_PLIST"
        echo "   Dashboard: http://${HOST}:${PORT}/dashboard"
    else
        echo "⚠️  LaunchAgent loaded. Checking status..."
        status
    fi
}

disable_autostart() {
    echo "🛑 Disabling macOS LaunchAgent for 9Router..."
    if [[ -f "$LAUNCH_AGENT_PLIST" ]]; then
        launchctl unload -w "$LAUNCH_AGENT_PLIST" 2>/dev/null || true
        rm -f "$LAUNCH_AGENT_PLIST"
        echo "✅ Auto-start disabled and LaunchAgent removed."
    else
        echo "ℹ️  Auto-start LaunchAgent was not installed."
    fi
    stop
}

case "${1:-status}" in
    start) start ;;
    stop) stop ;;
    status) status ;;
    dashboard|open) dashboard ;;
    logs) logs ;;
    restart) stop; sleep 1; start ;;
    enable-autostart|autostart) enable_autostart ;;
    disable-autostart) disable_autostart ;;
    *)
        echo "Usage: $0 {start|stop|status|dashboard|logs|restart|enable-autostart|disable-autostart}"
        exit 1
        ;;
esac
