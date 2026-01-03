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
      # bobthefish テーマ設定
      set -g theme_color_scheme dracula
      set -g theme_date_format "+[%H:%M:%S]"
      set -g theme_display_git_default_branch yes
      set -g theme_newline_cursor yes

      # Homebrew
      fish_add_path /opt/homebrew/bin

      # .NET tools
      fish_add_path $HOME/.dotnet/tools

      # ローカルbin
      fish_add_path $HOME/.local/bin

      # Cargo (rustup)
      fish_add_path $HOME/.cargo/bin

      # LM Studio CLI
      fish_add_path $HOME/.lmstudio/bin

      # Antigravity
      fish_add_path $HOME/.antigravity/antigravity/bin

      # peco で履歴検索 (Ctrl+R)
      bind \cr peco-history-selection

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
    nodejs_22
    ruby_3_4
    python314
    uv  # Python パッケージマネージャ

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
    peco
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

  ];

  # direnv（プロジェクト別バージョン管理）
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # 環境変数
  home.sessionVariables = {
    LANG = "ja_JP.UTF-8";
    EDITOR = "code";
    TERM = "xterm-256color";
  };
}
