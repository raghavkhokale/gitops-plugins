# p1as-mcp — Claude Code Context

`p1as-mcp` is the platform toolbelt for **PingOne Advanced Services (P1AS)** — the team that manages GA, field, and preview customer Kubernetes environments running on top of Ping Identity's Beluga platform. It exposes all platform workflows through an MCP server (`p1as-server`) so Claude Code sessions get typed, audited, approval-gated tools without any raw shell access.

This tool does NOT do: **live cluster mutations of any kind, ever** (read-only forever — see "Cluster mutations are NEVER permitted" rule below); raw shell mutations; bulk-cross-customer operations; or anything that bypasses the step-by-step approval ceremony. The sanctioned path for changes that affect live cluster state is via CSR + ArgoCD (Workflow B writes to the CSR; ArgoCD syncs).

---

## The two task types

Every engineer request falls into one of two categories:

**Info retrieval** — the user wants a fact, answer, or investigation result. No changes to any repo or cluster. Examples: "what version is deloitte on?", "what gotchas does acme have?", "list secrets in foo-bar dev". Use **Workflow A**.

**Repository modification** — the user wants to change state in a git repo (CSR, profile-repo, p1as-mcp, etc.). Examples: "add a custom patch for deloitte dev", "rotate the cert-host secret for acme prod" (these all become CSR changes). Use **Workflow B**.

**Cluster modification requests are NOT a valid task type for this tool** — see the "Cluster mutations are NEVER permitted" hard rule below. When the user asks for a cluster mutation, the response is a recommendation + paste-ready command/script for the user to run themselves, NEVER an execution.

**How to tell them apart:** if the request uses a change verb (add, update, rotate, apply, create, set, remove), it's a modification. If it uses an inquiry verb (show, list, what, find, check, get), it's info retrieval. Rare hybrid: the user asks a question whose answer leads directly to a proposed change ("should we increase the buffer size?" → info retrieval first; if they say "yes do it", pivot to Workflow B).

---

## Detailed sections (loaded via @-imports)

The full rules and reference data are split into the four files below, each loaded via Claude Code's `@`-import mechanism. Splitting keeps the top-level `CLAUDE.md` small enough to avoid the "large CLAUDE.md" performance warning while preserving every rule.

@./claude-workflow-a.md

@./claude-workflow-b.md

@./claude-universal-rules.md

@./claude-reference.md
