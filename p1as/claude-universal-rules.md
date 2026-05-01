## Universal rules (single source of truth — skills MUST cite, not duplicate)

### Cluster mutations are NEVER permitted (read-only forever)

**This is a permanent hard rule, not a transitional posture.** This tool does **read-only operations against live clusters, ever — no exceptions.** Even when the cluster category is later re-enabled (after a read-only Teleport service account is provisioned), the re-enable applies to **READ operations only**: `kubectl get`, `kubectl describe`, `kubectl logs`, `kubectl top`, `kubectl events`, `kubectl explain`, `tsh kube ls`, `aws sts get-caller-identity`, equivalent read-side MCP tools. Mutating operations are forbidden — permanently — regardless of category state, regardless of approval, regardless of how the user phrases the request.

**Forbidden, always:** `kubectl delete`, `kubectl apply`, `kubectl patch`, `kubectl scale`, `kubectl exec`, `kubectl edit`, `kubectl create`, `kubectl replace`, `kubectl rollout restart`, `kubectl rollout undo`, `kubectl cordon` / `uncordon`, `kubectl drain`, `kubectl taint`, `kubectl annotate` (mutating), `kubectl label` (mutating), `kubectl set`, `helm install` / `upgrade` / `uninstall`, `argocd app sync` / `rollback`, `aws eks update-*` of any kind, anything that issues a write to a live cluster. This list is non-exhaustive — if a command modifies live cluster state, it's forbidden, even if not listed above.

**What to do when the user asks for a cluster mutation:**

1. **Do not execute it.** Do not call any MCP tool that would execute it. Do not invoke `Bash` to run a mutating kubectl/helm/argocd command. Do not generate a confirm-side `*_confirm` call.
2. **Analyze the request** — apply Workflow A to understand what the user wants and gather the relevant CSR / cluster-read context to make a sound recommendation.
3. **Produce a recommendation** — the actual command(s), script, or runbook the user would run themselves. Make it turn-key:
   - Single command: paste-ready `kubectl apply -f /tmp/foo.yaml -n bar` (with the YAML body shown above it as a fenced block)
   - Multi-step: a numbered runbook the user can execute step-by-step, including any pre-checks and rollback steps
   - Complex/repeatable: a small bash script the user can review, save, and run themselves
4. **Cite sources** for every value in the command/script per "Citation discipline" — namespace, resource name, image tag, replica count, etc. all trace back to something you actually read in CSR / render / user-pasted kubectl output.
5. **Recommend a verification step** the user can run after the change to confirm it took effect (a `kubectl get` / `kubectl describe` command).
6. **Hand it off.** End the turn. The user runs it themselves. Do NOT offer to run it for them in a follow-up turn.

**The only sanctioned path for changes that affect live cluster state via this tool is the CSR + ArgoCD route** — modify the CSR via Workflow B, the user merges the MR, ArgoCD syncs the change to the cluster. The tool never bypasses ArgoCD by talking to the cluster directly.

**Why:** the tool ships to a small team operating critical customer environments. The cost of an accidental wrong-cluster mutation is unbounded (production outages, data loss, security incidents). The cost of "the AI wrote the command and I had to paste it" is a few seconds. The asymmetry is not close. Engineers retain full mutation capability via their own kubectl/helm/argocd CLI tooling outside this tool.

### Source-of-Truth matrix

Every kind of fact has exactly ONE authoritative source. Reading from a different source is a bug.

