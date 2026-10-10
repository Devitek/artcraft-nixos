# Builds the set of ArtCraft app packages available for `pkgs.system`.
#
# Sources (version + per-arch tarball url & hash) come from nvfetcher's
# `_sources/generated.nix`, keyed by `<app>-<system>`. Metadata lives in
# ./metadata.nix. Only apps that publish an artifact for the current system are
# exposed, so every attribute in the result builds on that system.
{ pkgs }:

let
  inherit (pkgs) lib;
  inherit (pkgs.stdenv.hostPlatform) system;

  metadata = import ./metadata.nix;
  sources = pkgs.callPackage ../_sources/generated.nix { };
  mkCraftApp = pkgs.callPackage ./mk-craft-app.nix { };

  keyFor = name: "${name}-${system}";
  hasArtifact = name: sources ? ${keyFor name};

  buildApp =
    name:
    let
      entry = sources.${keyFor name};
    in
    mkCraftApp {
      pname = name;
      inherit (entry) version src;
      description = metadata.${name}.description;
      extraLibs = (metadata.${name}.extraLibs or (_: [ ])) pkgs;
    };

  names = builtins.filter hasArtifact (builtins.attrNames metadata);
in
lib.genAttrs names buildApp
