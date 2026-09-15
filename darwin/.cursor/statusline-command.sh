#!/usr/bin/env bash
# Cursor CLI status line — Claude Code の statusline と同一の見た目にするため、
# 共通実装 (../.claude/statusline-command.sh) をそのまま実行する薄いラッパー。
# cursor-agent が stdin に渡す JSON は Claude Code とほぼ同スキーマ
# (workspace.current_dir / model.display_name / context_window.*)。
# .rate_limits が無いので 5h/7d セグメントは出ない。
exec bash "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../.claude/statusline-command.sh"
