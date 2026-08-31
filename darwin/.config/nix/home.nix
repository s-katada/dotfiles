{ config, lib, pkgs, ... }:
let
  # dotfiles リポジトリ作業ツリーの絶対パス。
  # flake のルートは darwin/.config/nix/ なので相対 path リテラル(../alacritty 等)は
  # flake の外を指してしまい pure 評価で使えない。絶対パス文字列の
  # mkOutOfStoreSymlink なら flake purity を回避でき、かつアプリが書き換えた
  # 設定も git diff として現れる（GNU Stow と同じ運用）。
  repoRoot   = "${config.home.homeDirectory}/dotfiles";
  repoDarwin = "${repoRoot}/darwin";
  link = relPath: config.lib.file.mkOutOfStoreSymlink "${repoDarwin}/${relPath}";
  # darwin と arch で中身を共有する設定は shared/ に置き、両方からここを指す。
  linkShared = relPath: config.lib.file.mkOutOfStoreSymlink "${repoRoot}/shared/${relPath}";
in
{
  home.stateVersion = "24.05";

  # fish シェル
  programs.fish = {
    enable = true;

    shellAliases = {
      e = "open -a Emacs .";
      g = "git";
      gi = "git";
      ber = "bundle exec rails";
      be = "bundle exec";
    };

    interactiveShellInit = ''
      # Starship プロンプト初期化
      starship init fish | source

      # Homebrew
      fish_add_path /opt/homebrew/bin

      # .NET tools
      fish_add_path $HOME/.dotnet/tools

      # ローカルbin
      fish_add_path $HOME/.local/bin

      # npm global
      fish_add_path $HOME/.npm-global/bin

      # Cargo (rustup)
      fish_add_path $HOME/.cargo/bin

      # LM Studio CLI
      fish_add_path $HOME/.lmstudio/bin

      # Android SDK
      fish_add_path $HOME/Library/Android/sdk/platform-tools

      # Antigravity
      fish_add_path $HOME/.antigravity/antigravity/bin

      # OrbStack
      source ~/.orbstack/shell/init2.fish 2>/dev/null || :

      # zoxide (Nixで管理しているので初期化のみ)
      zoxide init fish | source

      # atuin (シェル履歴。Ctrl-R を置き換え。上矢印は fish 既定の前方一致を維持)
      atuin init fish --disable-up-arrow | source

      # カーソルをブロックではなくライン(|)にする
      set -g fish_cursor_default line
      set -g fish_cursor_external line
    '';
  };

  # パッケージ
  home.packages = with pkgs; [
    # 開発言語・ランタイム
    bun
    nodejs
    ruby
    python3
    uv  # Python パッケージマネージャ

    # シェル
    starship  # Rust製プロンプト
    atuin  # シェル履歴を全文検索・同期し Ctrl-R を強化

    # Git 関連
    git
    gh
    delta  # git-delta
    act  # GitHub Actions をローカルで実行
    hunk  # レビューファーストのターミナル diff ビューア (hunk.dev)。flake input 由来

    # 検索・ファイル操作
    ripgrep
    fd
    eza
    bat
    tree
    fzf  # pecoより高速
    silver-searcher  # the_silver_searcher
    zoxide

    # ビルドツール
    cmake
    gnumake
    autoconf
    automake
    libtool
    pkgconf

    # メディア
    ffmpeg
    imagemagick

    # データベース
    postgresql_17

    # その他 CLI ツール
    zellij
    tmux
    ollama
    heroku
    mas  # Mac App Store CLI
    terminal-notifier
    tesseract
    graphviz
    dos2unix
    awscli
    terraform
    mas
    neovim
    tree-sitter  # nvim-treesitter (main) がパーサを `tree-sitter build` でビルドするのに必須
    gcc
    keymap-drawer
    mosh
    lazygit
    trippy
    yazi
    btop  # リソースモニタ（top の高機能版）
  ];

  # direnv（プロジェクト別バージョン管理）
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Git 設定
  # alias 等は元々 darwin/.config/git/config (2d8a225) にあったが、home-manager 生成の
  # symlink に戻した際に失われていたのでここに宣言として復元。arch/.config/git/config と同内容。
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "s-katada";
        email = "shunya.saitama@gmail.com";
      };
      alias = {
        g = "git";
        ci = "commit";
        s = "status";
        br = "branch";
        co = "checkout";
        di = "diff";
        df = "diff";
        si = "switch";
        log-graph = "log --graph --all --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cd) %C(bold blue)<%an>%Creset' --abbrev-commit --date=format-local:'%Y/%m/%d %H:%M:%S'";
      };
      init = {
        defaultBranch = "main";
      };
      core = {
        quotePath = false;  # 日本語ファイル名を正しく表示
        pager = "delta";
        editor = "nvim";
      };
      interactive = {
        diffFilter = "delta --color-only";
      };
      delta = {
        navigate = true;
        side-by-side = true;
      };
      merge = {
        conflictStyle = "zdiff3";
      };
    };
  };

  # 環境変数
  home.sessionVariables = {
    LANG = "ja_JP.UTF-8";
    EDITOR = "code";
    TERM = "xterm-256color";
    PGPASSWORD = "postgres";
  };

  # ---- dotfiles リンク（GNU Stow を廃止し home-manager に一本化）----
  # 全て mkOutOfStoreSymlink（リポジトリ作業ツリーへの書き込み可能シンボリックリンク）。
  # darwin-rebuild switch がこれらを作るので、別途 stow を走らせる手作業が不要になる。
  xdg.configFile = {
    "alacritty".source     = link ".config/alacritty";
    "ghostty".source       = link ".config/ghostty";
    "karabiner".source     = link ".config/karabiner"; # Karabiner はディレクトリ全体をリンク（公式要件）
    "starship.toml".source = link ".config/starship.toml";
    "nvim".source          = linkShared ".config/nvim"; # arch と共有 (shared/.config/nvim)
    "tmux".source          = link ".config/tmux";
    "wezterm".source       = link ".config/wezterm";
    "zellij".source        = link ".config/zellij";
    "gh/config.yml".source = link ".config/gh/config.yml"; # hosts.yml はトークンを含むので除外
    "git/ignore".source    = link ".config/git/ignore";   # git/config は programs.git が生成
    "btop".source          = link ".config/btop";         # btop.conf は btop 終了時に書き戻される（diff が出る従来運用）
    "herdr".source         = link ".config/herdr";        # 追跡は config.toml/patches のみ、実行時ファイルは gitignore 済み
    "nix/nix.conf".source  = link ".config/nix/nix.conf";
    # fisher 由来の completions/functions と fish_plugins は追跡済みの dotfiles。
    # conf.d と fish_variables はマシン固有の実行時状態なので実 ~/.config/fish に置く（リンクしない）。
    "fish/completions".source  = link ".config/fish/completions";
    "fish/functions".source    = link ".config/fish/functions";
    "fish/fish_plugins".source = link ".config/fish/fish_plugins";
  };

  # ~/ 直下のファイル（stow シンボリックリンクを置き換え）
  home.file.".aerospace.toml".source = link ".aerospace.toml";
  home.file.".emacs.d".source        = link ".emacs.d";
  # Claude の静的設定（~/.claude はアプリ管理の実ディレクトリなので個別ファイルのみリンク）
  home.file.".claude/settings.json".source         = link ".claude/settings.json";
  home.file.".claude/statusline-command.sh".source = link ".claude/statusline-command.sh";
  home.file.".claude/skills/hunk-review".source    = link ".skills/hunk-review";

  # Cursor Agent のグローバルスキル（~/.cursor はアプリ管理の実ディレクトリなので個別リンク）
  home.file.".cursor/skills/hunk-review".source    = link ".skills/hunk-review";

  # スクリーンショット保存先（system.defaults.screencapture.location 用に作成）
  home.activation.makeScreenshotsDir =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''run mkdir -p "$HOME/Screenshots"'';
}
