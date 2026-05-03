---
name: gitops:tenant-status
description: Get aggregated environment status: pods, ArgoCD, OpenSearch health.
when_to_use: |
  Use this skill to invoke the `tenant_status` operation directly.
  Trigger when the user asks specifically about tenant status or when a workflow skill
  delegates this specific operation.
---

# /gitops:tenant-status

Get aggregated environment status: pods, ArgoCD, OpenSearch health.

**MCP tool:** `mcp__gitops__tenant_status`

## What To Do

1. Call `mcp__gitops__tenant_status(tenant, environment)`.
2. Show the structured result to the user in a readable format.
3. Suggest next steps if applicable (e.g., related tools to call, follow-up actions).

