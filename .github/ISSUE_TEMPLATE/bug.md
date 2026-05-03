---
name: Bug report
about: A skill, agent, or hook misbehaving
title: "[bug] "
labels: bug
---

## What happened

<!-- One paragraph. Which slash command / agent / hook fired,
what you expected, what you got. -->

## Reproduction

```
# Inside Claude Code:
/<the slash command you ran>
```

## Environment

- Plugin install state (output of `cat ~/.claude/gitops-hook-last-fired.txt`):

  ```
  <paste>
  ```

- gitops-mcp version (`pip show gitops-mcp | grep Version`):
- Claude Code version:
- OS:

## Hypothesis (optional)

<!-- Was this a tool that exists in the upstream gitops-mcp? Did the
SessionStart hook fire? Is your cwd inside a `gitops-mcp init` scaffold? -->
