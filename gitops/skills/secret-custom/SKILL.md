---
name: gitops:secret-custom
description: Create or update a custom sealed secret.
when_to_use: |
  Use this skill to invoke the `secret_custom` operation directly.
  Trigger when the user asks specifically about secret custom or when a workflow skill
  delegates this specific operation.
---

# /gitops:secret-custom

Create or update a custom sealed secret.

**MCP tool:** `mcp__gitops__secret_custom`

## What To Do

1. Call `mcp__gitops__secret_custom(tenant, environment, name, data, namespace, product)`.
2. Show the structured result to the user in a readable format.
3. Suggest next steps if applicable (e.g., related tools to call, follow-up actions).

