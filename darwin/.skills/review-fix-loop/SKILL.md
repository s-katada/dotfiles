---
name: review-fix-loop
description: >-
  Orchestrate a Claude↔Cursor review/fix loop inside Herdr. Claude reviews,
  Cursor applies fixes, Claude re-reviews until VERDICT=CLEAN (or the round
  cap). Use when the user asks for review-fix loop, Claude review + Cursor fix,
  peer review until clean, or similar — and HERDR_ENV=1 with Claude and Cursor
  already in the same tab (discover Cursor by agent list; rename is optional).
---

# Review ↔ Fix loop (Claude reviews, Cursor fixes)

You are the **reviewer** (Claude). Cursor is the **fixer**. Do not edit files yourself unless the user explicitly asks you to; send actionable findings to Cursor via Herdr and re-review after each round.

## Preconditions

```bash
test "${HERDR_ENV:-}" = 1
```

If that fails, say you are not inside Herdr and stop.

Same tab must have one Claude and one Cursor. **No rename / pairing key is required.**

Resolve the fixer from `herdr agent list` filtered by `HERDR_TAB_ID` (or your own `tab_id`):

```bash
FIXER=$(herdr agent list | jq -r --arg tab "$HERDR_TAB_ID" '
  .result.agents
  | map(select(.tab_id == $tab and .agent == "cursor"))
  | first
  | .pane_id // empty
')
# If a friendly name already exists, `fixer` / that name also works as TARGET.
```

- Reviewer = you (Claude) — do **not** `agent prompt` yourself for the review work
- Fixer = that Cursor `pane_id` (or name `fixer` only if the user already renamed it)

## Loop (cap: 5 rounds unless user says otherwise)

### Round start — review

1. Inspect the worktree yourself (`git status`, `git diff`, focused paths the user named).
2. Produce findings that Cursor can act on. End your review block with exactly one of:

```text
VERDICT=CHANGES
```

or

```text
VERDICT=CLEAN
```

Rules for the verdict:

- `CLEAN` — no remaining actionable defects; stop the loop and summarize for the user.
- `CHANGES` — at least one concrete fix remains; continue.

### Hand off to Cursor (only when VERDICT=CHANGES)

Use `herdr agent prompt` (submits text + Enter). Prefer `--wait` with a generous timeout. Check-in style: if timeout, `agent read` / `agent get`, then wait again — do not abandon the fixer.

```bash
herdr agent get "$FIXER"
# if blocked: inspect with agent read, ask the user before send-keys

REVIEW=$(cat <<'EOF'
以下のレビュー指摘をすべて修正してください。推測で広げず、指摘された箇所だけ直す。
修正後は簡潔に何を変えたか列挙する。

---
<paste your findings here>
---
EOF
)

herdr agent prompt "$FIXER" "$REVIEW" --wait --timeout 300000
```

If `agent_blocked` or `agent_prompt_stalled`: `herdr agent read "$FIXER" --source recent-unwrapped --lines 80`, then decide with the user — do not blindly resend.

After a successful wait, read what Cursor did:

```bash
herdr agent read "$FIXER" --source recent-unwrapped --lines 120
```

### Re-review

Re-check the tree (diff / tests the user cares about). Emit a new verdict. Repeat until `VERDICT=CLEAN` or the round cap.

On round cap with remaining issues: stop, list leftovers, ask the user whether to continue.

## Prompt hygiene for Cursor

- File paths + line ranges when possible
- What is wrong + what “done” looks like
- No “also maybe refactor X” noise unless it blocks correctness
- One pasteable block per handoff (entire finding set)

## Anti-patterns

- Do not use annotate/reviewr Send for this loop (those target the pane under review, not cross-agent orchestration)
- Do not `pane send-text` without Enter; always `agent prompt`
- Do not launch a second Cursor if one already exists in the tab
- Do not YOLO `git push`, deploy, or destructive commands as part of the loop