| Kind of fact | Authoritative source | How to retrieve |
|---|---|---|
| Customer list, regions, env types, platform versions, customer type (GA/field/preview) | P1AS GA Environments Report (Google Sheet) | `mcp__glean__search` |
| Customer-specific known issues / gotchas | Confluence ST space | `mcp__server__customer_gotchas` |
| What overrides exist in CSR for customer X env Y | CSR at `origin/<env-branch>` | `mcp__server__csr_read` / `mcp__server__csr_list` |
| Platform default + customer override for resource X | A **two-tier composition** whose layout depends on the customer's platform version: a **base kustomize tier** (the CSR's `k8s-configs/` tree, kustomize-only) AND a **microservice tier** (CSR-LOCAL `<csr>/p1as-*/` kustomization trees that declare Helm charts via `helmCharts:`). Either tier can own a given resource, depending on version. The set of present microservices is determined by the customer's filesystem at their version, not by any hardcoded list. | **Use the Discovery methodology** (see Workflow B section). Render-first, both tiers (`csr_render(target='all')`); search rendered output for the resource; trace the kustomization graph backward to find the edit point. **Do not consult hardcoded path lists** — they're brittle across versions and miss the microservice tier. |
| Sealed secrets in CSR | CSR (specific paths discovered via the Discovery methodology, not hardcoded) | `mcp__server__secret_list` (the tool itself walks the appropriate locations) |
| Custom patches in CSR | CSR (specific paths discovered via the Discovery methodology, not hardcoded) | `mcp__server__patch_list` (the tool itself walks the appropriate locations) |
| What's actually deployed in the live cluster (pods, configmaps, secrets, ingress, current data values, current image tags) — **READ-ONLY** | Live cluster (read side only — see "Cluster mutations are NEVER permitted" rule) | **Cluster READ category is currently disabled (waiting on read-only Teleport service account); when re-enabled, READS only.** While disabled, produce a paste-ready kubectl/tsh command for the user to run themselves. Cluster MUTATIONS are forbidden permanently — when the user requests a mutation, produce a recommended command/script for the user to run themselves (never execute). |
| Open Jira tickets, search Jira | P1ASSD or PDO project on Jira | `mcp__atlassian__searchJiraIssues` |
| Read/update Confluence pages | Confluence | `mcp__atlassian__getConfluencePage` / `updateConfluencePage` |
| Org-wide search across Confluence/Jira/Drive | Glean | `mcp__glean__search` |
| S3 artifacts | S3 | `mcp__server__artifact_list` / `mcp__server__artifact_download` |
| AWS SSM parameters | AWS SSM | `mcp__server__ssm_get_parameter` / `mcp__server__ssm_get_by_path` |
| Git refs, diffs, history | Local git clones (CSR, profile-repo, platform repo) | `mcp__server__repo_diff` / `mcp__server__repo_search` / `mcp__server__repo_changelog` |
| Cross-customer patterns (other customers' overrides) | Other customer CSRs cloned locally | `mcp__server__repo_search` — **but per CLAUDE.md, these are HYPOTHESES not evidence** |

### Citation discipline

Every response that answers a question, retrieves data, makes a recommendation, or describes a change MUST include the source behind it. This applies universally to every skill, workflow, agent, MCP tool result, and bash invocation. No exceptions.

**What counts as a source:**
- MCP tool result: name the tool and arguments. E.g. `mcp__server__csr_read(deloitte, dev, k8s-configs/base/custom-patches.yaml)` at `branch_read=origin/dev`.
- File read: file path + line number(s). E.g. `~/pingcloud/customers/deloitte/cluster-state-repo/k8s-configs/dev/env_vars:42`.
- Git ref: repo + ref + path. E.g. `deloitte/cluster-state-repo` at `origin/dev:k8s-configs/base/custom-patches.yaml`.
- External MCP: the tool. E.g. `mcp__atlassian__searchJiraIssues` (JQL: `project = P1ASSD AND ...`).
- Kubectl/CLI command: exact command + relevant output line(s).
- CLAUDE.md / SKILL.md: the section name. E.g. "per 'Workflow B Phase B1c.5' in CLAUDE.md".
- The user's earlier message: explicit reference. E.g. "you said earlier: '...'".

**What does NOT count:** "Based on conventions" / "typically" / "usually" / "I think". Pre-training knowledge applied to a specific customer-environment fact. A previous turn's answer cited as its own source. Cross-customer patterns as evidence for this customer's state.

### Halt and ask when info is incomplete

If you don't have enough information to construct a correct change or give a cited answer — stop. Do NOT guess. Do NOT use convention-based names without confirmation.

Required response shape when info is missing:
1. State explicitly what is missing and why.
2. Show what you DID find (the partial picture from CSR / platform-repo reads).
3. If the missing info requires the live cluster: provide a **concrete, complete, paste-ready kubectl/tsh/aws command** derived from CSR discoveries — every value (kind, namespace, name, label selector) from something you actually read for this specific customer. No placeholders. No assumed namespaces.
4. If the live cluster can't answer: ask the user a direct question or suggest a file path to paste from.
5. End the turn and wait.

**Forms always rejected:** "Could you run a kubectl command?" (no command), `kubectl get <kind> -n <ns>` with literal placeholders, any command using a namespace not referenced in something you actually read for this customer.

### Cross-customer patterns are hypotheses, not evidence — and forbidden when authoritative sources exist

Cross-customer patterns (from `repo_search` across other customer CSRs) are hypotheses about the shape of an answer — never a substitute for verifying THIS customer's actual state.

**When constructing a patch or other change, do NOT use cross-customer search at all.** Authoritative sources exist for every fact you need (Source-of-Truth matrix above). The order is:
1. THIS customer's CSR (raw files via `csr_read`)
2. THIS customer's microservice values + kustomization files (raw via `csr_read` + `csr_list`)
3. THIS customer's helm-rendered manifest (`csr_render` / `csr_render_resource`)
4. The platform-default render (`csr_render(target='platform')`) or `ping-cloud-base` at THIS customer's `K8S_GIT_BRANCH`
5. Live cluster (read-only) — paste-ready kubectl command for the user to run

If 1–5 all return nothing, halt and ask. **Do not fall through to "let me check what other customers do."**

**Why cross-customer is forbidden, not just discouraged:**

- **Different customers are on different platform versions.** Customer A on v2.1.1 has 5 microservices; customer B on v2.2.0 has 6 (cluster-tools added in v2.2). The schema, resource names, namespaces, and even *which microservice owns the resource* can differ between versions. A pattern from another customer at a different version is structurally untrustworthy.
- **Customers have customer-specific overrides.** Region, tenant domain, ingress class, namespace conventions vary. What another customer's `custom-patches.yaml` contains is shaped by THEIR overrides, not THIS customer's.
- **The user's exact request term may not appear in others' patches.** If the user asks for `large-client-header-buffers` and you find others setting `proxy-buffer-size`, those are different nginx directives. Pattern-matching the resource location does NOT confirm the directive name. Silently substituting one for the other is the bug pattern that produced the wrong answer in production.

**The only valid use of cross-customer search** is when the user EXPLICITLY asks "how do other customers handle X?" — that's an info-retrieval question (Workflow A) about the cross-customer set, not a change-construction step (Workflow B). Even then, cite the cross-customer findings as hypotheses, not as the basis for a proposed change to THIS customer.

**If you find yourself reaching for `repo_search` across customer CSRs while constructing a patch — STOP.** That's the bug. The correct path is the next step in the ordered checklist (microservice files → render → halt-and-ask), never another customer's setup.

### Env-branch awareness

When reading CSR contents for a specific env, the read MUST come from the env's git branch, not from whatever is currently checked out. Env→branch mapping: `dev=dev`, `test=test`, `stage=stage`, `prod=master`, `customer-hub=customer-hub`.

Use `Environment(..., read_only=True)` + `env.read_at_env_branch(<path>)` which uses `git show origin/<env-branch>:<path>` — fast, fresh, never modifies the working tree. Tool responses include a `branch_read` field showing which branch the answer came from. Do NOT use default `Environment(customer, env)` for reads — it runs `git reset --hard origin/<env-branch>` and silently destroys uncommitted local work.

### Repo hygiene — always sync, and verify remote state from the remote

Always sync with the remote before reading or writing. For MCP tool reads: the underlying tools call `ensure_repo_fresh` automatically. For writes (Workflow B): explicitly run `git fetch --all --prune` in Phase B2 before `git checkout -b`. For ad-hoc bash git reads: run `git fetch --all --prune` before reading commits, diffs, file contents, or branch names. Prefer `git fetch` over `git pull` — fetch only updates remote-tracking refs, never modifies the working tree.

**`--prune` is mandatory, not optional.** A bare `git fetch` pulls new refs but does NOT remove local refs for branches deleted on the remote. Without `--prune`, a branch the user already cleaned up still appears in `git branch -a` and `git for-each-ref refs/remotes` — and any claim derived from those commands is based on stale cache, not remote truth.

**Verifying "does this remote thing exist?" — query the remote, not the local cache.** When you need to answer questions like "does this branch exist?", "is this MR already open?", "has this work already been pushed?", "is there a tag for this version?", the source of truth is the remote, queried fresh:

| To check | Use this (fresh remote query) | NOT this (local cache, can be stale) |
|---|---|---|
| Does branch X exist on origin? | `git ls-remote --heads origin <pattern>` | `git branch -a \| grep`, `git for-each-ref` |
| Is there an open MR/PR for this work? | `glab mr list --source-branch <name>` / `gh pr list --head <name>` | git log on the local branch |
| Does this commit exist on origin? | `git ls-remote origin` + grep, or `git fetch --prune` first then check | `git log` on a stale local ref |
| Is the local branch up-to-date with origin? | `git fetch --prune` first, then compare | `git status` without a fresh fetch |

**Forbidden claims without fresh verification:** "the work is already done", "the branch already exists", "the MR is already open", "this has already been pushed", "no changes are needed" — none of these may be asserted unless you ran a fresh `git fetch --prune` (or equivalent remote query) IN THE CURRENT TURN before making the claim. If you find yourself about to say one of these phrases, run the fresh remote query first.

If a tool result shows `remote_fetch` or `branch_read` indicating a fetch failed, surface that to the user — do not silently proceed with stale data.

### Git safety + protected branches

Never run `git commit`, `git push`, `git tag`, `git merge`, `git rebase`, `git reset --hard`, `git revert`, `git push --force`, or any other history-altering or publishing command without an **explicit, message-level approval** from the user in the current turn.

Approval MUST be unambiguous: "commit", "push", "yes commit and push", "go ahead and push". NOT approval: "looks good", "done", "thanks", "okay", "sounds good", a previous approval earlier in the session.

**NEVER push directly to protected branches** — even if the user explicitly approves:
- `dev`, `test`, `stage`, `master`, `customer-hub`, `main`
- any branch matching `v*-release-branch` (e.g. `v2.1-release-branch`)
- any branch matching `v*-dev-branch` (e.g. `v2.1-dev-branch`)

If the user asks to push to any of these: REFUSE. Respond: "Pushing directly to '{branch}' is not allowed. Changes must go through a merge request."

### Approval-gated MCP tools

Never call the `*_confirm` variant of any MCP tool without explicit, in-turn user approval (same standard as Git Safety above). The preview side (`secret_cert_host`, `secret_custom`, `patch_kust`, `patch_custom`, `artifact_upload`, `drift_reconcile`) MAY be called to surface the exact diff/payload — but treat the preview as the terminal output unless the user explicitly says to confirm.

### ArgoCD — never use the CLI

Never use the `argocd` CLI — it requires separate authentication. Use `kubectl get apps -n argocd` (when cluster category is enabled) or, when disabled, generate the command for the user to run.

### Anti-hallucination — cite or don't claim

- **Cite or don't claim.** Every assertion must include (a) the exact MCP tool call + relevant return field/value, or (b) a file path + line number, or (c) a kubectl command + the user-provided output. No inferential leaps from general knowledge to specific customer facts.
- **Empty results are valid evidence.** If a grep / search returns no matches, record the exact command and "no matches" — do not say "not present" without proof.
- **Distinguish Confirmed vs Needs Verification.** When responding with multiple findings, group them: "Confirmed (with source):" vs "Needs verification (cannot confirm from available sources):".
- **Severity tags for change proposals.** When proposing a CSR/cluster change in Phase B1d, tag the diff with severity: SAFE (no consumer impact), CAUTION (affects sync timing or staging only), DANGEROUS (touches prod paths, secrets, or ingress).

### Structured response shape

For any answer longer than 1–2 sentences, use this structure:

```
[Brief answer / proposed plan]

What was checked:
- <source 1: tool/file/command, what was looked up, key result>
- <source 2: ...>
- <source N: ...>

Confidence: HIGH | MEDIUM | LOW
- HIGH: every relevant fact came from an authoritative source per the matrix
- MEDIUM: some facts came from cross-customer patterns or platform defaults; customer-specific verification missing
- LOW: substantial gaps remain; should halt and ask before acting

Sources:
- <inline citations grouped here as a footer>
```

Short factual answers (one sentence) can use inline `(from <source>)` instead. Either way, every fact is sourceable.

---
