---
name: p1as:secret-custom
description: Create or update a custom sealed secret.
when_to_use: |
  Use this skill to invoke the `secret_custom` operation directly.
  Trigger when the user asks specifically about secret custom or when a workflow skill
  delegates this specific operation.
---

# /p1as:secret-custom

Create or update a custom sealed secret.

**MCP tool:** `mcp__server__secret_custom`

## What To Do

This is a **direct preview** of the underlying `mcp__server__secret_custom` tool — it shows what the operation would do, but **does NOT modify any files, commit, push, or create an MR**.

For any actual CSR modification, **use the /p1as:rotate-secrets workflow skill instead** — it follows the mandatory step-by-step Repository Modification Workflow defined in CLAUDE.md (plan → ticket+branch → local change → diff review → commit/push/MR — universal across all repos and git hosts).

If the user invoked this operation skill directly (e.g. typed `/p1as:secret-custom`):

1. Call `mcp__server__secret_custom(...)` with the user's arguments to produce a preview.
2. Show the preview to the user as informational output.
3. **Do NOT call `mcp__server__secret_custom_confirm`** under any circumstance from this skill — the `*_confirm` variant bundles file write + commit + push + MR, which violates the step-by-step workflow.
4. If the user wants to proceed with the change, route them to /p1as:rotate-secrets:
   > "To actually apply this change, use /p1as:rotate-secrets — it walks through the ticket, branch, local change, diff review, and MR steps explicitly. Want me to start that workflow now?"
