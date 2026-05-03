# Security policy

## Reporting a vulnerability

For security issues in this plugin marketplace — a malicious skill
that evades CI's no-leak grep, a hook that executes untrusted input,
an MCP-tool prefix collision that lets one plugin shadow another,
etc. — **please do not open a public GitHub issue.**

Open a **private security advisory** on this repository
(GitHub → Security → Advisories → "Report a vulnerability") with:

- A description of the issue.
- Steps to reproduce.
- Plugin version (from `gitops/.claude-plugin/plugin.json`).
- Any suggested fix.

Acknowledgment within 5 business days; initial assessment within 14.
Disclosure timing coordinated with the reporter.

## Note on tool implementations

Most reportable issues will actually live **upstream** in
[gitops-mcp](https://github.com/raghavkhokale/gitops-mcp), since this
repo is largely a build artifact (skills auto-generated from the
upstream package's MCP-tool docstrings). If you've narrowed the bug
to upstream code, the security policy lives there:
<https://github.com/raghavkhokale/gitops-mcp/blob/main/SECURITY.md>.

Hand-edited surface in this repo (which CAN host plugin-specific
issues): the SessionStart hook, the manifests, the workflow skills,
the agent. Issues isolated to those belong here.
