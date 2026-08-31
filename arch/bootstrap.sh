#!/usr/bin/env bash
# 新しい Arch マシンに dotfiles の設定と記録済みパッケージを復元する。
# arch/setup/export-state.sh (書き出し側) と対になる読み込み側。
#
# やること:
#   1. arch/state/ のパッケージ一覧をインストール (pacman、paru があれば AUR も)
#   2. arch/.config/* を ~/.config/ へ symlink (エントリ単位)
#   3. arch/.local/ のスクリプトと .desktop を ~/.local/ へ symlink (ファイル単位)
#   4. arch/state/dconf/*.ini があれば dconf load
#   5. スクリーンショット等のディレクトリ作成
#
# やらないこと (マシン依存なので別途 1 回だけ手動):
#   - GPU ドライバ / フォント (最後に案内を出す)
#   - ログイン画面: sudo ./arch/etc/greetd/deploy.sh
#   - herdr / niriswitcher-patched / bambu-gtkinit のビルド
#
# 何度実行しても安全: 既に正しい symlink なら何もせず、別の実体があれば
# 上書きせず警告だけ出す。~/.config 自体は実ディレクトリのまま維持する
# (丸ごと 1 本の symlink (fold) は home-manager 移行事故 (issue #2) の原因なのでやらない)。
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ARCH_DIR="$DOTFILES/arch"
STATE="$ARCH_DIR/state"

command -v pacman >/dev/null 2>&1 || { echo "pacman がありません。Arch マシン上で実行してください。" >&2; exit 1; }

link() { # link <リポジトリ側の実体> <ホーム側に作るリンク>
  local src=$1 dst=$2
  if [ -L "$dst" ]; then
    [ "$(readlink "$dst")" = "$src" ] && return 0
    echo "    WARN: $dst は別を指す symlink ($(readlink "$dst"))。手で確認してください" >&2
    return 0
  fi
  if [ -e "$dst" ]; then
    echo "    WARN: $dst に実体があるため触りません。取り込むか消すかしてから再実行を" >&2
    return 0
  fi
  mkdir -p "$(dirname "$dst")"
  ln -s "$src" "$dst"
  echo "    link: $dst -> $src"
}

echo "==> 1/5 公式パッケージ (arch/state/pacman-native.txt)"
if [ -s "$STATE/pacman-native.txt" ]; then
  sudo pacman -S --needed - <"$STATE/pacman-native.txt"
else
  echo "    一覧が無いのでスキップ"
fi

echo "==> 2/5 AUR パッケージ (arch/state/pacman-aur.txt)"
if [ -s "$STATE/pacman-aur.txt" ]; then
  if command -v paru >/dev/null 2>&1; then
    paru -S --needed - <"$STATE/pacman-aur.txt"
  else
    echo "    paru が無いのでスキップ。入れてから再実行してください:" >&2
    echo "      sudo pacman -S --needed base-devel && git clone https://aur.archlinux.org/paru.git && (cd paru && makepkg -si)" >&2
  fi
else
  echo "    一覧が無い (または空) のでスキップ"
fi

echo "==> 3/5 ~/.config へ symlink"
for src in "$ARCH_DIR/.config"/*; do
  [ -e "$src" ] || continue
  link "$src" "$HOME/.config/$(basename "$src")"
done

echo "==> 4/5 ~/.local へ symlink"
for src in "$ARCH_DIR/.local/bin"/*; do
  [ -e "$src" ] || continue
  link "$src" "$HOME/.local/bin/$(basename "$src")"
done
for src in "$ARCH_DIR/.local/share/applications"/*; do
  [ -e "$src" ] || continue
  link "$src" "$HOME/.local/share/applications/$(basename "$src")"
done

echo "==> 5/5 dconf の復元とディレクトリ作成"
# export-state.sh の DCONF_PATHS と対で管理する。ファイル名はパスの / を - に
# 置換したものだが、'nautilus-open-any-terminal' のように - を含むセグメントが
# あるため逆変換はできない。パスはここに明示的に列挙する。
DCONF_PATHS=(
  /org/gnome/desktop/interface/
  /org/gnome/desktop/wm/preferences/
  /org/gnome/nautilus/
  /org/gtk/settings/file-chooser/
  /org/gtk/gtk4/settings/file-chooser/
  /com/github/stunkymonkey/nautilus-open-any-terminal/
)
if command -v dconf >/dev/null 2>&1 && [ -d "$STATE/dconf" ]; then
  for p in "${DCONF_PATHS[@]}"; do
    name="$(echo "${p#/}" | sed 's|/$||; s|/|-|g')"
    ini="$STATE/dconf/${name}.ini"
    [ -r "$ini" ] || continue
    dconf load "$p" <"$ini"
    echo "    dconf load $p"
  done
else
  echo "    dconf か arch/state/dconf/ が無いのでスキップ"
fi
mkdir -p "$HOME/Pictures/Screenshots" "$HOME/Pictures/Wallpapers"

cat <<'MSG'

==> 完了。別途手動でやるもの (初回のみ):
  - GPU ドライバ:  sudo pacman -S nvidia-open nvidia-utils egl-wayland   # NVIDIA (RTX 50 系は open 必須)
                   sudo pacman -S mesa                                    # AMD / Intel はこちら
  - フォント:      sudo pacman -S noto-fonts noto-fonts-cjk noto-fonts-emoji ttf-nerd-fonts-symbols otf-font-awesome
  - ログイン画面:  sudo ./arch/etc/greetd/deploy.sh  (greetd greetd-regreet cage papirus-icon-theme を入れてから)
  - 状態の記録:    ./arch/setup/export-state.sh -> git add -A arch/state && commit & push
MSG
