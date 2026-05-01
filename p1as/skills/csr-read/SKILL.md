---
name: p1as:csr-read
description: Read a file from the customer's cluster-state-repo at the env branch (origin/<env-branch>).
when_to_use: |
  Use this skill to invoke the `csr_read` operation directly.
  Trigger when the user asks specifically about csr read or when a workflow skill
  delegates this specific operation.
---

# /p1as:csr-read

Read a file from the customer's cluster-state-repo at the env branch (origin/<env-branch>).

**MCP tool:** `mcp__server__csr_read`

## What To Do

1. Call `mcp__server__csr_read(customer, environment, path)`.
2. Show the structured result to the user in a readable format.
3. Suggest next steps if applicable (e.g., related tools to call, follow-up actions).

