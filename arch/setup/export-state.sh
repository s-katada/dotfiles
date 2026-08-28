#!/usr/bin/env bash
# 現行の Arch マシンから「設定ファイルに現れない状態」を吸い出して arch/state/ に書き出す。
#
# dotfiles には設定ファイルしか入っていないため、新しいマシンで同じ環境を作ろうとすると
#   - どのパッケージが入っていたか (特に AUR)
#   - どの systemd ユニットが enable されていたか
#   - dconf/gsettings に何を書いたか (Nautilus や GTK の設定はファイルに出ない)
# が判らず詰む。これらは「今動いているマシン」からしか取り出せないので、
# マシンを消す前にこのスクリプトを流して結果をコミットしておく。
#
# 使い方:  ./export-state.sh        (sudo 不要。読み取りしかしない)
#          git add -A arch/state && git commit && git push
#
# 出力先: arch/state/
#   pacman-explicit.txt  明示的に入れたパッケージ全部 (依存で入っただけのものは含まない)
#   pacman-native.txt    そのうち公式リポジトリのもの   -> pacman -S で入る
#   pacman-aur.txt       そのうちリポジトリに無いもの   -> AUR ヘルパで入れる
#   systemd-system.txt   enable されている system ユニット
#   systemd-user.txt     enable されている user ユニット
#   dconf/*.ini          GTK/Nautilus 系の設定 (ファイルに出ず dconf にしか無いもの)
#   system-info.md       ロケール・タイムゾーン・GPU・DM・壁紙など、人が読む用のメモ
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
OUT="$DOTFILES/arch/state"

if ! command -v pacman >/dev/null 2>&1; then
  echo "pacman がありません。これは Arch マシン上で実行してください。" >&2
  exit 1
fi

mkdir -p "$OUT"

echo "==> 1/5 パッケージ一覧"
# -e = explicit (自分で入れたもの)。-d の依存パッケージは新マシンでも自動で入るので除く。
# -n = native (公式リポジトリ), -m = foreign (AUR や手動ビルド)。
pacman -Qqe >"$OUT/pacman-explicit.txt"
pacman -Qqen >"$OUT/pacman-native.txt"
pacman -Qqem >"$OUT/pacman-aur.txt"
echo "    explicit $(wc -l <"$OUT/pacman-explicit.txt") / native $(wc -l <"$OUT/pacman-native.txt") / AUR $(wc -l <"$OUT/pacman-aur.txt")"

echo "==> 2/5 systemd の enable 状態"
# --state=enabled だけだと static/indirect が混ざらないので、これで「自分で enable した
# もの」がほぼそのまま出る。generated (xdg autostart 由来) は新マシンでも自動生成される。
systemctl list-unit-files --state=enabled --no-legend --no-pager 2>/dev/null \
  | awk '{print $1}' | sort >"$OUT/systemd-system.txt" || : >"$OUT/systemd-system.txt"
systemctl --user list-unit-files --state=enabled --no-legend --no-pager 2>/dev/null \
  | awk '{print $1}' | sort >"$OUT/systemd-user.txt" || : >"$OUT/systemd-user.txt"
echo "    system $(wc -l <"$OUT/systemd-system.txt") / user $(wc -l <"$OUT/systemd-user.txt")"

