---
name: p1as:ssm-get-parameter
description: Get an AWS SSM parameter by name.
when_to_use: |
  Use this skill to invoke the `ssm_get_parameter` operation directly.
  Trigger when the user asks specifically about ssm get parameter or when a workflow skill
  delegates this specific operation.
---

# /p1as:ssm-get-parameter

Get an AWS SSM parameter by name.

**MCP tool:** `mcp__server__ssm_get_parameter`

## What To Do

1. Call `mcp__server__ssm_get_parameter(name)`.
2. Show the structured result to the user in a readable format.
3. Suggest next steps if applicable (e.g., related tools to call, follow-up actions).

