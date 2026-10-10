# 0003. Use nvfetcher for hourly auto-updates

- Status: Accepted
- Date: 2026-10-10

## Context

Upstream releases are frequent and span 12 apps × 2 architectures (24 artifacts).
The repository must always offer the latest versions with correct Nix hashes, with
minimal human intervention.

## Decision

Track upstream with **nvfetcher**. `nvfetcher.toml` has one entry per (app, arch)
using `src.github` (latest release) with `src.prefix = "v"` and a templated
`fetch.url`. nvfetcher writes `_sources/generated.{json,nix}` (version + SRI hash).
A scheduled GitHub Actions workflow (`update.yml`, hourly) runs `scripts/update.sh`,
verifies the result with `nix flake check`, and lands a PR.

## Consequences

- Version detection is a cheap GitHub API call; a tarball is only re-downloaded
  when its version actually changes, so most hourly runs are no-ops.
- `_sources/generated.nix` is machine-managed and excluded from the linters/
  formatter check.
- nvfetcher needs a token (`GITHUB_TOKEN`) for API rate limits.

## Alternatives considered

- **Renovate**: good at bumping version strings, but cannot compute Nix SRI hashes
  on the hosted app (post-upgrade commands are restricted). It would still require
  a Nix hashing step, so it buys little here. It remains a good fit for bumping the
  `flake.lock` (nixpkgs) and GitHub Actions, which we may add later.
- **Custom script + `SHA256SUMS.txt`**: upstream publishes checksums, so hashes
  could be derived without downloading the tarballs (bandwidth win). More bespoke
  code to maintain than nvfetcher; kept as a possible future optimization.
