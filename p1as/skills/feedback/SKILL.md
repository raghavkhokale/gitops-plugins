---
name: p1as:feedback
description: File a bug or feedback ticket about p1as-mcp itself in the appropriate Jira project (PDO for tooling improvements; P1ASSD for operational failures affecting customers).
when_to_use: |
  Trigger when the user wants to report a bug, gripe, or suggestion about p1as-mcp itself —
  its tools, skills, or workflows — not about a customer environment.
---

# /p1as:feedback

File a Jira ticket about p1as-mcp itself. **This is a Workflow B (modification) operation against the Jira instance — follow Workflow B's approval-before-execution rule per CLAUDE.md.**

**Input (optional):** any text after the slash command is the user's raw feedback.

## What To Do

1. **Summarize.** Turn the user's feedback into 1–3 sentences in their voice (what they observed vs expected). If no input, draw from conversation history or ask. Do NOT paste full transcripts.

2. **Pick project + labels** per CLAUDE.md "Reference data" → Jira instances. Defaults:
   - Tooling/UX issues → `PDO`
   - Operational failures hitting customers → `P1ASSD`
   - Always include label `p1as-mcp-feedback`. Add `p1as-mcp-bug`, `p1as-mcp-improvement`, `p1as-mcp-skill-<name>`, or `p1as-mcp-agent-<name>` as applicable.

3. **Show the drafted ticket** (project, summary prefixed `[p1as-mcp] ` ≤120 chars, body, labels) and **get explicit approval** per Workflow B B1e. Never file without approval.

4. **File via `mcp__atlassian__createJiraIssue`** as Bug. Report back the issue key + URL on one line.

If Atlassian MCP is unreachable, halt per CLAUDE.md "Halt and ask when info is incomplete" — surface the error verbatim.
