---
name: gitops:drift-detect
description: Detect configuration drift in a tenant's environment.
when_to_use: |
  Use this skill to invoke the `drift_detect` operation directly.
  Trigger when the user asks specifically about drift detect or when a workflow skill
  delegates this specific operation.
---

# /gitops:drift-detect

Detect configuration drift in a tenant's environment.

**MCP tool:** `mcp__gitops__drift_detect`

## What To Do

1. Call `mcp__gitops__drift_detect(tenant, environment)`.
2. Show the structured result to the user in a readable format.
3. Suggest next steps if applicable (e.g., related tools to call, follow-up actions).

