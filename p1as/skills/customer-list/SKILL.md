---
name: p1as:customer-list
description: List all P1AS customers, optionally filtered by region.
when_to_use: |
  Use this skill to invoke the `customer_list` operation directly.
  Trigger when the user asks specifically about customer list or when a workflow skill
  delegates this specific operation.
---

# /p1as:customer-list

List all P1AS customers, optionally filtered by region.

**MCP tool:** `mcp__server__customer_list`

## What To Do

1. Call `mcp__server__customer_list(region)`.
2. Show the structured result to the user in a readable format.
3. Suggest next steps if applicable (e.g., related tools to call, follow-up actions).

