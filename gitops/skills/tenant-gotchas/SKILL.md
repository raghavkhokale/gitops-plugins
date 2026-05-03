---
name: gitops:tenant-gotchas
description: Get known upgrade gotchas for a tenant from Confluence.
when_to_use: |
  Use this skill to invoke the `tenant_gotchas` operation directly.
  Trigger when the user asks specifically about tenant gotchas or when a workflow skill
  delegates this specific operation.
---

# /gitops:tenant-gotchas

Get known upgrade gotchas for a tenant from Confluence.

**MCP tool:** `mcp__gitops__tenant_gotchas`

## What To Do

1. Call `mcp__gitops__tenant_gotchas(tenant, region)`.
2. Show the structured result to the user in a readable format.
3. Suggest next steps if applicable (e.g., related tools to call, follow-up actions).

