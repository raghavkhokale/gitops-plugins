---
name: gitops:patch-kust-confirm
description: Execute a previously approved kustomization patch.
when_to_use: |
  Use this skill to invoke the `patch_kust_confirm` operation directly.
  Trigger when the user asks specifically about patch kust confirm or when a workflow skill
  delegates this specific operation.
---

# /gitops:patch-kust-confirm

Execute a previously approved kustomization patch.

**MCP tool:** `mcp__gitops__patch_kust_confirm`

## What To Do

1. Call `mcp__gitops__patch_kust_confirm(execution_id)`.
2. Show the structured result to the user in a readable format.
3. Suggest next steps if applicable (e.g., related tools to call, follow-up actions).

