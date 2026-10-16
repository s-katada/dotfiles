#!/usr/bin/env bash
# Antigravity CLI status line — Claude Code の statusline と同一の見た目にするため、
# 共通実装 (../.claude/statusline-command.sh) に流す薄いラッパー。
#
# Antigravity CLI が stdin に渡す JSON には .quota (gemini-5h, gemini-weekly, 3p-5h 等)
# や .model.effort が含まれるため、Claude Code の .rate_limits / .model.param_summary
# 形式に整形して共通実装に流す。

set -uo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
shared="${SHARED_STATUSLINE:-$here/../.claude/statusline-command.sh}"
[ -f "$shared" ] || shared="$HOME/.claude/statusline-command.sh"

input=$(cat)

if [ -z "$input" ]; then
    exit 0
fi

# Antigravity の .quota / .model.effort を Claude Code 形式に変換
transformed=$(printf '%s' "$input" | jq -c '
  .model.id as $mid |
  (if ($mid | test("claude|gpt|o1|o3|o4"; "i")) then true else false end) as $is_3p |

  (if $is_3p and .quota["3p-5h"] != null and (.quota["3p-5h"].disabled | not) then
    .quota["3p-5h"]
  else
    .quota["gemini-5h"]
  end) as $q5 |

  (if $is_3p and .quota["3p-weekly"] != null and (.quota["3p-weekly"].disabled | not) then
    .quota["3p-weekly"]
  else
    .quota["gemini-weekly"]
  end) as $qw |

  .rate_limits = {
    five_hour: (if $q5 != null then {
      used_percentage: ((1.0 - ($q5.remaining_fraction // 1.0)) * 100.0),
      resets_at: $q5.reset_time
    } else null end),
    seven_day: (if $qw != null then {
      used_percentage: ((1.0 - ($qw.remaining_fraction // 1.0)) * 100.0),
      resets_at: $qw.reset_time
    } else null end)
  } |
  if .model.effort != null and .model.effort != "" and .model.param_summary == null then
    .model.param_summary = .model.effort
  else . end
' 2>/dev/null) || transformed=""

if [ -n "$transformed" ]; then
    printf '%s' "$transformed" | bash "$shared"
else
    printf '%s' "$input" | bash "$shared"
fi
