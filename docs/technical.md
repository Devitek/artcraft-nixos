# Technical architecture

## Repository layout

```
flake.nix               Flake outputs (packages, apps, overlay, modules, checks, devShell)
nvfetcher.toml          Upstream tracking config (one entry per app × arch)
_sources/generated.*    nvfetcher output: version + url + hash (machine-managed)
pkgs/
  mk-craft-app.nix      Generic builder for a pre-built Craft app
  metadata.nix          Per-app description + extraLibs hook
  default.nix           Builds the app set for pkgs.system
nix/
  overlay.nix           pkgs.artcraft.<app>
  nixos-module.nix      programs.artcraft (NixOS)
  hm-module.nix         programs.artcraft (Home Manager)
scripts/update.sh       nvfetcher wrapper + per-app bump summary
docs/adr/               Architecture Decision Records
.github/workflows/      ci.yml, update.yml, release-please.yml
```

## Packaging model

The apps are distributed as pre-built Linux tarballs
([ADR-0001](adr/0001-prebuilt-binaries.md)) with a uniform layout:

```
<name>-<ver>-linux-<arch>/bin/<name>[,-cli]
                         /share/{applications,icons/hicolor,metainfo,...}
```

`mk-craft-app.nix` fetches the tarball and:

1. unpacks `bin/` + `share/` into `$out`;
2. runs `autoPatchelfHook` to fix the ELF interpreter and direct `NEEDED` libs
   (only `glibc` + `libgcc_s`, from `stdenv.cc.cc.lib`);
3. wraps every binary with `wrapProgram`, prefixing `LD_LIBRARY_PATH` with the
   libraries the apps load via `dlopen` (windowing + GPU) plus the NixOS driver
   path `/run/opengl-driver/lib` ([ADR-0006](adr/0006-runtime-deps-wrapper.md)).

The dlopen'd set (from upstream `packaging/linux/nfpm.yaml`): `libxkbcommon(+x11)`,
`wayland`, `libx11`, `libxcb`, `libxcursor`, `libxi`, `vulkan-loader`, `libGL`. The
audio-capable apps (`filmcraft`, `effectcraft`, `deckcraft`, `soundcraft`) also link
`libasound.so.2`, added through the per-app `extraLibs` hook in `metadata.nix`.

GPU acceleration relies on the host graphics stack: set
`hardware.graphics.enable = true;` on NixOS.

## Sources and versioning

`nvfetcher.toml` declares one package per `(app, arch)`:

```toml
[photocraft-x86_64-linux]
src.github = "storytold/photocraft"   # latest GitHub release
src.prefix = "v"                       # strip the leading v -> $ver
fetch.url = "https://github.com/storytold/photocraft/releases/download/v$ver/photocraft-$ver-linux-x86_64.tar.gz"
```

`nvfetcher` writes `_sources/generated.nix`, a function returning
`{ "<app>-<system>" = { pname; version; src; }; }`. `pkgs/default.nix` reads it,
keyed by `<app>-<pkgs.system>`, and exposes only the apps that publish an artifact
for the current system — so every exposed attribute builds on that system.

## Flake outputs

| Output | Purpose |
| --- | --- |
| `packages.<sys>.<app>` / `.default` | Build a single app (`default` = PhotoCraft) |
| `apps.<sys>.<app>` | `nix run` |
| `overlays.default` | `pkgs.artcraft.<app>` |
| `nixosModules.default` | `programs.artcraft` (system) |
| `homeManagerModules.default` | `programs.artcraft` (user) |
| `checks.<sys>.<app>-smoke` | Headless `--version` smoke test |
| `checks.<sys>.nixos-module` / `.home-manager-module` | Module evaluation tests |
| `devShells.<sys>.default`, `formatter.<sys>` | Tooling, `nix fmt` |

## CI/CD

- **ci.yml** (PR + push to `main`): lint (`statix`, `deadnix`, `nixfmt --check` on
  hand-written Nix) and `nix flake check` on native `x86_64-linux` and
  `aarch64-linux` runners.
- **update.yml** (hourly + manual): `scripts/update.sh` runs `nvfetcher`; if
  `_sources/` changed, `nix flake check` gates the result, then a Conventional-Commit
  PR is opened and merged ([ADR-0003](adr/0003-update-mechanism.md),
  [ADR-0005](adr/0005-release-automation.md)).
- **release-please.yml**: SemVer tags, GitHub Releases and `CHANGELOG.md` from
  Conventional Commits.
- **renovate.yml**: weekly, keeps the GitHub Actions `uses:` pins current
  (auto-merges low-risk bumps when CI is green). Runners are pinned to
  `ubuntu-24.04`. See [ADR-0008](adr/0008-renovate-github-actions.md).

### Token note

Workflows prefer `secrets.ARTCRAFT_BOT_TOKEN` (a PAT) over `GITHUB_TOKEN`. Without a
PAT, bot PRs do not trigger a separate `ci.yml` run (the inline `nix flake check` is
the gate) and `release-please` relies on its schedule. See ADR-0005.

## How to add a new app

1. Add a `description` (and `extraLibs` if it links extra libraries) in
   `pkgs/metadata.nix`.
2. Add `<app>-x86_64-linux` and `<app>-aarch64-linux` entries to `nvfetcher.toml`.
3. Run `nix develop --command bash scripts/update.sh` to populate `_sources/`.
4. `nix build .#<app>` and `nix flake check` to validate.

## How to update manually

```sh
GITHUB_TOKEN=$(gh auth token) nix develop .#default --command bash scripts/update.sh
nix flake check -L
```
