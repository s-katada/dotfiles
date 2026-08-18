# bat の配色を theme.fish と同じ Catppuccin Mocha に揃える。
# bat は fzf.fish のプレビュー窓でも使われるので、ここを変えると fzf 側も揃う。
# 一覧は bat --list-themes で見られる。
status is-interactive; or exit
command -q bat; or exit

set -gx BAT_THEME "Catppuccin Mocha"
