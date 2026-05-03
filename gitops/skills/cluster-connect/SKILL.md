---
name: gitops:cluster-connect
description: Connect to a tenant's Kubernetes cluster via Teleport.
when_to_use: |
  Use this skill to invoke the `cluster_connect` operation directly.
  Trigger when the user asks specifically about cluster connect or when a workflow skill
  delegates this specific operation.
---

# /gitops:cluster-connect

Connect to a tenant's Kubernetes cluster via Teleport.

**MCP tool:** `mcp__gitops__cluster_connect`

## What To Do

1. Call `mcp__gitops__cluster_connect(tenant, environment, region)`.
2. Show the structured result to the user in a readable format.
3. Suggest next steps if applicable (e.g., related tools to call, follow-up actions).

