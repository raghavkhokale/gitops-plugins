---
name: p1as:repo-diff
description: Show diff between two git refs in a repo.
when_to_use: |
  Use this skill to invoke the `repo_diff` operation directly.
  Trigger when the user asks specifically about repo diff or when a workflow skill
  delegates this specific operation.
---

# /p1as:repo-diff

Show diff between two git refs in a repo.

**MCP tool:** `mcp__server__repo_diff`

## What To Do

1. Call `mcp__server__repo_diff(repo_path, base_ref, head_ref)`.
2. Show the structured result to the user in a readable format.
3. Suggest next steps if applicable (e.g., related tools to call, follow-up actions).

