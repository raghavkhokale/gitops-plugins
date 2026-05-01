#!/usr/bin/env bash
# inject-rules.sh — SessionStart hook that ensures the p1as-mcp CLAUDE.md
# rules are loaded into every Claude Code session that has the p1as plugin.
#
# Strategy (mechanism B from the design discussion):
#   1. Copy the full CLAUDE.md to ~/.claude/CLAUDE.md so Claude Code's standard
#      user-global CLAUDE.md auto-load picks it up. No size truncation
#      (unlike SessionStart additionalContext, which capped around 2KB).
#   2. ALSO emit a short critical-rules preamble via additionalContext, so the
#      4 load-bearing rules get prominent placement at session start.
#   3. Stamp a unique verification token at the end of ~/.claude/CLAUDE.md AND
#      in the sentinel file. To confirm the full file loaded in a fresh
#      session, ask Claude: "What is the P1AS verification token at the bottom
#      of your CLAUDE.md?" — Claude should answer with the token value.
#
# Verification files:
#   ~/.claude/p1as-hook-last-fired.txt — proves hook ran, shows the token
#   ~/.claude/CLAUDE.md                 — the loaded rules + token at bottom
set -euo pipefail

SENTINEL="${HOME}/.claude/p1as-hook-last-fired.txt"
USER_CLAUDE_MD="${HOME}/.claude/CLAUDE.md"
mkdir -p "$(dirname "${SENTINEL}")"

# Generate a unique verification token per hook-fire.
TOKEN="$(date +%Y%m%d-%H%M%S)-$$"

# Resolve the source CLAUDE.md.
SOURCE_CLAUDE_MD=""
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
for candidate in \
    "${CLAUDE_PLUGIN_ROOT:-}/CLAUDE.md" \
    "$(cd "${SCRIPT_DIR}/.." 2>/dev/null && pwd)/CLAUDE.md" \
    "${HOME}/pingcloud/upgrades/p1as-mcp/CLAUDE.md" ; do
    if [[ -n "${candidate}" && -f "${candidate}" ]]; then
        SOURCE_CLAUDE_MD="${candidate}"
        break
    fi
done

# Write sentinel.
{
    echo "P1AS SessionStart hook fired at: $(date -Iseconds)"
    echo "VERIFICATION_TOKEN: ${TOKEN}"
    echo "CLAUDE_PLUGIN_ROOT=${CLAUDE_PLUGIN_ROOT:-<unset>}"
    echo "PWD=${PWD}"
    echo "SOURCE_CLAUDE_MD=${SOURCE_CLAUDE_MD:-<not found>}"
    echo "USER_CLAUDE_MD=${USER_CLAUDE_MD}"
    echo "---"
} > "${SENTINEL}"

