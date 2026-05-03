#!/usr/bin/env bash
# inject-rules.sh — SessionStart hook for the gitops plugin.
#
# What this does (and what it deliberately doesn't):
#
# The user's project — scaffolded by `gitops-mcp init` — already has a
# CLAUDE.md (and the four claude-*.md @-imports) at its root. Claude
# Code auto-loads CLAUDE.md from the cwd, so the workflow rules + the
# source-of-truth matrix are already in context for any session
# launched inside the project tree. This hook does NOT copy them into
# ~/.claude/ — that would override per-project context with a single
# global copy and is the wrong shape for an OSS tool that any number
# of projects might use simultaneously.
#
# What this hook DOES is emit a small SessionStart preamble that
# names the tool, points at the relevant files, and stamps a
# verification token so the user can confirm the hook fired (ask
# Claude "what's the gitops-mcp verification token from the
# SessionStart preamble?" — it should answer with the token).
#
# Sentinel file (for debugging hook-not-firing issues):
#   ~/.claude/gitops-hook-last-fired.txt
set -euo pipefail

SENTINEL="${HOME}/.claude/gitops-hook-last-fired.txt"
mkdir -p "$(dirname "${SENTINEL}")"

TOKEN="$(date +%Y%m%d-%H%M%S)-$$"

{
    echo "gitops SessionStart hook fired at: $(date -Iseconds)"
    echo "VERIFICATION_TOKEN: ${TOKEN}"
    echo "CLAUDE_PLUGIN_ROOT=${CLAUDE_PLUGIN_ROOT:-<unset>}"
    echo "PWD=${PWD}"
} > "${SENTINEL}"

CTX_FILE="$(mktemp)"
trap 'rm -f "${CTX_FILE}"' EXIT
cat > "${CTX_FILE}" <<EOF
=== gitops-mcp plugin — SessionStart preamble ===
=== Verification token: ${TOKEN} ===

The gitops-mcp plugin is loaded. Workflow A (info retrieval) and
Workflow B (repo modification) ceremonies, plus the source-of-truth
matrix and the universal rules, live in the four claude-*.md files
at the project root (rendered by \`gitops-mcp init\`). If you don't
see those rules in context, the user's cwd is not inside a
gitops-mcp project tree — ask which project they want to operate on.

Load-bearing rules even when the longer files aren't loaded:

1. ALWAYS use 'git fetch --all --prune' (NEVER bare 'git fetch').
   Without --prune, deleted remote branches still appear in
   'git branch -r' and you will make false claims based on stale
   local refs.

2. ONE MUTATING ACTION PER TURN, then END the turn. A mutating
   action is: file edit, git commit, git push, PR/MR create,
   ticket comment. After one such action, end the turn and wait
   for the next user authorization. "Execute this runbook" is
   approval for the PLAN only.

3. NEVER speculate about why a branch/PR/commit is absent.
   After 'git fetch --all --prune', an absent branch ONLY means
   "not on remote right now." It does NOT mean merged, abandoned,
   or never pushed. To know history, ASK or check 'gh pr list
   --state all' / 'glab mr list --state all'.

4. Tenant task targets live under the workspace_root configured
   in gitops.yaml (default: ~/gitops/tenants/<tenant>/<repo>).
   If you cannot identify tenant + env from the request, halt
   and ask.

=== END preamble (token: ${TOKEN}) ===
EOF

GITOPS_HOOK_CTX_FILE="${CTX_FILE}" python3 - <<'PYEOF'
import json, os, sys
with open(os.environ["GITOPS_HOOK_CTX_FILE"]) as f:
    ctx = f.read()
sys.stdout.write(json.dumps({
    "hookSpecificOutput": {
        "hookEventName": "SessionStart",
        "additionalContext": ctx,
    }
}))
sys.stdout.write("\n")
PYEOF

echo "Hook completed at: $(date -Iseconds)" >> "${SENTINEL}"
