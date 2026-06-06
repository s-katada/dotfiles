#!/usr/bin/env bash
# Notify when a Cursor agent turn finishes. Hook failures should not block work.

set -u

input=$(cat)

cwd=$(printf '%s' "$input" | jq -r '.workspace.current_dir // .cwd // empty' 2>/dev/null || true)
session_name=$(printf '%s' "$input" | jq -r '.session_name // empty' 2>/dev/null || true)

message="タスクが完了しました"
if [ -n "$session_name" ]; then
  message="${message}: ${session_name}"
elif [ -n "$cwd" ]; then
  message="${message}: $(basename "$cwd")"
fi

osascript - "$message" >/dev/null 2>&1 <<'APPLESCRIPT' || true
on run argv
  display notification (item 1 of argv) with title "Cursor" sound name "Glass"
end run
APPLESCRIPT
exit 0
