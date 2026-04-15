#!/usr/bin/env bash
# Poll for a Firefox window with "Slack" in the title and move it to the messaging workspace.
# Runs at niri startup; exits after 60 seconds if Slack never appears.
for i in $(seq 1 60); do
    id=$(niri msg --json windows 2>/dev/null \
        | jq -r '.[] | select(.title | test("Slack")) | .id' \
        | head -1)
    if [ -n "$id" ]; then
        niri msg action move-window-to-workspace --window-id "$id" messaging --focus false
        exit 0
    fi
    sleep 1
done
