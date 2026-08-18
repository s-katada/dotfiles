# Claude Code から起動された端末に残っている環境変数を掃除する。
#
# エージェントが使う Bash ツールの環境変数は、そこから起動したプロセス
# （GUI のターミナルを含む）すべてに継承される。CLAUDE_CODE_CHILD_SESSION が
# 残った端末で claude を起動すると「入れ子の子セッション」と判定され、
# 会話ログ（transcript）が保存されなくなる。
# 対話シェルのときだけ掃除するので、エージェント自身の非対話シェルには影響しない。
if status is-interactive; and set -q CLAUDE_CODE_CHILD_SESSION
    set -e CLAUDE_CODE_CHILD_SESSION
    set -e CLAUDE_CODE_SESSION_ID
    set -e CLAUDE_PID
    set -e CLAUDE_CODE_MESSAGING_SOCKET
    set -e CLAUDE_CODE_MESSAGING_TOKEN
    set -e CLAUDE_EFFORT
    set -e CLAUDECODE
    set -e CLAUDE_CODE_ENTRYPOINT
    set -e AI_AGENT
    # SHELL=/bin/bash も継承されるため、新しい端末が fish ではなく bash で開く
    set -gx SHELL /usr/bin/fish
end
