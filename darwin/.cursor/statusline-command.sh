#!/usr/bin/env bash
# Cursor CLI status line — Claude Code の statusline と同一の見た目にするため、
# 共通実装 (../.claude/statusline-command.sh) に流す薄いラッパー。
# cursor-agent が stdin に渡す JSON は Claude Code とほぼ同スキーマだが
# .rate_limits が無いので、代わりに Cursor の月次 included usage
# (statusline-usage-refresh.sh がキャッシュした値) を .rate_limits.monthly に
# 注入して渡す。Claude Code は .rate_limits.monthly を送らないので、
# Claude 側の表示には一切影響しない。

set -uo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
shared="$here/../.claude/statusline-command.sh"
cache="${CURSOR_USAGE_CACHE:-${XDG_CACHE_HOME:-$HOME/.cache}/cursor-statusline-usage.json}"

input=$(cat)

now=$(date +%s)
mtime=$(stat -f %m "$cache" 2>/dev/null || echo 0)

# キャッシュが無い/10分より古い → バックグラウンドで更新 (描画はブロックしない)
if [ $((now - mtime)) -gt 600 ]; then
    (bash "$here/statusline-usage-refresh.sh" >/dev/null 2>&1 &)
fi

# 24時間以内のキャッシュだけ信用して注入 (それより古いのは認証切れ等なので隠す)
if [ -s "$cache" ] && [ "$mtime" -gt 0 ] && [ $((now - mtime)) -lt 86400 ]; then
    merged=$(printf '%s' "$input" | jq -c --slurpfile u "$cache" '.rate_limits.monthly = $u[0]' 2>/dev/null) || merged=""
    [ -n "$merged" ] && input=$merged
fi

printf '%s' "$input" | bash "$shared"
