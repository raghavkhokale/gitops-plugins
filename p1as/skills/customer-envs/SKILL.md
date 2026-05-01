---
name: p1as:customer-envs
description: List all environments for a customer.
when_to_use: |
  Use this skill to invoke the `customer_envs` operation directly.
  Trigger when the user asks specifically about customer envs or when a workflow skill
  delegates this specific operation.
---

# /p1as:customer-envs

List all environments for a customer.

**MCP tool:** `mcp__server__customer_envs`

## What To Do

1. Call `mcp__server__customer_envs(customer)`.
2. Show the structured result to the user in a readable format.
3. Suggest next steps if applicable (e.g., related tools to call, follow-up actions).

