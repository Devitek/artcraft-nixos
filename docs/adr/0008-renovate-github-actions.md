# 0008. Renovate keeps the GitHub Actions up to date

- Status: Accepted
- Date: 2026-10-11

## Context

A CI warning surfaced that `actions/checkout@v4` and `release-please-action@v4`
still ran on the deprecated Node 20 runtime. These `uses:` pins drift silently;
nvfetcher (ADR-0003) only tracks the Craft apps, not our CI tooling.

## Decision

Add **Renovate** (self-hosted via `.github/workflows/renovate.yml`) scoped to the
`github-actions` manager only. It runs weekly, opens grouped `ci(deps): …` PRs, and
**auto-merges minor/patch/digest** bumps once CI is green (`platformAutomerge`);
**major** bumps open a PR for review. Config lives in `renovate.json`.

Runners are pinned to `ubuntu-24.04` (not `ubuntu-latest`) so the announced
`ubuntu-latest` → Ubuntu 26 migration can't change CI underfoot; bumping that label
stays an explicit, reviewed change.

Division of labour:

- **nvfetcher** → Craft app versions (`_sources/`, `nvfetcher.toml`).
- **Renovate** → GitHub Actions `uses:` pins.
- **release-please** → our own SemVer releases.

## Consequences

- The Node-20-style drift is caught automatically from now on.
- Renovate edits files under `.github/workflows/`, which GitHub only allows with a
  token carrying **Workflows: Read and write**. `ARTCRAFT_BOT_TOKEN` must include
  that permission (the default `GITHUB_TOKEN` cannot edit workflow files at all).
- `renovate.json` is also valid for the hosted Renovate GitHub App, so installing
  the App instead of the workflow is a drop-in alternative (and needs no token).

## Alternatives considered

- **Hosted Renovate App only**: zero token management, but an out-of-repo setup;
  kept as the documented alternative.
- **Extend Renovate to `nix`/`flake.lock`**: the self-hosted action lacks a Nix
  runtime, making lockfile maintenance unreliable; nixpkgs refresh is left out of
  scope for now.
