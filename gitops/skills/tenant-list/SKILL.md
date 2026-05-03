---
name: gitops:tenant-list
description: List all gitops-mcp tenants, optionally filtered by region.
when_to_use: |
  Use this skill to invoke the `tenant_list` operation directly.
  Trigger when the user asks specifically about tenant list or when a workflow skill
  delegates this specific operation.
---

# /gitops:tenant-list

List all gitops-mcp tenants, optionally filtered by region.

**MCP tool:** `mcp__gitops__tenant_list`

## What To Do

1. Call `mcp__gitops__tenant_list(region)`.
2. Show the structured result to the user in a readable format.
3. Suggest next steps if applicable (e.g., related tools to call, follow-up actions).

