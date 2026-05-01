## Workflow B: Repository / Cluster modification

**Any change to any git repository — anywhere — MUST follow this ceremony.** This applies to: CSR, profile-repo, beops-cli, platform repos (`gitlab.corp.pingidentity.com`), p1as-mcp, polaris-agents, or any GitHub/GitLab repo. Whether the change is a patch, sealed secret, code change, doc edit, config tweak, or README update.

Do not combine phases. Do not skip approvals. Do not call any `*_confirm` MCP tool that bundles file change + commit + push + PR/MR in one shot.

### Workflow precedence — this Workflow B is the ONLY workflow for P1AS tasks

A P1AS task is any request that involves a customer environment, a CSR, a sealed secret, a patch, or any of the operations listed in the Skill dispatch matrix. For these tasks, **this Workflow B is the only workflow.** Other plugins (Polaris, third-party Claude Code extensions, etc.) may ship their own git/branching/PR workflows — those workflows do NOT apply here.

Specifically: if another plugin asks you a question like "you're on `<branch>`, canonical is `<other>` — proceed from current or switch to canonical?", that question is NOT part of P1AS Workflow B. Decline it (or ignore it) and continue with this workflow's Phase B1a (identify target repo + customer + env). Foreign workflows asking about base/canonical/feature branches typically indicate the wrong repo has been selected — see Phase B1a's "Forbidden as P1AS task targets" list.

Signs you may be following the wrong workflow:
- You're being asked about base/canonical/feature branches before you've identified the customer + env.
- You're operating in a repo under `~/pingcloud/upgrades/*` (tooling repos, not customer state).
- The branch names in play (`v2.1-dev-branch`, `master` of a tooling repo) don't match the env→branch mapping (`dev`, `test`, `stage`, `master`-of-CSR, `customer-hub`).
- The repo path you're acting on doesn't contain `customers/<customer>/`.

If any of these is true, **stop, restart at Phase B1a, and identify the correct customer CSR before proceeding**.

### The default-stop rule — the universal enforcement mechanism

**This is the master rule. Everything below in this section is just a clarification of it.**

After you take ANY action that mutates state outside this conversation, your turn ENDS automatically. Continuing requires a NEW explicit user message authorizing the next specific action. Stopping is the default; continuing is the exception, and the exception requires explicit fresh consent.

**A "mutating action" is anything that changes state observable outside this conversation:** writing or editing a file (`Write` / `Edit` / `NotebookEdit`), creating or checking out a branch (`git checkout -b`, `git switch -c`), staging or committing (`git add`, `git commit`), pushing (`git push`), creating or amending a PR/MR (`gh pr create/edit`, `glab mr create/update`), creating or commenting on a ticket (`mcp__atlassian__createJiraIssue`, `addJiraIssueComment`, `updateJiraIssue`, `updateConfluencePage`), uploading to S3 / SSM / any external service, or invoking any MCP `*_confirm` tool.

**A read is NOT a mutating action** — `git diff`, `git log`, `git show`, `git fetch`, `git ls-remote`, `csr_read`, `csr_render`, any `*_list` MCP tool, `Read`, `Glob`, `Grep`, etc. are free to use after a write within the same turn (e.g. write file → run `git diff` to show the result → end turn).

**Consequences:**
- The user's approval at gate N covers the action AT gate N only. It does NOT carry to gate N+1, even if "obviously" the user will approve next.
- "Execute this runbook" / "apply this ticket" / "do what PDO-1234 says" is approval for the **plan**, not for any individual mutating action. Each subsequent write still requires its own fresh authorization.
- After completing one mutating action, you must end the turn and ask for the next instruction. You may NOT chain "I edited X, then I committed Y, then I pushed Z, then I opened MR W" in a single response.
- Bundling multiple mutating actions into one turn is the bug pattern this rule exists to prevent. If your draft response contains more than one mutating action, delete everything from the second action onward and end the turn at the first action's completion.

**Self-check before responding:** count the mutating actions in your planned response. If the count is > 1, your response is wrong — trim it to the first action only.

