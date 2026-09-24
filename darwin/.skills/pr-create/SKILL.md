---
name: pr-create
description: Create a pull request with gh, filling the repository's PR template (or this skill's bundled template) section by section. Use whenever the user asks to open, create, draft, or write a pull request.
---

# PR 作成

`gh` で PR を作る。本文はテンプレートの節構造に沿って埋める。

**PR のタイトルと本文は日本語で書く。**

`gh pr create` がリポジトリのテンプレートを自動で拾うのは対話実行のときだけ。
エージェントは非対話で走るので、自分でテンプレートを読んで埋め、`--body-file` で渡す。

## 1. 前提を確認する

```bash
gh pr view --json number -q .number 2>/dev/null   # 既に PR があれば作らない
BASE=$(gh repo view --json defaultBranchRef -q .defaultBranchRef.name)
git fetch origin "$BASE" --quiet
```

ベースブランチをユーザーが指定していればそちらを優先する。

## 2. テンプレートを選ぶ

上から順に、最初に見つかったものを使う。

1. `.github/PULL_REQUEST_TEMPLATE.md`
2. `.github/pull_request_template.md`
3. `PULL_REQUEST_TEMPLATE.md` / `docs/PULL_REQUEST_TEMPLATE.md`
4. `.github/PULL_REQUEST_TEMPLATE/` 配下（複数ある場合はどれを使うかユーザーに聞く）
5. どれも無ければ、このスキルに同梱の `code.md` または `journal.md`

同梱テンプレートを使う場合、差分の中身で選ぶ。

- **`journal.md`** — 写真・PDF・Markdown・測定データなど、記録が主な変更
- **`code.md`** — ソースコードが主な変更

```bash
git diff --name-only "origin/$BASE"...HEAD
```

**判断がつかないときは自分で決めずユーザーに聞く。** 混在している場合も聞く。

## 3. 事実を集める

```bash
git log --reverse --format='%s%n%b' "origin/$BASE"..HEAD
git diff --stat "origin/$BASE"...HEAD
```

関連 Issue 番号はブランチ名とコミット本文から拾う。見つからなければその節は空のままにする。**番号を推測して書かない。**

## 4. 埋める

- **見出しは一字一句変えない。** 節の追加・削除・並べ替えもしない
- `<!-- ... -->` の指示コメントは、読んだ上で削除する
- 該当しない節は削除せず「該当なし」と書く
- チェックボックスは**実際に確認したものだけ** `[x]` にする。未実施は `[ ]` のまま残す
- **やっていない検証を書かない。** テストを流していないなら動作確認の節にそう書く
- 小さな変更は各節1行でよい
- 埋める材料が無い節が多いときは、勝手に埋めずユーザーに聞く

## 5. 作成する

本文を一時ファイルに書いてから渡す。

```bash
gh pr create --base "$BASE" --title "<title>" --body-file <tmpfile>
```

- `--fill` / `--fill-first` / `--fill-verbose` は**使わない**（本文がコミットメッセージで上書きされる）
- 中身を確認したいときは `--dry-run` を付けて一度見せる
- ブランチが未 push なら `git push -u origin HEAD` が必要。**push と PR 作成の前にユーザーの合図を取る**（ユーザーが明示的に作成を指示している場合はそのまま進めてよい）
- ドラフトにするか、レビュアー・ラベルを付けるかはユーザーの指示に従う

## よくある失敗

- **本文が空、または節が消えている** — `--body` に短い文字列を渡している。`--body-file` を使う
- **テンプレートが反映されない** — `gh` に任せている。自分で読んで埋める
- **チェックが全部埋まっている** — 確認していないものまで `[x]` にしている
- **`origin/$BASE` が無い** — `git fetch origin "$BASE"` をしていない
