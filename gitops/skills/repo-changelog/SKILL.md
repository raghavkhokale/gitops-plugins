---
name: gitops:repo-changelog
description: Generate changelog from commits between two git refs.
when_to_use: |
  Use this skill to invoke the `repo_changelog` operation directly.
  Trigger when the user asks specifically about repo changelog or when a workflow skill
  delegates this specific operation.
---

# /gitops:repo-changelog

Generate changelog from commits between two git refs.

**MCP tool:** `mcp__gitops__repo_changelog`

## What To Do

1. Call `mcp__gitops__repo_changelog(repo_path, from_ref, to_ref)`.
2. Show the structured result to the user in a readable format.
3. Suggest next steps if applicable (e.g., related tools to call, follow-up actions).

