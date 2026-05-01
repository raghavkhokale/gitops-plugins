# p1as-claude-plugins

The Claude Code plugin marketplace for the **P1AS Platform** — distributes the `/p1as:*` skill catalog, `@"p1as:* (agent)"` specialist agents, and the `mcp__server__*` tool surface to every engineer's Claude Code session, available from any working directory.

## What it does

This repo packages the AI-facing surface of [`p1as-mcp`](https://github.com/ping-internal/p1as-mcp) as a Claude Code plugin marketplace. After installation, every Claude Code session — from any directory, not just inside the `p1as-mcp` repo — has access to:

- **Skills** under `/p1as:*` — currently active: 5 workflow skills (`do`, `patch`, `rotate-secrets`, `resume`, `feedback`), ~26 auto-generated operation skills (one per active MCP tool), and 1 reference skill (`jira-context`) that auto-loads p1as-specific Atlassian context. Additional skills become available when their parent category is enabled.
- **Specialist agents** addressable as `@"p1as:secrets (agent)"` (additional agents become available when their parent category is enabled — see [source repo's Feature gates section](https://github.com/ping-internal/p1as-mcp#feature-gates--enabling-and-disabling-categories)).
- **The `p1as` MCP server registration** — points at the locally-installed `p1as-server` binary so all `mcp__server__*` tools are available.

**This repo is a build artifact.** The skills, agents, and `.mcp.json` here are mirrored from `p1as-mcp/.claude/skills/`, `p1as-mcp/.claude/agents/`, and `p1as-mcp/.mcp.json` by `scripts/build-plugin.sh` in the source repo. The mirror runs automatically on each tagged release of `p1as-mcp`.

```
p1as-claude-plugins/
├── .claude-plugin/
│   └── marketplace.json     # Marketplace catalog: lists the p1as plugin
└── p1as/                     # The plugin
    ├── .claude-plugin/
    │   └── plugin.json       # Plugin manifest (name, version, repository)
    ├── skills/               # mirrored skill folders (count varies by which categories are enabled)
    ├── agents/               # mirrored agent files (count varies by which categories are enabled)
    └── .mcp.json             # Mirrored MCP server registration
```

## Architecture — where this fits in the bigger picture

This repo is **one of three pieces** that together deliver p1as-mcp to engineers:

```
┌──────────────────────────────────────────────────────────────────────┐
│ ping-internal/p1as-mcp                                            │
│   • Python source (~17K LOC) — MCP server, CLI, tools/, utils/       │
│   • Source-of-truth for skills (.claude/skills/) and agents          │
│   • Source-of-truth for the .mcp.json that registers p1as-server     │
│   • CI on tag push: builds wheel, runs scripts/build-plugin.sh       │
└────────────────────────────┬─────────────────────────────────────────┘
                             │
                             │ scripts/build-plugin.sh mirrors
                             │ .claude/{skills,agents} + .mcp.json
                             ▼
┌──────────────────────────────────────────────────────────────────────┐
│ ping-internal/p1as-claude-plugins  ← YOU ARE HERE                 │
│   • Marketplace catalog + plugin manifest                            │
│   • Mirrored skills, agents, .mcp.json (build artifact)              │
│   • Engineers install via /plugin marketplace add + /plugin install  │
└────────────────────────────┬─────────────────────────────────────────┘
                             │
                             │ /plugin install pulls into engineer's
                             │ Claude Code session
                             ▼
┌──────────────────────────────────────────────────────────────────────┐
│ Engineer's Claude Code (any directory)                               │
│   • /p1as:* slash commands                                           │
│   • @"p1as:* (agent)" specialists                                    │
│   • mcp__server__* MCP tools (calls into p1as-server binary,         │
│     installed separately via pipx)                                   │
└──────────────────────────────────────────────────────────────────────┘
```

**Two-artifact distribution:**
- **Python package** — `pipx install "git+ssh://git@github.com/ping-internal/p1as-mcp.git"` puts `p1as-server`, `p1as`, `p1as-cli` binaries on PATH. Required.
- **Claude Code plugin** — `/plugin install p1as@p1as-claude-plugins` registers the skills, agents, and points at the `p1as-server` binary. Required for the AI surface.

The plugin without the binary is non-functional (skills can't call MCP tools that don't exist). The binary without the plugin still works as an MCP server for any MCP-aware client and as a CLI — Claude Code engineers just lose the curated UX.

## How to set up

**Prerequisites:**
- Claude Code CLI installed and on `$PATH` — `which claude`
- `p1as-mcp` installed — `pipx install "git+ssh://git@github.com/ping-internal/p1as-mcp.git"` (the plugin's `.mcp.json` calls the `p1as-server` binary that pipx installs)
- Configured GitHub SSH key

**Two commands — once, ever:**

```bash
claude
> /plugin marketplace add git@github.com:ping-internal/p1as-claude-plugins.git
> /plugin install p1as@p1as-claude-plugins
```

After install, restart Claude Code. You should see the `p1as` plugin connected in the MCP server list (run `/mcp` to verify) and all `/p1as:*` skills appear in `/` autocomplete.

**Updates** are automatic on each Claude Code restart. To force an update:

```
/plugin marketplace update p1as-claude-plugins
```

## What the engineer needs to do

**Day-to-day usage** (works from any directory):

- **Type a slash command** — `/p1as:patch <customer> <env>`, `/p1as:rotate-secrets`, `/p1as:do <natural-language-prompt>`, etc.
- **Or just describe what you want** — Claude auto-loads the right skill from intent. "What known gotchas does deloitte have?" loads `customer-gotchas`. "List customers in eu-central" loads `customer-list`.
- **Address a specialist agent** for isolated heavy work — `@"p1as:secrets (agent)" list sealed secrets in deloitte-dev and flag any expiring soon`.
- **Read-only by policy** — the AI surface does not execute mutations. For destructive operations, Claude will produce the exact command for you to run yourself. See [`p1as-mcp/CLAUDE.md`](https://github.com/ping-internal/p1as-mcp/blob/main/CLAUDE.md) for the full safety rules.

**If something breaks:**

- `/mcp` to check whether the `p1as` server is connected. If it shows failed, the underlying `p1as-server` binary likely isn't on `$PATH` — check with `which p1as-server`. If missing, `pipx install` again per the setup section.
- `claude --debug` in a separate terminal to see MCP startup errors verbatim.
- If a skill behaves unexpectedly, the source-of-truth lives in `p1as-mcp/.claude/skills/<name>/SKILL.md` — file an issue against `p1as-mcp`, not against this repo.

## Examples

**Auto-loaded skill — describe what you want, no slash command:**

```
> what known gotchas does deloitte have?
> list customers in eu-central
> show me current patches in deloitte-dev
> what sealed secrets exist in deloitte-test?
```
Claude reads each skill's `description` and `when_to_use`, picks the right one, calls the underlying MCP tool. No memorization required.

**Explicit slash command — when you know what you want:**

```
/p1as:patch deloitte dev
/p1as:rotate-secrets deloitte dev
/p1as:feedback the docs-search skill returned a stale page for FOO
/p1as:resume
```

**Specialist agents — isolated heavy work:**

```
@"p1as:secrets (agent)" list sealed secrets in deloitte-dev and flag any expiring in the next 30 days
```
The agent runs in its own context window. Returns a focused summary; the underlying detail never enters your main session.

**The router — when you don't know which skill fits:**

```
/p1as:do show me the latest known issues for deloitte-dev and tell me if there's an existing Jira ticket
```
The `do` skill classifies the prompt and dispatches to the right combination of skills (e.g. `customer-gotchas` for known issues + Polaris's Atlassian MCP for Jira correlation + a summary at the end).

**Destructive ops — Claude generates, you run:**

```
> rotate the cert-host secret for deloitte-dev with the new cert in /tmp/new-cert.pem
```
Claude will NOT execute the rotation. It produces the exact `p1as` CLI command in a fenced code block for you to copy and run yourself. The AI surface is read-only by policy.

**Resuming an investigation across sessions:**

```
/p1as:resume
```
Picks up any interrupted multi-step skill from where it left off (30-min TTL on staged state).

## How to contribute

**Don't edit this repo directly.** All skill, agent, and `.mcp.json` content is mirrored from `p1as-mcp` on each release — manual edits here will be overwritten on the next release.

**To change a skill, agent, or MCP server registration:**

1. Open a PR against [`p1as-mcp`](https://github.com/ping-internal/p1as-mcp). The full extension guide (with templates and examples for each kind of artifact) lives in that repo's [README — How to contribute](https://github.com/ping-internal/p1as-mcp#how-to-contribute) section.
2. Quick reference for where each thing lives in `p1as-mcp`:

   | What you want to change | Where to edit | Hand-written or generated? |
   |---|---|---|
   | **Workflow skill** (`/p1as:patch`, `/p1as:rotate-secrets`, `/p1as:do`, etc.) | `.claude/skills/<name>/SKILL.md` | Hand-written |
   | **Operation skill** (1:1 wrapper around an MCP tool) | Edit the tool's docstring in `p1as/server.py`, re-run `python scripts/gen-operation-skills.py` | Auto-generated |
   | **Operation skill richer body** | `.claude/skills/_overrides/<skill-name>.override.md` (merged in by the generator) | Hand-written |
   | **Reference skill** (auto-loaded context like `jira-context`) | `.claude/skills/<name>/SKILL.md` | Hand-written |
   | **Specialist agent** | `.claude/agents/<name>.md` | Hand-written |
   | **A new MCP tool** | Add to `p1as/tools/<category>.py`, register in `p1as/server.py` with `@mcp.tool()` decorator | Hand-written |
   | **MCP server config** (servers, env vars) | `.mcp.json` directly | Hand-written |
   | **Project context** Claude reads on session start | `CLAUDE.md` directly | Hand-written |
   | **Bash allowlist** | `.claude/settings.json` directly | Hand-written |

3. Run `make test` in `p1as-mcp` to verify nothing breaks.
4. After merge, the next tagged release auto-mirrors changes here via `scripts/build-plugin.sh`.

**The only things edited directly in this repo:** the marketplace and plugin manifest schemas (`.claude-plugin/marketplace.json` and `p1as/.claude-plugin/plugin.json`) and this README. The `version` field in `plugin.json` is updated automatically by `scripts/build-plugin.sh` to match `p1as-mcp`'s `setup.py` version — don't edit it by hand.

**Adding a new plugin to this marketplace** (future):

1. Create a sibling top-level directory next to `p1as/` (e.g., `p1as-upgrade-assistant/`) with the same internal layout (`.claude-plugin/plugin.json`, `skills/`, `agents/`, `.mcp.json`).
2. Add an entry to the `plugins` array in `.claude-plugin/marketplace.json` with `name`, `description`, `version`, `source: ./<dir>`.
3. If the new plugin is mirrored from a source repo, add a corresponding `build-plugin.sh` in that repo and update its CI to push here.

## See also

- [`p1as-mcp`](https://github.com/ping-internal/p1as-mcp) — the source-of-truth repo that produces this marketplace's content
- [Claude Code plugin marketplace docs](https://docs.claude.com/en/docs/claude-code/plugins) — schema reference for `marketplace.json` and `plugin.json`
