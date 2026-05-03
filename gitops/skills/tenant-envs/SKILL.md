---
name: gitops:tenant-envs
description: List all environments for a tenant.
when_to_use: |
  Use this skill to invoke the `tenant_envs` operation directly.
  Trigger when the user asks specifically about tenant envs or when a workflow skill
  delegates this specific operation.
---

# /gitops:tenant-envs

List all environments for a tenant.

**MCP tool:** `mcp__gitops__tenant_envs`

## What To Do

1. Call `mcp__gitops__tenant_envs(tenant)`.
2. Show the structured result to the user in a readable format.
3. Suggest next steps if applicable (e.g., related tools to call, follow-up actions).

