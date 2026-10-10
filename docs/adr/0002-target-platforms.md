# 0002. Target `x86_64-linux` and `aarch64-linux`

- Status: Accepted
- Date: 2026-10-10

## Context

The repository targets NixOS users. Upstream publishes Linux artifacts for two
architectures (`x86_64`, `aarch64`) plus macOS `.dmg`, Windows and FreeBSD builds.

## Decision

Support **`x86_64-linux`** and **`aarch64-linux`** only.

## Consequences

- Both Linux architectures upstream ships are covered.
- CI builds `aarch64-linux` natively on GitHub's free arm64 runners.
- The flake restricts its systems list accordingly; other systems simply get no
  outputs rather than evaluation errors.

## Alternatives considered

- **Add Darwin** (from the universal `.dmg`): meaningful extra work (app bundles,
  signing/quarantine) for a NixOS-focused project. Deferred, not rejected forever.
- **x86_64 only**: would exclude ARM NixOS machines for little simplification.
