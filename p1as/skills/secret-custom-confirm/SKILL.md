---
name: p1as:secret-custom-confirm
description: Execute a previously approved custom sealed-secret creation.
when_to_use: |
  Use this skill to invoke the `secret_custom_confirm` operation directly.
  Trigger when the user asks specifically about secret custom confirm or when a workflow skill
  delegates this specific operation.
---

# /p1as:secret-custom-confirm

Execute a previously approved custom sealed-secret creation.

**MCP tool:** `mcp__server__secret_custom_confirm`

## What To Do

1. Call `mcp__server__secret_custom_confirm(execution_id)`.
2. Show the structured result to the user in a readable format.
3. Suggest next steps if applicable (e.g., related tools to call, follow-up actions).

