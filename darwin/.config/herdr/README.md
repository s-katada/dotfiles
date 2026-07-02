# Herdr Keybindings

zellij (`darwin/.config/zellij/config.kdl`) の操作感に寄せた設定。
herdr は tmux 型の**単一プレフィックス方式**で、zellij の**モーダル方式**
(Ctrl p → Pane モード、Ctrl t → Tab モード…) は構造的に再現できない。
そこで最頻出の zellij Pane モードキー `Ctrl p` をプレフィックスに採用し、
残りは直接チョード (Alt 系 / Ctrl n / Ctrl s) に分散させている。

反映コマンド: `herdr server reload-config`

## プレフィックス

| Key | Action |
|-----|--------|
| `Ctrl p` | プレフィックス (zellij の Pane モードに相当) |
| `Enter` / `Esc` | プレフィックスモードを抜ける (sticky パッチ、下記参照) |
| `Ctrl p` `Ctrl p` | リテラル `Ctrl p` をペイン内アプリへ送信 (zellij の Locked 代替) |
| `Ctrl p` `?` | 全キーバインドのヘルプ表示 |

### sticky prefix (自前パッチ)

素の herdr はプレフィックス後の 1 アクションで即モードを抜けるが、
`prefix_sticky = true` (独自オプション) で **Enter/Esc を押すまで
プレフィックスに留まり、アクションを連打できる** zellij のモーダル操作感にしてある。

- `Ctrl p` → `h h j x r` … のように連続操作、`Enter` で終了
- 未割当キーは無視される (モードは抜けない)
- コピー/リサイズモードやダイアログを開くキーは従来どおりそちらに遷移
- デタッチ、スクロールバック編集、pane型カスタムコマンドは実行後に抜ける

**実装**: herdr は AGPL の Rust 製なので v0.7.1 ソースにパッチを当てて
ビルドし、brew の Cellar 内バイナリを差し替えている (`brew pin herdr` 済み)。

- 差分: `patches/sticky-prefix.patch` (config オプション追加 + prefix モード遷移 + テスト 8 件)
- 再ビルド: `bash build-patched.sh` (rustup と zig@0.15 が必要、後者は自動インストール)
- 戻す: `brew unpin herdr && brew reinstall herdr`
- herdr のバージョンが上がったらパッチの再調整が必要 (スクリプトが version 不一致で止まる)

## ペイン (zellij: `Ctrl p` → キー)

| Key | Action | zellij |
|-----|--------|--------|
| `prefix+h/j/k/l` | ペインフォーカス移動 | 同一 |
| `prefix+d` | 下に分割 | 同一 (`d`) |
| `prefix+r` | 右に分割 | 同一 (`r`) |
| `prefix+n` | 新規ペイン (右分割に固定) | zellij は自動レイアウト |
| `prefix+x` | ペインを閉じる | 同一 |
| `prefix+f` / `prefix+z` | ズーム (フルスクリーン) | `f` と同一 |
| `prefix+c` | ペイン名変更 | 同一 |
| `prefix+p` / `prefix+Tab` | 次のペインへフォーカス切替 | `p` と同一 |
| `prefix+Shift+Tab` | 前のペインへ | — |
| `prefix+Shift+h/j/k/l` | ペイン入替 | zellij Move モード (`Ctrl m` → h/j/k/l) の代替 |

## Alt 直接チョード (zellij のグローバル Alt 系)

| Key | Action | zellij |
|-----|--------|--------|
| `Alt+h/j/k/l` / `Alt+矢印` | ペインフォーカス移動 | ほぼ同一 (端でのタブ折返しなし) |
| `Alt+n` | 新規ペイン (右分割) | `Alt n` 相当 |
| `Alt+t` | 新規タブ | — (zellij: `Ctrl t` → `n`) |
| `Alt+Shift+h` / `Alt+Shift+l` | 前 / 次のタブ | — (zellij: `Ctrl t` → `h/l`) |
| `Alt+1..9` | タブ直接ジャンプ | — (zellij: `Ctrl t` → `1..9`) |

## モード (zellij の 2 段階操作を直接チョードで再現)

