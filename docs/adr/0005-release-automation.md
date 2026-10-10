# 0005. Auto-merged update PRs and release-please (SemVer)

- Status: Accepted
- Date: 2026-10-10

## Context

Updates should land automatically yet traceably, and the repository's own versions
must follow SemVer with a generated changelog.

## Decision

- **Update delivery**: `update.yml` refreshes `_sources/`, runs `nix flake check`
  as the authoritative gate, then opens a PR and merges it (squash). This honours
  "auto-merge when CI is green": the inline `nix flake check` *is* the green gate.
- **Releases**: `release-please` (`release-type: simple`, manifest-driven) turns
  Conventional Commits into SemVer tags, GitHub Releases and `CHANGELOG.md`.
- **Tokens**: workflows use `secrets.ARTCRAFT_BOT_TOKEN` when present, else
  `GITHUB_TOKEN`.

## Consequences

- Fully hands-off happy path: hourly bump → verified → merged → released.
- Every change is a PR with a build log and a Conventional Commit, feeding the
  changelog and the knowledge base.
- The repo settings must allow squash merges and auto-merge.

## Known limitation (and the PAT remedy)

A PR or push made with the default `GITHUB_TOKEN` does **not** trigger other
workflows. So:

- bot update PRs do not spawn a separate `ci.yml` run (mitigated: `update.yml`
  runs `nix flake check` itself before merging);
- bot merges to `main` do not trigger `release-please` on `push` (mitigated:
  `release-please.yml` also runs on a schedule).

Configuring a Personal Access Token as `ARTCRAFT_BOT_TOKEN` removes both caveats:
bot PRs then run `ci.yml` and `release-please` reacts to every merge. This is the
recommended production setup.

## Alternatives considered

- **Direct push to main**: simpler but no PR trail; rejected for traceability.
- **Manual merge of update PRs**: safe but incompatible with the hourly cadence.
