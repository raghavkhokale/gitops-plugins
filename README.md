# gitops-plugins

The Claude Code plugin marketplace for [`gitops-mcp`](https://github.com/<your-user>/gitops-mcp) — distributes the `/gitops:*` skill catalog, `@"gitops:secrets (agent)"` specialist agent, and the `mcp__gitops__*` tool surface to every Claude Code session, available from any working directory.

## What it does

This repo packages the AI-facing surface of `gitops-mcp` as a Claude Code plugin marketplace. After installation, every Claude Code session — from any cwd, not just inside a project tree — has access to:

- **Skills** under `/gitops:*` — workflow skills (`do`, `patch`, `rotate-secrets`, `resume`, `feedback`) plus 42 auto-generated operation skills (one per `@mcp.tool()` in the server). Skills are 1:1 mirrors of MCP tool docstrings; the source of truth is `gitops-mcp/gitops_mcp/server.py`.
- **Specialist agents** addressable as `@"gitops:secrets (agent)"` for sealed-secret discovery + planning. The agent enforces the same Workflow B ceremony defined in your project's `CLAUDE.md`.
- **MCP tools** registered as `mcp__gitops__<tool>` — the `gitops` prefix comes from `.mcp.json`'s server name; the actual tool implementations live in `gitops-mcp` and are invoked via the `gitops-mcp-server` binary that ships with the `gitops-mcp` Python package.

## Source-of-truth relationship

```
gitops-mcp (Python package)         gitops-plugins (this repo)
├── gitops_mcp/server.py        ──> gitops/skills/<name>/SKILL.md
│   (@mcp.tool() decorators)        (auto-generated; 1:1)
└── build/skills/               ──> gitops/skills/
    (`make skills` output)          (sync target — see RELEASE.md)
```

This repo is largely **a build artifact** — releases of `gitops-mcp` regenerate skills and push them here. Hand-edit only the workflow skills (`gitops/skills/{do,patch,rotate-secrets,resume,feedback}/`), the agent (`gitops/agents/secrets.md`), the SessionStart hook (`gitops/hooks/inject-rules.sh`), and the manifests (`.claude-plugin/marketplace.json`, `gitops/.claude-plugin/plugin.json`, `gitops/.mcp.json`). Auto-generated skill files for `mcp__gitops__*` operations get clobbered by every release.

## Prerequisites

1. **Install `gitops-mcp`** — the plugin invokes `gitops-mcp-server` from your shell:
   ```bash
   pipx install gitops-mcp
   gitops-mcp --help    # verify it's on PATH
   ```
2. **Scaffold a project** — Claude Code's `CLAUDE.md` auto-load expects the four `claude-*.md` files at the project root. Generate them via:
   ```bash
   gitops-mcp init my-gitops-project
   cd my-gitops-project
   ```
   The init step writes `gitops.yaml` (your config), `.mcp.json` (Claude Code MCP registration), `CLAUDE.md` + four imports, and `tenants/` + `docs/runbooks/` placeholder dirs.

## Install the plugin

Inside Claude Code (CLI or VS Code extension), from any project:

```
/plugin marketplace add git@github.com:<your-user>/gitops-plugins.git
/plugin install gitops@gitops-plugins
```

Then restart your Claude Code session — the SessionStart hook fires and stamps a verification token at `~/.claude/gitops-hook-last-fired.txt`. Confirm the hook ran by asking: *"What's the gitops-mcp verification token from the SessionStart preamble?"*

## Workflow

The plugin enforces two patterns defined in detail in your project's `CLAUDE.md`:

- **Workflow A** — info retrieval (read-only). Pick the right source per the source-of-truth matrix, retrieve via the cheapest authoritative path, cite every fact, halt if information is incomplete.
- **Workflow B** — repo modification. Plan → ticket+branch → local edit → diff approval → commit/push/PR, with a per-turn user-approval gate at each phase. Never bundles mutating actions.

Cluster mutations are forbidden permanently — when the user asks for one, the response is a paste-ready command for them to run themselves, never an execution.

## Common commands

In any Claude Code session inside a project tree:

> /gitops:do show me the latest patches applied to tenant-a dev
>
> /gitops:rotate-secrets — the cert-host TLS for tenant-b prod is expiring next week
>
> /gitops:patch tenant-a dev — increase the nginx large-client-header-buffers
>
> @"gitops:secrets (agent)" list sealed secrets in tenant-a-dev and flag any expiring in 30 days

## Updating

Release flow lives in [RELEASE.md](RELEASE.md). The short version: a tag push on `gitops-mcp` (e.g. `v0.3.0`) regenerates this repo's skills via `make skills` in `gitops-mcp` and pushes the result here at the same tag. Plugin consumers re-pull via `/plugin update gitops@gitops-plugins`.

## Layout

```
.
├── .claude-plugin/
│   └── marketplace.json     # Plugin marketplace manifest
├── gitops/
│   ├── .claude-plugin/
│   │   └── plugin.json      # Plugin manifest
│   ├── .mcp.json            # MCP server registration (points at gitops-mcp-server)
│   ├── agents/              # Specialist agents (hand-written)
│   │   └── secrets.md
│   ├── hooks/               # SessionStart hook (verification preamble)
│   │   ├── hooks.json
│   │   └── inject-rules.sh
│   └── skills/              # Operation skills (1:1 with MCP tools, auto-generated)
│       ├── tenant-list/SKILL.md
│       ├── config-read/SKILL.md
│       └── ...
├── README.md                # this file
└── LICENSE
```

## License

[Apache-2.0](LICENSE).
