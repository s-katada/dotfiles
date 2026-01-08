{ pkgs, ... }:
{
  # Determinate Nix を使用しているため、nix-darwin の Nix 管理を無効化
  nix.enable = false;

  # fish を有効シェルに追加
  environment.shells = [ pkgs.fish ];
  programs.fish.enable = true;

  # Homebrew (GUI アプリのみ)
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";  # Homebrew で管理していないものを削除
    };
    taps = [
      "grishka/grishka"
    ];
    casks = [
      # フォント
      "font-hack-nerd-font"
      # アプリ
      "1password"
      "adobe-acrobat-reader"
      "alacritty"
      "android-studio"
      "arc"
      "arduino-ide"
      "bambu-studio"
      "bitwarden"
      "chromedriver"
      "claude"
      "claude-code"
      "cursor"
      "discord"
      "emacs-app"
      "firefox"
      "gather"
      "ghostty"
      "gitify"
      "google-chrome"
      "google-drive"
      "handbrake-app"
      "karabiner-elements"
      "libreoffice"
      "lm-studio"
      "microsoft-remote-desktop"
      "neardrop"
      "notion"
      "obsidian"
      "orbstack"
      "raycast"
      "rustdesk"
      "slack"
      "spotify"
      "synology-drive"
      "teamviewer"
      "vial"
      "visual-studio-code"
      "void"
      "zoom"
    ];
  };

  # システムバージョン
  system.stateVersion = 4;
  system.primaryUser = "awesomemr";

  # ユーザー設定
  users.users.awesomemr = {
    name = "awesomemr";
    home = "/Users/awesomemr";
    shell = pkgs.fish;
  };
}
