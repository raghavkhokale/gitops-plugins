---
name: p1as:resume
description: Resume an interrupted approval-gated p1as workflow from where it left off.
when_to_use: |
  Trigger when: the user wants to continue an interrupted p1as operation that was waiting for approval.
  Signals: "resume", "continue the patch", "pick up where we left off", "the session was interrupted",
  or the user references a pending execution_id.
---

# /p1as:resume

Resume an interrupted approval-gated workflow.

**Input** (optional): An execution_id, or a description of the operation to resume (e.g., "resume axa dev patch", "continue the cert rotation").

## What To Do

1. Find the pending operation — follow this logic:
   - If the user provides an execution_id directly, use it
   - If the user describes the operation, ask them to confirm the execution_id from the previous session output
   - If unclear, explain that the execution_id is shown in the preview output of the interrupted operation

2. Identify the operation type from the execution_id prefix or user description:
   - `patch_kust_*` → call `mcp__server__patch_kust_confirm(execution_id)`
   - `patch_custom_*` → call `mcp__server__patch_custom_confirm(execution_id)`
   - `secret_cert_*` → call `mcp__server__secret_cert_host_confirm(execution_id)`
   - `secret_custom_*` → call `mcp__server__secret_custom_confirm(execution_id)`
   - `artifact_upload_*` → call `mcp__server__artifact_upload_confirm(execution_id)`
   - `drift_reconcile_*` → call `mcp__server__drift_reconcile_confirm(execution_id)`
   - `cluster_exec_*` → call `mcp__server__cluster_exec_confirm(execution_id)`

3. Before executing, briefly describe what the pending operation will do (from the execution_id or user's description) and ask for final confirmation.

4. On confirmation, call the appropriate `*_confirm` tool and report the result.

**Note:** Approval tokens expire after 30 minutes. If the execution_id is stale, re-run the original operation (patch, secret create, etc.) to get a fresh preview and execution_id.
