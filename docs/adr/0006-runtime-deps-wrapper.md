# 0006. Provide dlopen'd runtime libraries via a wrapper

- Status: Accepted
- Date: 2026-10-10

## Context

Upstream's `packaging/linux/nfpm.yaml` documents that the binaries link only
`glibc` and `libgcc_s` directly. The windowing stack (X11/Wayland, xkbcommon) and
the GPU backend (Vulkan, or EGL/GL) are loaded at runtime with `dlopen`. Because
these are not ELF `NEEDED` entries, `autoPatchelfHook` cannot see or patch them.

## Decision

- Use `autoPatchelfHook` to fix the ELF interpreter and the direct `NEEDED` libs
  (`stdenv.cc.cc.lib` covers `libgcc_s`/`libstdc++`).
- Wrap every installed binary with `wrapProgram`, prefixing `LD_LIBRARY_PATH` with
  the dlopen'd libraries: `libxkbcommon`, `wayland`, `xorg.libX11`, `xorg.libxcb`,
  `xorg.libXcursor`, `xorg.libXi`, `vulkan-loader`, `libGL`, plus the NixOS driver
  path `/run/opengl-driver/lib` (`addDriverRunpath.driverLink`) for the Vulkan ICD
  and GL/EGL vendor libraries.

## Consequences

- One generic builder (`mk-craft-app.nix`) works for all apps: identical GUI stack
  and artifact layout across the suite.
- GPU acceleration relies on the host's `hardware.graphics.enable` (documented).
- If upstream adds a new dlopen'd dependency, the app prints the missing library at
  startup (upstream's `linux_libs` check), making diagnosis easy.

## Alternatives considered

- **Patch RUNPATH only**: insufficient, since dlopen resolution ignores RUNPATH for
  libraries that are not `NEEDED` unless absolute paths are used.
- **Run inside an FHS/buildFHSEnv**: heavier and less transparent than a targeted
  `LD_LIBRARY_PATH` wrapper for a known, small dependency set.
