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
| `Ctrl p` `Ctrl p` | リテラル `Ctrl p` をペイン内アプリへ送信 (zellij の Locked 代替) |
| `Ctrl p` `?` | 全キーバインドのヘルプ表示 |

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

## セッション / ワークスペース (zellij: `Ctrl o` 相当)

| Key | Action | zellij |
|-----|--------|--------|
| `prefix+q` | デタッチ (全て動いたまま) | `Ctrl o` → `d` |
| `prefix+w` | ワークスペースピッカー | `Ctrl o` → `w` (セッションマネージャ) |
| `prefix+g` | Goto ピッカー (herdr デフォルト) | — |
| `prefix+b` | サイドバー切替 (herdr デフォルト) | — |
| `prefix+s` | 設定画面 (herdr デフォルト) | `Ctrl o` → `c` |
| `prefix+Shift+n/w/d` | ワークスペース 新規/名変更/閉じる (herdr デフォルト) | — |
| `prefix+e` | スクロールバックをエディタで開く | Scroll モード → `e` |
| `prefix+o` | 通知元へジャンプ (herdr デフォルト) | — |

## 妥協点 (herdr に機能が存在しないもの)

- **フローティングペイン** (`Alt f`, Pane モード `w`/`e`) — なし
- **スタックペイン / ピン留め / ペインフレーム切替** (Pane モード `s`/`i`/`z`) — なし
- **タブの並べ替え** (`Alt i/o`) / **ペインのタブ分離** (Tab モード `b`/`[`/`]`) — なし
- **スワップレイアウト** (`Alt [/]`) / **タブ同期** (Tab モード `s`) — なし
- **コピーモード内検索** (Scroll → `s`) — なし。`prefix+e` で $EDITOR に落として検索する
- **Locked モード** (`Ctrl g`) — なし。プレフィックス 2 度押しのリテラル送信のみ
- **キーからの Quit** (`Ctrl o` → `q`) — なし。`herdr server stop` を使う
- **`Ctrl n` / `Ctrl s` の横取り** — zellij 同様この 2 キーはペイン内アプリに届かない
- **`Alt+矢印` の横取り** — zellij 同様シェルの単語ジャンプ (Option+←/→) は使えない
- **端でのタブ折返し** (`MoveFocusOrTab`) — `Alt h/l` はペイン移動のみ。タブは `Alt+Shift+h/l`
