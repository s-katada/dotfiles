# git のリポジトリ情報を 1 行にまとめて返すヘルパー。
# porcelain=v2 を 1 回だけ呼んでパースするので、プロンプトが重くならない。
#
# 見た目は darwin/.config/starship.toml のカスタム git セグメントに合わせている:
#   赤背景   ... 未ステージの変更あり（ステージ済みが混ざっていても赤）
#   黄背景   ... ステージ済みのみ
#   緑背景 + ... untracked ファイルのみ
#   緑背景   ... clean
function _prompt_git --description 'Render the git segment of the prompt'
    set -l raw (command git --no-optional-locks status --porcelain=v2 --branch --show-stash 2>/dev/null)
    or return

    set -l branch ""
    set -l oid ""
    set -l ahead 0
    set -l behind 0
    set -l staged 0
    set -l modified 0
    set -l untracked 0
    set -l conflict 0
    set -l stash 0

    for line in $raw
        set -l head (string sub -l 1 -- $line)
        if test "$head" = '#'
            if string match -q -- '# branch.head *' $line
                set branch (string replace -- '# branch.head ' '' $line)
            else if string match -q -- '# branch.oid *' $line
                set oid (string sub -l 7 -- (string replace -- '# branch.oid ' '' $line))
            else if string match -q -- '# branch.ab *' $line
                set -l ab (string split ' ' -- (string replace -- '# branch.ab ' '' $line))
                set ahead (string replace -- '+' '' $ab[1])
                set behind (string replace -- '-' '' $ab[2])
            else if string match -q -- '# stash *' $line
                set stash (string replace -- '# stash ' '' $line)
            end
        else if test "$head" = 1 -o "$head" = 2
            # XY フィールド: 1 文字目 = index (staged)、2 文字目 = worktree (未 add)
            set -l xy (string sub -s 3 -l 2 -- $line)
            test (string sub -s 1 -l 1 -- $xy) != '.'; and set staged (math $staged + 1)
            test (string sub -s 2 -l 1 -- $xy) != '.'; and set modified (math $modified + 1)
        else if test "$head" = u
            set conflict (math $conflict + 1)
        else if test "$head" = '?'
            set untracked (math $untracked + 1)
        end
    end

    # detached HEAD なら短縮 SHA を出す
    set -l name
    if test "$branch" = '(detached)' -o -z "$branch"
        set name "➦ $oid"
    else
        set name " $branch"
    end

    # 上流との差分（チップの中に入れる）
    set -l ab ""
    test $ahead -gt 0; and set ab "$ab ⇡$ahead"
    test $behind -gt 0; and set ab "$ab⇣$behind"

    # 作業ツリーの状態でチップの色を決める（darwin と同じ Dracula 配色）
    set -l chip_color
    set -l dots ""
    if test $modified -gt 0 -o $conflict -gt 0
        set chip_color (set_color -o f8f8f2 --background=ff5555)
    else if test $staged -gt 0
        set chip_color (set_color -o 282a36 --background=f1fa8c)
    else if test $untracked -gt 0
        set chip_color (set_color -o 282a36 --background=50fa7b)
        set dots "..."
    else
        set chip_color (set_color -o 282a36 --background=50fa7b)
    end

    set -l out $chip_color" $name$dots$ab "(set_color normal)

    # rebase / merge / cherry-pick などの進行中オペレーション
    set -l gitdir (command git rev-parse --git-dir 2>/dev/null)
    set -l op ""
    if test -n "$gitdir"
        if test -d $gitdir/rebase-merge -o -d $gitdir/rebase-apply
            set op REBASE
        else if test -f $gitdir/MERGE_HEAD
            set op MERGE
        else if test -f $gitdir/CHERRY_PICK_HEAD
            set op CHERRY-PICK
        else if test -f $gitdir/BISECT_LOG
            set op BISECT
        end
    end
    test -n "$op"; and set -a out (set_color -o red)"[$op]"

    test $stash -gt 0; and set -a out (set_color brmagenta)"\$$stash"

    echo -n (string join ' ' $out)(set_color normal)
end