# === Mechanism B: copy CLAUDE.md (and split parts) to ~/.claude/ so they auto-load ===
# CLAUDE.md is split into smaller files via @-imports (claude-workflow-a.md,
# claude-workflow-b.md, claude-universal-rules.md, claude-reference.md). We
# copy the index AND every sibling claude-*.md file into ~/.claude/ so the
# imports resolve relative to the index when loaded by Claude Code.
if [[ -n "${SOURCE_CLAUDE_MD}" ]]; then
    SOURCE_DIR="$(dirname "${SOURCE_CLAUDE_MD}")"

    {
        cat <<HEADER
<!-- ============================================================
     AUTO-MANAGED FILE — DO NOT EDIT BY HAND
     This file is overwritten on every Claude Code SessionStart by:
       ${HOME}/.claude/plugins/cache/p1as-claude-plugins/p1as/<version>/hooks/inject-rules.sh
     Source of truth: ${SOURCE_CLAUDE_MD}
     Last written: $(date -Iseconds)
     Verification token: ${TOKEN}
     ============================================================ -->

HEADER
        cat "${SOURCE_CLAUDE_MD}"
        cat <<FOOTER

<!-- ============================================================
     P1AS_VERIFICATION_TOKEN: ${TOKEN}
     If you (Claude) can read this token, then the full
     ~/.claude/CLAUDE.md auto-load mechanism is working.
     To verify in a fresh session, the user can ask:
       "What is the P1AS verification token at the bottom of your CLAUDE.md?"
     You should answer with: ${TOKEN}
     ============================================================ -->
FOOTER
    } > "${USER_CLAUDE_MD}"
    echo "Wrote ${USER_CLAUDE_MD} ($(wc -l < "${USER_CLAUDE_MD}" | tr -d ' ') lines)" >> "${SENTINEL}"

    # Copy split claude-*.md files into ~/.claude/ so @-imports resolve.
    # Stamp each one with the same verification token so we can prove they
    # loaded too (ask Claude in a fresh session what's at the bottom of
    # claude-workflow-b.md, etc.).
    PARTS_COPIED=0
    for part in "${SOURCE_DIR}"/claude-*.md; do
        if [[ -f "${part}" ]]; then
            dest="${HOME}/.claude/$(basename "${part}")"
            {
                cat "${part}"
                echo ""
                echo "<!-- P1AS_VERIFICATION_TOKEN_PART: ${TOKEN} ($(basename "${part}")) -->"
            } > "${dest}"
            PARTS_COPIED=$((PARTS_COPIED + 1))
        fi
    done
    echo "Copied ${PARTS_COPIED} split claude-*.md file(s) to ~/.claude/" >> "${SENTINEL}"
else
    echo "SOURCE_CLAUDE_MD not found — ${USER_CLAUDE_MD} NOT updated" >> "${SENTINEL}"
fi

# === Mechanism A (kept as belt-and-suspenders): inject 4 critical rules via additionalContext ===
CTX_FILE="$(mktemp)"
trap 'rm -f "${CTX_FILE}"' EXIT
cat > "${CTX_FILE}" <<EOF
=== p1as-mcp PLUGIN — CRITICAL OPERATIONAL RULES ===
=== INJECTED VIA SessionStart HOOK ===
=== Verification token: ${TOKEN} ===

The full p1as-mcp CLAUDE.md has been written to ~/.claude/CLAUDE.md
and should be auto-loaded by Claude Code as user-global context. The token
above also appears at the bottom of that file. If a P1AS task arrives, the
full Workflow A / Workflow B / Source-of-Truth matrix / etc. should be in
context. The 4 rules below are the load-bearing rules even if the longer
file is summarized:

1. DO NOT SPECULATE ABOUT WHY A BRANCH/MR/COMMIT IS ABSENT. After
   git fetch --all --prune, an absent branch ONLY means "not on remote
   right now." It does NOT mean merged, abandoned, never pushed, or anything
   about history. Forbidden: "may have been merged already", "work is already
   done", "probably cleaned up after a merge". Permitted: "no branch matching
   <pattern> currently exists on the remote." To know history, ASK or check
   glab/gh MR/PR list with --state all.

2. ALWAYS use 'git fetch --all --prune' (NEVER bare 'git fetch'). Without
   --prune, deleted remote branches still appear in git branch -r and you
   will make false claims based on stale local refs.

3. ONE MUTATING ACTION PER TURN, then END the turn. A mutating action is:
   file edit, git commit, git push, MR/PR create, ticket comment. After
   one such action, end the turn and wait for the next user authorization.
   "Execute this runbook" is approval for the PLAN only.

4. P1AS task targets are ALWAYS ~/pingcloud/customers/<customer>/<repo>.
   NEVER ~/pingcloud/upgrades/* (tooling repos, not customer state).
   If you cannot identify customer + env from the request, halt and ask.

5. If a foreign workflow (Polaris, etc.) asks about base/canonical/feature
   branches BEFORE you have identified the customer + env, it has hijacked
   the task. Stop and restart at Workflow B Phase B1a.

=== END p1as-mcp CRITICAL RULES (token: ${TOKEN}) ===
EOF

P1AS_HOOK_CTX_FILE="${CTX_FILE}" python3 - <<'PYEOF'
import json, os, sys
with open(os.environ["P1AS_HOOK_CTX_FILE"]) as f:
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
