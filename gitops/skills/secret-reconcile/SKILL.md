---
name: gitops:secret-reconcile
description: Compare sealed secrets between git (CSR) and the live cluster.
when_to_use: |
  Use this skill to invoke the `secret_reconcile` operation directly.
  Trigger when the user asks specifically about secret reconcile or when a workflow skill
  delegates this specific operation.
---

# /gitops:secret-reconcile

Compare sealed secrets between git (CSR) and the live cluster.

**MCP tool:** `mcp__gitops__secret_reconcile`

## What To Do

1. Call `mcp__gitops__secret_reconcile(tenant, environment)`.
2. Show the structured result to the user in a readable format.
3. Suggest next steps if applicable (e.g., related tools to call, follow-up actions).

