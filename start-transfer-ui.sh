#!/bin/bash

echo "Starting Rclone Transfer Manager..."
echo "=================================="
echo ""

# Check if rclone is running
if ! pgrep -f "rclone rcd" > /dev/null; then
    echo "Starting rclone RC server..."
    ~/.local/bin/rclone rcd --rc-web-gui --rc-user=admin --rc-pass=admin --rc-addr=:5572 --rc-web-gui-no-open-browser &
    RCLONE_PID=$!
    echo "Rclone RC started (PID: $RCLONE_PID)"
    sleep 2
else
    echo "Rclone RC is already running"
fi

# Start the web UI server
echo ""
echo "Starting Transfer Manager UI..."
cd "$(dirname "$0")/web-ui"
python3 server.py &
UI_PID=$!

echo ""
echo "Transfer Manager is running!"
echo ""
echo "Access the UI at: http://localhost:8080"
echo ""
echo "Available remotes:"
~/.local/bin/rclone listremotes
echo ""
echo "Press Ctrl+C to stop all services"

# Trap Ctrl+C to clean up
trap 'echo "Stopping services..."; kill $UI_PID 2>/dev/null; exit' INT

# Wait for the UI process
wait $UI_PID