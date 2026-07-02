#!/usr/bin/env bash
# herdr に sticky prefix パッチ (patches/sticky-prefix.patch) を当てて
# ビルドし、brew の Cellar 内バイナリを差し替える。
#
# 使い方:   bash ~/.config/herdr/build-patched.sh
# 反映:     herdr server stop してから herdr を起動し直す
# 戻し方:   brew unpin herdr && brew reinstall herdr
#
# パッチは HERDR_VERSION のソースに対して書かれている。brew が別バージョンに
# 上がったらパッチの再調整が必要 (適用に失敗したらこのスクリプトは止まる)。
set -euo pipefail

HERDR_VERSION="0.7.1"
PATCH_FILE="$(cd "$(dirname "$0")" && pwd)/patches/sticky-prefix.patch"
TARBALL_URL="https://github.com/ogulcancelik/herdr/archive/refs/tags/v${HERDR_VERSION}.tar.gz"
WORK_DIR="$(mktemp -d /tmp/herdr-sticky-build.XXXXXX)"
trap 'rm -rf "$WORK_DIR"' EXIT

installed_version="$(brew list --versions herdr | awk '{print $2}')"
if [[ "$installed_version" != "$HERDR_VERSION" ]]; then
  echo "error: brew の herdr は ${installed_version} だがパッチは ${HERDR_VERSION} 用。" >&2
  echo "       HERDR_VERSION とパッチを新バージョンに合わせて更新すること。" >&2
  exit 1
fi

command -v cargo >/dev/null || { echo "error: cargo がない (rustup を入れる)" >&2; exit 1; }
if [[ ! -x /opt/homebrew/opt/zig@0.15/bin/zig ]]; then
  echo "zig@0.15 がないので brew でインストールする"
  brew install zig@0.15
fi

# nix プロファイルの GNU libtool / gcc が Apple のツールを横取りして
# vendored libghostty-vt のビルドとリンクを壊すため、/usr/bin 側を優先させる
mkdir -p "$WORK_DIR/shim"
ln -sf /usr/bin/libtool "$WORK_DIR/shim/libtool"
ln -sf /usr/bin/cc "$WORK_DIR/shim/cc"
ln -sf /usr/bin/c++ "$WORK_DIR/shim/c++"
export PATH="$WORK_DIR/shim:/opt/homebrew/opt/zig@0.15/bin:$HOME/.cargo/bin:$PATH"

echo "==> ソース取得 v${HERDR_VERSION}"
curl -fsSL "$TARBALL_URL" | tar xz -C "$WORK_DIR"
cd "$WORK_DIR/herdr-${HERDR_VERSION}"

echo "==> パッチ適用"
patch -p1 --forward <"$PATCH_FILE"

echo "==> ビルド (数分かかる)"
cargo build --release

CELLAR_BIN="/opt/homebrew/Cellar/herdr/${HERDR_VERSION}/bin/herdr"
if [[ ! -f "${CELLAR_BIN}.orig" ]]; then
  cp "$CELLAR_BIN" "${CELLAR_BIN}.orig"
fi
# brew のバイナリは読み取り専用 (r-xr-xr-x) なので上書きでなく削除→配置
rm -f "$CELLAR_BIN"
cp target/release/herdr "$CELLAR_BIN"
chmod 555 "$CELLAR_BIN"
brew pin herdr >/dev/null

echo "==> 完了: $CELLAR_BIN を差し替えた (元は herdr.orig)"
echo "    brew pin 済みなので brew upgrade では上書きされない"
"$CELLAR_BIN" --version
echo "    反映するにはサーバーを再起動: herdr server stop → herdr"
