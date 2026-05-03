---
name: gitops:tenant-info
description: Get tenant details: regions, versions, env_vars, feature flags.
when_to_use: |
  Use this skill to invoke the `tenant_info` operation directly.
  Trigger when the user asks specifically about tenant info or when a workflow skill
  delegates this specific operation.
---

# /gitops:tenant-info

Get tenant details: regions, versions, env_vars, feature flags.

**MCP tool:** `mcp__gitops__tenant_info`

## What To Do

1. Call `mcp__gitops__tenant_info(tenant)`.
2. Show the structured result to the user in a readable format.
3. Suggest next steps if applicable (e.g., related tools to call, follow-up actions).

