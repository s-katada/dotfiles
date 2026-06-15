#!/usr/bin/env bash
# 新しい Apple Silicon Mac 用ブートストラップ（まっさらな macOS が前提）。
#
# これは「スクリプト化できる前準備」だけを自動化する。完全な 1 コマンドは macOS の
# 仕様上不可能で、この後に sudo を伴う nix-darwin switch を 1 回 + GUI での権限承認が残る。
#
# 流れ:  [このスクリプト: Xcode CLT / Nix / Rosetta / Homebrew / clone]
#        -> [sudo nix-darwin switch を 1 回]  -> [GUI 権限承認チェックリスト]
set -euo pipefail

REPO_SSH="git@github.com:s-katada/dotfiles.git"
REPO_HTTPS="https://github.com/s-katada/dotfiles.git"
REPO_DIR="${HOME}/dotfiles"
FLAKE="${REPO_DIR}/darwin/.config/nix#s-katada-private"

echo "==> 1/6 Xcode Command Line Tools (git に必要)"
if ! xcode-select -p >/dev/null 2>&1; then
  xcode-select --install || true
  echo "    GUI のインストールが終わるまで待機します..."
  until xcode-select -p >/dev/null 2>&1; do sleep 10; done
fi

echo "==> 2/6 Determinate Nix"
if ! command -v nix >/dev/null 2>&1; then
  cat <<'MSG'
    macOS 公式は GUI の .pkg インストーラです。先にこれを入れ、シェルを開き直して再実行してください:
      https://install.determinate.systems/determinate-pkg/stable/Universal
    （CLI で済ませたい場合のみ、非公式ですが次でも可:
       curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --determinate ）
MSG
  exit 1
fi

echo "==> 3/6 Rosetta 2 (x86 cask 用: teamviewer/android-studio 等)"
softwareupdate --install-rosetta --agree-to-license || true

echo "==> 4/6 Homebrew (nix-darwin は brew 本体を入れない)"
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"  # 同一シェルで brew を PATH に（初回 switch 前に必須）

echo "==> 5/6 リポジトリの clone"
if [ ! -d "${REPO_DIR}/.git" ]; then
  git clone "${REPO_SSH}" "${REPO_DIR}" || git clone "${REPO_HTTPS}" "${REPO_DIR}"
fi

echo "==> 6/6 初回 nix-darwin switch"
echo "    ※ masApps を入れるには先に App Store.app へ Apple ID でサインインしてください。"
read -r -p "    サインイン済みなら Enter（未サインインだと masApps で switch が失敗する場合あり）: " _ || true
# darwin-rebuild はまだ存在しないので nix run で起動。experimental-features を明示。
sudo nix run --extra-experimental-features 'nix-command flakes' \
  nix-darwin/master#darwin-rebuild -- switch --flake "${FLAKE}"

cat <<'EOF'

==> 完了。残りは GUI でしかできない手作業です:
  - 各アプリを一度起動して権限を承認:
      Accessibility / Input Monitoring (Karabiner / Aerospace / Homerow / Raycast),
      Screen Recording (Shottr)
  - Karabiner: 設定 > 一般 > ログイン項目と機能拡張 でドライバ機能拡張を Allow -> 再起動
  - サインイン: iCloud / 1Password (+SSH agent) / Tailscale / Google Drive / 各アプリ
  - SSH 秘密鍵を ~/.ssh に配置 (chmod 600)、gh auth login
  - 2 回目以降のリビルド:
      sudo darwin-rebuild switch --flake ~/dotfiles/darwin/.config/nix#s-katada-private
  - 初回や再起動後に "Unexpected files in /etc, aborting" が出たら、該当ファイルを
      sudo mv /etc/<file> /etc/<file>.before-nix-darwin
    で退避して再実行（/etc/bashrc /etc/zshrc /etc/zshenv /etc/shells 等。再起動後に再発しうる）
EOF
