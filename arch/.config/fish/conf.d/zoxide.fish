# zoxide: 訪問履歴を学習する「賢い cd」。
#   z <ディレクトリ名の一部>  … よく行く場所へ一発で移動
#   zi                        … fzf で候補から選んで移動
# init が生成する関数を毎回読み込む。非対話シェルでは不要なので抜ける。
status is-interactive; or exit
command -q zoxide; or exit # 未導入の環境でエラーを出さない

zoxide init fish | source