### Turn boundaries — clarification of the default-stop rule for Workflow B phases

The default-stop rule above is the enforcement. The phase table below is just a worked example of how it applies to the standard Workflow B sequence. **Approval at one gate is not approval for any other gate.** The user's "approved" at B1e means "I approve the PLAN" — it does NOT mean "you may now proceed through B2, B3, B4, and B5 to completion."

The mandatory turn-end gates in Workflow B are:

| After | The turn MUST end and wait for | Prohibited |
|---|---|---|
| **B1e** (plan shown) | User to say "approved" / "looks right" / "go" | Auto-advancing to B2 in the same turn |
| **B2 step 1** (asked about ticket) | User to provide ticket info | Inventing a ticket ID or auto-creating one without confirmation |
| **B2 step 4** (working branch created) | User to say "go ahead with the change" / "make the edit" | Auto-advancing to B3 (writing the file) in the same turn |
| **B3** (file edited locally; `git diff` shown) | User to say "diff looks right" / "approved" | Auto-advancing to B4 (commit/push/MR) in the same turn — even after the diff is shown, no commit happens until the user responds |
| **B4 step 1** (asked "should I commit, push, and create MR?") | User to say "yes commit and push" or equivalent unambiguous instruction | Running `git commit` / `git push` / `glab mr create` without that explicit instruction in the current turn |

**Phrases that indicate you are about to violate this rule** — if you find yourself about to write any of these, STOP and reconsider:

- "I'll proceed through phases B2–B5"
- "I'll create the branch, apply the edit, commit, and push"
- "Now I'll run the full Workflow B"
- "Continuing with the rest of the steps"
- Any "I'll do X, then Y, then Z" where X, Y, Z cross phase boundaries
- "I'll execute the runbook"
- "I'll apply the steps from PDO-1234"
- "I'll follow the Confluence page"
- "I'll make the changes the ticket describes"
- "Now I'll do what the runbook says"

These phrases are bundling. They are forbidden — **including when the user has explicitly said "execute this runbook" or "apply this ticket."** A runbook/ticket specifies *what* to change; it is NOT a delegation of approval authority. The user must still approve at each turn boundary (plan, branch, diff, commit/push). See "'Execute this runbook' is NOT blanket approval" in the Discovery methodology section.

If your response would naturally include one of these phrases, replace it with the next-gate prompt only: "Branch created. Ready to apply the change in Phase B3 — confirm to proceed" (or "Diff shown. Reply 'approved' to commit." for B3, etc.).

A single Workflow B execution typically spans **6–9 assistant turns** with user responses interleaved:

1. (assistant) B1 plan shown → ask "approved?" → END TURN
2. (user) "approved"
3. (assistant) B2 step 1 — ask about existing ticket → END TURN
4. (user) "PDO-1234" (or "create one for me")
5. (assistant) B2 step 4 — branch created → "ready to apply the change in B3 — confirm to proceed" → END TURN
6. (user) "go ahead"
7. (assistant) B3 — edit applied + diff shown → ask "diff approved?" → END TURN
8. (user) "diff approved"
9. (assistant) B4 step 1 — ask "should I commit, push, and create MR?" → END TURN
10. (user) "yes commit and push"
11. (assistant) B4 step 2 — commit + push + MR + return URL

Anything that collapses adjacent assistant turns is bundling. Pattern-match on yourself: if your draft response covers more than one phase boundary, delete it and write only the next gate's prompt.

### Discovery methodology — find the resource in its rendered form, then trace it back (Workflow B Phase B1b)

#### Skip discovery when the user has already done it

The methodology below is for cases where Claude has to **figure out** what to change. If the user has already told you exactly what to change — by giving explicit instructions, pointing at a runbook, or referencing a ticket with detailed steps — **skip the methodology and follow what they said.** The user's own instruction (or an authoritative team runbook they pointed at) is itself a source per the "Citation discipline" rule, frequently more authoritative than what discovery would produce (e.g. the security team has already vetted the exact change).

