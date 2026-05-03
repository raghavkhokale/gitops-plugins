---
name: gitops:drift-reconcile-confirm
description: Execute a previously approved drift reconciliation.
when_to_use: |
  Use this skill to invoke the `drift_reconcile_confirm` operation directly.
  Trigger when the user asks specifically about drift reconcile confirm or when a workflow skill
  delegates this specific operation.
---

# /gitops:drift-reconcile-confirm

Execute a previously approved drift reconciliation.

**MCP tool:** `mcp__gitops__drift_reconcile_confirm`

## What To Do

1. Call `mcp__gitops__drift_reconcile_confirm(execution_id)`.
2. Show the structured result to the user in a readable format.
3. Suggest next steps if applicable (e.g., related tools to call, follow-up actions).

