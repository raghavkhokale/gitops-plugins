---
name: gitops:auth-status
description: Check authentication status for all services (Teleport, AWS, Atlassian).
when_to_use: |
  Use this skill to invoke the `auth_status` operation directly.
  Trigger when the user asks specifically about auth status or when a workflow skill
  delegates this specific operation.
---

# /gitops:auth-status

Check authentication status for all services (Teleport, AWS, Atlassian).

**MCP tool:** `mcp__gitops__auth_status`

## What To Do

1. Call `mcp__gitops__auth_status()`.
2. Show the structured result to the user in a readable format.
3. Suggest next steps if applicable (e.g., related tools to call, follow-up actions).

