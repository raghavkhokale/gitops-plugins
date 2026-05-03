---
name: gitops:cluster-query
description: Run any read-only command on the connected cluster.
when_to_use: |
  Use this skill to invoke the `cluster_query` operation directly.
  Trigger when the user asks specifically about cluster query or when a workflow skill
  delegates this specific operation.
---

# /gitops:cluster-query

Run any read-only command on the connected cluster.

**MCP tool:** `mcp__gitops__cluster_query`

## What To Do

1. Call `mcp__gitops__cluster_query(command)`.
2. Show the structured result to the user in a readable format.
3. Suggest next steps if applicable (e.g., related tools to call, follow-up actions).

