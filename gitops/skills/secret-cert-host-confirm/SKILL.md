---
name: gitops:secret-cert-host-confirm
description: Execute a previously approved TLS sealed-secret creation.
when_to_use: |
  Use this skill to invoke the `secret_cert_host_confirm` operation directly.
  Trigger when the user asks specifically about secret cert host confirm or when a workflow skill
  delegates this specific operation.
---

# /gitops:secret-cert-host-confirm

Execute a previously approved TLS sealed-secret creation.

**MCP tool:** `mcp__gitops__secret_cert_host_confirm`

## What To Do

1. Call `mcp__gitops__secret_cert_host_confirm(execution_id)`.
2. Show the structured result to the user in a readable format.
3. Suggest next steps if applicable (e.g., related tools to call, follow-up actions).

