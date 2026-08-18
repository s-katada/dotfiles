# 右プロンプト: 実行時間（1 秒以上のときだけ）と現在時刻
function fish_right_prompt --description 'Write out the right prompt'
    if test $CMD_DURATION -gt 1000
        echo -n (set_color yellow)"󰔟 "(_prompt_duration $CMD_DURATION)(set_color normal)" "
    end
    echo -n (set_color brblack)(date '+%H:%M:%S')(set_color normal)
end
