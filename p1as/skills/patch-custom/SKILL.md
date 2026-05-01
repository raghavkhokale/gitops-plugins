---
name: p1as:patch-custom
description: LEGACY template-based path.
when_to_use: |
  Use this skill to invoke the `patch_custom` operation directly.
  Trigger when the user asks specifically about patch custom or when a workflow skill
  delegates this specific operation.
---

# /p1as:patch-custom

LEGACY template-based path.

**MCP tool:** `mcp__server__patch_custom`

## What To Do

This is a **direct preview** of the underlying `mcp__server__patch_custom` tool. It renders a bundled template and shows what would be applied — but **the bundled templates are generic, customer-agnostic starting points** (see CLAUDE.md "Bundled patch templates are starting points, NOT source of truth"). The output may not match the customer's actual resource shape.

**For any actual patch creation, use the /p1as:patch workflow skill** — it follows the mandatory step-by-step Repository Modification Workflow and starts with `csr_read` to inspect actual CSR state before constructing the patch.

If the user invoked this operation skill directly (e.g. typed `/p1as:patch-custom`):

1. **First, call `mcp__server__csr_read(customer, env, 'k8s-configs/base/custom-patches.yaml')` and `mcp__server__csr_read(customer, env, 'k8s-configs/<env>/env_vars')` to surface what's actually in the CSR.** Show that output to the user.
2. Then call `mcp__server__patch_custom(...)` to render the template-based preview. Show it to the user with the explicit caveat: "this template is generic — verify it matches your actual CSR state."
3. **Do NOT call `mcp__server__patch_custom_confirm`** under any circumstance from this skill — the `*_confirm` variant bundles file write + commit + push + MR, which violates the step-by-step workflow.
4. If the user wants to proceed with the change, route them to /p1as:patch:
   > "To actually apply this change with proper validation against your CSR state, use /p1as:patch — it walks through reading current state, constructing the patch from what's actually there, ticket+branch, local change, diff review, and MR steps explicitly. Want me to start that workflow now?"
