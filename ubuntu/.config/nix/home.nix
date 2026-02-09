{ pkgs, ... }: {
  home.username = "saitama"; # WSLでのユーザー名を確認してね
  home.homeDirectory = "/home/saitama";
  home.stateVersion = "23.11"; # 導入時のバージョン

  # ここに常用したいパッケージを書く！
  home.packages = [
    pkgs.git
    pkgs.fish
    pkgs.zellij
    pkgs.neovim
    pkgs.claude-code
  ];

  # fish自体の設定もここで完結できます
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -g fish_greeting "" # 起動時の挨拶を消す
    '';
  };
}
