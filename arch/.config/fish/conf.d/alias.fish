# darwin (home.nix の programs.fish.shellAliases) と同じ alias 定義。
# darwin 側は home-manager が conf.d に生成するのに対し、arch は手書きのこのファイルで揃える。
# 略語の abbr (abbr.fish) と違い、alias は履歴にそのまま残したい短縮コマンド用。
status is-interactive; or exit

alias g 'git'
alias gi 'git'
alias be 'bundle exec'
alias ber 'bundle exec rails'

# e: カレントディレクトリを Emacs で開く (darwin では `open -a Emacs .`)。
# arch にはまだ emacs を入れていないので、存在するときだけ定義する。
if command -q emacs
    alias e 'emacs .'
end
