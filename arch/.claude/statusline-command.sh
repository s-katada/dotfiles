#!/usr/bin/env bash
# Claude Code status line — Catppuccin Mocha theme.
# Sections: dir | git | 5h-limit | 7d-limit | model | ctx | time
# Usage data is read from `.rate_limits` in the statusline JSON Claude Code
# pipes to us — same numbers /usage shows in the UI. No external tools, no
# network calls.
#
# darwin/.claude/statusline-command.sh の arch 版。差分は fmt_reset の date の
# 呼び出し順だけ (下のコメント参照) なので、片方を直したら diff で確認して両方に
# 反映する:  diff darwin/.claude/statusline-command.sh arch/.claude/statusline-command.sh
#
# 依存: jq (JSON の読み取り), Nerd Font のグリフ (ttf-nerd-fonts-symbols)

set -uo pipefail

input=$(cat)

# ── Inputs ────────────────────────────────────────────────────────────────
cwd=$(printf '%s' "$input"        | jq -r '.workspace.current_dir // .cwd // ""')
model=$(printf '%s' "$input"      | jq -r '.model.display_name // ""')
ctx_remaining=$(printf '%s' "$input" | jq -r '
    .context_window.remaining_percentage // (
        if (.context_window.used_percentage // null) != null
        then (100 - .context_window.used_percentage)
        else empty
        end
    )')
five_pct=$(printf '%s' "$input"   | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_reset=$(printf '%s' "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
week_pct=$(printf '%s' "$input"   | jq -r '.rate_limits.seven_day.used_percentage // empty')
week_reset=$(printf '%s' "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

# ── Catppuccin Mocha (truecolor) ──────────────────────────────────────────
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
C_PINK=$'\033[38;2;245;194;231m'
C_OVERLAY=$'\033[38;2;127;132;156m'
C_SUBTEXT=$'\033[38;2;186;194;222m'

SEP="${C_OVERLAY} ▎${RESET}"
BAR_WIDTH=8

bar() {
    # bar PERCENT [WIDTH]
    local pct=${1:-0} width=${2:-$BAR_WIDTH}
    pct=$(printf '%.0f' "$pct" 2>/dev/null || printf '0')
    [ "$pct" -lt 0 ]   && pct=0
    [ "$pct" -gt 100 ] && pct=100
    local filled=$(( (pct * width + 50) / 100 ))
    local empty=$(( width - filled ))
    local out="" i
    for ((i=0;i<filled;i++)); do out="${out}█"; done
    for ((i=0;i<empty;i++));  do out="${out}░"; done
    printf '%s' "$out"
}

# Color escalation for "used %": low=green, high=red.
used_color() {
    local pct=${1:-0}
    pct=$(printf '%.0f' "$pct" 2>/dev/null || printf '0')
    if   [ "$pct" -lt 50 ]; then printf '%s' "$C_GREEN"
    elif [ "$pct" -lt 75 ]; then printf '%s' "$C_YELLOW"
    elif [ "$pct" -lt 90 ]; then printf '%s' "$C_PEACH"
    else                          printf '%s' "$C_RED"
    fi
}

# Color escalation for "remaining %": opposite direction.
remaining_color() {
    local pct=${1:-0}
    pct=$(printf '%.0f' "$pct" 2>/dev/null || printf '0')
    if   [ "$pct" -ge 60 ]; then printf '%s' "$C_GREEN"
    elif [ "$pct" -ge 30 ]; then printf '%s' "$C_YELLOW"
    elif [ "$pct" -ge 15 ]; then printf '%s' "$C_PEACH"
    else                         printf '%s' "$C_RED"
    fi
}

# Format ISO timestamp -> "HH:MM" in local time (or empty on failure).
#
# darwin 側との唯一の差分。GNU date (Linux) を先に試す。
# BSD date (macOS) は -d を「日を指定」と解釈して別物になり、GNU date は -j を
# 知らないのでエラーになる。どちらも失敗時は次にフォールバックするので、
# 順番を入れ替えるだけで両プラットフォームで動く。Linux では GNU が先に当たるため
# 毎描画ごとに失敗プロセスを 1 つ起こさずに済む。
fmt_reset() {
    local iso="${1:-}"
    [ -z "$iso" ] && return 0
    date -d "$iso" "+%H:%M" 2>/dev/null \
        || date -j -f "%Y-%m-%dT%H:%M:%S" "${iso%%.*}" "+%H:%M" 2>/dev/null \
        || true
}

# ── Directory segment ─────────────────────────────────────────────────────
home="$HOME"
short_cwd="${cwd/#$home/\~}"

dir_segment=""
if git_root=$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null); then
    repo_name=$(basename "$git_root")
    rel="${cwd#$git_root}"; rel="${rel#/}"
    if [ -n "$rel" ]; then
        dir_segment="${C_BLUE} ${RESET}${BOLD}${C_LAVENDER}${repo_name}${RESET}${C_OVERLAY}/${C_SUBTEXT}${rel}${RESET}"
    else
        dir_segment="${C_BLUE} ${RESET}${BOLD}${C_LAVENDER}${repo_name}${RESET}"
    fi
else
    dir_segment="${C_BLUE} ${RESET}${C_SUBTEXT}${short_cwd}${RESET}"
fi

# ── Git segment ───────────────────────────────────────────────────────────
git_segment=""
if git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
    branch=$(git -C "$cwd" -c core.checkStat=minimal symbolic-ref --short HEAD 2>/dev/null \
             || git -C "$cwd" rev-parse --short HEAD 2>/dev/null \
             || printf '%s' '?')

    ahead=$(git -C "$cwd" -c core.checkStat=minimal rev-list --count @{upstream}..HEAD 2>/dev/null || printf '0')
    behind=$(git -C "$cwd" -c core.checkStat=minimal rev-list --count HEAD..@{upstream} 2>/dev/null || printf '0')

    ab=""
    if [ "$ahead" != "0" ];  then ab="${ab} ⇡${ahead}"; fi
    if [ "$behind" != "0" ]; then ab="${ab} ⇣${behind}"; fi

    has_modified=false; has_staged=false; has_untracked=false
    git -C "$cwd" -c core.checkStat=minimal diff --quiet 2>/dev/null         || has_modified=true
    git -C "$cwd" -c core.checkStat=minimal diff --cached --quiet 2>/dev/null || has_staged=true
    if [ -n "$(git -C "$cwd" ls-files --others --exclude-standard 2>/dev/null | head -1)" ]; then
        has_untracked=true
    fi

    state=""; color="$C_GREEN"
    if   $has_modified;  then color="$C_RED";    state=" ●"
    elif $has_staged;    then color="$C_YELLOW"; state=" +"
    elif $has_untracked; then color="$C_PEACH";  state=" ?"
    fi

    git_segment="${color} ${branch}${state}${ab}${RESET}"
fi

# ── 5-hour limit segment ──────────────────────────────────────────────────
five_segment=""
if [ -n "$five_pct" ]; then
    pct_int=$(printf '%.0f' "$five_pct")
    color=$(used_color "$five_pct")
    reset_str=$(fmt_reset "$five_reset")
    reset_part=""
    [ -n "$reset_str" ] && reset_part="${C_OVERLAY}↻${reset_str}${RESET}"
    five_segment="${C_TEAL}5h${RESET} ${color}$(bar "$five_pct")${RESET} ${color}${pct_int}%${RESET}${reset_part:+ ${reset_part}}"
fi

# ── 7-day limit segment ───────────────────────────────────────────────────
week_segment=""
if [ -n "$week_pct" ]; then
    pct_int=$(printf '%.0f' "$week_pct")
    color=$(used_color "$week_pct")
    reset_str=$(fmt_reset "$week_reset")
    reset_part=""
    [ -n "$reset_str" ] && reset_part="${C_OVERLAY}↻${reset_str}${RESET}"
    week_segment="${C_PINK}7d${RESET} ${color}$(bar "$week_pct")${RESET} ${color}${pct_int}%${RESET}${reset_part:+ ${reset_part}}"
fi

# ── Model segment ─────────────────────────────────────────────────────────
model_segment=""
[ -n "$model" ] && model_segment="${C_MAUVE}󰚩 ${model}${RESET}"

# ── Context segment ───────────────────────────────────────────────────────
ctx_segment=""
if [ -n "$ctx_remaining" ]; then
    pct_int=$(printf '%.0f' "$ctx_remaining")
    color=$(remaining_color "$ctx_remaining")
    if   [ "$pct_int" -ge 30 ]; then emoji="🧠"
    elif [ "$pct_int" -ge 15 ]; then emoji="⚠️ "
    else                              emoji="🚨"
    fi
    ctx_segment="${emoji} ${color}$(bar "$ctx_remaining") ${pct_int}%${RESET}"
fi

# ── Time segment ──────────────────────────────────────────────────────────
time_segment="${C_OVERLAY} $(date +%H:%M)${RESET}"

# ── Assemble ──────────────────────────────────────────────────────────────
parts=("$dir_segment")
[ -n "$git_segment" ]   && parts+=("$git_segment")
[ -n "$five_segment" ]  && parts+=("$five_segment")
[ -n "$week_segment" ]  && parts+=("$week_segment")
[ -n "$model_segment" ] && parts+=("$model_segment")
[ -n "$ctx_segment" ]   && parts+=("$ctx_segment")
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
