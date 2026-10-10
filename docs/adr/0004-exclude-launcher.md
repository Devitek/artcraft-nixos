# 0004. Do not package the craft-launcher

- Status: Accepted
- Date: 2026-10-10

## Context

Upstream ships a `craft-launcher` whose job is to list the Craft apps, download the
right pre-built build for the current machine from GitHub releases, install them and
keep them up to date (optionally from the system tray).

On NixOS this model is a poor fit:

- Binaries fetched at runtime are dynamically linked against an FHS layout that does
  not exist on NixOS; they will not run without patching.
- Imperative, self-managed installs under `$HOME` bypass the Nix store and break the
  declarative, reproducible model NixOS users expect.

## Decision

Do **not** package `craft-launcher`. On NixOS, **this flake is the installer and
updater**: apps are declared in configuration and refreshed by the hourly
automation (see ADR-0003).

## Consequences

- Users install and pin apps declaratively (flake / overlay / NixOS / Home Manager),
  and updates arrive as reviewable version bumps.
- One fewer package to maintain, and no confusing second update path.
- Users expecting the launcher UI will not find it; the README states this plainly.

## Alternatives considered

- **Package it and document the limitation**: still exposes a broken self-update
  path on NixOS. Rejected in favour of a single, Nix-native update story.
- **Package it with a wrapper that redirects to Nix**: ongoing effort to track the
  launcher's evolving behaviour for little benefit. Rejected.
