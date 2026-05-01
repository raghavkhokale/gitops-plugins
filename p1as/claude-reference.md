## Skill dispatch matrix

When a user's request arrives (via `/p1as:do` or directly), use this table to route:

| User-intent signal | Skill / Workflow / Agent |
|---|---|
| "patch", "apply patch", "kustomize", "kust patch", "custom patch", "custom-patches.yaml" | `/p1as:patch` (Workflow B specialization) |
| "rotate secrets", "expiring cert", "renew TLS", "secret rotation", "cert-host", "create sealed secret", "kubeseal" | `/p1as:rotate-secrets` (Workflow B specialization) |
| "resume", "pick up where I left off", "continue the work", "what was I doing" | `/p1as:resume` |
| "file a bug about p1as-mcp", "p1as-mcp is broken", "feedback about this tool", "raise a ticket about this tool" | `/p1as:feedback` |
| "list customers", "show me all customers" | `/p1as:customer-list` (Workflow A) |
| "what envs does X have", "list environments for X" | `/p1as:customer-envs` (Workflow A) |
| "known gotchas for X", "what's quirky about X" | `/p1as:customer-gotchas` (Workflow A) |
| "list sealed secrets in X", "what secrets exist in X" | `/p1as:secret-list` (Workflow A) |
| "list current patches in X", "what patches are applied" | `/p1as:patch-list` (Workflow A) |
| "list S3 artifacts", "what's in the artifacts bucket" | `/p1as:artifact-list` (Workflow A) |
| "search X repo for Y", "grep the deloitte repo" | `/p1as:repo-search` (Workflow A) |
| "diff X repo between A and B" | `/p1as:repo-diff` (Workflow A) |
| "get SSM parameter X", "fetch SSM at path Y" | `/p1as:ssm-get-parameter` / `/p1as:ssm-get-by-path` (Workflow A) |
| "EKS SSM params for X" | `/p1as:ssm-eks-parameters` (Workflow A) |
| "p1as references", "where do I find X info" | `/p1as:p1as-references` |
| Cluster READ operations (query, logs, get, describe, drift detect, health, incident investigation) | Cluster category currently disabled — generate kubectl/tsh command for the user to run themselves. When re-enabled, use the cluster MCP tools (read side only). |
| Cluster MUTATION operations (exec, apply, delete, scale, restart, drain, etc.) | **NEVER execute.** Per the "Cluster mutations are NEVER permitted" rule, analyze the request, produce a recommended command/script with sources, and hand off. Do not call any mutating MCP tool, do not run mutating kubectl via Bash. The user runs it themselves. |
| Secret creation / rotation with agent mode | `@"p1as:secrets (agent)"` |

---

## Active skills + agents

See the dispatch matrix above for routing. Skills are loaded from `.claude/skills/`. Agents from `.claude/agents/`.

| Skill | Purpose |
|---|---|
| `/p1as:do` | General-purpose router — classifies input and dispatches to the right skill |
| `/p1as:patch` | Apply a kustomize/custom patch via Workflow B (patch-specific phases) |
| `/p1as:rotate-secrets` | Rotate sealed secrets via Workflow B (secret-specific phases) |
| `/p1as:resume` | Resume an interrupted approval-gated flow |
| `/p1as:feedback` | File a bug/feedback ticket about p1as-mcp itself |

| Agent | Purpose |
|---|---|
| `@"p1as:secrets (agent)"` | Sealed-secret creation and rotation against the CSR (CSR git only) |

### Currently disabled categories

The `cluster` category is **disabled by feature flag** — all `cluster_*` MCP tools, `p1as cluster *` CLI subcommands, cluster-* operation skills, and `@"p1as:cluster (agent)"` are gated off until a read-only Kubernetes service account is provisioned.

If a user asks for any cluster operation (read OR mutation): do NOT attempt to call `mcp__server__cluster_*` (not registered). Generate the equivalent kubectl/tsh command for the user to run themselves.

**When the cluster category is later re-enabled, READ operations only.** Cluster mutations are forbidden permanently per the "Cluster mutations are NEVER permitted" rule above — that rule is independent of the category gate. Re-enabling the cluster category just unlocks `kubectl get` / `kubectl describe` / `kubectl logs` / `tsh kube ls` and similar read tools; it does NOT enable any mutating operation.

**To re-enable** (read side only): remove `cluster` from `P1AS_DISABLED_CATEGORIES` in `.mcp.json`, move skills from `.claude/skills/_disabled/` back to `.claude/skills/`, move agent from `.claude/agents/_disabled/`, re-run `python scripts/gen-operation-skills.py`, run `bash scripts/build-plugin.sh`, restart Claude Code. The `cluster_exec` / `cluster_exec_confirm` tools should remain disabled even after the read side is re-enabled — they are mutation tools and forbidden permanently.

