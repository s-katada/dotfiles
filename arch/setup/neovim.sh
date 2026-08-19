#!/usr/bin/env bash
# darwin (nix-darwin) と同じ Neovim 環境を Arch 上に作る。
#
# 設定の実体は shared/.config/nvim/ にあり、mac 側 (darwin/.config/nix/home.nix の
# linkShared) と同じファイルを見る。プラグインのバージョンも shared/.config/nvim/
# lazy-lock.json で固定されているので、`Lazy! restore` で mac と同一版が入る。
#
# 使い方:  ./neovim.sh      (パッケージのインストールで sudo を聞かれる)
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
NVIM_SRC="$DOTFILES/shared/.config/nvim"

echo "==> 1/4 パッケージのインストール"
#   neovim          本体
#   npm             mason が ts_ls / prettierd / eslint_d を入れるのに必要 (Arch では nodejs と別)
#   lazygit         snacks.nvim の <leader>gg から呼ばれる
#   ruby            ruby_lsp / rubocop を gem で入れるのに必要
#   tree-sitter-cli nvim-treesitter (main) がパーサを `tree-sitter build` でビルドする。
#                   master 系と違い C コンパイラだけでは足りず、この CLI が必須
# 既に入っているもの: git gcc make unzip curl nodejs ripgrep fd wl-clipboard python
# (クリップボードは wl-clipboard 経由。mac の pbcopy 相当で、設定側は unnamedplus のまま動く)
sudo pacman -S --needed --noconfirm neovim npm lazygit ruby tree-sitter-cli

echo "==> 2/4 設定のシンボリックリンク"
# ディレクトリごとリンクする。lazy.nvim が lazy-lock.json を書き換えるので、
# その変更がそのまま dotfiles の git diff に出る (mac 側と同じ運用)。
if [ -e "$HOME/.config/nvim" ] && [ ! -L "$HOME/.config/nvim" ]; then
  echo "    既存ディレクトリを退避: ~/.config/nvim -> ~/.config/nvim.bak"
  mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak"
fi
mkdir -p "$HOME/.config"
ln -sfn "$NVIM_SRC" "$HOME/.config/nvim"
echo "    ~/.config/nvim -> $NVIM_SRC"

echo "==> 3/4 プラグインを lazy-lock.json のバージョンで復元"
# restore なので mac と同一のコミットが入る (sync/update だと最新に上がってずれる)。
nvim --headless "+Lazy! restore" +qa

echo "==> 4/4 mason のフォーマッタ・リンタを入れる"
# LSP (ts_ls/lua_ls/ruby_lsp/rust_analyzer) は mason-lspconfig が初回ファイル
# オープン時に自動で入れる。フォーマッタ・リンタは対象外なのでここで入れておく。
nvim --headless "+MasonInstall stylua prettierd eslint_d" +qa \
  || echo "    MasonInstall が失敗。nvim を開いて :MasonInstall stylua prettierd eslint_d で入れ直せる"

# treesitter のパーサは初回 nvim 起動時に install() が裏で落としてビルドする
# (nvim-treesitter main の作法。既に入っている言語は no-op)。

cat <<'MSG'

==> 完了。`nvim` で起動すると dashboard が出る。

  初回だけ、最初にファイルを開いたところで mason が LSP を落としてくる
  (ts_ls / lua_ls / ruby_lsp / rust_analyzer)。:Mason で進捗が見える。

  確認:
    :checkhealth        構成の健全性 (クリップボード = wl-copy になっているか等)
    :Lazy               プラグインの状態。mac と同じコミットか確認できる
    :Mason              LSP・フォーマッタの状態

  treesitter のパーサは初回起動時に裏でビルドされる。状況は
    :checkhealth nvim-treesitter   で確認、手で入れ直すなら :TSInstall <lang>。

  既知の差 (mac 側も同じ):
    - rustfmt は mac 側にも無い (nix の home.packages に rust ツールチェインが無い)
      ので、rust の保存時フォーマットは両方で LSP フォールバックになる。
      欲しければ  sudo pacman -S rust  (mac は home.nix に rustup を足す)
MSG
