---
name: gitops:repo-clone
description: Clone tenant repos (config-repo + profile-repo) to ~/pingcloud/tenants/.
when_to_use: |
  Use this skill to invoke the `repo_clone` operation directly.
  Trigger when the user asks specifically about repo clone or when a workflow skill
  delegates this specific operation.
---

# /gitops:repo-clone

Clone tenant repos (config-repo + profile-repo) to ~/pingcloud/tenants/.

**MCP tool:** `mcp__gitops__repo_clone`

## What To Do

1. Call `mcp__gitops__repo_clone(tenant)`.
2. Show the structured result to the user in a readable format.
3. Suggest next steps if applicable (e.g., related tools to call, follow-up actions).

