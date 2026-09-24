#!/usr/bin/env bash
# plugins.list に書かれた herdr プラグインをインストールする。
# 使い方: bash ~/.config/herdr/install-plugins.sh
set -euo pipefail

root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
list=$root/plugins.list
bin=${HERDR_BIN_PATH:-herdr}

if ! command -v "$bin" >/dev/null 2>&1 && [[ $bin == herdr ]]; then
  echo "herdr not found on PATH" >&2
  exit 1
fi

if [[ ! -f $list ]]; then
  echo "missing $list" >&2
  exit 1
fi

while IFS= read -r line || [[ -n $line ]]; do
  # trim / skip comments and blanks
  line=${line%%#*}
  line=$(printf '%s' "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
  [[ -z $line ]] && continue
  echo "→ herdr plugin install $line"
  "$bin" plugin install "$line" --yes
done <"$list"

echo "done. plugin configs (if any) live under $root/plugins/config/"
