{ pkgs, ... }:
{
  home.stateVersion = "24.05";

  # zsh を使用
  programs.zsh = {
    enable = true;
    enableCompletion = true;
  };

  # mise から移行するツール
  home.packages = with pkgs; [
    # JavaScript
    bun
    nodejs_22  # LTS
    ruby_3_4

    # その他便利ツール
    ripgrep
    fd
    eza
    bat
  ];

  # Starship プロンプト
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  # direnv（プロジェクト別バージョン管理）
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # 環境変数
  home.sessionVariables = {
    EDITOR = "code";
  };
}
