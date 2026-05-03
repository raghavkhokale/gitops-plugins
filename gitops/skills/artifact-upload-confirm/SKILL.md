---
name: gitops:artifact-upload-confirm
description: Execute a previously approved artifact upload.
when_to_use: |
  Use this skill to invoke the `artifact_upload_confirm` operation directly.
  Trigger when the user asks specifically about artifact upload confirm or when a workflow skill
  delegates this specific operation.
---

# /gitops:artifact-upload-confirm

Execute a previously approved artifact upload.

**MCP tool:** `mcp__gitops__artifact_upload_confirm`

## What To Do

1. Call `mcp__gitops__artifact_upload_confirm(execution_id)`.
2. Show the structured result to the user in a readable format.
3. Suggest next steps if applicable (e.g., related tools to call, follow-up actions).