| User input | What to do |
|---|---|
| Explicit instructions naming the file AND the content (e.g. "edit `<path>` to add `<yaml>`") | Skip discovery. Go straight to Phase B1d (show diff). Cite the user's message as the source. |
| Runbook URL (Confluence page, Jira ticket, file path, pasted runbook text) | **Read the runbook first** via Workflow A (`mcp__atlassian__getConfluencePage`, `mcp__atlassian__getJiraIssue`, `Read` for a local file, etc.). Then evaluate specificity: runbook names file + content → skip discovery, follow it; runbook gives intent only → fall back to discovery for the unspecified bits. |
| Partial specifics (resource named but not the file, or field named but not the full current state) | **Partial discovery** — only the bits the user didn't specify. Don't re-discover what they've already told you. |
| Pure intent (e.g. "increase the Nginx public header size for deloitte dev") | Run the full Discovery methodology below. |

**Even when skipping discovery, still apply the completeness check (B1c.5).** If the user's instructions or runbook is missing something (a namespace, an existing data field that needs preserving, the env-branch to target), halt and ask. "Following instructions" does not license skipping the safety nets — and it does not license bypassing any other Workflow B rule (turn boundaries, ticket+branch, diff approval, commit/push approval all still apply). The user's input controls *what* to change; the workflow still controls *how* to change it.

#### "Execute this runbook" is NOT blanket approval — read this carefully

When the user says "execute this runbook" / "apply the steps from PDO-1234" / "follow this Confluence page" / "do what the ticket says" / "make the changes the runbook describes" — this is approval **only for the high-level intent**, not for any specific Workflow B phase. Each phase (B1e plan, B2 ticket+branch, B3 file write + diff, B4 commit/push/MR) still has its own per-turn gate. The runbook's content is the **specification of what to change**; it is **not a delegation of approval authority** for executing those changes.

Concretely: if the runbook says "edit file X to set Y, then commit with message Z, then push and open an MR against env-branch W" and the user says "execute this runbook," do NOT do all four in one turn. The correct flow is still:

1. Show the plan derived from the runbook (file + content + commit message + target branch + verification steps from the runbook). Cite the runbook URL/ticket as the source. **END TURN, wait for "approved".**
2. Ask about the ticket (use the runbook's ticket if it's the runbook itself; ask if they want to file a new one if not). **END TURN.**
3. Create the working branch + announce it. **END TURN.**
4. Apply the file edit + show `git diff`. **END TURN, wait for "diff approved".**
5. Ask "should I commit, push, and create the MR?" **END TURN.**
6. On explicit "yes commit and push," execute the commit + push + MR; return the MR URL.

A runbook that has been pre-vetted by the team is a great way to make Claude faster (skips the discovery render and the construction guesswork) — but it does not change the per-phase approval requirement. Engineers expect to inspect the diff and explicitly approve the commit/push regardless of whether the change came from their head or from a runbook.

#### Discovery methodology (when no explicit instructions)

Before constructing any change, find the target resource's actual current shape. **Do NOT consult a hardcoded list of file paths** — file names like `custom-patches.yaml`, `values.yaml`, `sealed-secrets.yaml`, `kustomization.yaml`, `env_vars` recur at many nodes in the kustomization graph (base, region, microservice, values-files), and which ones matter depends on the customer's layout and platform version. Use the methodology, not a path list.

**Render-first, BOTH tiers.** For "where is X defined for this customer?" call `mcp__server__csr_render` to render BOTH tiers in one go — the **base kustomize tier** (`target='platform'` — the `k8s-configs/` tree, kustomize-only) AND **all present microservice Helm charts** (each `target='<p1as-microservice>'`, kustomize+helm). The simplest invocation is `csr_render(target='all')` which renders everything present. Both tiers contribute to the customer's deployment; rendering only one tier loses visibility into the other. Search the combined rendered YAML by kind+name. The render is the ground-truth answer to "what shape does X have for this customer at this version?"

