# Contributing

Thanks for your interest in `artcraft-nixos`. This repository packages the
[ArtCraft](https://github.com/storytold) creative suite for NixOS. It does **not**
contain the apps' source code — only Nix packaging, modules and automation.

## Workflow

1. **One issue per unit of work.** Every feature, packaging job, automation change
   or docs task is tracked by a GitHub issue that carries its plan, progress notes
   and a Definition of Done. Issues double as the project's knowledge base.
2. **Branch** from `main`: `type/short-slug` (e.g. `feat/nixos-module`).
3. **Conventional Commits** for every commit and PR title:
   - `feat:` new capability · `fix:` bug fix · `chore:` deps/version bumps ·
     `docs:` documentation · `ci:` pipelines · `refactor:`, `build:`, `test:`.
   - Scope = app or area, e.g. `feat(photocraft): package 0.6.0`.
4. **PR** referencing the issue (`Closes #N`), green CI, then squash-merge.
5. **Releases** are cut by [release-please](https://github.com/googleapis/release-please)
   from Conventional Commits (SemVer). Do not bump versions by hand.

## Definition of Done

A change is done when:

- [ ] `nix flake check` passes.
- [ ] The affected package(s) build on `x86_64-linux` (and `aarch64-linux` when applicable).
- [ ] A smoke test covers new packages (the binary starts / passes its runtime-lib check).
- [ ] A short [ADR](docs/adr/) is added for any structural decision.
- [ ] Documentation (`README.md`, `docs/`) is updated.
- [ ] Commits follow Conventional Commits and the issue is closed with a short wrap-up.

## Local development

```sh
nix develop            # reproducible shell: nix tooling, nvfetcher, linters, gh
nix flake check        # evaluate + build checks
nix build .#photocraft # build a single app
nix fmt                # format Nix files
```

## Architecture decision records

Structural decisions live in [`docs/adr/`](docs/adr/) using a lightweight MADR-style
template. Add a new numbered file when you make a decision worth remembering.
