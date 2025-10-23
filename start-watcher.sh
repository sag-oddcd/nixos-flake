#!/usr/bin/env bash

# Start NixOS flake watcher in background
# Creates PID file for tracking

set -e

WATCHER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PID_FILE="$WATCHER_DIR/.watcher.pid"
LOG_FILE="$WATCHER_DIR/watcher.log"

# Check if already running
if [ -f "$PID_FILE" ]; then
    OLD_PID=$(cat "$PID_FILE")
    if kill -0 "$OLD_PID" 2>/dev/null; then
        echo "Watcher already running (PID: $OLD_PID)"
        exit 0
    else
        # Stale PID file, remove it
        rm -f "$PID_FILE"
    fi
fi

# Start watchexec in background
cd "$WATCHER_DIR"
watchexec \
    -w . \
    -e nix,md,sh \
    --debounce 5s \
    ./.watchexec.sh \
    > "$LOG_FILE" 2>&1 &

WATCHER_PID=$!

# Save PID
echo "$WATCHER_PID" > "$PID_FILE"

echo "NixOS flake watcher started (PID: $WATCHER_PID)"
echo "Log: $LOG_FILE"
