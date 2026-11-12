<p align="center">
  <img src=".github/assets/banner.svg" alt="artcraft-nixos" width="100%">
</p>

<p align="center">The ArtCraft creative suite for NixOS, kept in sync with upstream releases.</p>

<p align="center">
  <a href="https://github.com/Devitek/artcraft-nixos/releases/latest"><img src="https://img.shields.io/github/v/release/Devitek/artcraft-nixos?style=flat-square&label=release&labelColor=141517&color=F0703A" alt="Latest release"></a>
  <a href="https://github.com/Devitek/artcraft-nixos/actions/workflows/ci.yml"><img src="https://img.shields.io/github/actions/workflow/status/Devitek/artcraft-nixos/ci.yml?branch=main&style=flat-square&label=ci&labelColor=141517" alt="CI"></a>
  <a href="https://github.com/Devitek/artcraft-nixos/actions/workflows/update.yml"><img src="https://img.shields.io/github/actions/workflow/status/Devitek/artcraft-nixos/update.yml?branch=main&style=flat-square&label=auto-update&labelColor=141517" alt="Auto-update"></a>
  <a href="LICENSE"><img src="https://img.shields.io/github/license/Devitek/artcraft-nixos?style=flat-square&labelColor=141517&color=F6F5F2" alt="License"></a>
</p>

<p align="center">
  <a href="#installation">Installation</a> ·
  <a href="#usage">Usage</a> ·
  <a href="#documentation">Documentation</a> ·
  <a href="CHANGELOG.md">Changelog</a> ·
  <a href="CONTRIBUTING.md">Contributing</a>
</p>

