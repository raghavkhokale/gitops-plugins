---
name: p1as:artifact-download
description: Download an artifact from S3 (ping-artifacts or pingbinarybucket).
when_to_use: |
  Use this skill to invoke the `artifact_download` operation directly.
  Trigger when the user asks specifically about artifact download or when a workflow skill
  delegates this specific operation.
---

# /p1as:artifact-download

Download an artifact from S3 (ping-artifacts or pingbinarybucket).

**MCP tool:** `mcp__server__artifact_download`

## What To Do

1. Call `mcp__server__artifact_download(product, name, version, filename, profile)`.
2. Show the structured result to the user in a readable format.
3. Suggest next steps if applicable (e.g., related tools to call, follow-up actions).

