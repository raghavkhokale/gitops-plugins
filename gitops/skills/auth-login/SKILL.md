---
name: gitops:auth-login
description: Login to specified providers (teleport, aws, atlassian) or all if not specified.
when_to_use: |
  Use this skill to invoke the `auth_login` operation directly.
  Trigger when the user asks specifically about auth login or when a workflow skill
  delegates this specific operation.
---

# /gitops:auth-login

Login to specified providers (teleport, aws, atlassian) or all if not specified.

**MCP tool:** `mcp__gitops__auth_login`

## What To Do

1. Call `mcp__gitops__auth_login(providers)`.
2. Show the structured result to the user in a readable format.
3. Suggest next steps if applicable (e.g., related tools to call, follow-up actions).

