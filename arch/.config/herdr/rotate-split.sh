#!/usr/bin/env bash
# herdr: アクティブペインが属するタブの分割方向をトグルする (上下 ↔ 左右)。
# config.toml の prefix+shift+r カスタムコマンドから呼ばれる。
#
# herdr には分割方向を変える組み込みアクションが無い (0.9.0 時点。swap_pane_*
# は位置交換のみ)。さらに同一タブ内への `pane move --split` は same_tab 判定で
# no-op になるため、「一時タブへ退避 → 反対方向で戻す」の2段階 move で実現する。
# ターミナルをレイアウトツリー上で付け替えるだけなので、実行中のプロセスや
# スクロールバックには影響しない。
# 2ペイン構成のタブのみ対応 (それ以外はトースト通知を出して何もしない)。

set -uo pipefail

BIN="${HERDR_BIN_PATH:-herdr}"
PANE="${HERDR_ACTIVE_PANE_ID:?HERDR_ACTIVE_PANE_ID is not set}"

layout=$("$BIN" pane layout --pane "$PANE" | jq '.result.layout') || exit 1

count=$(jq '.panes | length' <<<"$layout")
if [ "$count" != "2" ]; then
    "$BIN" notification show "rotate split" \
        --body "2ペインのタブのみ対応です (現在 ${count} ペイン)" \
        --sound none >/dev/null 2>&1 || true
    exit 0
fi

tab=$(jq -r '.tab_id' <<<"$layout")
dir=$(jq -r '.splits[0].direction' <<<"$layout")
ratio=$(jq -r '.splits[0].ratio' <<<"$layout")
focused=$(jq -r '.focused_pane_id' <<<"$layout")
# 左上のペインを基準 (移動先ターゲット) にして、もう片方を動かす。
# down→right の回転で 上→左 / 下→右 になるよう順序を保つ。
first=$(jq -r '.panes | sort_by(.rect.y, .rect.x) | .[0].pane_id' <<<"$layout")
second=$(jq -r '.panes | sort_by(.rect.y, .rect.x) | .[1].pane_id' <<<"$layout")

if [ "$dir" = "down" ]; then newdir="right"; else newdir="down"; fi

# 元々フォーカスしていたペインにフォーカスを戻す
focus_flag="--no-focus"
[ "$focused" = "$second" ] && focus_flag="--focus"

"$BIN" pane move "$second" --new-tab --no-focus >/dev/null || exit 1

if ! "$BIN" pane move "$second" --tab "$tab" --split "$newdir" \
        --target-pane "$first" --ratio "$ratio" $focus_flag >/dev/null; then
    # 戻せなかったら元の方向で復旧を試み、ペインが一時タブに取り残されるのを防ぐ
    "$BIN" pane move "$second" --tab "$tab" --split "$dir" \
        --target-pane "$first" --ratio "$ratio" $focus_flag >/dev/null 2>&1 || true
    exit 1
fi
