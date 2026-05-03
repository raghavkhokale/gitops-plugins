---
name: gitops:repo-search
description: Search for a pattern across tenant repos using git grep.
when_to_use: |
  Use this skill to invoke the `repo_search` operation directly.
  Trigger when the user asks specifically about repo search or when a workflow skill
  delegates this specific operation.
---

# /gitops:repo-search

Search for a pattern across tenant repos using git grep.

**MCP tool:** `mcp__gitops__repo_search`

## What To Do

1. Call `mcp__gitops__repo_search(pattern, repo_paths)`.
2. Show the structured result to the user in a readable format.
3. Suggest next steps if applicable (e.g., related tools to call, follow-up actions).

