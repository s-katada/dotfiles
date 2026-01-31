-- Leader key (must be set before lazy)
vim.g.mapleader = " "       -- スペースをLeaderキーに
vim.g.maplocalleader = " "  -- ローカルLeaderも同様

-- Core options
vim.opt.number = true       -- 行番号表示
vim.opt.tabstop = 2         -- タブ幅2
vim.opt.shiftwidth = 2      -- インデント幅2
vim.opt.expandtab = true    -- タブをスペースに変換
vim.opt.smartindent = true  -- 自動インデント
vim.opt.ignorecase = true   -- 検索時大文字小文字無視
vim.opt.smartcase = true    -- 大文字入力時は区別
vim.opt.clipboard = "unnamedplus"  -- システムクリップボード共有
vim.opt.termguicolors = true       -- TrueColor有効
vim.opt.signcolumn = "yes"  -- 左端にサイン列を常に表示
vim.opt.updatetime = 250    -- 更新間隔(ms)
vim.opt.undofile = true     -- undo履歴をファイルに保存
vim.opt.splitbelow = true   -- 水平分割は下に
vim.opt.splitright = true   -- 垂直分割は右に
vim.opt.scrolloff = 8       -- スクロール時の余白行数
vim.opt.wrap = false        -- 行の折り返し無効
vim.opt.autoread = true     -- 外部変更を自動検知

-- 外部変更の自動リロード
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  command = "checktime",
})

