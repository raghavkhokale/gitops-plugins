---
name: gitops:secret-list
description: List sealed secrets for a tenant environment (from CSR sealed-secrets.
when_to_use: |
  Use this skill to invoke the `secret_list` operation directly.
  Trigger when the user asks specifically about secret list or when a workflow skill
  delegates this specific operation.
---

# /gitops:secret-list

List sealed secrets for a tenant environment (from CSR sealed-secrets.

**MCP tool:** `mcp__gitops__secret_list`

## What To Do

1. Call `mcp__gitops__secret_list(tenant, environment)`.
2. Show the structured result to the user in a readable format.
3. Suggest next steps if applicable (e.g., related tools to call, follow-up actions).

