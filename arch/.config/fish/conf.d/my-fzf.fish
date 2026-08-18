# fzf の見た目とプレビュー設定。
#
# ファイル名を fzf.fish にしないこと: PatrickF1/fzf.fish プラグイン自身が
# conf.d/fzf.fish を置くため上書きされる。また conf.d はファイル名の辞書順に
# 読まれるので "my-" 始まりならプラグイン本体より後に読まれ、上書きが効く。
status is-interactive; or exit

# 配色は conf.d/theme.fish と同じ Catppuccin Mocha。プロンプト・補完メニュー・fzf を揃える。
set -gx FZF_DEFAULT_OPTS "\
--height=60% --layout=reverse --border --info=inline \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a"

# fzf.fish のプレビュー窓（既定の cat より読みやすい）
set -gx fzf_preview_file_cmd "bat --style=numbers --color=always"
set -gx fzf_preview_dir_cmd "ls -A --color=always" # eza を入れたら eza --all --color=always に

# キーバインドは fzf.fish の既定のまま（macOS 側と同じ）:
#   Ctrl+R 履歴 / Ctrl+Alt+F ファイル / Ctrl+Alt+L git log
#   Ctrl+Alt+S git status / Ctrl+Alt+P プロセス / Ctrl+V 変数
# 変えたい場合はここで上書きする。fish 4 のキー名構文を使う:
#   fzf_configure_bindings --variables=ctrl-alt-v
# 無効化は値を空にする:
#   fzf_configure_bindings --processes=

# Ctrl+V の変数検索を無効化する。ターミナルの貼り付け操作と紛らわしいため。
# 値を空にすると、そのバインドだけ設定されない（他は既定のまま）。
fzf_configure_bindings --variables=
