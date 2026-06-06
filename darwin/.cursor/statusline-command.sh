#!/usr/bin/env bash
# Cursor CLI status line - Catppuccin Mocha inspired.
# Sections: dir | git | model | api tokens | context | time

set -uo pipefail

input=$(cat)

cwd=$(printf '%s' "$input" | jq -r '.workspace.current_dir // .cwd // env.PWD // ""')
model=$(printf '%s' "$input" | jq -r '.model.display_name // .model.id // ""')
model_params=$(printf '%s' "$input" | jq -r '.model.param_summary // empty')
ctx_remaining=$(printf '%s' "$input" | jq -r '
  .context_window.remaining_percentage // (
    if (.context_window.used_percentage // null) != null
    then (100 - .context_window.used_percentage)
    else empty
    end
  )
')
total_input=$(printf '%s' "$input" | jq -r '.context_window.total_input_tokens // empty')
total_output=$(printf '%s' "$input" | jq -r '.context_window.total_output_tokens // empty')
current_input=$(printf '%s' "$input" | jq -r '
  .context_window.current_usage.input_tokens //
  .context_window.current_usage.input //
  .context_window.current_usage.prompt_tokens //
  empty
')
current_output=$(printf '%s' "$input" | jq -r '
  .context_window.current_usage.output_tokens //
  .context_window.current_usage.output //
  .context_window.current_usage.completion_tokens //
  empty
')

RESET=$'\033[0m'
BOLD=$'\033[1m'

C_LAVENDER=$'\033[38;2;180;190;254m'
C_BLUE=$'\033[38;2;137;180;250m'
C_GREEN=$'\033[38;2;166;227;161m'
C_YELLOW=$'\033[38;2;249;226;175m'
C_RED=$'\033[38;2;243;139;168m'
C_PEACH=$'\033[38;2;250;179;135m'
C_MAUVE=$'\033[38;2;203;166;247m'
C_TEAL=$'\033[38;2;148;226;213m'
C_OVERLAY=$'\033[38;2;127;132;156m'
C_SUBTEXT=$'\033[38;2;186;194;222m'

SEP="${C_OVERLAY} | ${RESET}"
BAR_WIDTH=8

bar() {
  local pct=${1:-0} width=${2:-$BAR_WIDTH}
  pct=$(printf '%.0f' "$pct" 2>/dev/null || printf '0')
  [ "$pct" -lt 0 ] && pct=0
  [ "$pct" -gt 100 ] && pct=100
  local filled=$(( (pct * width + 50) / 100 ))
  local empty=$(( width - filled ))
  local out="" i
  for ((i = 0; i < filled; i++)); do out="${out}#"; done
  for ((i = 0; i < empty; i++)); do out="${out}-"; done
  printf '%s' "$out"
}

compact_num() {
  local n=${1:-}
  [ -z "$n" ] && return 0
  awk -v n="$n" 'BEGIN {
    if (n >= 1000000) printf "%.1fM", n / 1000000;
    else if (n >= 1000) printf "%.1fk", n / 1000;
    else printf "%d", n;
  }'
}

remaining_color() {
  local pct=${1:-0}
  pct=$(printf '%.0f' "$pct" 2>/dev/null || printf '0')
  if [ "$pct" -ge 60 ]; then printf '%s' "$C_GREEN"
  elif [ "$pct" -ge 30 ]; then printf '%s' "$C_YELLOW"
  elif [ "$pct" -ge 15 ]; then printf '%s' "$C_PEACH"
  else printf '%s' "$C_RED"
  fi
}

home="$HOME"
short_cwd="${cwd/#$home/\~}"

dir_segment=""
if [ -n "$cwd" ] && git_root=$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null); then
  repo_name=$(basename "$git_root")
  rel="${cwd#$git_root}"
  rel="${rel#/}"
  if [ -n "$rel" ]; then
    dir_segment="${BOLD}${C_LAVENDER}${repo_name}${RESET}${C_OVERLAY}/${C_SUBTEXT}${rel}${RESET}"
  else
    dir_segment="${BOLD}${C_LAVENDER}${repo_name}${RESET}"
  fi
else
  dir_segment="${C_BLUE}${short_cwd}${RESET}"
fi

git_segment=""
if [ -n "$cwd" ] && git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
  branch=$(git -C "$cwd" -c core.checkStat=minimal symbolic-ref --short HEAD 2>/dev/null \
    || git -C "$cwd" rev-parse --short HEAD 2>/dev/null \
    || printf '%s' '?')

  ahead=$(git -C "$cwd" -c core.checkStat=minimal rev-list --count @{upstream}..HEAD 2>/dev/null || printf '0')
  behind=$(git -C "$cwd" -c core.checkStat=minimal rev-list --count HEAD..@{upstream} 2>/dev/null || printf '0')

  ab=""
  if [ "$ahead" != "0" ]; then ab="${ab} +${ahead}"; fi
  if [ "$behind" != "0" ]; then ab="${ab} -${behind}"; fi

  has_modified=false
  has_staged=false
  has_untracked=false
  git -C "$cwd" -c core.checkStat=minimal diff --quiet 2>/dev/null || has_modified=true
  git -C "$cwd" -c core.checkStat=minimal diff --cached --quiet 2>/dev/null || has_staged=true
  if [ -n "$(git -C "$cwd" ls-files --others --exclude-standard 2>/dev/null | awk 'NR == 1 { print; exit }')" ]; then
    has_untracked=true
  fi

  state=""
  color="$C_GREEN"
  if $has_modified; then
    color="$C_RED"
    state=" *"
  elif $has_staged; then
    color="$C_YELLOW"
    state=" staged"
  elif $has_untracked; then
    color="$C_PEACH"
    state=" ?"
  fi

  git_segment="${color}git:${branch}${state}${ab}${RESET}"
fi

model_segment=""
if [ -n "$model" ]; then
  model_segment="${C_MAUVE}model:${model}${model_params:+ ${model_params}}${RESET}"
fi

api_segment=""
if [ -n "$total_input" ] || [ -n "$total_output" ] || [ -n "$current_input" ] || [ -n "$current_output" ]; then
  total_part=""
  current_part=""
  if [ -n "$total_input" ] || [ -n "$total_output" ]; then
    total_part="in:$(compact_num "${total_input:-0}") out:$(compact_num "${total_output:-0}")"
  fi
  if [ -n "$current_input" ] || [ -n "$current_output" ]; then
    current_part="last +$(compact_num "${current_input:-0}")/+$(compact_num "${current_output:-0}")"
  fi
  api_segment="${C_TEAL}api:${RESET} ${C_SUBTEXT}${total_part}${current_part:+ ${current_part}}${RESET}"
fi

ctx_segment=""
if [ -n "$ctx_remaining" ]; then
  pct_int=$(printf '%.0f' "$ctx_remaining")
  color=$(remaining_color "$ctx_remaining")
  ctx_segment="${C_SUBTEXT}ctx:${RESET} ${color}[$(bar "$ctx_remaining")] ${pct_int}% left${RESET}"
fi

time_segment="${C_OVERLAY}$(date +%H:%M)${RESET}"

parts=("$dir_segment")
[ -n "$git_segment" ] && parts+=("$git_segment")
[ -n "$model_segment" ] && parts+=("$model_segment")
[ -n "$api_segment" ] && parts+=("$api_segment")
[ -n "$ctx_segment" ] && parts+=("$ctx_segment")
parts+=("$time_segment")

output=""
for p in "${parts[@]}"; do
  if [ -z "$output" ]; then
    output="$p"
  else
    output="${output}${SEP}${p}"
  fi
done

printf '%b' "$output"
