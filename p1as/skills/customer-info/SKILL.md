---
name: p1as:customer-info
description: Get customer details: regions, versions, env_vars, feature flags.
when_to_use: |
  Use this skill to invoke the `customer_info` operation directly.
  Trigger when the user asks specifically about customer info or when a workflow skill
  delegates this specific operation.
---

# /p1as:customer-info

Get customer details: regions, versions, env_vars, feature flags.

**MCP tool:** `mcp__server__customer_info`

## What To Do

1. Call `mcp__server__customer_info(customer)`.
2. Show the structured result to the user in a readable format.
3. Suggest next steps if applicable (e.g., related tools to call, follow-up actions).

