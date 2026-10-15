# artcraft-nixos

> Unofficial NixOS packaging of the **ArtCraft** creative suite by
> [storytold / Learning Machines LLC](https://github.com/storytold).

[![CI](https://github.com/Devitek/artcraft-nixos/actions/workflows/ci.yml/badge.svg)](https://github.com/Devitek/artcraft-nixos/actions/workflows/ci.yml)
[![Auto-update](https://github.com/Devitek/artcraft-nixos/actions/workflows/update.yml/badge.svg)](https://github.com/Devitek/artcraft-nixos/actions/workflows/update.yml)

This flake packages the ArtCraft apps for NixOS as a Nix **flake**, a **nixpkgs
overlay**, a **NixOS module** and a **Home Manager module**. Packages track the
official GitHub releases and are refreshed automatically (hourly).

> **Disclaimer.** This is a community repository and is **not affiliated with or
> endorsed by** storytold / Learning Machines LLC. It repackages the official,
> pre-built Linux release binaries (Apache-2.0 / MIT upstream). The packaging code
> here is MIT-licensed.

## Applications

| Package | Upstream | Description |
| --- | --- | --- |
| `photocraft` | [storytold/photocraft](https://github.com/storytold/photocraft) | Raster image editing |
| `vectorcraft` | [storytold/vectorcraft](https://github.com/storytold/vectorcraft) | Vector graphics |
| `filmcraft` | [storytold/filmcraft](https://github.com/storytold/filmcraft) | Video editing |
| `lightcraft` | [storytold/lightcraft](https://github.com/storytold/lightcraft) | Lighting / photo processing |
| `pdfcraft` | [storytold/pdfcraft](https://github.com/storytold/pdfcraft) | PDF tooling |
| `effectcraft` | [storytold/effectcraft](https://github.com/storytold/effectcraft) | Visual effects |
| `designcraft` | [storytold/designcraft](https://github.com/storytold/designcraft) | Design / layout |
| `gridcraft` | [storytold/gridcraft](https://github.com/storytold/gridcraft) | Spreadsheets / grids |
| `wordcraft` | [storytold/wordcraft](https://github.com/storytold/wordcraft) | Word processing |
| `deckcraft` | [storytold/deckcraft](https://github.com/storytold/deckcraft) | Presentations |
| `cadcraft` | [storytold/cadcraft](https://github.com/storytold/cadcraft) | CAD |
| `soundcraft` | [storytold/soundcraft](https://github.com/storytold/soundcraft) | Audio |
| `figcraft` | [storytold/figcraft](https://github.com/storytold/figcraft) | UI Design / Prototyping |

> The **craft-launcher** is intentionally not packaged: on NixOS, this flake *is*
> the installer/updater. See [ADR-0004](docs/adr/0004-exclude-launcher.md).

## Supported systems

`x86_64-linux` and `aarch64-linux` (the only Linux architectures published upstream).

These are GPU applications (egui + wgpu). On NixOS make sure graphics drivers are
available:

```nix
hardware.graphics.enable = true; # NixOS < 24.11: hardware.opengl.enable = true;
```

## Usage

### Try an app without installing

```sh
nix run github:devitek/artcraft-nixos#photocraft
```

### As a flake input

```nix
{
  inputs.artcraft.url = "github:devitek/artcraft-nixos";
  # optional: reuse your own nixpkgs
  inputs.artcraft.inputs.nixpkgs.follows = "nixpkgs";
}
```

### NixOS module

```nix
{
  imports = [ artcraft.nixosModules.default ];

  programs.artcraft = {
    enable = true;
    apps = [ "photocraft" "vectorcraft" "pdfcraft" ];
  };

  hardware.graphics.enable = true;
}
```

### Home Manager module

```nix
{
  imports = [ artcraft.homeManagerModules.default ];

  programs.artcraft = {
    enable = true;
    apps = [ "photocraft" "soundcraft" ];
  };
}
```

### Overlay

```nix
nixpkgs.overlays = [ artcraft.overlays.default ];
# then: pkgs.artcraft.photocraft
```

## How updates work

A scheduled GitHub Actions workflow runs [`nvfetcher`](https://github.com/berberman/nvfetcher)
hourly, detects new upstream releases, refreshes `_sources/generated.json` with the
new versions and hashes, verifies the packages build, and opens an auto-merging PR.
See [docs/technical.md](docs/technical.md) and
[ADR-0003](docs/adr/0003-update-mechanism.md).

## Troubleshooting

### `HTTP error 403` when fetching the flake

If fetching `github:devitek/artcraft-nixos` returns a GitHub API `403`, fetch over
git instead of the REST API — just swap the flake URL:

```sh
nix run 'git+https://github.com/devitek/artcraft-nixos#photocraft'
```

## Documentation

- [Functional overview](docs/functional.md)
- [Technical architecture](docs/technical.md)
- [Architecture Decision Records](docs/adr/)
- [Contributing](CONTRIBUTING.md)

## License

Packaging code: [MIT](LICENSE). The packaged binaries remain under their upstream
licenses (`MIT OR Apache-2.0`).
