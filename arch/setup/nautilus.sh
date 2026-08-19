#!/usr/bin/env bash
# macOS の Finder 相当として Nautilus (GNOME Files) を入れて設定する。
#
#   nautilus          ... ファイラ本体 (GTK4 / Wayland ネイティブ)
#   sushi             ... Space キーでのプレビュー = Quick Look 相当
#   ffmpegthumbnailer ... 動画のサムネイル生成
#   udisks2           ... USB メモリ等をサイドバーに出してマウントする
#
# GNOME デスクトップ環境そのものは入らない (gnome-shell / mutter / gnome-session は無し)。
# GTK4 / libadwaita / gvfs は regreet や waybar の依存として既に入っているので、
# 実際に追加されるのは上の 4 つだけ。GTK4 アプリなので Wayland ネイティブに動く。
#
# 見た目 (ライトテーマ) とサイドバーのお気に入りは dotfiles 側のファイルで管理し、
# それ以外の Nautilus の設定は dconf にしか置けないのでこのスクリプトで流し込む。
#
# 使い方:  ./nautilus.sh      (パッケージのインストールで sudo を聞かれる)
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
ARCH_DIR="$DOTFILES/arch"

echo "==> 1/3 パッケージのインストール"
# 追加で欲しくなったら: gvfs-mtp (Android 実機), gvfs-smb (Windows 共有), gvfs-google
sudo pacman -S --needed --noconfirm nautilus sushi ffmpegthumbnailer udisks2

echo "==> 2/3 設定ファイルのシンボリックリンク"
# このリポジトリは「ファイル単位で ~/.config へ symlink」方式なので、それに合わせる。
link() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    echo "    既存ファイルを退避: $dst -> $dst.bak"
    mv "$dst" "$dst.bak"
  fi
  ln -sfn "$src" "$dst"
  echo "    $dst -> $src"
}
link "$ARCH_DIR/.config/gtk-3.0/settings.ini" "$HOME/.config/gtk-3.0/settings.ini"
link "$ARCH_DIR/.config/gtk-4.0/settings.ini" "$HOME/.config/gtk-4.0/settings.ini"
# サイドバーのお気に入り。GTK4 アプリも参照先はこの gtk-3.0 のファイル。
link "$ARCH_DIR/.config/gtk-3.0/bookmarks" "$HOME/.config/gtk-3.0/bookmarks"

echo "==> 3/3 dconf の設定"
# Nautilus のバージョンでキーが増減するため、存在するものだけ設定する。
set_key() {
  local schema="$1" key="$2" value="$3"
  if gsettings list-keys "$schema" 2>/dev/null | grep -qx "$key"; then
    gsettings set "$schema" "$key" "$value"
    echo "    $schema $key = $value"
  else
    echo "    skip (キーが無い): $schema $key"
  fi
}

# アプリ全体をライトに。xdg-desktop-portal-gtk がこの値を
# org.freedesktop.appearance color-scheme として公開するので、
# Electron / Chromium 系 (Cursor 等) の "システムに従う" もこれに従う。
set_key org.gnome.desktop.interface color-scheme "'prefer-light'"

# Finder に寄せる:
#   一覧表示 + フォルダを三角で展開 = Finder のリスト表示
set_key org.gnome.nautilus.preferences default-folder-viewer "'list-view'"
set_key org.gnome.nautilus.list-view use-tree-view "true"
set_key org.gnome.nautilus.list-view default-visible-columns \
  "['name', 'size', 'type', 'date_modified']"
set_key org.gnome.nautilus.list-view default-column-order \
  "['name', 'size', 'type', 'date_modified']"
#   ダブルクリックで開く (Finder と同じ)
set_key org.gnome.nautilus.preferences click-policy "'double'"
#   サムネイルは常に出す
set_key org.gnome.nautilus.preferences show-image-thumbnails "'always'"
#   Shift+Delete で完全削除を出す
set_key org.gnome.nautilus.preferences show-delete-permanently "true"
#   フォルダを先に並べる
set_key org.gtk.gtk4.Settings.FileChooser sort-directories-first "true"

cat <<'MSG'

==> 完了。

  起動:      Mod+Alt+Space (niri のキーバインド) / vicinae から "Files"
  プレビュー: ファイルを選んで Space (sushi)
  隠しファイル: Ctrl+H
  新しいタブ: Ctrl+T   パスを直接入力: Ctrl+L

  サイドバーのお気に入りを増やしたら、~/.config/gtk-3.0/bookmarks は dotfiles への
  symlink なので、そのまま git diff に出る。

  やりたくなったら:
    - Nautilus から ghostty を開く:  paru -S nautilus-open-any-terminal
        gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal ghostty
    - Android 実機や Windows 共有を見る:  sudo pacman -S gvfs-mtp gvfs-smb
    - ウィンドウのボタンを macOS と同じ左寄せにする (GTK アプリ全部に効く):
        ~/.config/gtk-{3,4}.0/settings.ini に
        gtk-decoration-layout=close,minimize,maximize:
MSG
