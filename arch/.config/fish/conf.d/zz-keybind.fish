# キーバインド。
#
# ghostty 側で Ctrl+V を端末で処理せず 0x16 のままアプリに送るようにしたため
# (arch/.config/ghostty/config 参照)、fish 側で受け取ってペーストにする。
# こうしないと fish で Ctrl+V が効かなくなる (fish は ctrl-v を既定で使っていない)。
# fish_clipboard_paste は fish 標準の関数で、Wayland では wl-paste -n を使う
# (要 wl-clipboard)。端末自身のペーストは Ctrl+Shift+V に残してある。
#
# ファイル名を "zz-" で始めること。conf.d は辞書順に読まれ、my-fzf.fish より
# 後でなければならない:
#   1. fzf.fish (プラグイン本体) が既定バインドを張る。変数検索の既定は Ctrl+V
#   2. ここで Ctrl+V を上書き
#   3. my-fzf.fish の fzf_configure_bindings --variables= が、まず
#      _fzf_uninstall_bindings で Ctrl+V を含む既定キーを erase してから張り直す
# 2 が 3 より先だと、ここで張った Ctrl+V が 3 で消える (実際に踏んだ)。
#
# --mode も必ず付ける。付けないと実行時点のモードにしか入らない。
status is-interactive; or exit

for mode in default insert
    bind --mode $mode ctrl-v fish_clipboard_paste
end
