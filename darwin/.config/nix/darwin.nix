{ pkgs, ... }:
{
  # Determinate Nix を使用しているため、nix-darwin の Nix 管理を無効化
  nix.enable = false;

  # zsh を有効シェルに追加
  environment.shells = [ pkgs.zsh ];
  programs.zsh.enable = true;

  # システムバージョン
  system.stateVersion = 4;

  # ユーザー設定
  users.users.awesomemr = {
    name = "awesomemr";
    home = "/Users/awesomemr";
    shell = pkgs.zsh;
  };
}
