# Migrating from `p1as-claude-plugins`

This repo replaces the internal `p1as-claude-plugins` marketplace. The relationship to its predecessor is **rename + reshape**, not an in-place upgrade — pre-existing installs will not auto-update because every identifier in the install manifest changed.

## Migration in one shot

Inside Claude Code, from any project:

```
/plugin uninstall p1as@p1as-claude-plugins
/plugin marketplace remove p1as-claude-plugins

/plugin marketplace add git@github.com:<your-user>/gitops-plugins.git
/plugin install gitops@gitops-plugins
```

Then restart Claude Code. Verify the SessionStart hook fired by asking:

> What's the gitops-mcp verification token from the SessionStart preamble?

The answer should be a `YYYYMMDD-HHMMSS-<pid>` string also visible at `~/.claude/gitops-hook-last-fired.txt`.

## What changed (rename map)

| Old | New |
|---|---|
| Marketplace `p1as-claude-plugins` | `gitops-plugins` |
| Plugin `p1as` | `gitops` |
| MCP server name `server` | `gitops` |
| MCP server command `p1as-server` | `gitops-mcp-server` |
| Env var `P1AS_DISABLED_CATEGORIES` | `GITOPS_DISABLED_CATEGORIES` |
| Skill prefix `/p1as:` | `/gitops:` |
| Tool prefix `mcp__server__` | `mcp__gitops__` |
| Sentinel file `~/.claude/p1as-hook-last-fired.txt` | `~/.claude/gitops-hook-last-fired.txt` |

## Renamed MCP tools (auto-aliased for one minor release)

The Python package `gitops-mcp` ships a backward-compat shim
(`gitops_mcp/_compat.py`) that registers the old names alongside the new
ones with a `DeprecationWarning`. So skill files referencing the old names
keep working; users see a deprecation message in their audit log.

| Old tool | New tool |
|---|---|
| `customer_info` | `tenant_info` |
| `customer_list` | `tenant_list` |
| `customer_envs` | `tenant_envs` |
| `customer_gotchas` | `tenant_gotchas` |
| `csr_read` | `config_read` |
| `csr_list` | `config_list` |
| `csr_render` | `config_render` |
| `csr_render_resource` | `config_render_resource` |
| `p1as_query` | `org_query` |
| `p1as_references` | `references` |

## Breaking: per-project context replaces global CLAUDE.md copy

The old `p1as-claude-plugins` SessionStart hook copied
`CLAUDE.md` (and the four imports) into `~/.claude/CLAUDE.md`, so
the rules applied globally regardless of your cwd.

The new hook does NOT do this. Instead, the user's project tree —
scaffolded by `gitops-mcp init` — has `CLAUDE.md` and the four
`claude-*.md` files at its root, and Claude Code auto-loads them
per-project. This is the right shape for an OSS tool that any number
of projects might use simultaneously.

If you don't see the workflow rules in your session context, it's
because your cwd is not inside a `gitops-mcp init` scaffold. Run
`gitops-mcp init` first.

## Breaking: project-specific config

`p1as-claude-plugins` worked anywhere because everything was
P1AS-flavored — Jira projects (P1ASSD, PDO), GitLab corp host,
Confluence ST space, Teleport proxy, S3 buckets, and tenant-data
source were all hardcoded.

`gitops-plugins` works against whatever is configured in your project's
`gitops.yaml`. Backends (git host, CD system, identity, tickets, docs,
artifacts) are all pluggable per-org via `gitops-mcp init`. See the
gitops-mcp README for the full schema.

## Cleanup

The old workflow files used to ship inside the plugin:

```
gitops/CLAUDE.md
gitops/claude-workflow-a.md
gitops/claude-workflow-b.md
gitops/claude-universal-rules.md
gitops/claude-reference.md
```

They are gone from this repo (Phase 7 of the OSS refactor). The
authoritative versions are now Jinja2 templates in `gitops-mcp` at
`gitops_mcp/config/templates/claude/`, rendered into your project tree
with your config substituted at `gitops-mcp init` time.
