---
name: p1as:artifact-list
description: List available artifacts in S3.
when_to_use: |
  Use this skill to invoke the `artifact_list` operation directly.
  Trigger when the user asks specifically about artifact list or when a workflow skill
  delegates this specific operation.
---

# /p1as:artifact-list

List available artifacts in S3.

**MCP tool:** `mcp__server__artifact_list`

## What To Do

1. Call `mcp__server__artifact_list(product, name, profile)`.
2. Show the structured result to the user in a readable format.
3. Suggest next steps if applicable (e.g., related tools to call, follow-up actions).

