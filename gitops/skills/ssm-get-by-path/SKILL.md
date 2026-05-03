---
name: gitops:ssm-get-by-path
description: Get all AWS SSM parameters under a path.
when_to_use: |
  Use this skill to invoke the `ssm_get_by_path` operation directly.
  Trigger when the user asks specifically about ssm get by path or when a workflow skill
  delegates this specific operation.
---

# /gitops:ssm-get-by-path

Get all AWS SSM parameters under a path.

**MCP tool:** `mcp__gitops__ssm_get_by_path`

## What To Do

1. Call `mcp__gitops__ssm_get_by_path(path)`.
2. Show the structured result to the user in a readable format.
3. Suggest next steps if applicable (e.g., related tools to call, follow-up actions).

