---
name: gitops:cluster-logs
description: Get pod logs with filters.
when_to_use: |
  Use this skill to invoke the `cluster_logs` operation directly.
  Trigger when the user asks specifically about cluster logs or when a workflow skill
  delegates this specific operation.
---

# /gitops:cluster-logs

Get pod logs with filters.

**MCP tool:** `mcp__gitops__cluster_logs`

## What To Do

1. Call `mcp__gitops__cluster_logs(pod, namespace, since, search, container)`.
2. Show the structured result to the user in a readable format.
3. Suggest next steps if applicable (e.g., related tools to call, follow-up actions).

