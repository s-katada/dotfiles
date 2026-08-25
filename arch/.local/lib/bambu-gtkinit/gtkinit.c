// Bambu Studio 起動クラッシュ (SIGSEGV) のワークアラウンド。
//
// Bambu Studio は wxEntry (= gtk_init) より前に GUI_App のコンストラクタで
// Label::initSysFont → wxSystemSettingsNative::GetFont を呼び、未初期化の GTK で
// ウィジェットを作ろうとする。gtk3 3.24.52 ではこれが GtkSettings NULL の
// CRITICAL 連発の末に segfault する。LD_PRELOAD でプロセス起動時に gtk_init を
// 先回りで呼んでおくと回避できる。上流が初期化順を直したら不要になる。
//
// 発動は bambu 本体のプロセスに限定し、その場で LD_PRELOAD を unset して
// 子プロセスに伝播させない。glycin (gdk-pixbuf の画像ローダ) や WebKit は
// サンドボックス化されたワーカープロセスを起動するので、そこにこのシムが
// 継承されると GTK 初期化が走ってワーカーが壊れ、画像読み込みが永久に
// 返らずウィンドウが出ないまま固まる。
//
// ビルド:
//   gcc -shared -fPIC gtkinit.c -o ~/.local/lib/bambu-gtkinit.so \
//       $(pkg-config --cflags --libs gtk+-3.0)
// 使い方 (BambuStudio.desktop の Exec と合わせる):
//   LD_PRELOAD=~/.local/lib/bambu-gtkinit.so bambu-studio
#define _GNU_SOURCE
#include <errno.h>
#include <stdlib.h>
#include <string.h>
#include <gtk/gtk.h>

__attribute__((constructor)) static void init(void)
{
    const char *name = program_invocation_short_name;
    if (strcmp(name, "bambu-studio") != 0 && strcmp(name, "bambustu_main") != 0)
        return;
    unsetenv("LD_PRELOAD");
    gtk_init_check(NULL, NULL);
}
