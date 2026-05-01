---
name: p1as:csr-list
description: List files/directories at a path in the customer's CSR at the env branch.
when_to_use: |
  Use this skill to invoke the `csr_list` operation directly.
  Trigger when the user asks specifically about csr list or when a workflow skill
  delegates this specific operation.
---

# /p1as:csr-list

List files/directories at a path in the customer's CSR at the env branch.

**MCP tool:** `mcp__server__csr_list`

## What To Do

1. Call `mcp__server__csr_list(customer, environment, path)`.
2. Show the structured result to the user in a readable format.
3. Suggest next steps if applicable (e.g., related tools to call, follow-up actions).