[ArtCraft](https://github.com/storytold) is a suite of creative apps by storytold. This repository repackages their official pre-built Linux releases for NixOS, with desktop entries and declarative install. New upstream releases are picked up, built, smoke-tested and merged automatically.

> [!NOTE]
> Community project, not affiliated with or endorsed by storytold / Learning Machines LLC. App bugs belong upstream; packaging bugs belong [here](https://github.com/Devitek/artcraft-nixos/issues).

## Installation

Try an app without installing anything:

```sh
nix run github:devitek/artcraft-nixos#photocraft
```

Or add the flake to your inputs:

```nix
{
  inputs.artcraft.url = "github:devitek/artcraft-nixos";
  inputs.artcraft.inputs.nixpkgs.follows = "nixpkgs"; # optional
}
```

Supports `x86_64-linux` and `aarch64-linux`. The apps render on the GPU, so enable `hardware.graphics.enable = true;` on NixOS.

## Applications

| Package | What it does | Version | Upstream |
| --- | --- | --- | --- |
| `photocraft` | Raster image editing | <img src="https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fraw.githubusercontent.com%2FDevitek%2Fartcraft-nixos%2Fmain%2F_sources%2Fgenerated.json&query=%24%5B%27photocraft-x86_64-linux%27%5D.version&style=flat-square&label=&labelColor=141517&color=141517" alt="photocraft version"> | [storytold/photocraft](https://github.com/storytold/photocraft) |
| `vectorcraft` | Vector graphics | <img src="https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fraw.githubusercontent.com%2FDevitek%2Fartcraft-nixos%2Fmain%2F_sources%2Fgenerated.json&query=%24%5B%27vectorcraft-x86_64-linux%27%5D.version&style=flat-square&label=&labelColor=141517&color=141517" alt="vectorcraft version"> | [storytold/vectorcraft](https://github.com/storytold/vectorcraft) |
| `filmcraft` | Video editing | <img src="https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fraw.githubusercontent.com%2FDevitek%2Fartcraft-nixos%2Fmain%2F_sources%2Fgenerated.json&query=%24%5B%27filmcraft-x86_64-linux%27%5D.version&style=flat-square&label=&labelColor=141517&color=141517" alt="filmcraft version"> | [storytold/filmcraft](https://github.com/storytold/filmcraft) |
| `lightcraft` | Lighting / photo processing | <img src="https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fraw.githubusercontent.com%2FDevitek%2Fartcraft-nixos%2Fmain%2F_sources%2Fgenerated.json&query=%24%5B%27lightcraft-x86_64-linux%27%5D.version&style=flat-square&label=&labelColor=141517&color=141517" alt="lightcraft version"> | [storytold/lightcraft](https://github.com/storytold/lightcraft) |
| `pdfcraft` | PDF tooling | <img src="https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fraw.githubusercontent.com%2FDevitek%2Fartcraft-nixos%2Fmain%2F_sources%2Fgenerated.json&query=%24%5B%27pdfcraft-x86_64-linux%27%5D.version&style=flat-square&label=&labelColor=141517&color=141517" alt="pdfcraft version"> | [storytold/pdfcraft](https://github.com/storytold/pdfcraft) |
| `effectcraft` | Visual effects | <img src="https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fraw.githubusercontent.com%2FDevitek%2Fartcraft-nixos%2Fmain%2F_sources%2Fgenerated.json&query=%24%5B%27effectcraft-x86_64-linux%27%5D.version&style=flat-square&label=&labelColor=141517&color=141517" alt="effectcraft version"> | [storytold/effectcraft](https://github.com/storytold/effectcraft) |
| `designcraft` | Design / layout | <img src="https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fraw.githubusercontent.com%2FDevitek%2Fartcraft-nixos%2Fmain%2F_sources%2Fgenerated.json&query=%24%5B%27designcraft-x86_64-linux%27%5D.version&style=flat-square&label=&labelColor=141517&color=141517" alt="designcraft version"> | [storytold/designcraft](https://github.com/storytold/designcraft) |
| `gridcraft` | Spreadsheets / grids | <img src="https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fraw.githubusercontent.com%2FDevitek%2Fartcraft-nixos%2Fmain%2F_sources%2Fgenerated.json&query=%24%5B%27gridcraft-x86_64-linux%27%5D.version&style=flat-square&label=&labelColor=141517&color=141517" alt="gridcraft version"> | [storytold/gridcraft](https://github.com/storytold/gridcraft) |
| `wordcraft` | Word processing | <img src="https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fraw.githubusercontent.com%2FDevitek%2Fartcraft-nixos%2Fmain%2F_sources%2Fgenerated.json&query=%24%5B%27wordcraft-x86_64-linux%27%5D.version&style=flat-square&label=&labelColor=141517&color=141517" alt="wordcraft version"> | [storytold/wordcraft](https://github.com/storytold/wordcraft) |
| `deckcraft` | Presentations | <img src="https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fraw.githubusercontent.com%2FDevitek%2Fartcraft-nixos%2Fmain%2F_sources%2Fgenerated.json&query=%24%5B%27deckcraft-x86_64-linux%27%5D.version&style=flat-square&label=&labelColor=141517&color=141517" alt="deckcraft version"> | [storytold/deckcraft](https://github.com/storytold/deckcraft) |
| `cadcraft` | CAD | <img src="https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fraw.githubusercontent.com%2FDevitek%2Fartcraft-nixos%2Fmain%2F_sources%2Fgenerated.json&query=%24%5B%27cadcraft-x86_64-linux%27%5D.version&style=flat-square&label=&labelColor=141517&color=141517" alt="cadcraft version"> | [storytold/cadcraft](https://github.com/storytold/cadcraft) |
| `soundcraft` | Audio | <img src="https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fraw.githubusercontent.com%2FDevitek%2Fartcraft-nixos%2Fmain%2F_sources%2Fgenerated.json&query=%24%5B%27soundcraft-x86_64-linux%27%5D.version&style=flat-square&label=&labelColor=141517&color=141517" alt="soundcraft version"> | [storytold/soundcraft](https://github.com/storytold/soundcraft) |
| `figcraft` | UI design / prototyping | <img src="https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fraw.githubusercontent.com%2FDevitek%2Fartcraft-nixos%2Fmain%2F_sources%2Fgenerated.json&query=%24%5B%27figcraft-x86_64-linux%27%5D.version&style=flat-square&label=&labelColor=141517&color=141517" alt="figcraft version"> | [storytold/figcraft](https://github.com/storytold/figcraft) |
| `craft-anything` | Reverse engineering | <img src="https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fraw.githubusercontent.com%2FDevitek%2Fartcraft-nixos%2Fmain%2F_sources%2Fgenerated.json&query=%24%5B%27craft-anything-x86_64-linux%27%5D.version&style=flat-square&label=&labelColor=141517&color=141517" alt="craft-anything version"> | [storytold/craft-anything](https://github.com/storytold/craft-anything) |

Each app ships with its `*-cli` companion. The craft-launcher is not packaged: on NixOS, this flake is the installer ([ADR-0004](docs/adr/0004-exclude-launcher.md)).

## Usage

**NixOS**

```nix
{
  imports = [ artcraft.nixosModules.default ];
  programs.artcraft = {
    enable = true;
    apps = [ "photocraft" "vectorcraft" "pdfcraft" ]; # default: all apps
  };
}
```

**Home Manager**

```nix
{
  imports = [ artcraft.homeManagerModules.default ];
  programs.artcraft = {
    enable = true;
    apps = [ "photocraft" "soundcraft" ];
  };
}
```

**Overlay**

```nix
nixpkgs.overlays = [ artcraft.overlays.default ];
# then: pkgs.artcraft.photocraft
```

## How updates work

[nvfetcher](https://github.com/berberman/nvfetcher) tracks upstream releases. When a new one lands, the update workflow refreshes the versions and hashes, runs `nix flake check` (builds, smoke tests, module evaluation) and merges the change. [release-please](https://github.com/googleapis/release-please) then cuts a SemVer release of this repository. Pin a tag if you prefer to update on your own schedule.

<details>
<summary><strong>Troubleshooting</strong></summary>

**`HTTP error 403` when fetching the flake.** Fetch over git instead of the GitHub API:

```sh
nix run 'git+https://github.com/devitek/artcraft-nixos#photocraft'
```

</details>

## Documentation

- [Functional overview](docs/functional.md)
- [Technical architecture](docs/technical.md)
- [Architecture Decision Records](docs/adr/)

## Contributing

Contributions are welcome. Please read [CONTRIBUTING.md](CONTRIBUTING.md) first: one issue per change, Conventional Commits, green CI.

## License

The packaging code is released under the [MIT License](LICENSE). The apps remain under their upstream licenses (`MIT OR Apache-2.0`).

---

<p align="center">
  <a href="https://github.com/Devitek">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset=".github/assets/devitek-wordmark-blanc.svg">
      <img src=".github/assets/devitek-wordmark-encre.svg" alt="Devitek" height="22">
    </picture>
  </a>
  <br>
  <sub>Built and maintained by <a href="https://github.com/Devitek">Devitek</a></sub>
</p>
