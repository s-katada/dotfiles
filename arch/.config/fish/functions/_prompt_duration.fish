# ミリ秒を 1.2s / 3m20s / 1h02m のような読みやすい形にする
function _prompt_duration --argument-names ms
    set -l s (math "floor($ms / 1000)")
    set -l h (math "floor($s / 3600)")
    set -l m (math "floor($s % 3600 / 60)")
    set -l sec (math "$s % 60")
    if test $h -gt 0
        printf '%dh%02dm' $h $m
    else if test $m -gt 0
        printf '%dm%02ds' $m $sec
    else
        printf '%.1fs' (math "$ms / 1000")
    end
end
