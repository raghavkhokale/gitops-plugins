---
name: gitops:patch-custom
description: DEPRECATED — bundled templates removed; use the /gitops:patch workflow instead.
when_to_use: |
  Use this skill to invoke the `patch_custom` operation directly.
  Trigger when the user asks specifically about patch custom or when a workflow skill
  delegates this specific operation.
---

# /gitops:patch-custom

DEPRECATED — bundled templates removed; use the /gitops:patch workflow instead.

**MCP tool:** `mcp__gitops__patch_custom`

## What To Do

1. Call `mcp__gitops__patch_custom(tenant, environment, patch_file, patch_args)`.
2. Show the structured result to the user in a readable format.
3. Suggest next steps if applicable (e.g., related tools to call, follow-up actions).

