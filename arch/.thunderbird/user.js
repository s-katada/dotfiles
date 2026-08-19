// Thunderbird の設定。プロファイル配下に user.js として置くと、起動ごとに
// この内容が prefs.js へ強制的に書き込まれる。GUI で設定した内容は sqlite や
// prefs.js に散って dotfiles で追跡できないが、ここに書いた分は宣言的に管理できる。
//
// 配置: ~/.thunderbird/<profile>.default-release/ に対して
//         user.js -> arch/.thunderbird/user.js
//         chrome  -> arch/.thunderbird/chrome
//       のシンボリックリンクを張る。プロファイル名はランダムなので
//       実際の名前は ~/.thunderbird/profiles.ini で確認する。
//
// 反映には Thunderbird の再起動が必要。GUI で変えても次の起動でここの値に戻る。

// ---------------------------------------------------------------------------
// 配色
// ---------------------------------------------------------------------------
// 実際の色は chrome/userChrome.css (Catppuccin Latte) で当てる。読み込むには
// このフラグが必要。
//
// 補足: ui.window / ui.-moz-sidebar のような ui.* prefs でシステム色を
// 差し替える方法は Thunderbird には効かない。prefs には取り込まれるが、
// Thunderbird は messenger の colors.css で独自トークンを定義していて
// システム色を経由しないため。詳細は userChrome.css の冒頭に記録した。
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

// UI をライトで固定する (0 = ライト / 1 = ダーク)。
// ターミナルや regreet は Mocha のダークだが、GUI アプリは gtk-3.0/gtk-4.0 の
// settings.ini で意図的にライトへ寄せているので、そちらの慣習に合わせる。
// Catppuccin のライト変種が Latte なのでパレットの一貫性は保てる。
user_pref("ui.systemUsesDarkTheme", 0);

// メール本文(HTML)の配色は差し替えない。
// 0=ダーク / 1=ライト / 2=システム追従 / 3=UI のテーマに追従。
// 1 に固定して、送信者が意図した見た目のままメールを表示する。
user_pref("layout.css.prefers-color-scheme.content-override", 1);

// ---------------------------------------------------------------------------
// フォント
// ---------------------------------------------------------------------------
// 既定は Nimbus Sans (Helvetica の代替) で、日本語は fontconfig 経由だと
// Noto Sans CJK KR に落ちて漢字が韓国字形になる。欧文と日本語を明示する。
user_pref("font.default.x-western",         "sans-serif");
user_pref("font.name.sans-serif.x-western", "Adwaita Sans");
user_pref("font.name.monospace.x-western",  "Noto Sans Mono CJK JP");

user_pref("font.default.ja",         "sans-serif");
user_pref("font.name.sans-serif.ja", "Noto Sans CJK JP");
user_pref("font.name.serif.ja",      "Noto Serif CJK JP");
user_pref("font.name.monospace.ja",  "Noto Sans Mono CJK JP");

// ---------------------------------------------------------------------------
// 新着メールの通知
// ---------------------------------------------------------------------------
// swaync (niri の spawn-at-startup で常駐) がデスクトップ通知を出すので、
// Thunderbird 内蔵のポップアップではなく OS の通知に流す。

// 新着時に通知を出す。use_system_alert で libnotify 経由 = swaync に出る
user_pref("mail.biff.show_alert",        true);
user_pref("mail.biff.use_system_alert",  true);

// 通知の中身。差出人・件名・本文プレビューを載せる
user_pref("mail.biff.alert.show_sender",     true);
user_pref("mail.biff.alert.show_subject",    true);
user_pref("mail.biff.alert.show_preview",    true);
user_pref("mail.biff.alert.preview_length",  80);   // 既定 40 では短い

// 通知から直接操作できるアクション
user_pref("mail.biff.alert.enabled_actions", "mark-as-read,delete");

// 音は鳴らさない (通知だけで足りるため)。鳴らしたい場合は true にする
user_pref("mail.biff.play_sound", false);

// トレイアイコン。既定のまま無効にしておく。
//
// 訂正の記録: 当初「Wayland には常駐トレイが無い」と書いていたが誤りだった。
// この環境にはトレイがある。waybar の tray モジュールが org.kde.StatusNotifierWatcher
// を持っていて、fcitx5 / 1Password / Slack / Discord が実際に登録している。
// Thunderbird も true にすれば StatusNotifierItem を登録することを確認した。
//
// ただし true にしても**ウィンドウを閉じると Thunderbird は終了する**
// (実測: 閉じた時点でプロセスもトレイ項目も消えた)。つまりトレイに畳んで常駐させる
// ことはできず、常駐させたいならウィンドウを開いたままにするしかない。
// アイコン自体が欲しいときだけ true にする。
user_pref("mail.biff.show_tray_icon_always", false);

// IMAP IDLE。サーバ側から push されるので新着はほぼ即座に届く。
// check_time はその保険としてのポーリング間隔(分)。
user_pref("mail.server.default.use_idle",   true);
user_pref("mail.server.default.check_time", 5);

// ---------------------------------------------------------------------------
// 使わない機能を止める (メールだけ使う)
// ---------------------------------------------------------------------------
// カレンダー / タスク / チャット / アドレス帳は本体に組み込みでビルドされていて
// アドオンのように取り外せない。UI から消すのは chrome/userChrome.css 側で行い、
// ここでは prefs で止められる動作を切る。

// カレンダーのリマインダを出さない・鳴らさない・インジケータも出さない
user_pref("calendar.alarms.show",            false);
user_pref("calendar.alarms.playsound",       false);
user_pref("calendar.alarms.indicator.show",  false);
