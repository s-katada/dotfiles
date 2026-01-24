{ pkgs, ... }:
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

      # Antigravity
      fish_add_path $HOME/.antigravity/antigravity/bin

      # OrbStack
      source ~/.orbstack/shell/init2.fish 2>/dev/null || :

      # zoxide (Nixで管理しているので初期化のみ)
      zoxide init fish | source
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

    # Git 関連
    git
    gh
    delta  # git-delta

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
    gcc
    keymap-drawer
  ];

  # direnv（プロジェクト別バージョン管理）
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Git 設定
  programs.git = {
    enable = true;
    settings = {
      core = {
        quotePath = false;  # 日本語ファイル名を正しく表示
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
}
