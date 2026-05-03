---
name: gitops:config-render-resource
description: Render a specific Kubernetes resource from the tenant's CSR manifests.
when_to_use: |
  Use this skill to invoke the `config_render_resource` operation directly.
  Trigger when the user asks specifically about config render resource or when a workflow skill
  delegates this specific operation.
---

# /gitops:config-render-resource

Render a specific Kubernetes resource from the tenant's CSR manifests.

**MCP tool:** `mcp__gitops__config_render_resource`

## What To Do

1. Call `mcp__gitops__config_render_resource(tenant, environment, kind, name, namespace)`.
2. Show the structured result to the user in a readable format.
3. Suggest next steps if applicable (e.g., related tools to call, follow-up actions).

