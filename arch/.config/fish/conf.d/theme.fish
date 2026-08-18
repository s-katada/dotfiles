# Catppuccin Mocha 系の配色。プロンプトとコマンドラインの色を揃えている。
# ここは -g (グローバル) で設定しているので、消せば fish 標準色に戻る。
set -g fish_color_normal cdd6f4
set -g fish_color_command 89b4fa          # コマンド名
set -g fish_color_keyword f38ba8          # if / for などのキーワード
set -g fish_color_quote a6e3a1            # 文字列
set -g fish_color_redirection f5c2e7      # > や |
set -g fish_color_end fab387              # ; や &
set -g fish_color_error f38ba8            # 存在しないコマンド（入力中に赤くなる）
set -g fish_color_param cdd6f4
set -g fish_color_option f9e2af
set -g fish_color_comment 6c7086
set -g fish_color_operator f5c2e7
set -g fish_color_escape eba0ac
set -g fish_color_autosuggestion 585b70   # 履歴からの補完候補（薄いグレー）
set -g fish_color_cwd 89b4fa
set -g fish_color_valid_path --underline
set -g fish_color_selection --background=45475a
set -g fish_color_search_match --background=45475a

# 補完メニュー（Tab を押したときの一覧）
set -g fish_pager_color_progress 6c7086
set -g fish_pager_color_prefix f5c2e7 --bold
set -g fish_pager_color_completion cdd6f4
set -g fish_pager_color_description 6c7086
set -g fish_pager_color_selected_background --background=45475a
