---
name: p1as:repo-clone
description: Clone customer repos (cluster-state-repo + profile-repo) to ~/pingcloud/customers/.
when_to_use: |
  Use this skill to invoke the `repo_clone` operation directly.
  Trigger when the user asks specifically about repo clone or when a workflow skill
  delegates this specific operation.
---

# /p1as:repo-clone

Clone customer repos (cluster-state-repo + profile-repo) to ~/pingcloud/customers/.

**MCP tool:** `mcp__server__repo_clone`

## What To Do

1. Call `mcp__server__repo_clone(customer)`.
2. Show the structured result to the user in a readable format.
3. Suggest next steps if applicable (e.g., related tools to call, follow-up actions).