---

## Reference data

### Jira / Confluence conventions

**Two Jira instances:**
- Development tickets — `https://pingidentity.atlassian.net` — project key: `PDO`
- Support tickets — `https://pingidentitycollab.atlassian.net` — project key: `P1ASSD`

When filing: customer-impacting incidents → `P1ASSD`; engineering/tooling improvements → `PDO`.

Customer gotchas live in Confluence space `ST`:
- URL: `https://pingidentity.atlassian.net/wiki/spaces/ST/pages/<page-id>/<customer-slug>`
- Access via `mcp__server__customer_gotchas(customer, region)`.

**JQL quick-reference:**
```
# Open P1ASSD support tickets for a customer
project = P1ASSD AND text ~ "<customer>" AND statusCategory != Done ORDER BY created DESC

# My open PDO tasks this sprint
project = PDO AND assignee = currentUser() AND sprint in openSprints() AND statusCategory != Done

# Recent P1ASSD tickets (last 7 days)
project = P1ASSD AND created >= -7d ORDER BY created DESC
```

Use Glean MCP (`mcp__glean__*`) for search. Use Atlassian MCP (`mcp__atlassian__*`) for create/update. Do NOT use p1as's own jira/docs tools — removed in favour of Polaris's MCPs.

### Customer data source

**Single source of truth for all customer data:** P1AS GA Environments Report (Google Sheet):
`https://docs.google.com/spreadsheets/d/1LwJJOGVa-RDC-SeFFN-sMcG1S9iHrtfCwI4emPQJpWg/edit?usp=sharing`

- Contains: customer name, DNS name, primary region, Beluga platform version per env, env status, customer type (GA/field/preview)
- Access via Glean MCP — search "P1AS customer list"
- Do NOT use `customers.yaml` or any local file — stale and unreliable

### GitLab repo URL patterns

**Instances:** `gitlab.corp.pingidentity.com` (platform repos, beops-cli, CSRs), `profiles.devops.ping.cloud` (GA profile-repos), `profiles.devops-qa.ping.cloud` (field/preview profile-repos).

**Cluster-state-repo patterns (try in order):**
1. `https://gitlab.corp.pingidentity.com/pingcloudpt-customers/ga-{primary_region}-{customer}/cluster-state-repo`
2. `https://gitlab.corp.pingidentity.com/pingcloudpt-customers/{customer}/cluster-state-repo`
3. `https://gitlab.corp.pingidentity.com/pingcloudpt-customers/{customer}-{primary_region}-ga/cluster-state-repo`
- Field: `https://gitlab.corp.pingidentity.com/pingcloudpt-customers/field-{primary_region}-{customer}/cluster-state-repo`

**Local clones:** `~/pingcloud/customers/{customer}/cluster-state-repo` and `profile-repo`.

### Env → branch mapping

`dev=dev`, `test=test`, `stage=stage`, `prod=master`, `customer-hub=customer-hub`

---

## Atlassian / Glean MCP notes

This tool depends on Polaris's Atlassian + Glean MCPs for all Jira/Confluence operations. If installed without Polaris, the `.mcp.json` at repo root declares both MCPs so Claude Code will prompt you to authenticate. Engineers with Polaris already installed get this automatically. If Atlassian or Glean MCP is unreachable, report the error verbatim — do not fall back to direct API calls.

---

## Extending p1as-mcp

- MCP tools: `p1as/tools/*.py` — each file corresponds to a tool category
- Server registration: `p1as/server.py` — `@mcp.tool()` decorated functions appear as `mcp__server__<function_name>`
- Operation skills: auto-generated from docstrings by `scripts/gen-operation-skills.py` — edit docstring, re-run generator
- Session/auth abstractions: `p1as/utils/tsh_session.py`, `p1as/utils/aws_session.py`, `p1as/utils/kube_session.py`
- Audit logging: all tool calls go through `p1as/middleware.py`
- Reference data: `p1as/data/references.json` — accessed via `mcp__server__p1as_references(topic)`

<!-- CATEGORY:cluster:k8s_safety:START -->
<!-- cluster category currently disabled (section: k8s_safety). Overlay lives in .claude/_categories/cluster.md (SECTION: k8s_safety). Re-enable with: scripts/toggle-category.sh enable cluster -->
<!-- CATEGORY:cluster:k8s_safety:END -->

<!-- CATEGORY:cluster:docs:START -->
<!-- cluster category currently disabled (section: docs). Overlay lives in .claude/_categories/cluster.md (SECTION: docs). Re-enable with: scripts/toggle-category.sh enable cluster -->
<!-- CATEGORY:cluster:docs:END -->