echo "==> 3/5 dconf のダンプ"
# Nautilus の表示設定・アイコンテーマ・color-scheme などはファイルに出ず dconf にしか無い。
#
# ここは `dconf dump /` を丸ごと入れない。このリポジトリは公開なのに対し、dconf には
# 最近開いたファイルのパス・プリンタ名・アカウント名など、設定とは言えないものが混ざる。
# デスクトップの見た目とファイラの挙動に効くサブツリーだけを取り、全体のダンプは
# リポジトリ外に置いて目視用にする。
DCONF_PATHS=(
  /org/gnome/desktop/interface/          # color-scheme / icon-theme / フォント
  /org/gnome/desktop/wm/preferences/     # ボタン配置など (GTK アプリのタイトルバー)
  /org/gnome/nautilus/                   # 一覧表示・列・クリック挙動
  /org/gtk/settings/file-chooser/        # GTK3 のファイル選択ダイアログ
  /org/gtk/gtk4/settings/file-chooser/   # GTK4 のファイル選択ダイアログ
  /com/github/stunkymonkey/nautilus-open-any-terminal/
)
if command -v dconf >/dev/null 2>&1; then
  # dconf dump の出力は「指定したパスからの相対」なので、複数パス分を 1 ファイルに
  # 混ぜると dconf load で戻せなくなる。パスごとに 1 ファイルにして、ファイル名に
  # 戻し先のパスを持たせる (/ を - に置換)。復元は bootstrap 側でループする。
  rm -rf "$OUT/dconf"
  mkdir -p "$OUT/dconf"
  for p in "${DCONF_PATHS[@]}"; do
    body="$(dconf dump "$p" 2>/dev/null || true)"
    [ -n "$body" ] || continue
    name="$(echo "${p#/}" | sed 's|/$||; s|/|-|g')"
    printf '%s' "$body" >"$OUT/dconf/${name}.ini"
    echo "    $p -> dconf/${name}.ini"
  done
  full="${TMPDIR:-/tmp}/dconf-full-${USER:-user}.ini"
  dconf dump / >"$full" 2>/dev/null || true
  echo "    全体のダンプ: $full (リポジトリ外。目で見て足したいパスがあれば DCONF_PATHS に追加)"
else
  echo "    dconf が無いのでスキップ"
fi

echo "==> 4/5 システム情報のメモ"
# 新マシンの archinstall / 初期設定で同じ選択をするための覚書。機械的に流すものではない。
{
  echo "# Arch マシンの状態メモ"
  echo
  echo "arch/setup/export-state.sh が生成。新マシンの初期設定で同じ選択をするための覚書。"
  echo
  echo '## 基本'
  echo '```'
  echo "hostname : $(cat /etc/hostname 2>/dev/null || echo unknown)"
  echo "kernel   : $(uname -r)"
  echo "timezone : $(timedatectl show -p Timezone --value 2>/dev/null || echo unknown)"
  echo "locale   : $(grep -h . /etc/locale.conf 2>/dev/null | tr '\n' ' ')"
  echo "shell    : ${SHELL:-unknown}"
  echo "AUR      : $(command -v paru >/dev/null && echo paru || { command -v yay >/dev/null && echo yay || echo '(ヘルパ未検出)'; })"
  echo '```'
  echo
  echo '## 有効なロケール (/etc/locale.gen)'
  echo '```'
  grep -v '^#' /etc/locale.gen 2>/dev/null | grep . || echo '(取得できず)'
  echo '```'
  echo
  echo '## グラフィック'
  echo '```'
  lspci -k 2>/dev/null | grep -A3 -iE 'vga|3d controller' || echo '(lspci なし)'
  echo '```'
  echo
  echo '## ディスプレイマネージャ / セッション'
  echo '```'
  echo "display-manager -> $(readlink -f /etc/systemd/system/display-manager.service 2>/dev/null || echo '(未設定)')"
  echo '```'
  echo
  echo '## 壁紙'
  echo 'awww は自分のキャッシュから前回の壁紙を復元するため、画像の実体は dotfiles に無い。'
  echo '新マシンへ手で持っていくこと。'
  echo '```'
  ls -1 "$HOME/Pictures/Wallpapers" 2>/dev/null || echo '(~/Pictures/Wallpapers が無い)'
  echo '```'
  echo
  echo '## 手で確認すること'
  echo '- SSH 秘密鍵 (~/.ssh)、gh auth login、1Password などのサインイン'
  echo '- Chrome / Thunderbird のプロファイル (アカウント設定は dotfiles に含まれない)'
  echo '- mozc の学習データは意図的に追跡していない (arch/.config/mozc/*.db は config1.db のみ)'
} >"$OUT/system-info.md"

echo "==> 5/5 完了"
cat <<MSG

  書き出し先: $OUT

  このリポジトリは公開なので、コミット前に中身をざっと確認してください
  (AUR 一覧に手元でビルドしただけのものが混ざっていないか、dconf/*.ini に
   見られたくない値が無いか):

    git -C "$DOTFILES" add -A arch/state
    git -C "$DOTFILES" diff --cached
    git -C "$DOTFILES" commit -m "chore: arch のパッケージ・systemd・dconf の状態を記録する"
    git -C "$DOTFILES" push origin main

  これがあれば新マシン側は
    pacman -S --needed - < arch/state/pacman-native.txt
    paru   -S --needed - < arch/state/pacman-aur.txt
    dconf load /org/gnome/nautilus/ < arch/state/dconf/org-gnome-nautilus.ini
  で戻せます (実際の手順は arch/bootstrap.sh に組み込む予定)。
MSG
