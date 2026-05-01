---
name: p1as:patch-list
description: List current patches applied in a customer environment
when_to_use: |
  Use this skill to invoke the `patch_list` operation directly.
  Trigger when the user asks specifically about patch list or when a workflow skill
  delegates this specific operation.
---

# /p1as:patch-list

List current patches applied in a customer environment

**MCP tool:** `mcp__server__patch_list`

## What To Do

1. Call `mcp__server__patch_list(customer, environment)`.
2. Show the structured result to the user in a readable format.
3. Suggest next steps if applicable (e.g., related tools to call, follow-up actions).

