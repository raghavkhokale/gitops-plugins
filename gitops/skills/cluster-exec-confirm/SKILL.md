---
name: gitops:cluster-exec-confirm
description: Execute a previously approved cluster command.
when_to_use: |
  Use this skill to invoke the `cluster_exec_confirm` operation directly.
  Trigger when the user asks specifically about cluster exec confirm or when a workflow skill
  delegates this specific operation.
---

# /gitops:cluster-exec-confirm

Execute a previously approved cluster command.

**MCP tool:** `mcp__gitops__cluster_exec_confirm`

## What To Do

1. Call `mcp__gitops__cluster_exec_confirm(execution_id)`.
2. Show the structured result to the user in a readable format.
3. Suggest next steps if applicable (e.g., related tools to call, follow-up actions).

