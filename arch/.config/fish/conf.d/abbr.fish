# abbr（abbreviation）= 入力確定時に本来のコマンドへ展開される略語。
# alias と違い履歴に展開後が残るので、後から履歴を読み返して意味が分かる。
# 使い方: 略語を打って Space か Enter を押すと展開される。
status is-interactive; or exit

# git
abbr -a gs 'git status -sb'
abbr -a gd 'git diff'
abbr -a ga 'git add'
abbr -a gc 'git commit'
abbr -a gp 'git push'
abbr -a gl 'git log --oneline --graph --decorate -20'

# ディレクトリ移動
abbr -a .. 'cd ..'
abbr -a ... 'cd ../..'

# Arch のパッケージ管理（paru = pacman + AUR）
abbr -a syu 'paru -Syu'
abbr -a pss 'paru -Ss'
abbr -a pqi 'paru -Qi'