**Trace the kustomization graph backward.** When you need to know which input file to EDIT, walk the graph from the kustomization that produced the rendered hit. For platform-tier hits: walk from `<csr>/k8s-configs/<region>/kustomization.yaml`. For microservice-tier hits: walk from `<csr>/p1as-X/<region>/kustomization.yaml` (which declares the helmChart) into its values-files chain. Recursively read each `kustomization.yaml`'s `resources`, `bases`, `components`, `helmCharts`, `patchesStrategicMerge`, `patches`, `configMapGenerator`, `secretGenerator` references. The file that introduces the resource (or overrides the field you want to change) is the edit point.

**Path agnosticism — the rule.** Do NOT assume `custom-patches.yaml` lives only at `k8s-configs/base/`. It can exist at any kustomization-graph node — base, region, microservice directory, values-files chain. Same for `values.yaml`, `sealed-secrets.yaml`, etc. Use graph traversal to find ALL instances; do not consult any hardcoded path list.

**Layout varies by version.** v1.x has no microservices; v2.0+ adds them; the set of present microservices changes between v2.x minors (e.g. v2.1.1 had 5; v2.2.0 added cluster-tools = 6). Determine the layout from the customer's actual filesystem (`csr_list` recursively, or `csr_render` and inspect what got rendered) — never assume.

**The render IS the version-aware truth.** If you can render the customer's CSR at their version and find the resource in the output, you have the definitive answer for THIS customer at THIS version. Cross-customer patterns and pre-training conventions are not a substitute.

**When render is too expensive or fails.** Fall back in this order: (a) walk the kustomization graph and read the input files yourself via `csr_read` / `csr_list`, (b) halt and ask the user for paste-ready kubectl output of the live resource. **Never** fall back to other customers' CSRs — per "Cross-customer patterns are hypotheses" rule.

### Phase B1 — Plan and propose (no changes yet)

#### B1a — Identify target repo + sync with origin

**Repo identification is mandatory, explicit, and the FIRST thing you do.** Before any git command (`git status`, `git fetch`, `git branch`, `git checkout`, anything), you MUST state in your response:

1. **Customer name** (e.g. "deloitte")
2. **Environment** (e.g. "dev")
3. **Exact target repo path** (e.g. `~/pingcloud/customers/deloitte/cluster-state-repo`)

If any of these is unclear from the user's request, **HALT and ask**. Do NOT infer the customer or env from the current working directory. Do NOT walk parent directories looking for "the relevant repo." Do NOT pick a repo because it's the only git repo nearby.

**P1AS task targets are restricted to:**
- A customer cluster-state-repo: `~/pingcloud/customers/<customer>/cluster-state-repo`
- A customer profile-repo: `~/pingcloud/customers/<customer>/profile-repo`
- A platform repo (only when the user has explicitly named it: `ping-cloud-base`, `beops-cli`, etc.)

**Forbidden as P1AS task targets:**
- `~/pingcloud/upgrades/*` — these are tooling/development repos for the p1as-mcp project itself, NOT customer state. They are NEVER the target for a customer-facing patch, secret rotation, or any other Workflow B operation. If the working directory is under `~/pingcloud/upgrades/`, that is not a hint about which customer to act on.
- Any git repo found by walking `..` from the current working directory. The current working directory is irrelevant to P1AS task target selection.

Once the target repo is identified, sync before reading or writing:

```bash
git -C <target-repo-path> fetch --all --prune
```

For MCP tool reads: `Environment(customer, env, ...)` calls `ensure_repo_fresh` automatically — no extra fetch needed. For ad-hoc bash git reads, always `fetch --all --prune` first.

#### B1b — Read actual current state (use the Discovery methodology)

Apply the Discovery methodology defined above to find the target resource's actual current shape and the right edit point. **No hardcoded path lists** — the methodology (render both tiers → search the output → trace the kustomization graph backward) handles version-variance and the multi-location layout. Skill files specialize on the task-specific edit-point heuristic (which kind of edit point is appropriate for this kind of change), not on which paths to read. Never construct from memory or cross-customer patterns.

#### B1c — Construct the change from actual state + user intent

