<!-- One sentence describing what this PR does. -->

## What changed

<!-- Bullet points. -->

## Why

## Source-of-truth check

- [ ] If this PR touches `gitops/skills/<operation-skill>/SKILL.md`
      for an auto-generated skill (anything that's a 1:1 wrapper of
      a `mcp__gitops__*` tool), the change really belongs upstream
      in [gitops-mcp](https://github.com/<your-user>/gitops-mcp)
      as a docstring edit. Confirm the upstream PR or open one.
- [ ] If this PR touches workflow skills (`do`, `patch`, …), the
      agent (`secrets.md`), the SessionStart hook, or the manifests,
      it's hand-edited surface and lives here.

## Test plan

- [ ] `shellcheck gitops/hooks/inject-rules.sh` clean (run by CI)
- [ ] All JSON manifests parse + name-shape sanity checks pass
      (run by CI)
- [ ] No company-brand tokens introduced (run by CI's `no-leaks` job)
