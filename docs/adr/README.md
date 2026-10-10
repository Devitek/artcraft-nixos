# Architecture Decision Records

Lightweight records of the structural decisions behind `artcraft-nixos`.
Format inspired by [MADR](https://adr.github.io/madr/).

| # | Decision | Status |
| --- | --- | --- |
| [0001](0001-prebuilt-binaries.md) | Package pre-built release binaries, not from source | Accepted |
| [0002](0002-target-platforms.md) | Target `x86_64-linux` + `aarch64-linux` | Accepted |
| [0003](0003-update-mechanism.md) | Use nvfetcher for hourly auto-updates | Accepted |
| [0004](0004-exclude-launcher.md) | Do not package the craft-launcher | Accepted |
| [0005](0005-release-automation.md) | Auto-merge update PRs + release-please (SemVer) | Accepted |
| [0006](0006-runtime-deps-wrapper.md) | Provide dlopen'd runtime libs via a wrapper | Accepted |
| [0007](0007-dev-environment.md) | Reproducible dev env via flake devShell (not devbox) | Accepted |
| [0008](0008-renovate-github-actions.md) | Renovate keeps the GitHub Actions up to date | Accepted |

## Template

```markdown
# NNNN. Title

- Status: Proposed | Accepted | Superseded by ADR-XXXX
- Date: YYYY-MM-DD

## Context
## Decision
## Consequences
## Alternatives considered
```
