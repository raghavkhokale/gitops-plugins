# Verification

Per-PR / per-push gate for the plugin marketplace.

## CI

The CI workflow at [`.github/workflows/ci.yml`](.github/workflows/ci.yml)
runs five jobs:

| Job | What it checks |
|---|---|
| `shellcheck` | Lints `gitops/hooks/inject-rules.sh` |
| `json-validity` | Parses every JSON manifest |
| `manifest-shape` | Asserts `marketplace.name`, `plugin.name`, `mcp.json` server name + command |
| `skill-frontmatter` | Every `SKILL.md` has parseable frontmatter; `name:` starts with `gitops:`; matches parent dir |
| `no-leaks` | Greps for forbidden brand tokens across the tree |

## Drills

The plugin install drill is documented upstream in
[`gitops-mcp/scripts/verify/plugin-install-drill.md`](https://github.com/<your-user>/gitops-mcp/blob/main/scripts/verify/plugin-install-drill.md).
Run on every release tag.

## Pre-release checklist

Before tagging a new release matching a `gitops-mcp` tag:

- [ ] `gitops-mcp`'s `make skills` was just run — `build/skills/`
      reflects current upstream tool docstrings
- [ ] Skills synced into this repo: `rm -rf gitops/skills && cp -R
      ../gitops-mcp/build/skills gitops/skills`
- [ ] Version bumped to match the upstream tag in
      `.claude-plugin/marketplace.json` and
      `gitops/.claude-plugin/plugin.json`
- [ ] CI green (all 5 jobs)
- [ ] Plugin-install drill walked through manually
