---
name: gitops:secret-cert-host
description: Create or update a TLS sealed secret from a certificate.
when_to_use: |
  Use this skill to invoke the `secret_cert_host` operation directly.
  Trigger when the user asks specifically about secret cert host or when a workflow skill
  delegates this specific operation.
---

# /gitops:secret-cert-host

Create or update a TLS sealed secret from a certificate.

**MCP tool:** `mcp__gitops__secret_cert_host`

## What To Do

1. Call `mcp__gitops__secret_cert_host(tenant, environment, cert_path, key_path, hosts)`.
2. Show the structured result to the user in a readable format.
3. Suggest next steps if applicable (e.g., related tools to call, follow-up actions).

