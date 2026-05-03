---
name: gitops:drift-reconcile
description: Generate a reconciliation plan for detected drift.
when_to_use: |
  Use this skill to invoke the `drift_reconcile` operation directly.
  Trigger when the user asks specifically about drift reconcile or when a workflow skill
  delegates this specific operation.
---

# /gitops:drift-reconcile

Generate a reconciliation plan for detected drift.

**MCP tool:** `mcp__gitops__drift_reconcile`

## What To Do

1. Call `mcp__gitops__drift_reconcile(tenant, environment)`.
2. Show the structured result to the user in a readable format.
3. Suggest next steps if applicable (e.g., related tools to call, follow-up actions).

