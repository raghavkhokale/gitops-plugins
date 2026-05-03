# Contributing to gitops-plugins

This repo is mostly a **build artifact** of [gitops-mcp](https://github.com/raghavkhokale/gitops-mcp).
Most files in `gitops/skills/` are auto-generated from the upstream
package's MCP-tool docstrings. Hand-editing those files is a
short-lived patch — the next release will overwrite them.

## What's hand-edited vs auto-generated

**Hand-edit these:**
- `.claude-plugin/marketplace.json` — marketplace manifest
- `gitops/.claude-plugin/plugin.json` — plugin manifest
- `gitops/.mcp.json` — MCP server registration
- `gitops/agents/secrets.md` — specialist agent
- `gitops/hooks/inject-rules.sh` — SessionStart hook
- `gitops/hooks/hooks.json` — hook registration
- `gitops/skills/{do,patch,rotate-secrets,resume,feedback}/SKILL.md` —
  workflow skills (specialize Workflow B for specific tasks)
- `README.md`, `MIGRATION.md`, `RELEASE.md`

**Don't hand-edit these — they get clobbered on release:**
- `gitops/skills/<operation-skill>/SKILL.md` — anything that's a 1:1
  wrapper of an MCP tool (e.g. `tenant-list`, `config-read`,
  `secret-cert-host`, etc.). To change one of these, edit the
  corresponding tool's docstring in `gitops-mcp/gitops_mcp/server.py`,
  run `make skills` upstream, and resync here.

## Local sync from gitops-mcp

For pre-release validation:

```bash
# in gitops-mcp clone:
make skills
# in gitops-plugins clone:
rm -rf gitops/skills
cp -R ../gitops-mcp/build/skills gitops/skills
git diff --stat   # inspect what changed
```

## Testing the plugin locally

```bash
# Inside Claude Code (CLI or VS Code), from any project:
/plugin marketplace add /absolute/path/to/this/repo
/plugin install gitops@gitops-plugins
# Restart Claude Code, then verify the SessionStart hook ran:
cat ~/.claude/gitops-hook-last-fired.txt
```

## Adding a new workflow skill

Workflow skills (`do`, `patch`, …) specialize Workflow B for a
specific task. They live under `gitops/skills/<name>/SKILL.md` and
are NOT regenerated. To add one:

1. Pick a name; create `gitops/skills/<name>/SKILL.md` with frontmatter:
   ```yaml
   ---
   name: gitops:<name>
   description: <one-line description>
   when_to_use: |
     <trigger conditions>
   ---
   ```
2. Body should reference Workflow B in CLAUDE.md (the user's project
   root, not this repo) for the canonical phase definitions. Skills
   specialize phases; they don't redefine them.
3. If the skill needs MCP tools that don't exist yet, add the tool
   in `gitops-mcp` first.

## CI

GitHub Actions runs:
- JSON-schema validation on `marketplace.json` + `plugin.json` +
  `.mcp.json`.
- `shellcheck` on `gitops/hooks/inject-rules.sh`.

See [.github/workflows/ci.yml](.github/workflows/ci.yml).

## License

By contributing, you agree your contribution is licensed under
[Apache-2.0](LICENSE).