| Key | Action | zellij |
|-----|--------|--------|
| `Ctrl n` → `h/j/k/l` → `Ctrl n`/`Esc` | リサイズモード | ほぼ同一 (縮小の H/J/K/L と `+/-` はなし。方向キーで境界を動かす) |
| `Ctrl s` (または `prefix+[`) | コピーモード (スクロール) | Scroll モード相当 |

コピーモード内: `h/j/k/l` 移動 / `w/b/e` 単語 / `{` `}` ブロック /
`Ctrl d/u` 半ページ / `Ctrl f/b` ページ / `G` 最下部 /
`v`・Space 選択開始 / `y`・Enter コピー / `q`・Esc 終了

## タブ

| Key | Action | zellij |
|-----|--------|--------|
| `prefix+t` / `Alt+t` | 新規タブ | `Ctrl t` → `n` |
| `prefix+1..9` / `Alt+1..9` | タブ切替 | `Ctrl t` → `1..9` |
| `Alt+Shift+h/l` | 前 / 次のタブ | `Ctrl t` → `h/l` |
| `prefix+Shift+x` | タブを閉じる | `Ctrl t` → `x` |
| `prefix+Shift+t` | タブ名変更 | `Ctrl t` → `r` |
| `prefix+Shift+b` | ペインを新規タブに分離 (カスタムコマンド) | `Ctrl t` → `b` |

## セッション / ワークスペース (zellij: `Ctrl o` 相当)

| Key | Action | zellij |
|-----|--------|--------|
| `prefix+q` | デタッチ (全て動いたまま) | `Ctrl o` → `d` |
| `prefix+Shift+q` | herdr 終了 (カスタムコマンド。確認なしで即停止) | `Ctrl o` → `q` |
| `prefix+w` | ワークスペースピッカー | `Ctrl o` → `w` (セッションマネージャ) |
| `prefix+g` | Goto ピッカー (herdr デフォルト) | — |
| `prefix+b` | サイドバー切替 (herdr デフォルト) | — |
| `prefix+s` | 設定画面 (herdr デフォルト) | `Ctrl o` → `c` |
| `prefix+Shift+n/w/d` | ワークスペース 新規/名変更/閉じる (herdr デフォルト) | — |
| `prefix+e` | スクロールバックをエディタで開く | Scroll モード → `e` |
| `prefix+o` | 通知元へジャンプ (herdr デフォルト) | — |

## 日本語 IME との併用

`[experimental] switch_ascii_input_source_in_prefix = true` により、
プレフィックスモードに入ると macOS の入力ソースが一時的に ASCII 対応
レイアウト (ABC 等) へ切替わり、抜けると元の IME に復元される
(ネイティブ TIS API 使用)。sticky prefix と組み合わせると、モード滞在中は
ずっと英数のまま h/j/k/l 等が通り、Enter/Esc で日本語入力に戻る。

- このフラグは起動時のみ読込。変更したらサーバー再起動が必要
- 変換中 (未確定文字がある状態) の `Ctrl p` は IME 側が消費することがある。
  確定してから押す
- リサイズ/コピーモードへ遷移した時点でプレフィックスを抜けた扱いになり
  IME が復元される。日本語入力のままこれらのモードを使うときは矢印キーで操作する

## 妥協点 (herdr に機能が存在しないもの。2026-07 確認済みで受容)

- **フローティングペイン** (`Alt f`, Pane モード `w`/`e`) — なし。`alt+f` は意図的に未割当
- **スタックペイン / ピン留め / ペインフレーム切替** (Pane モード `s`/`i`/`z`) — なし
- **タブの並べ替え** (`Alt i/o`) / **隣のタブへのペイン移動** (Tab モード `[`/`]`) — なし
- **スワップレイアウト** (`Alt [/]`) / **タブ同期** (Tab モード `s`) — なし
- **コピーモード内検索** (Scroll → `s`) — なし。`prefix+e` で $EDITOR に落として検索する
- **Locked モード** (`Ctrl g`) — なし。プレフィックス 2 度押しのリテラル送信のみ
- **`Ctrl n` / `Ctrl s` の横取り** — zellij 同様この 2 キーはペイン内アプリに届かない
- **`Alt+矢印` の横取り** — zellij 同様シェルの単語ジャンプ (Option+←/→) は使えない
- **端でのタブ折返し** (`MoveFocusOrTab`) — `Alt h/l` はペイン移動のみ。タブは `Alt+Shift+h/l`
