---
name: p1as:rotate-secrets
description: Rotate sealed secrets (cert-host or custom) for a customer environment. Specialization of CLAUDE.md Workflow B for secret rotation.
when_to_use: |
  Trigger when the user wants to rotate secrets or certs, mentions an expiring certificate, or wants to
  create/update a sealed secret. Signals: "rotate secrets", "expiring cert", "renew TLS", "secret rotation",
  "cert-host", "create sealed secret", "kubeseal".
---

# /p1as:rotate-secrets

Specialization of CLAUDE.md **Workflow B: Repository / Cluster modification** for secret rotation. Follow Workflow B in full (phases B1a–B5) — this file documents only the secret-specific edit-point heuristic and the kubeseal preview path.

**Input:** Customer, env, and a description of the rotation. E.g. "rotate cert-host secret for deloitte-dev with new cert at /tmp/cert.pem and key at /tmp/key.pem", "create custom sealed secret named foo-bar in deloitte-test with value X".

---

## Phase B1b — discovery

Use the **Discovery methodology** in CLAUDE.md (Workflow B). For sealed secrets, the resource you're looking for is `kind: SealedSecret` with the relevant name (and any consumer references — Ingresses, Deployments — that point at the secret name). The methodology (render both tiers → search by kind+name → trace the graph backward) finds where the secret currently lives AND any resources that consume it. No hardcoded paths.

**First check the "Skip discovery when the user has already done it" rule** (top of the methodology section). If the user has provided explicit instructions or a runbook (e.g. "create a sealed secret named X in namespace Y from cert at /tmp/cert.pem"), skip the discovery and follow what they said. Don't render the manifest if the user has specified the secret name, namespace, and source material.

---

## Phase B1c — edit-point heuristic for secrets + kubeseal preview

**Edit point** comes from the graph traversal:
- If the customer already has a SealedSecret of this name in the CSR, the new sealed value replaces it in the file the traversal identified.
- If creating a net-new SealedSecret, place it at the kustomization-graph node that owns secrets for this resource — the graph tells you which node by showing where the consumer (Ingress, Deployment, etc.) is included.

**Build the SealedSecret YAML:**
- **TLS cert-host:** SealedSecret with the user-provided cert/key + metadata (name, namespace, hosts) matching the customer's ingress shape from the discovery output.
- **Custom:** SealedSecret with user-provided data + metadata matching namespace/label conventions from the discovery output.

You MAY call `mcp__server__secret_cert_host` / `mcp__server__secret_custom` to produce a kubeseal-rendered preview. Treat as a draft — validate all metadata against the discovered customer state before presenting. Discard the `execution_id`; Phase B3 writes via `Edit`/`Write`, NOT via `*_confirm`.

---

## Phase B1c.5 — completeness check (per CLAUDE.md "Halt and ask")

- Target secret name and namespace confirmed from CSR / render — not guessed from convention?
- Consumer references identified, so the change won't break a consumer?
- For cert-host: hostnames covered by the new cert match what the discovered ingress expects?

If any are unknown, STOP. Derive paste-ready kubectl commands from your discoveries (every value from what you actually read, no placeholders).

---

## Phase B3 (apply locally + diff + approve) — secret specifics

Use `Write` for net-new SealedSecret files or `Edit` for multi-document YAML files (insert/replace the specific document, not overwrite the whole file). Do NOT call `mcp__server__secret_cert_host_confirm` or `mcp__server__secret_custom_confirm` — those bundle write+commit+push+MR and violate Workflow B.

After writing: run `git diff`, show output, ask "Does this diff look right? Reply 'approved' to commit, or tell me what to change." **END TURN, wait.** Per CLAUDE.md "Turn boundaries", this is a mandatory turn boundary.

---

## Multi-secret rotation

If the user wants to rotate multiple secrets: run phases B1–B3 once per secret on the SAME working branch (one ticket, one branch). Bundle all writes into a single commit at B4, with a message listing all rotated secrets. Single MR for the bundle.

## Out of scope

This skill does NOT verify the live cluster sees the new secret — that requires `secret_reconcile` from the `cluster` category, which is currently disabled. After MR is merged, the user confirms sync via their own `kubectl get sealedsecrets`.
