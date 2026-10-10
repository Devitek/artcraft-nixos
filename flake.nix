{
  description = "Unofficial NixOS packaging of the ArtCraft creative suite (storytold)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    let
      # Only the Linux architectures published upstream.
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      inherit (nixpkgs) lib;

      forAllSystems =
        f:
        lib.genAttrs systems (
          system:
          f {
            inherit system;
            pkgs = nixpkgs.legacyPackages.${system};
          }
        );

      # ArtCraft app package set for a given nixpkgs instance.
      craftPackagesFor = pkgs: import ./pkgs { inherit pkgs; };
    in
    {
      # Individual app packages, e.g. `.#photocraft`. `default` is PhotoCraft.
      packages = forAllSystems (
        { pkgs, ... }:
        let
          craft = craftPackagesFor pkgs;
        in
        craft // { default = craft.photocraft; }
      );

      # `nix run .#<app>` entry points.
      apps = forAllSystems (
        { pkgs, ... }:
        lib.mapAttrs (_name: pkg: {
          type = "app";
          program = lib.getExe pkg;
        }) (craftPackagesFor pkgs)
      );

      # nixpkgs overlay: adds `pkgs.artcraft.<app>`.
      overlays.default = import ./nix/overlay.nix;

      # System / per-user integration modules.
      nixosModules.default = import ./nix/nixos-module.nix;
      homeManagerModules.default = import ./nix/hm-module.nix;

      checks = forAllSystems (
        { pkgs, system }:
        let
          craft = craftPackagesFor pkgs;

          # Headless smoke test per app: the binary must start and report its
          # version (exercises the patched interpreter + wrapper, no display/GPU).
          smoke = lib.mapAttrs' (
            name: pkg:
            lib.nameValuePair "${name}-smoke" (
              pkgs.runCommand "${name}-smoke" { nativeBuildInputs = [ pkg ]; } ''
                echo "smoke-testing ${name} ${pkg.version}"
                ${lib.getExe pkg} --version
                touch "$out"
              ''
            )
          ) craft;

          # Evaluate the NixOS module and assert a selected app lands in
          # environment.systemPackages (no system build required).
          nixosEval =
            let
              sys = lib.nixosSystem {
                modules = [
                  ./nix/nixos-module.nix
                  {
                    nixpkgs.hostPlatform = system;
                    programs.artcraft = {
                      enable = true;
                      apps = [ "photocraft" ];
                    };
                    boot.loader.grub.enable = false;
                    fileSystems."/" = {
                      device = "nodev";
                      fsType = "tmpfs";
                    };
                    system.stateVersion = "24.05";
                  }
                ];
              };
              ok = builtins.any (p: (p.pname or "") == "photocraft") sys.config.environment.systemPackages;
            in
            pkgs.runCommand "nixos-module-eval" { } (
              if ok then
                "echo 'photocraft present in systemPackages' > \"$out\""
              else
                "echo 'photocraft missing from systemPackages' >&2; exit 1"
            );

          # Evaluate the Home Manager module in isolation (no home-manager input
          # needed): stub home.packages and assert a selected app lands in it.
          hmEval =
            let
              eval = lib.evalModules {
                specialArgs = { inherit pkgs; };
                modules = [
                  ./nix/hm-module.nix
                  {
                    options.home.packages = lib.mkOption {
                      type = lib.types.listOf lib.types.package;
                      default = [ ];
                    };
                  }
                  {
                    programs.artcraft = {
                      enable = true;
                      apps = [ "photocraft" ];
                    };
                  }
                ];
              };
              ok = builtins.any (p: (p.pname or "") == "photocraft") eval.config.home.packages;
            in
            pkgs.runCommand "home-manager-module-eval" { } (
              if ok then
                "echo 'photocraft present in home.packages' > \"$out\""
              else
                "echo 'photocraft missing from home.packages' >&2; exit 1"
            );
        in
        smoke
        // {
          nixos-module = nixosEval;
          home-manager-module = hmEval;
        }
      );

      # Reproducible development shell: Nix tooling + updater + linters.
      devShells = forAllSystems (
        { pkgs, ... }:
        {
          default = pkgs.mkShellNoCC {
            name = "artcraft-nixos";
            packages = with pkgs; [
              nvfetcher # upstream release tracker + hash generator
              nix-prefetch # fallback hash computation
              jq
              gh
              nixfmt # `nix fmt` (RFC 166 style)
              statix # Nix linter
              deadnix # dead-code finder
              shellcheck
            ];
            shellHook = ''
              echo "artcraft-nixos devshell — nvfetcher $(nvfetcher --version 2>/dev/null || echo '?')"
            '';
          };
        }
      );

      formatter = forAllSystems ({ pkgs, ... }: pkgs.nixfmt);
    };
}