Build the YAML (or code change) based on what you actually read in B1b and what the user wants. For each field in the proposed output, you must be able to trace it to either the user's explicit instruction or something you read in B1b. No guessing. No bundled-template values unless you read the template, adapted every field, and can trace each value.

#### B1c.5 — Verify completeness; halt if missing info

Before writing any YAML, audit your construction:
- Resource kind, name, namespace — confirmed from CSR or platform repo, not guessed?
- All existing data fields captured, so the change won't clobber them?
- Customer-specific naming conventions verified from the discovered CSR / render state — NOT assumed from convention?

If any are unknown or guessed, **STOP**. State what's missing, show what you did find, and provide paste-ready kubectl/tsh commands derived from your CSR discoveries (every value from what you read, no placeholders). End the turn and wait. Per "Cross-customer patterns are hypotheses" rule: never substitute a different field name from another customer's patch and present it as equivalent.

#### B1d — Show diff with sources

Show: (1) current state with citation to the tool call that established it, (2) proposed change with each field traced to user instruction or CSR read, (3) human-readable summary of what specifically changes. Include a severity tag: SAFE (no consumer impact), CAUTION (affects sync timing or staging only), DANGEROUS (touches prod paths, secrets, or ingress).

#### B1e — Get explicit approval

Ask: "Does this plan look right? Reply 'approved' to continue, or tell me what to change." End the turn and wait. If the user wants edits, iterate on B1c–B1d.

### Phase B2 — Ticket and branch

This phase has TWO turn boundaries: one before creating the branch (gather ticket info), one after (announce branch created and stop).

1. Ask: "Is there an existing ticket for this work?" → **END TURN, wait.**
2. After the user provides the ticket info (or asks you to create one):
   - If existing: use the ticket ID as the branch name.
   - If new: use `mcp__atlassian__createJiraIssue` — preview the ticket fields, confirm, create. Use the returned ticket ID as the branch name.
   - If no ticket: use a descriptive slug like `tooling-<short-slug>`.
3. Create the working branch:
   ```bash
   cd ~/pingcloud/customers/<customer>/cluster-state-repo
   git fetch --all --prune
   git checkout -b <branch-name> origin/<env-branch>
   ```
4. Report: "Branch `<branch-name>` created on top of `origin/<env-branch>`. Ready to apply the change in Phase B3 — confirm to proceed." → **END TURN, wait.** Do not advance to B3 in the same turn.

### Phase B3 — Apply change locally (Edit/Write tool, never `*_confirm`)

Triggered only after the user confirms in response to the B2 "ready to proceed" prompt.

1. Write the change to the local working tree using the `Edit` (surgical changes) or `Write` tool. Do NOT call `mcp__server__patch_*_confirm` or `mcp__server__secret_*_confirm` — those bundle write + commit + push + MR, violating this workflow.
2. Run `git diff` and show the full output.
3. Ask: "Does this diff look right? Reply 'approved' to commit, or tell me what to change." → **END TURN, wait.** Do not commit, do not push, do not create the MR in the same turn — even if the diff "obviously" looks right.

If the user wants edits, return to step 1 (re-edit, show new diff, ask again).

### Phase B4 — Commit, push, PR/MR (get explicit approval)

Triggered only after the user approves the diff in response to the B3 prompt. Note: the previous numbering had B4 as a separate "diff review" gate and B5 as the commit gate; these are now consolidated — B3 shows the diff and asks for approval, B4 is the commit/push/MR execution gate.

1. After diff approval, ask: "Should I commit, push, and create a merge request?" → **END TURN, wait.**
2. On explicit "yes commit and push" or equivalent unambiguous instruction (NOT "looks good" / "okay" / "thanks"):

```bash
git add <changed-file>
git commit -m "<TICKET-ID>: <one-line summary> for <Customer> <Env>"
git push -u origin <branch-name>
glab mr create --title "<TICKET-ID>: <summary>" \
               --description "Refs <TICKET-ID>" \
               --target-branch <env-branch> \
               --source-branch <branch-name>
```

Return the MR URL. For GitHub repos: use `gh pr create` instead.

