# 0007. Reproducible dev environment via flake devShell

- Status: Accepted
- Date: 2026-10-10

## Context

Contributors and CI need the same toolchain (nvfetcher, linters, `gh`, Nix
formatters) to develop and test the packaging. The target of the repository is Nix
itself, so the dev environment should not introduce a foreign dependency manager.

## Decision

Provide the development environment as `devShells.default` in `flake.nix`, entered
with `nix develop`. Tooling: `nvfetcher`, `nix-prefetch`, `jq`, `gh`,
`nixfmt-rfc-style`, `statix`, `deadnix`, `shellcheck`. `nix fmt` is wired to
`nixfmt-rfc-style` via `formatter`.

## Consequences

- Zero extra tooling: anyone with Nix + flakes gets a byte-identical shell.
- CI reuses the exact same shell, so "works on my machine" gaps shrink.
- The dev toolchain is pinned by `flake.lock` alongside the packaging inputs.

## Alternatives considered

- **devbox**: pleasant UX but adds a non-Nix-native layer and a second lockfile for
  a project whose whole purpose is Nix. Rejected to keep a single source of truth.
- **Ad-hoc `nix-shell shell.nix`**: works, but we already ship a flake; a flake
  devShell keeps everything in one pinned graph.
