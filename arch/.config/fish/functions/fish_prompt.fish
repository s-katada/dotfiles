# 2 行プロンプト:
#   1 行目: [SSH] cwd  git 情報
#   2 行目: ❯ (直前のコマンドが失敗すると赤くなる)
function fish_prompt --description 'Write out the prompt'
    set -l last_status $status
    set -l pipe_status $pipestatus

    # --- 1 行目 -------------------------------------------------------
    echo

    # SSH 越し / root のときだけ user@host を出す
    if set -q SSH_CONNECTION; or set -q SSH_TTY
        echo -n (set_color -o brred)"󰢹 "(set_color brred)$USER(set_color -d)"@"(set_color brred)(prompt_hostname)(set_color normal)" "
    else if fish_is_root_user
        echo -n (set_color -o red)"⚡ root"(set_color normal)" "
    end

    # Python の仮想環境（環境変数だけを見るのでコストゼロ）
    if set -q VIRTUAL_ENV
        echo -n (set_color cyan)"("(basename $VIRTUAL_ENV)")"(set_color normal)" "
    end

    # カレントディレクトリ: 末尾 2 つはそのまま、それより上は 1 文字に短縮
    echo -n (set_color -o blue)(prompt_pwd --dir-length=1 --full-length-dirs=2)(set_color normal)

    # git セグメント
    set -l git_info (_prompt_git)
    test -n "$git_info"; and echo -n "  $git_info"

    # 書き込み不可なディレクトリの警告
    test -w . ;or echo -n " "(set_color -o red)""(set_color normal)

    # バックグラウンドジョブ
    set -l jobcount (count (jobs -p))
    test $jobcount -gt 0; and echo -n " "(set_color brblack)"⚙ $jobcount"(set_color normal)

    # --- 2 行目 -------------------------------------------------------
    echo

    # 直前のコマンドの終了ステータス（パイプは全部並べる）
    if test $last_status -ne 0
        if test (count $pipe_status) -gt 1
            echo -n (set_color -o red)"["(string join '|' $pipe_status)"]"(set_color normal)" "
        else
            echo -n (set_color -o red)"[$last_status]"(set_color normal)" "
        end
    end

    if fish_is_root_user
        echo -n (set_color -o red)"# "
    else if test $last_status -ne 0
        echo -n (set_color -o red)"❯ "
    else
        echo -n (set_color -o green)"❯ "
    end
    set_color normal
end
