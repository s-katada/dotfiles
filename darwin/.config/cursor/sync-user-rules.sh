#!/usr/bin/env bash
# Cursor のローカル User Rules キャッシュ (state.vscdb) を、dotfiles の
# ~/.cursor/rules/*.mdc (alwaysApply) 本文で更新する。
# home-manager activation または手動で実行。クラウドの User Rules UI とは別系統。
set -euo pipefail

RULES_DIR="${CURSOR_RULES_DIR:-$HOME/.cursor/rules}"
DB="${CURSOR_STATE_VSCDB:-$HOME/Library/Application Support/Cursor/User/globalStorage/state.vscdb}"

if [[ ! -d "$RULES_DIR" ]]; then
  echo "skip: no $RULES_DIR" >&2
  exit 0
fi
if [[ ! -f "$DB" ]]; then
  echo "skip: no Cursor state.vscdb (IDE not installed?)" >&2
  exit 0
fi

python3 - "$RULES_DIR" "$DB" <<'PY'
import re, sqlite3, sys
from pathlib import Path

rules_dir, db = map(Path, sys.argv[1:3])
bodies = []
for path in sorted(rules_dir.glob("*.mdc")):
    text = path.read_text(encoding="utf-8")
    # strip YAML frontmatter if present
    if text.startswith("---"):
        m = re.match(r"\A---\n.*?\n---\n?", text, re.S)
        if m:
            text = text[m.end():]
    text = text.strip()
    if text:
        bodies.append(text)

merged = "\n\n".join(bodies).strip()
if not merged:
    print("skip: no rule bodies", file=sys.stderr)
    raise SystemExit(0)

con = sqlite3.connect(db)
con.execute(
    "INSERT INTO ItemTable(key, value) VALUES(?, ?) "
    "ON CONFLICT(key) DO UPDATE SET value=excluded.value",
    ("aicontext.personalContext", merged),
)
con.commit()
con.close()
print(f"synced aicontext.personalContext from {rules_dir} ({len(merged)} bytes)")
PY
