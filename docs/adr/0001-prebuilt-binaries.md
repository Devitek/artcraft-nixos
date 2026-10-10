# 0001. Package pre-built release binaries, not from source

- Status: Accepted
- Date: 2026-10-10

## Context

The ArtCraft apps are large Rust GUI applications (egui/eframe + wgpu). Upstream
publishes, for every release, ready-to-run Linux tarballs for `x86_64` and
`aarch64`. Releases are frequent (the launcher shipped five in a single day).

## Decision

Package the **official pre-built `.tar.gz` Linux artifacts** and adapt them to Nix
with `autoPatchelfHook` + a runtime wrapper. We do **not** build from source.

## Consequences

- Packages match exactly what upstream ships and tests; no divergence.
- Hourly updates are cheap: fetch an artifact and record its hash.
- `meta.sourceProvenance = [ binaryNativeCode ]` documents the binary nature.
- We depend on upstream keeping a stable artifact naming/layout (it is uniform
  across all apps and versions observed).

## Alternatives considered

- **Build from source (crane/naersk)**: huge build graphs for GUI/wgpu stacks, slow
  CI, large closures, and a constant risk of drift from upstream release builds.
  Disproportionate for a packaging/distribution repository. Rejected.
