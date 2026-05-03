---
name: gitops:config-render
description: Render a tenant's CSR manifests (kustomize + helm) and return metadata.
when_to_use: |
  Use this skill to invoke the `config_render` operation directly.
  Trigger when the user asks specifically about config render or when a workflow skill
  delegates this specific operation.
---

# /gitops:config-render

Render a tenant's CSR manifests (kustomize + helm) and return metadata.

**MCP tool:** `mcp__gitops__config_render`

## What To Do

1. Call `mcp__gitops__config_render(tenant, environment, target, force)`.
2. Show the structured result to the user in a readable format.
3. Suggest next steps if applicable (e.g., related tools to call, follow-up actions).

