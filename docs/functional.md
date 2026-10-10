# Functional overview

## What this is

`artcraft-nixos` makes the **ArtCraft** creative suite (by storytold / Learning
Machines LLC) installable on NixOS the way NixOS users expect: declaratively,
reproducibly, and always up to date. It repackages the official pre-built Linux
release binaries — it does not fork or rebuild the apps.

It is **unofficial** and not affiliated with or endorsed by the upstream authors.

## Who it's for

- NixOS users who want one or more ArtCraft apps in `configuration.nix`.
- Home Manager users who want them per-user.
- Anyone who wants to try an app with a single `nix run`.

## The applications

| Package | Upstream | What it does |
| --- | --- | --- |
| `photocraft` | storytold/photocraft | Raster image editing (layers, formats, filters) |
| `vectorcraft` | storytold/vectorcraft | Vector graphics |
| `filmcraft` | storytold/filmcraft | Video editing |
| `lightcraft` | storytold/lightcraft | Photo processing / lighting |
| `pdfcraft` | storytold/pdfcraft | PDF viewing and tooling |
| `effectcraft` | storytold/effectcraft | Visual effects |
| `designcraft` | storytold/designcraft | Design and layout |
| `gridcraft` | storytold/gridcraft | Spreadsheets / grids |
| `wordcraft` | storytold/wordcraft | Word processing |
| `deckcraft` | storytold/deckcraft | Presentations |
| `cadcraft` | storytold/cadcraft | CAD |
| `soundcraft` | storytold/soundcraft | Audio editing |

Each app also ships a `*-cli` companion (e.g. `photocraft-cli`); it is installed
alongside the GUI binary.

The **craft-launcher is intentionally not packaged** — on NixOS this flake plays the
launcher's role (install + update). See
[ADR-0004](adr/0004-exclude-launcher.md).

## What the flake provides

- `packages.<system>.<app>` — one derivation per app (`default` is PhotoCraft).
- `apps.<system>.<app>` — `nix run` entry points.
- `overlays.default` — adds `pkgs.artcraft.<app>`.
- `nixosModules.default` — `programs.artcraft` for system-wide installs.
- `homeManagerModules.default` — `programs.artcraft` for per-user installs.
- `devShells.default`, `formatter`, and `checks` (headless smoke tests + module
  evaluations).

Supported systems: `x86_64-linux`, `aarch64-linux`
([ADR-0002](adr/0002-target-platforms.md)).

## Staying up to date

Upstream releases often. A scheduled job refreshes the packaged versions hourly and
lands them automatically once they build, so the flake tracks upstream closely. Pin
a specific commit of this flake if you prefer to update on your own schedule.

See the [technical documentation](technical.md) for how it all fits together.
