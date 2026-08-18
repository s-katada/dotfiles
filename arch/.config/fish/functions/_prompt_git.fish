# git のリポジトリ情報を 1 行にまとめて返すヘルパー。
# porcelain=v2 を 1 回だけ呼んでパースするので、プロンプトが重くならない。
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
    set -l label
    if test "$branch" = '(detached)' -o -z "$branch"
        set label (set_color -o yellow)"➦ $oid"
    else
        set label (set_color -o magenta)" $branch"
    end

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

    set -l out $label
    test -n "$op"; and set -a out (set_color -o red)"[$op]"

    # 上流との差分
    set -l sync
    test $ahead -gt 0; and set -a sync (set_color cyan)"⇡$ahead"
    test $behind -gt 0; and set -a sync (set_color cyan)"⇣$behind"
    test -n "$sync"; and set -a out (string join '' $sync)

    # 作業ツリーの状態
    set -l st
    test $conflict -gt 0; and set -a st (set_color -o red)"✖$conflict"
    test $staged -gt 0; and set -a st (set_color green)"+$staged"
    test $modified -gt 0; and set -a st (set_color yellow)"!$modified"
    test $untracked -gt 0; and set -a st (set_color blue)"?$untracked"
    test $stash -gt 0; and set -a st (set_color brmagenta)"\$$stash"
    if test -n "$st"
        set -a out (string join (set_color normal)" " $st)
    else
        set -a out (set_color green)"✔"
    end

    echo -n (string join ' ' $out)(set_color normal)
end
