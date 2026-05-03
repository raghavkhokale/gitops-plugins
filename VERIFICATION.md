# Verification

Final reconciliation for the plugin marketplace.

## CI

The CI workflow at [`.github/workflows/ci.yml`](.github/workflows/ci.yml)
is the per-PR / per-push gate. Five jobs:

| Job | What it checks |
|---|---|
| `shellcheck` | Lints `gitops/hooks/inject-rules.sh` |
| `json-validity` | Parses every JSON manifest |
| `manifest-shape` | Asserts `marketplace.name`, `plugin.name`, `mcp.json` server name + command |
| `skill-frontmatter` | Every `SKILL.md` has parseable frontmatter; `name:` starts with `gitops:`; matches parent dir |
| `no-leaks` | Greps for forbidden brand tokens across the tree, excluding MIGRATION.md + README.md |

## Drills

The plugin install drill is documented upstream in
[`gitops-mcp/scripts/verify/plugin-install-drill.md`](https://github.com/<your-user>/gitops-mcp/blob/main/scripts/verify/plugin-install-drill.md).
Run on every release tag.

## Audit reconciliation

Phase-0 baseline grep (broad pattern, includes substring noise):

```
$ wc -l audit.txt
394 audit.txt
```

Post-Phase-9 high-signal grep (real brand tokens only):

```
$ grep -rIn -E \
    'pingidentity|forgeblocks|p1as_query|p1as_references|p1as-mcp|p1as-cli|P1AS_DISABLED|gitlab\.corp\.pingidentity|deloitte|accor|axa|boeing|centene|gartner' \
    --exclude=audit.txt --exclude-dir=.git . | wc -l
4
```

Where the 4 live (all intentional):

| Location | Count | Why |
|---|---|---|
| `MIGRATION.md` | 3 | The rename map MUST mention the old `p1as_query`, `p1as_references`, etc. — that's its job. |
| `.github/workflows/ci.yml` | 1 | The `no-leaks` job's grep pattern contains the forbidden tokens by name. |

`README.md` references `MIGRATION.md` once but doesn't include the
pattern itself, so the high-signal grep doesn't catch it.

The CI `no-leaks` job runs the same grep against the live tree,
excluding MIGRATION.md and README.md — and fails the build on any
new leak.

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
- [ ] Plugin-install drill walked through manually (see upstream
      `scripts/verify/plugin-install-drill.md`)
