#!/usr/bin/env bash
# Cursor の月次 included usage を取得して statusline 用にキャッシュする。
# statusline-command.sh からバックグラウンドで呼ばれる (描画はブロックしない)。
#
# 認証: Linux 版 cursor-agent が保存する ~/.config/cursor/auth.json の
#   accessToken をそのまま使う (無ければ secret-tool にフォールバック)。
# API: cursor-agent 本体の /usage ダイアログと同じ
#   aiserver.v1.DashboardService/GetCurrentPeriodUsage (Connect JSON)。
# 手動テスト: bash statusline-usage-refresh.sh --debug

set -uo pipefail

CACHE_FILE="${CURSOR_USAGE_CACHE:-${XDG_CACHE_HOME:-$HOME/.cache}/cursor-statusline-usage.json}"
AUTH_FILE="${CURSOR_AUTH_FILE:-${XDG_CONFIG_HOME:-$HOME/.config}/cursor/auth.json}"
DEBUG=0
[ "${1:-}" = "--debug" ] && DEBUG=1

mkdir -p "$(dirname "$CACHE_FILE")"

# 多重起動ガード (statusline は高頻度に描画されるため)
LOCK_DIR="$CACHE_FILE.lock"
if ! mkdir "$LOCK_DIR" 2>/dev/null; then
    # 古い lock は掃除して次回に賭ける (クラッシュ残骸対策)
    if [ -d "$LOCK_DIR" ] && [ $(( $(date +%s) - $(stat -c %Y "$LOCK_DIR" 2>/dev/null || echo 0) )) -gt 120 ]; then
        rmdir "$LOCK_DIR" 2>/dev/null || true
    fi
    exit 0
fi
trap 'rmdir "$LOCK_DIR" 2>/dev/null' EXIT

token=""
if [ -r "$AUTH_FILE" ]; then
    token=$(jq -r '.accessToken // empty' "$AUTH_FILE" 2>/dev/null) || token=""
fi
if [ -z "$token" ] && command -v secret-tool >/dev/null 2>&1; then
    token=$(secret-tool lookup service cursor-access-token account cursor-user 2>/dev/null) || token=""
fi
if [ -z "$token" ]; then
    [ "$DEBUG" = 1 ] && echo "$AUTH_FILE からトークンを取得できない (cursor-agent login 済み?)" >&2
    exit 0
fi

resp=$(curl -sS -m 8 -X POST \
    'https://api2.cursor.sh/aiserver.v1.DashboardService/GetCurrentPeriodUsage' \
    -H "Authorization: Bearer $token" \
    -H 'Content-Type: application/json' \
    -H 'connect-protocol-version: 1' \
    -d '{}' 2>/dev/null) || resp=""
[ "$DEBUG" = 1 ] && printf 'response: %s\n' "$resp" >&2
[ -z "$resp" ] && exit 0

# protobuf JSON は camelCase が既定 (念のため snake_case もフォールバック)。
# int64 (billingCycleEnd) は文字列で来るので tonumber。ミリ秒なら秒へ丸める。
out=$(printf '%s' "$resp" | jq -c '
    def num: if . == null then null elif (type == "string") then tonumber else . end;
    (.planUsage // .plan_usage) as $p
    | (($p.totalPercentUsed // $p.total_percent_used) | num) as $pct
    | ((.billingCycleEnd // .billing_cycle_end) | num) as $end
    | select($pct != null)
    | {used_percentage: $pct}
      + (if $end != null then
            {resets_epoch: (if $end > 100000000000 then ($end / 1000 | floor) else $end end)}
         else {} end)
' 2>/dev/null) || out=""
if [ -z "$out" ]; then
    [ "$DEBUG" = 1 ] && echo "レスポンスから使用率を取り出せない (認証切れ or スキーマ変更?)" >&2
    exit 0
fi

# resets_epoch → 表示用 "MM/DD" (ローカルタイム)
epoch=$(printf '%s' "$out" | jq -r '.resets_epoch // empty')
if [ -n "$epoch" ]; then
    disp=$(date -d "@$epoch" '+%m/%d' 2>/dev/null || date -r "$epoch" '+%m/%d' 2>/dev/null || true)
    [ -n "$disp" ] && out=$(printf '%s' "$out" | jq -c --arg d "$disp" '. + {resets_display: $d}')
fi

tmp="$CACHE_FILE.tmp.$$"
printf '%s\n' "$out" > "$tmp" && mv "$tmp" "$CACHE_FILE"
[ "$DEBUG" = 1 ] && { echo "cached:" >&2; cat "$CACHE_FILE" >&2; }
exit 0
