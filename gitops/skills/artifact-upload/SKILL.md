---
name: gitops:artifact-upload
description: Upload an artifact to S3.
when_to_use: |
  Use this skill to invoke the `artifact_upload` operation directly.
  Trigger when the user asks specifically about artifact upload or when a workflow skill
  delegates this specific operation.
---

# /gitops:artifact-upload

Upload an artifact to S3.

**MCP tool:** `mcp__gitops__artifact_upload`

## What To Do

1. Call `mcp__gitops__artifact_upload(filepath, product, name, version, profile)`.
2. Show the structured result to the user in a readable format.
3. Suggest next steps if applicable (e.g., related tools to call, follow-up actions).

