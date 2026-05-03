---
name: gitops:config-read
description: Read a file from the tenant's config-repo at the env branch (origin/<env-branch>).
when_to_use: |
  Use this skill to invoke the `config_read` operation directly.
  Trigger when the user asks specifically about config read or when a workflow skill
  delegates this specific operation.
---

# /gitops:config-read

Read a file from the tenant's config-repo at the env branch (origin/<env-branch>).

**MCP tool:** `mcp__gitops__config_read`

## What To Do

1. Call `mcp__gitops__config_read(tenant, environment, path)`.
2. Show the structured result to the user in a readable format.
3. Suggest next steps if applicable (e.g., related tools to call, follow-up actions).

