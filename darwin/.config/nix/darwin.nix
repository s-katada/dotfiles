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
      cleanup = "none";  # Homebrew Bundle の cleanup は手動で確認してから行う
    };
    taps = [
      "grishka/grishka"
      "nikitabobko/tap"
    ];
    casks = [
      # フォント
      "font-hack-nerd-font"
      # アプリ
      "1password"
      "adobe-acrobat-reader"
      "alacritty"
      "android-studio"
      "nikitabobko/tap/aerospace"
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
      "ghostty"
      "gitify"
      "google-chrome"
      "google-drive"
      "handbrake-app"
      "homerow"
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
      "teamviewer"
      "tailscale-app"
      "vial"
      "visual-studio-code"
      "void"
      "wezterm"
      "zoom"
      "shottr"
      "autodesk-fusion"
      "balenaetcher"
      "cmux"
      "kicad"
      "azookey"
    ];
  };

  # macOS 入力デバイス設定
  system.defaults = {
    NSGlobalDomain = {
      # ポインタ/スクロール
      "com.apple.trackpad.scaling" = 3.0; # トラックパッドの軌跡の速さ: 0-3
      "com.apple.swipescrolldirection" = true; # ナチュラルスクロール

      # Force Click は誤操作が多いので無効化
      "com.apple.trackpad.forceClick" = false;
    };

    # マウスの軌跡の速さ: 0-3。CPI/DPI 自体はデバイス側設定なので、
    # macOS では tracking speed を Nix 管理する。
    ".GlobalPreferences"."com.apple.mouse.scaling" = 3.0;

    trackpad = {
      Clicking = true; # タップでクリック
      Dragging = false;
      TrackpadRightClick = true; # 2本指クリック/タップで副ボタン
      TrackpadThreeFingerDrag = false;
      TrackpadThreeFingerTapGesture = 2; # Look up & data detectors

      ActuationStrength = 1; # Silent Clicking 無効
      FirstClickThreshold = 0; # 軽いクリック
      SecondClickThreshold = 0; # 軽い Force Touch
    };
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
