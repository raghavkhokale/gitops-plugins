---
name: gitops:cluster-exec
description: Run a command that modifies cluster state.
when_to_use: |
  Use this skill to invoke the `cluster_exec` operation directly.
  Trigger when the user asks specifically about cluster exec or when a workflow skill
  delegates this specific operation.
---

# /gitops:cluster-exec

Run a command that modifies cluster state.

**MCP tool:** `mcp__gitops__cluster_exec`

## What To Do

1. Call `mcp__gitops__cluster_exec(command, description)`.
2. Show the structured result to the user in a readable format.
3. Suggest next steps if applicable (e.g., related tools to call, follow-up actions).

