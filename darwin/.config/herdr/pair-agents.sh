#!/usr/bin/env bash
# 今のタブ内の claude / cursor を reviewer / fixer にリネームする。
# review-fix-loop スキル用。確認: herdr agent list
set -euo pipefail

if [[ "${HERDR_ENV:-}" != "1" ]]; then
  echo "error: not inside Herdr (HERDR_ENV!=1)" >&2
  exit 1
fi

BIN="${HERDR_BIN_PATH:-herdr}"

tab_id="${HERDR_TAB_ID:-}"
if [[ -z "$tab_id" ]]; then
  tab_id="$("$BIN" pane current | jq -r '.result.pane.tab_id')"
fi

pair="$("$BIN" agent list | jq -r --arg tab "$tab_id" '
  .result.agents
  | map(select(.tab_id == $tab))
  | {
      claude: (map(select(.agent == "claude")) | first | .pane_id // empty),
      cursor: (map(select(.agent == "cursor")) | first | .pane_id // empty)
    }
  | "\(.claude)\t\(.cursor)"
')"

claude_pane="${pair%%$'\t'*}"
cursor_pane="${pair#*$'\t'}"

if [[ -z "$claude_pane" || -z "$cursor_pane" || "$claude_pane" == "null" || "$cursor_pane" == "null" ]]; then
  echo "error: need both claude and cursor in tab $tab_id" >&2
  "$BIN" agent list | jq -r --arg tab "$tab_id" '
    .result.agents[] | select(.tab_id == $tab)
    | "  \(.agent)  \(.pane_id)  \(.agent_status)"
  ' >&2
  exit 1
fi

"$BIN" agent rename "$claude_pane" reviewer >/dev/null
"$BIN" agent rename "$cursor_pane" fixer >/dev/null

echo "paired tab=$tab_id reviewer=$claude_pane fixer=$cursor_pane"
"$BIN" notification show "review-fix" \
  --body "reviewer + fixer paired" \
  --sound none >/dev/null 2>&1 || true
