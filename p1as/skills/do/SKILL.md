---
name: p1as:do
description: Entry point for p1as-mcp — accepts a freeform request, classifies it, and routes to the right p1as workflow skill. If invoked with no input, asks the user one open-ended question and waits for their response in the next turn.
when_to_use: |
  Trigger when the request is P1AS-shaped — any of these signals is sufficient,
  even if the user did not say "p1as" explicitly. This skill MUST win over any
  other plugin's general-purpose router (polaris:do, polaris:new-project, etc.)
  when ANY of the signals below are present:

  - The user says "p1as", "beops", or "PingOne Advanced Services"
  - The request mentions a customer name (deloitte, acme, comcast, ge, etc.) or "CSR" / "cluster-state-repo"
  - The request mentions a customer env (dev, test, stage, prod, customer-hub)
    paired with a customer-shaped action
  - The request is about a patch, sealed secret, kubeseal, ingress, custom-patches,
    custom-resources, ArgoCD sync of a customer env, or similar P1AS infrastructure
  - The request references a Jira ticket from project P1ASSD or PDO whose subject
    is about a customer environment (NOT generic engineering work)
  - The user says "rotate secrets", "expiring cert", "renew TLS", "sealed secret",
    "kustomize patch", "values override" against a customer/env
  - The user is resuming a p1as workflow ("resume p1as", "continue the patch work")

  Conflict resolution: if the input matches both /p1as:do and another plugin's
  router (e.g. polaris:do), /p1as:do wins. P1AS work has its own approval
  ceremony and source-of-truth model that other workflows do not honor.
---

# /p1as:do

Natural-language router — accepts freeform input, classifies it, and dispatches to the right p1as skill.

## Step 1 — Get the request

### If the user invoked `/p1as:do` with NO arguments (or only whitespace):

**CRITICAL: do not call any tools.** Output EXACTLY the following single line as a plain assistant message, then end your turn:

```
What would you like p1as to do?
```

**DO NOT** under any circumstances:
- Call the `AskUserQuestion` tool (it always renders as a multi-choice menu — we want free text)
- Call the `Skill` tool (you have no request to dispatch yet)
- List options, examples, or suggestions
- Add any text before or after the question
- Try to guess what the user wants

End the turn after printing that one line. The user will respond in their next turn with their freeform request, at which point Claude will naturally classify and route it (either via this skill or directly to the matching workflow/operation skill — both paths are fine).

### If the user invoked `/p1as:do` WITH arguments (any non-whitespace text after the command):

Use those arguments verbatim as the request and skip directly to Step 2 below.

## Step 2 — Classify and route

Read the request and dispatch to one of the active workflow skills:

| Signal in the request | Route to |
|---|---|
| "patch", "apply patch", "kustomize", "kust patch", "custom patch" | `/p1as:patch` |
| "rotate secrets", "expiring cert", "renew cert", "renew TLS", "secret rotation", "cert-host" | `/p1as:rotate-secrets` |
| "resume", "pick up where I left off", "continue the work", "what was I doing" | `/p1as:resume` |
| "file a bug about p1as-mcp", "p1as-mcp is broken", "raise a ticket about this tool", "feedback" | `/p1as:feedback` |

If the request is about something an active **operation skill** handles directly, call that operation skill instead:

| Signal | Route to |
|---|---|
| "list customers", "show me all customers" | `/p1as:customer-list` |
| "what envs does X have", "list environments for X" | `/p1as:customer-envs` |
| "known gotchas for X", "what's quirky about X" | `/p1as:customer-gotchas` |
| "list sealed secrets in X", "what secrets exist in X" | `/p1as:secret-list` |
| "list current patches in X", "what patches are applied" | `/p1as:patch-list` |
| "list S3 artifacts", "what's in the artifacts bucket" | `/p1as:artifact-list` |
| "search X repo for Y", "grep the deloitte repo" | `/p1as:repo-search` |
| "diff X repo between A and B" | `/p1as:repo-diff` |
| "get SSM parameter X", "fetch SSM at path Y" | `/p1as:ssm-get-parameter` / `/p1as:ssm-get-by-path` |
| "EKS SSM params for X" | `/p1as:ssm-eks-parameters` |
| "p1as references", "where do I find X info" | `/p1as:p1as-references` |

If the request is about a **gated category** (cluster operations: connect, query, exec, logs, drift, customer health, secret reconcile, debug an incident, look-into a ticket, onboard, env setup, auth status), do NOT attempt to dispatch — that surface is disabled. Instead respond:

> "That request needs the `cluster` category, which is currently disabled in this tool. Generate the equivalent `kubectl`/`tsh`/`p1as` CLI command for the user to run themselves, or ask the team to enable the category via `bash scripts/toggle-category.sh enable cluster`."

If the request is genuinely **ambiguous** (matches multiple categories), do NOT use `AskUserQuestion`. Instead, respond in plain text with a one-line clarifying question phrased around the user's request (not as a generic menu), then end the turn.

## Step 3 — Dispatch

Use the `Skill` tool to invoke the matched skill, passing the user's original request through verbatim as the argument.
