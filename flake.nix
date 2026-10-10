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

      # Headless smoke test per app: the binary must start and report its version
      # (exercises the patched interpreter + wrapper without needing a display/GPU).
      checks = forAllSystems (
        { pkgs, ... }:
        lib.mapAttrs' (
          name: pkg:
          lib.nameValuePair "${name}-smoke" (
            pkgs.runCommand "${name}-smoke" { nativeBuildInputs = [ pkg ]; } ''
              echo "smoke-testing ${name} ${pkg.version}"
              ${lib.getExe pkg} --version
              touch "$out"
            ''
          )
        ) (craftPackagesFor pkgs)
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