-- Bootstrap lazy.nvim (プラグインマネージャーの自動インストール)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Snacks.nvim: 便利機能コレクション
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },   -- 大きいファイルの最適化
      dashboard = {                   -- スタートダッシュボード
        enabled = true,
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { section = "startup" },
        },
      },
      indent = { enabled = true },    -- インデントガイド
      input = { enabled = true },     -- 入力UI改善
      notifier = { enabled = true, timeout = 3000 },  -- 通知UI
      quickfile = { enabled = true }, -- 高速ファイル読み込み
      scroll = { enabled = true },    -- スムーズスクロール
      statuscolumn = { enabled = true },  -- ステータス列カスタマイズ
      words = { enabled = true },     -- カーソル下の単語ハイライト
      lazygit = { enabled = true },   -- Lazygit統合
      terminal = { enabled = true },  -- ターミナル統合
    },
    keys = {
      { "<leader>;", function() Snacks.dashboard() end, desc = "Dashboard" },
      { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
      { "<leader>gf", function() Snacks.lazygit.log_file() end, desc = "Lazygit file history" },
      { "<leader>gl", function() Snacks.lazygit.log() end, desc = "Lazygit log" },
      { "<leader>n", function() Snacks.notifier.show_history() end, desc = "Notification history" },
      { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss notifications" },
      { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete buffer" },
      { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next reference", mode = { "n", "t" } },
      { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Previous reference", mode = { "n", "t" } },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          _G.dd = function(...) Snacks.debug.inspect(...) end  -- デバッグ用inspect
          _G.bt = function() Snacks.debug.backtrace() end      -- バックトレース表示
          vim.print = _G.dd
        end,
      })
    end,
  },

  -- Noice.nvim: コマンドライン・メッセージ・通知のモダンUI
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",  -- UI基盤ライブラリ
    },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = true,         -- 検索を画面下に表示
        command_palette = true,       -- コマンドをパレット風に
        long_message_to_split = true, -- 長いメッセージを分割表示
        inc_rename = true,            -- インクリメンタルリネーム
        lsp_doc_border = true,        -- LSPドキュメントに枠線
      },
    },
    keys = {
      { "<leader>sn", "", desc = "+noice" },
      { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect cmdline" },
      { "<leader>snl", function() require("noice").cmd("last") end, desc = "Noice last message" },
      { "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice history" },
      { "<leader>sna", function() require("noice").cmd("all") end, desc = "Noice all" },
      { "<leader>snd", function() require("noice").cmd("dismiss") end, desc = "Dismiss all" },
      { "<leader>snt", function() require("noice").cmd("pick") end, desc = "Noice picker" },
      { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll forward", mode = { "i", "s" } },
      { "<c-u>", function() if not require("noice.lsp").scroll(-4) then return "<c-u>" end end, silent = true, expr = true, desc = "Scroll backward", mode = { "i", "s" } },
    },
  },

  -- Colorscheme: カラースキーム(Tokyo Night)
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 999,
    config = function()
      vim.cmd([[colorscheme tokyonight]])
    end,
  },

  -- Telescope: ファジーファインダー
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.6",
    dependencies = {
      "nvim-lua/plenary.nvim",        -- 必須ライブラリ
      {
        "nvim-telescope/telescope-fzf-native.nvim",  -- 高速検索拡張
        build = "make",
      },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      telescope.setup({
        defaults = {
          mappings = {
            i = {  -- Insertモードのキーマップ
              ["<C-j>"] = actions.move_selection_next,      -- 次の候補
              ["<C-k>"] = actions.move_selection_previous,  -- 前の候補
            },
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,                   -- あいまい検索有効
            override_generic_sorter = true, -- 汎用ソーター上書き
            override_file_sorter = true,    -- ファイルソーター上書き
            case_mode = "smart_case",       -- スマートケース
          },
        },
      })
      telescope.load_extension("fzf")

      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
      vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Recent files" })
      vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Diagnostics" })
      vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Document symbols" })
    end,
  },

  -- Neo-tree: ファイルエクスプローラー
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",  -- ファイルアイコン
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<C-b>", "<cmd>Neotree toggle<cr>", desc = "Explorer" },
    },
  },

  -- Lualine: ステータスライン
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = { theme = "tokyonight" },
      })
    end,
  },

  -- Which-key: キーバインドヘルプ表示
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300  -- キー入力待機時間(ms)
    end,
    opts = {},
  },

  -- Treesitter: 構文解析によるハイライト・インデント
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {  -- 自動インストールする言語
          "lua",
          "typescript",
          "tsx",
          "javascript",
          "ruby",
          "rust",
          "json",
          "yaml",
          "markdown",
          "markdown_inline",
          "html",
          "css",
          "vim",
          "vimdoc",
        },
        highlight = { enable = true },  -- ハイライト有効
        indent = { enable = true },     -- インデント有効
      })
    end,
  },

  -- Mason: LSP/DAP/Linter/Formatterのインストーラー
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end,
  },

  -- Mason-LSPConfig: MasonとLSPConfigの橋渡し
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {  -- 自動インストールするLSP
          "ts_ls",            -- TypeScript
          "lua_ls",           -- Lua
          "ruby_lsp",         -- Ruby
          "rust_analyzer",    -- Rust
        },
      })
    end,
  },

  -- LSP Config: LSPクライアント設定
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      local lspconfig = require("lspconfig")

      -- LSP共通キーマップ
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local opts = { buffer = ev.buf }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
          vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "References" }))
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Implementation" }))
          vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover" }))
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename" }))
          vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "Line diagnostics" }))
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
        end,
      })

      -- LSPサーバー設定
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      lspconfig.ts_ls.setup({ capabilities = capabilities })

      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },  -- vimグローバル変数を認識
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = { enable = false },
          },
        },
      })

      lspconfig.ruby_lsp.setup({ capabilities = capabilities })
      lspconfig.rust_analyzer.setup({ capabilities = capabilities })
    end,
  },

  -- Blink.cmp: 自動補完エンジン
  {
    "saghen/blink.cmp",
    dependencies = { "rafamadriz/friendly-snippets" },  -- スニペット集
    version = "*",
    opts = {
      keymap = { preset = "default" },
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },  -- 補完ソース
      },
    },
  },

  -- Conform: フォーマッター
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {  -- 言語別フォーマッター
        lua = { "stylua" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
        yaml = { "prettierd", "prettier", stop_after_first = true },
        markdown = { "prettierd", "prettier", stop_after_first = true },
        ruby = { "rubocop" },
        rust = { "rustfmt" },
      },
      format_on_save = {      -- 保存時に自動フォーマット
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
  },

  -- Nvim-lint: Linter
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {  -- 言語別Linter
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        ruby = { "rubocop" },
      }
      -- 自動Lint実行タイミング
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("lint", { clear = true }),
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },

  -- Gitsigns: Git差分表示・操作
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {  -- 差分記号
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      current_line_blame = false,  -- 行ごとのblame表示
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end
        -- Hunk間ナビゲーション
        map("n", "]c", function()
          if vim.wo.diff then return "]c" end
          vim.schedule(function() gs.next_hunk() end)
          return "<Ignore>"
        end, { expr = true, desc = "Next hunk" })
        map("n", "[c", function()
          if vim.wo.diff then return "[c" end
          vim.schedule(function() gs.prev_hunk() end)
          return "<Ignore>"
        end, { expr = true, desc = "Previous hunk" })
        -- Hunk操作
        map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage hunk" })
        map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset hunk" })
        map("v", "<leader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Stage hunk" })
        map("v", "<leader>hr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Reset hunk" })
        map("n", "<leader>hS", gs.stage_buffer, { desc = "Stage buffer" })
        map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
        map("n", "<leader>hR", gs.reset_buffer, { desc = "Reset buffer" })
        map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
        map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, { desc = "Blame line" })
        map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "Toggle line blame" })
        map("n", "<leader>hd", gs.diffthis, { desc = "Diff this" })
        map("n", "<leader>hD", function() gs.diffthis("~") end, { desc = "Diff this ~" })
        map("n", "<leader>td", gs.toggle_deleted, { desc = "Toggle deleted" })
      end,
    },
  },

  -- Mini.nvim: 軽量ユーティリティモジュール集
  {
    "echasnovski/mini.nvim",
    version = false,
    event = "VeryLazy",
    config = function()
      require("mini.pairs").setup()     -- 括弧の自動ペア
      require("mini.surround").setup()  -- 囲み文字操作 (sa, sd, sr)
      require("mini.comment").setup()   -- コメントトグル (gc)
      require("mini.ai").setup()        -- テキストオブジェクト拡張
      require("mini.bracketed").setup() -- 括弧系ナビゲーション
    end,
  },

  -- Flash: 高速モーション・ジャンプ
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    },
  },

  -- Bufferline: タブ風バッファ表示
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    event = "VeryLazy",
    opts = {
      options = {
        mode = "buffers",               -- バッファモード
        diagnostics = "nvim_lsp",       -- LSP診断表示
        separator_style = "thin",       -- 区切り線スタイル
        show_buffer_close_icons = false,
        show_close_icon = false,
      },
    },
    keys = {
      { "<leader>bp", "<cmd>BufferLinePick<cr>", desc = "Pick buffer" },
      { "<leader>bc", "<cmd>BufferLinePickClose<cr>", desc = "Pick close buffer" },
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous buffer" },
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
    },
  },

  -- Trouble: 診断・参照の一覧表示
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "Trouble",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer diagnostics (Trouble)" },
      { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
      { "<leader>xl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP definitions/references (Trouble)" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location list (Trouble)" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix list (Trouble)" },
    },
    opts = {},
  },

  -- Toggleterm: ターミナル管理
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      { "<leader>tt", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Terminal horizontal" },
      { "<leader>tv", "<cmd>ToggleTerm direction=vertical size=80<cr>", desc = "Terminal vertical" },
      { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Terminal float" },
      {
        "<leader>tg",
        function()
          local Terminal = require("toggleterm.terminal").Terminal
          local lazygit = Terminal:new({
            cmd = "lazygit",
            dir = "git_dir",
            direction = "float",
            float_opts = { border = "curved" },
            on_open = function(term)
              vim.cmd("startinsert!")
              vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
            end,
          })
          lazygit:toggle()
        end,
        desc = "Lazygit",
      },
    },
    opts = {
      open_mapping = [[<c-\>]],     -- Ctrl+\でターミナルトグル
      direction = "float",          -- デフォルトはフロート
      float_opts = { border = "curved" },
    },
  },

  -- Todo-comments: TODO/FIXME等のハイライト
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
    },
  },
})
