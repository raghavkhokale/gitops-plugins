---
name: p1as:customer-gotchas
description: Get known upgrade gotchas for a customer from Confluence.
when_to_use: |
  Use this skill to invoke the `customer_gotchas` operation directly.
  Trigger when the user asks specifically about customer gotchas or when a workflow skill
  delegates this specific operation.
---

# /p1as:customer-gotchas

Get known upgrade gotchas for a customer from Confluence.

**MCP tool:** `mcp__server__customer_gotchas`

## What To Do

1. Call `mcp__server__customer_gotchas(customer, region)`.
2. Show the structured result to the user in a readable format.
3. Suggest next steps if applicable (e.g., related tools to call, follow-up actions).

