{ config, pkgs, ... }:
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
    brews = [
      "herdr"  # ターミナル常駐のエージェントマルチプレクサ。nixpkgs未収録のため brew で管理
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
      # 本体が自己更新するため、バージョン固定の claude-code cask ではなく
      # @latest を使う（stable cask とは同時インストール不可で衝突する）
      "claude-code@latest"
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
      # karabiner-elements の cask は auto_updates 指定のため、通常の brew upgrade では
      # 更新対象から外れる。その結果アプリ自身の自動更新だけがバージョンを上げ、
      # Homebrew の記録（15.3.0）と実体（16.1.0）が乖離していた。v15 -> v16 は
      # 特権デーモンが karabiner_grabber から Karabiner-Core-Service へ変わる更新で、
      # 登録が引き継がれず「GUI にはルールが見えるのに一切効かない」状態になる。
      # greedy = true で brew 管理下に戻し、更新時に公式 pkg（デーモン登録を含む）を通す。
      { name = "karabiner-elements"; greedy = true; }
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

    # Mac App Store アプリ（mas 経由。事前に App Store.app へサインインが必要）
    masApps = {
      "GarageBand" = 682658836;
      "iMovie" = 408981434;
      "Keynote" = 409183694;
      "Kindle" = 302584613;
      "LINE" = 539883307;
      "Numbers" = 409203825;
      "Pages" = 409201541;
      "Perplexity" = 6714467650;
      "Telephone" = 406825478;
      "The Unarchiver" = 425424353;
    };
  };

  # rebuild ごとに root で走る後処理。
  system.activationScripts.postActivation.text = ''
    # ---- Karabiner-Elements の特権デーモン登録チェック ----
    # 特権デーモンの登録が失効するとキー再マップは一切効かなくなるが、設定 GUI 上は
    # ルールが有効に見えるため気付きにくい（実際に約2週間気付けなかった）。
    # rebuild ごとに検知して復旧手順を出す。異常検知でも activation は止めない。
    if [ -d /Applications/Karabiner-Elements.app ]; then
      if ! /bin/launchctl print system 2>/dev/null | /usr/bin/grep -q 'org.pqrs.service.daemon.Karabiner-Core-Service'; then
        echo ""
        echo "[karabiner] 警告: 特権デーモン Karabiner-Core-Service が未登録です。キー再マップは効きません。"
        echo "[karabiner] 復旧1: Karabiner-Elements.app を開き、表示される services のセットアップを完了する"
        echo "[karabiner]         (システム設定 > 一般 > ログイン項目と機能拡張 で pqrs.org の許可が必要)"
        echo "[karabiner] 復旧2: 直らなければ brew reinstall --cask karabiner-elements"
        echo "[karabiner] 状態確認: '/Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli' \\"
        echo "[karabiner]           --show-settings-window-guidance | grep core_daemons_enabled"
        echo ""
      fi
    fi

    # ---- 外観のライト固定 ----
    # ライトは AppleInterfaceStyle キーが無い状態なので、system.defaults では
    # 表現できない（書き込みしかできない）。過去に Dark を書いた実機ではキーが
    # 残るため、rebuild ごとにユーザーコンテキストで削除する。
    # キーが無いときの delete は失敗するので set -e に巻き込まれないようにする。
    /bin/launchctl asuser "$(/usr/bin/id -u -- ${config.system.primaryUser})" \
      /usr/bin/sudo --user=${config.system.primaryUser} -- \
      /usr/bin/defaults delete -g AppleInterfaceStyle 2>/dev/null || true

    # ---- Spotlight 系ショートカットを nix 管理下に置く ----
    # システム設定 > キーボード > キーボードショートカット > Spotlight の2項目。
    # 実機では ID 64 だけが手作業で無効化されており、宣言が dotfiles に残っていなかった。
    #   ID 64 = ⌘Space「Spotlight 検索を表示」→ Raycast に譲るので無効
    #   ID 65 = ⌥⌘Space「Finder の検索ウインドウを表示」→ 無効。⌥⌘Space は
    #           Finder をホームで開く用に karabiner.json 側へ割り当て直した。
    # AppleSymbolicHotKeys は全ホットキーが1つの辞書に入るため、system.defaults で
    # 丸ごと書くと他のショートカットまで消える。-dict-add で該当 ID だけ差し替える。
    # parameters = (ASCII, キーコード, 修飾フラグ)。49=Space / 1048576=⌘ / 1572864=⌘+⌥。
    primary_uid="$(/usr/bin/id -u -- ${config.system.primaryUser})"

    disable_symbolic_hotkey() {
      /bin/launchctl asuser "$primary_uid" \
        /usr/bin/sudo --user=${config.system.primaryUser} -- \
        /usr/bin/defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add "$1" \
        "<dict><key>enabled</key><false/><key>value</key><dict><key>parameters</key><array><integer>65535</integer><integer>$2</integer><integer>$3</integer></array><key>type</key><string>standard</string></dict></dict>"
    }

    disable_symbolic_hotkey 64 49 1048576 # ⌘Space
    disable_symbolic_hotkey 65 49 1572864 # ⌥⌘Space

    # 書き込んだホットキーは activateSettings を叩かないと再ログインまで反映されない。
    /bin/launchctl asuser "$primary_uid" \
      /usr/bin/sudo --user=${config.system.primaryUser} -- \
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u \
      2>/dev/null || true

    # ---- Finder の再起動 ----
    # nix-darwin の activate は Dock しか killall しない（killall -qu <user> Dock）。
    # そのため下の system.defaults.finder.* は rebuild 直後には反映されず、次に Finder が
    # 再起動するまで古い設定のまま動き続ける。「rebuild したのに効かない」「後から急に
    # 挙動が変わった」の原因になるので、ここで明示的に再起動して反映タイミングを揃える。
    /usr/bin/killall -qu ${config.system.primaryUser} Finder || true
  '';

  # macOS 入力デバイス設定
  system.defaults = {
    NSGlobalDomain = {
      # ポインタ/スクロール
      "com.apple.trackpad.scaling" = 3.0; # トラックパッドの軌跡の速さ: 0-3
      "com.apple.swipescrolldirection" = true; # ナチュラルスクロール

      # Force Click は誤操作が多いので無効化
      "com.apple.trackpad.forceClick" = false;

      # キーボード（GUI 設定を廃止するための追加。全て nix-darwin で検証済み）
      KeyRepeat = 2; # キーリピート速度（小さいほど速い）
      InitialKeyRepeat = 15; # リピート開始までの遅延
      ApplePressAndHoldEnabled = false; # アクセント長押しを無効化（キーリピート優先）
      # F1-F12 の扱い。false = キーに印字された機能（輝度・音量など）を fn なしで
      # 直接使う（Apple 既定の挙動）。純粋な F1-F12 が必要なときは fn+F1 を使う。
      # true にすると逆で、F1 が素の F1 になり輝度・音量が fn 側へ移る。
      # Karabiner はこの値を読んで f キーの変換テーブルを組み立てるため、
      # 変更後は Karabiner 側の挙動も追従する（別途設定は不要）。
      "com.apple.keyboard.fnState" = false;
      AppleKeyboardUIMode = 3; # フルキーボードアクセス

      # テキスト入力（開発者向けに自動変換を全てオフ）
      NSAutomaticSpellingCorrectionEnabled = false;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false; # ストレートクォートを保持
      NSAutomaticInlinePredictionEnabled = false;

      # 外観
      # 「自動」（時刻で light/dark を切り替える）が有効なままだと macOS 側が
      # AppleInterfaceStyle を書き換えるため、どちらに固定するにも自動を切る必要がある。
      # 実機はこれが 1 のままで、Dark を書いても昼間は light に戻っていた。
      AppleInterfaceStyleSwitchesAutomatically = false; # 外観「自動」を無効化
      # ライト固定。macOS では「ライト = AppleInterfaceStyle キーが存在しない」なので
      # このオプションは "Dark" か null しか取れない。null は「nix が管理しない」の意味で
      # キーを消してはくれないため、削除は下の postActivation 側で行う。
      # ダークに戻すなら "Dark" にし、postActivation の削除ブロックを外す。
      AppleInterfaceStyle = null; # ライトモード固定
      AppleShowScrollBars = "Always"; # WhenScrolling|Automatic|Always
      _HIHideMenuBar = false; # メニューバーを自動非表示にしない

      # 地域・時刻・単位
      AppleICUForce24HourTime = true;
      AppleMeasurementUnits = "Centimeters";
      AppleMetricUnits = 1;
      AppleTemperatureUnit = "Celsius";

      # その他
      AppleShowAllExtensions = true; # 拡張子を常に表示（finder 側とも併用）
      NSDocumentSaveNewDocumentsToCloud = false; # 既定保存先をローカルに
      AppleFontSmoothing = 1;
      "com.apple.sound.beep.feedback" = 0; # 音量変更時のビープ無効
    };

    # fn キーを単体で押したときの動作（システム設定 > キーボード >
    # キーボードショートカット > ファンクションキー の「fn キーを押して」）。
    # nix-darwin では整数ではなく文字列 enum で指定する。対応は
    # "Do Nothing"=0 / "Change Input Source"=1 / "Show Emoji & Symbols"=2 / "Start Dictation"=3。
    # 既存の実機値が 1（入力ソースを変更）なので、挙動を変えずにそのまま宣言する。
    # なお F1-F12 を標準ファンクションキーとして使う設定は別項目で、
    # 上の NSGlobalDomain."com.apple.keyboard.fnState" 側で管理している。
    hitoolbox.AppleFnUsageType = "Change Input Source";

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

    # ---- Dock ----
    dock = {
      autohide = true;
      autohide-delay = 0.0; # Nix float。表示までの遅延0
      autohide-time-modifier = 0.2; # Nix float。表示/非表示アニメ速度
      tilesize = 48;
      magnification = false;
      orientation = "left"; # bottom|left|right
      mineffect = "scale"; # genie|suck|scale
      minimize-to-application = true;
      show-recents = false;
      mru-spaces = false; # Spaces の自動並び替え無効（aerospace 向け）
      expose-group-apps = false;
      showhidden = true;
      show-process-indicators = true;
      # ホットコーナー（1=何もしない。0 は無効値なので使わないこと）
      wvous-tl-corner = 1;
      wvous-tr-corner = 1;
      wvous-bl-corner = 1;
      wvous-br-corner = 1;
    };

    # ---- Finder ----
    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true; # 隠しファイル表示
      ShowPathbar = true;
      ShowStatusBar = true;
      FXPreferredViewStyle = "Nlsv"; # リスト表示（icnv/Nlsv/clmv/Flwv）
      _FXSortFoldersFirst = true;
      FXDefaultSearchScope = "SCcf"; # 検索は現在のフォルダ
      FXEnableExtensionChangeWarning = false;
      ShowHardDrivesOnDesktop = false;
      ShowExternalHardDrivesOnDesktop = true;
      ShowMountedServersOnDesktop = false;
      ShowRemovableMediaOnDesktop = true;
      QuitMenuItem = false;
      NewWindowTarget = "Home";
      _FXShowPosixPathInTitle = true;
    };

    # ---- スクリーンショット（保存先 ~/Screenshots は home.nix の activation で作成）----
    screencapture = {
      location = "~/Screenshots";
      type = "png";
      disable-shadow = true;
      include-date = true;
      show-thumbnail = false;
    };

    # ---- スクリーンセーバ / ロック ----
    screensaver = {
      askForPassword = true;
      askForPasswordDelay = 0; # 0=即時
    };

    # ---- ログインウィンドウ ----
    loginwindow = {
      GuestEnabled = false;
      SHOWFULLNAME = false;
      DisableConsoleAccess = true; # '>console' ログインを禁止
    };

    # ---- Window Manager（aerospace 運用のため macOS 側タイリングを無効化）----
    WindowManager = {
      GloballyEnabled = false; # Stage Manager オフ
      EnableStandardClickToShowDesktop = false;
      EnableTilingByEdgeDrag = false;
      EnableTopTilingByEdgeDrag = false;
      EnableTiledWindowMargins = false;
    };

    # ---- Spaces ----
    spaces.spans-displays = false; # ディスプレイごとに別 Spaces（要ログアウト）

    # ---- メニューバー時計 ----
    menuExtraClock = {
      ShowSeconds = false;
      Show24Hour = true;
      ShowDate = 1; # 0=スペース次第,1=常に,2=表示しない
      ShowDayOfWeek = true;
    };

    # ---- コントロールセンター ----
    controlcenter = {
      BatteryShowPercentage = true;
    };

    # ---- ソフトウェアアップデート ----
    SoftwareUpdate.AutomaticallyInstallMacOSUpdates = false;
  };

  # ホスト名（system.defaults ではなくトップレベルのオプション）
  networking.hostName = "s-katada-private";
  networking.computerName = "s-katada-private";
  networking.localHostName = "s-katada-private";

  # アプリケーションファイアウォール（旧 system.defaults.alf.* は廃止済み）
  networking.applicationFirewall.enable = true;

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
