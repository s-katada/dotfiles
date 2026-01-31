# Neovim Configuration

## セットアップ

1. Neovimを起動（プラグインが自動インストールされる）
2. `:Mason` でフォーマッター・リンターをインストール
   ```
   :MasonInstall stylua prettierd eslint_d
   ```

## プラグイン一覧

### コア (Ultra Modern)
| プラグイン | 用途 |
|-----------|------|
| lazy.nvim | プラグインマネージャー |
| snacks.nvim | QoL機能統合 (dashboard, notifier, indent, terminal等) |
| noice.nvim | モダンUI (cmdline, messages, popupmenu) |
| tokyonight.nvim | カラースキーム |
| nvim-treesitter | シンタックスハイライト |

### LSP・補完
| プラグイン | 用途 |
|-----------|------|
| mason.nvim | LSP/ツールインストーラー |
| mason-lspconfig.nvim | Mason-LSP連携 |
| nvim-lspconfig | LSP設定 |
| blink.cmp | 自動補完 (最新、nvim-cmp後継) |
| friendly-snippets | スニペット集 |

### コード品質
| プラグイン | 用途 |
|-----------|------|
| conform.nvim | フォーマッター |
| nvim-lint | リンター |
| gitsigns.nvim | Git差分表示 |

### 編集・ナビゲーション
| プラグイン | 用途 |
|-----------|------|
| telescope.nvim | ファジーファインダー |
| telescope-fzf-native.nvim | Telescope高速化 |
| neo-tree.nvim | ファイルエクスプローラー |
| flash.nvim | 高速ジャンプ |
| mini.nvim | pairs, surround, comment等 |

### UI
| プラグイン | 用途 |
|-----------|------|
| lualine.nvim | ステータスライン |
| bufferline.nvim | バッファタブ |
| which-key.nvim | キーマップ表示 |
| trouble.nvim | 診断一覧 |
| toggleterm.nvim | ターミナル |
| todo-comments.nvim | TODO/FIXMEハイライト |

## キーマップ

### 基本
| キー | 動作 |
|------|------|
| `<Space>` | Leader key |
| `<C-b>` | Neo-tree toggle |
| `<C-\>` | ターミナル toggle |

### Snacks.nvim
| キー | 動作 |
|------|------|
| `<leader>;` | Dashboard |
| `<leader>gg` | Lazygit |
| `<leader>gf` | Lazygit file history |
| `<leader>gl` | Lazygit log |
| `<leader>n` | 通知履歴 |
| `<leader>un` | 通知を閉じる |
| `<leader>bd` | バッファ削除 |
| `]]` / `[[` | 次/前の参照 (word) |

### Noice.nvim
| キー | 動作 |
|------|------|
| `<leader>snl` | 最後のメッセージ |
| `<leader>snh` | メッセージ履歴 |
| `<leader>sna` | 全メッセージ |
| `<leader>snd` | メッセージを閉じる |

### ファイル検索 (Telescope)
| キー | 動作 |
|------|------|
| `<leader>ff` | ファイル検索 |
| `<leader>fg` | テキスト検索 (grep) |
| `<leader>fb` | バッファ一覧 |
| `<leader>fr` | 最近開いたファイル |
| `<leader>fh` | ヘルプ検索 |
| `<leader>fd` | 診断一覧 |
| `<leader>fs` | シンボル検索 |

### LSP
| キー | 動作 |
|------|------|
| `gd` | 定義へジャンプ |
| `gD` | 宣言へジャンプ |
| `gr` | 参照一覧 |
| `gi` | 実装へジャンプ |
| `K` | ホバー情報 |
| `<leader>ca` | コードアクション |
| `<leader>rn` | リネーム |
| `<leader>e` | 行の診断表示 |
| `[d` / `]d` | 前/次の診断 |

### Git (gitsigns)
| キー | 動作 |
|------|------|
| `]c` / `[c` | 次/前のhunk |
| `<leader>hs` | hunkをステージ |
| `<leader>hr` | hunkをリセット |
| `<leader>hS` | バッファをステージ |
| `<leader>hp` | hunkをプレビュー |
| `<leader>hb` | blame表示 |
| `<leader>tb` | inline blame toggle |
| `<leader>hd` | diff表示 |

### バッファ
| キー | 動作 |
|------|------|
| `<S-h>` | 前のバッファ |
| `<S-l>` | 次のバッファ |
| `<leader>bp` | バッファを選択 |
| `<leader>bc` | バッファを閉じる |
| `<leader>bd` | バッファ削除 (snacks) |

### Flash (モーション)
| キー | 動作 |
|------|------|
| `s` | Flash jump |
| `S` | Flash treesitter |

### ターミナル
| キー | 動作 |
|------|------|
| `<leader>tt` | 水平ターミナル |
| `<leader>tv` | 垂直ターミナル |
| `<leader>tf` | フローティングターミナル |
| `<leader>tg` | lazygit (toggleterm) |
| `<leader>gg` | lazygit (snacks) |

### Trouble (診断)
| キー | 動作 |
|------|------|
| `<leader>xx` | 診断一覧 |
| `<leader>xX` | バッファの診断 |
| `<leader>xs` | シンボル一覧 |
| `<leader>xt` | TODO一覧 |

### TODO Comments
| キー | 動作 |
|------|------|
| `]t` / `[t` | 次/前のTODO |
| `<leader>st` | TODO検索 |

### フォーマット
| キー | 動作 |
|------|------|
| `<leader>cf` | 手動フォーマット |
| (自動) | 保存時に自動フォーマット |

## 対応言語

- TypeScript / JavaScript / JSX / TSX
- Lua
- Ruby / Rails
- Rust

## Tips

- `<Space>` を押して待つと which-key でキーマップ一覧が表示される
- `:checkhealth` で設定状態を確認
- `:Lazy` でプラグイン管理
- `:Mason` でLSP/ツール管理
- 起動時にdashboardが表示される (snacks.nvim)
- コマンドラインがモダンなUIに変更 (noice.nvim)
