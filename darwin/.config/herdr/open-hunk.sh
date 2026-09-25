#!/usr/bin/env bash
# herdr: アクティブペインの右に分割して hunk (side-by-side) を開く。
# config.toml の prefix+shift+v から呼ばれる。
#
# reviewr と違い hunk は herdr プラグインではないので、pane split → pane run で再現する。

set -euo pipefail

BIN="${HERDR_BIN_PATH:-herdr}"
PANE="${HERDR_ACTIVE_PANE_ID:?HERDR_ACTIVE_PANE_ID is not set}"
CWD="${HERDR_ACTIVE_PANE_CWD:-$PWD}"

if ! command -v hunk >/dev/null 2>&1; then
  "$BIN" notification show "hunk" \
    --body "hunk が PATH にありません" \
    --sound none >/dev/null 2>&1 || true
  exit 0
fi

# 右に分割して新ペインにフォーカス（等分プラグインが入っていれば直後に揃う）
out=$("$BIN" pane split --pane "$PANE" --direction right --cwd "$CWD" --focus --ratio 0.5)
new_id=$(printf '%s\n' "$out" | jq -r '.result.pane.pane_id // .result.pane_id // empty')

if [[ -z $new_id || $new_id == null ]]; then
  "$BIN" notification show "hunk" \
    --body "ペイン分割に失敗しました" \
    --sound none >/dev/null 2>&1 || true
  printf '%s\n' "$out" >&2
  exit 1
fi

# 作業ツリーの side-by-side。引数を足したければこのスクリプトを編集。
"$BIN" pane run "$new_id" "hunk diff --mode split"
