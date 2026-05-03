---
name: gitops:patch-list
description: List current patches applied in a tenant environment
when_to_use: |
  Use this skill to invoke the `patch_list` operation directly.
  Trigger when the user asks specifically about patch list or when a workflow skill
  delegates this specific operation.
---

# /gitops:patch-list

List current patches applied in a tenant environment

**MCP tool:** `mcp__gitops__patch_list`

## What To Do

1. Call `mcp__gitops__patch_list(tenant, environment)`.
2. Show the structured result to the user in a readable format.
3. Suggest next steps if applicable (e.g., related tools to call, follow-up actions).

