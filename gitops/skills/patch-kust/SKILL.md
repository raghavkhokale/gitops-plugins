---
name: gitops:patch-kust
description: Apply a kustomization patch to the base kustomization.
when_to_use: |
  Use this skill to invoke the `patch_kust` operation directly.
  Trigger when the user asks specifically about patch kust or when a workflow skill
  delegates this specific operation.
---

# /gitops:patch-kust

Apply a kustomization patch to the base kustomization.

**MCP tool:** `mcp__gitops__patch_kust`

## What To Do

1. Call `mcp__gitops__patch_kust(tenant, environment, patch_file, skip_checks, git_message)`.
2. Show the structured result to the user in a readable format.
3. Suggest next steps if applicable (e.g., related tools to call, follow-up actions).

