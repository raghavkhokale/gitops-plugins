---
name: p1as:patch-custom-confirm
description: Execute a previously approved custom patch.
when_to_use: |
  Use this skill to invoke the `patch_custom_confirm` operation directly.
  Trigger when the user asks specifically about patch custom confirm or when a workflow skill
  delegates this specific operation.
---

# /p1as:patch-custom-confirm

Execute a previously approved custom patch.

**MCP tool:** `mcp__server__patch_custom_confirm`

## What To Do

1. Call `mcp__server__patch_custom_confirm(execution_id)`.
2. Show the structured result to the user in a readable format.
3. Suggest next steps if applicable (e.g., related tools to call, follow-up actions).

