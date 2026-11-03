{ config, lib, pkgs, ... }:
let
  # dotfiles リポジトリ作業ツリーの絶対パス。
  # flake のルートは darwin/.config/nix/ なので相対 path リテラル(../ghostty 等)は
  # flake の外を指してしまい pure 評価で使えない。絶対パス文字列の
  # mkOutOfStoreSymlink なら flake purity を回避でき、かつアプリが書き換えた
  # 設定も git diff として現れる（GNU Stow と同じ運用）。
  repoRoot   = "${config.home.homeDirectory}/dotfiles";
  repoDarwin = "${repoRoot}/darwin";
  link = relPath: config.lib.file.mkOutOfStoreSymlink "${repoDarwin}/${relPath}";
  # darwin と arch で中身を共有する設定は shared/ に置き、両方からここを指す。
  linkShared = relPath: config.lib.file.mkOutOfStoreSymlink "${repoRoot}/shared/${relPath}";

  # 手元で使う python3 だけを CPython 3.14.10 にする（nixpkgs は 3.14.8）。nixpkgs が 3.14.10 以上に追いついたら外し、pkgs.python3 に戻す。
  # 理由: CVE-2026-115557（ssl が侵害された eMudhra 中間 CA を拒否しない）、CVE-2026-114583（tarfile）
  # overlay で python3 ごと差し替えると Python に依存する全パッケージがソースから再ビルドになるので、
  # ここで作った CPython は home.packages にだけ入れる（awscli2 などの内部の Python は nixpkgs のまま）。
  python3Patched = (pkgs.python314.override {
    self = python3Patched;  # python3Patched.pkgs / withPackages もこの CPython を使うように
    # ビルド用のコピー（pythonOnBuildForHost など）にも同じ CPython を使わせる。指定しないと sourceVersion が伝わらず、
    # withPackages で「3.14.8 の URL に 3.14.10 のハッシュ」の tarball を取りに行って失敗する
    __splices = {
      pythonOnBuildForBuild = python3Patched;
      pythonOnBuildForHost = python3Patched;
      pythonOnHostForHost = python3Patched;
      pythonOnBuildForTarget = python3Patched;
    };
    sourceVersion = { major = "3"; minor = "14"; patch = "10"; suffix = ""; };
    # python.org のリリースページの SHA-256 と一致を確認済み
    hash = "sha256-3kFKVxGavvUnhNiZPjQdU67WNfwrBcJgfZ+YosW3IDI=";
  }).overrideAttrs (old: {
    # 3.14.10 で Lib/mimetypes.py の knownfiles が if/else の中に移り、nixpkgs の mimetypes.patch が当たらない。
    # 同じ内容（mailcap の mime.types だけを見る）を 3.14.10 向けに書き直したパッチに差し替える
    patches = map
      (p: if lib.hasSuffix "/mimetypes.patch" (toString p) then ./patches/cpython-3.14.10-mimetypes.patch else p)
      old.patches;
  });
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
    nodejs_26  # Active LTS。nixpkgs の nodejs は LTS の切り替えに追随が遅いので系列を明示する
    ruby
    python3Patched  # 上の let を参照（脆弱性修正のため 3.14.10）
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
    silver-searcher-ng  # the_silver_searcher の PCRE2 対応 fork（旧版は nixpkgs から削除）
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
    antigravity-cli
    heroku
    mas  # Mac App Store CLI
    terminal-notifier
    tesseract
    graphviz
    dos2unix
    awscli2  # v1（awscli）は nixpkgs で botocore とのバージョン不整合によりビルド不可
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
    "ghostty".source       = link ".config/ghostty";
    "karabiner".source     = link ".config/karabiner"; # Karabiner はディレクトリ全体をリンク（公式要件）
    "starship.toml".source = link ".config/starship.toml";
    "nvim".source          = linkShared ".config/nvim"; # arch と共有 (shared/.config/nvim)
    "tmux".source          = link ".config/tmux";
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
  home.file.".emacs.d".source        = link ".emacs.d";
  # Codex / Claude / Gemini / Cursor 共通: 細粒度コミット等の横断ルールは
  # darwin/.cursor/rules/*.mdc が単一ソース。AGENTS.md / CLAUDE.md / GEMINI.md は同ファイルへの相対リンク。
  home.file.".codex/AGENTS.md".source             = link ".codex/AGENTS.md";
  home.file.".claude/CLAUDE.md".source             = link ".claude/CLAUDE.md";
  home.file.".gemini/GEMINI.md".source             = link ".gemini/GEMINI.md";
  home.file.".claude/settings.json".source         = link ".claude/settings.json";
  home.file.".claude/statusline-command.sh".source = link ".claude/statusline-command.sh";
  home.file.".gemini/statusline-command.sh".source = link ".gemini/statusline-command.sh";
  home.file.".claude/skills/hunk-review".source    = link ".skills/hunk-review";
  home.file.".claude/skills/pr-create".source      = link ".skills/pr-create";
  home.file.".claude/skills/review-fix-loop".source = link ".skills/review-fix-loop";

  # Cursor: アプリ管理の ~/.cursor へ個別リンク（skills / グローバル rules）
  home.file.".cursor/skills/hunk-review".source    = link ".skills/hunk-review";
  home.file.".cursor/skills/pr-create".source      = link ".skills/pr-create";
  home.file.".cursor/skills/review-fix-loop".source = link ".skills/review-fix-loop";
  home.file.".cursor/rules/atomic-commits.mdc".source = link ".cursor/rules/atomic-commits.mdc";
  home.file.".config/cursor/sync-user-rules.sh".source = link ".config/cursor/sync-user-rules.sh";

  # スクリーンショット保存先（system.defaults.screencapture.location 用に作成）
  home.activation.makeScreenshotsDir =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''run mkdir -p "$HOME/Screenshots"'';

  # Cursor IDE のローカル User Rules キャッシュを ~/.cursor/rules から同期
  # （ファイル実体 = ソース・オブ・トゥルース。クラウド UI とは別系統）
  home.activation.syncCursorUserRules =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run bash "${repoDarwin}/.config/cursor/sync-user-rules.sh" || true
    '';
}
