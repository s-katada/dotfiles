#!/usr/bin/env bash
# ログイン画面 (ディスプレイマネージャ) を sddm から greetd + regreet に切り替える。
#
#   greetd  ... 認証してセッションを起動する DM 本体
#   cage    ... regreet を全画面表示するためだけの最小 Wayland コンポジタ
#   regreet ... GTK4 のグリーター UI (この配下の regreet.toml / regreet.css で見た目を決める)
#
# /etc 配下は root 所有かつ greeter ユーザーから読める必要があるため、~/.config のように
# dotfiles へのシンボリックリンクにはせず、このスクリプトでコピーして配る。
#
# 使い方:  sudo ./deploy.sh [壁紙のパス]
# 元に戻す: sudo systemctl disable greetd && sudo systemctl enable sddm && reboot
set -euo pipefail

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# 壁紙の既定値は sudo 実行者のホームから解決する (ユーザー名を焼き込まない)。
USER_HOME="$(getent passwd "${SUDO_USER:-$USER}" | cut -d: -f6)"
WALLPAPER="${1:-$USER_HOME/Pictures/Wallpapers/wallhaven-v9r97m.jpg}"
BACKGROUND=/usr/share/backgrounds/greeter.png

if [ "$(id -u)" -ne 0 ]; then
  echo "root で実行してください: sudo $0" >&2
  exit 1
fi

echo "==> 1/5 パッケージの確認"
pacman -Qq greetd greetd-regreet cage >/dev/null

echo "==> 2/5 設定ファイルを /etc/greetd/ へ配置"
install -Dm644 "$SRC_DIR/config.toml"  /etc/greetd/config.toml
install -Dm644 "$SRC_DIR/regreet.toml" /etc/greetd/regreet.toml
install -Dm644 "$SRC_DIR/regreet.css"  /etc/greetd/regreet.css

echo "==> 3/5 背景画像を生成 ($BACKGROUND)"
# greeter ユーザーはユーザーのホーム (700) を読めないので、壁紙は /usr/share へコピーする。
# そのついでに ffmpeg でぼかして暗く焼き、フォームの文字が壁紙に埋もれないようにする。
if [ -r "$WALLPAPER" ]; then
  if command -v ffmpeg >/dev/null; then
    ffmpeg -y -loglevel error -i "$WALLPAPER" \
      -vf "format=rgb24,gblur=sigma=8,colorchannelmixer=rr=0.55:gg=0.55:bb=0.58,format=rgb24" \
      "$BACKGROUND"
  else
    echo "    ffmpeg が無いので加工せずコピーします"
    install -Dm644 "$WALLPAPER" "$BACKGROUND"
  fi
  chmod 644 "$BACKGROUND"
else
  echo "    壁紙 $WALLPAPER が読めないので背景はスキップ (単色の背景になります)"
fi

echo "==> 4/5 regreet の状態ディレクトリを作成"
systemd-tmpfiles --create /usr/lib/tmpfiles.d/regreet.conf

echo "==> 5/5 DM を greetd へ切り替え"
# display-manager.service のエイリアスが競合するので、sddm が居れば先に無効化する。
# 新規マシンには sddm 自体が入っていないので、無くても止まらないようにしておく。
systemctl disable sddm 2>/dev/null || true
systemctl enable greetd

cat <<'MSG'

==> 完了。再起動すると新しいログイン画面になります。

  動かなかったときは Ctrl+Alt+F2 で tty に切り替えてログインし、
    sudo systemctl disable greetd && sudo systemctl enable sddm && sudo reboot
  で sddm に戻せます (sddm はアンインストールしていません)。

  見た目を直すとき: dotfiles 側の arch/etc/greetd/regreet.{toml,css} を編集して
    regreet --demo -c arch/etc/greetd/regreet.toml -s arch/etc/greetd/regreet.css
  でその場で確認 -> sudo ./deploy.sh で反映。
MSG
