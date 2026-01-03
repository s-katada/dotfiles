# 文字コードはUTF-8
export LANG=ja_JP.UTF-8
# editor
export Editor=vim
# postgresql
export PGPASSWORD=postgres
# aliases
alias e="open -a Emacs ."
alias g="git"
alias gi="git"
alias ber="bundle exec rails"
alias be="bundle exec"
# fish config
set -g theme_color_scheme dracula
set -g theme_date_format "+[%H:%M:%S]"
set -g theme_display_git_default_branch yes
set -g theme_newline_cursor yes
# peco
bind '^R' peco-history-selection

if [ "$(uname -m)" = "arm64" ]
  eval "$(/opt/homebrew/bin/brew shellenv)"
  eval "$(/opt/homebrew/bin/mise activate fish)"
  export PATH="/opt/homebrew/opt/postgresql@17/bin:$HOME/.dotnet/tools:$PATH"
else
  eval $(/usr/local/bin/brew shellenv)
end

set -x TERM xterm-256color

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /Users/awesomemr/.lmstudio/bin
# End of LM Studio CLI section

fish_add_path $HOME/.local/bin

# Added by Antigravity
fish_add_path /Users/awesomemr/.antigravity/antigravity/bin

# zoxide(ディレクトリ移動が楽になる)
zoxide init fish | source