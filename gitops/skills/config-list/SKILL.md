---
name: gitops:config-list
description: List files/directories at a path in the tenant's CSR at the env branch.
when_to_use: |
  Use this skill to invoke the `config_list` operation directly.
  Trigger when the user asks specifically about config list or when a workflow skill
  delegates this specific operation.
---

# /gitops:config-list

List files/directories at a path in the tenant's CSR at the env branch.

**MCP tool:** `mcp__gitops__config_list`

## What To Do

1. Call `mcp__gitops__config_list(tenant, environment, path)`.
2. Show the structured result to the user in a readable format.
3. Suggest next steps if applicable (e.g., related tools to call, follow-up actions).

