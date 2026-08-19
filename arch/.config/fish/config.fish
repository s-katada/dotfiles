if status is-interactive
    # Commands to run in interactive sessions can go here
end
set -g fish_greeting
# エディタ。-x を付けて環境変数として書き出すのが要点。
# set -g だけだと fish 内の変数にしかならず子プロセスに渡らないため、$EDITOR を
# 見るツールが軒並みフォールバックしてしまう。実例: yazi は Enter でファイルを
# 開くとき ${EDITOR:-vi} を実行するので、EDITOR が渡らないと vi を探し、
# この環境には vi が無いので「status code: 127」で失敗していた。
# vim ではなく nvim を使う (arch/setup/neovim.sh で設定している方)。
set -gx EDITOR nvim
set -gx VISUAL nvim
