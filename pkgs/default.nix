# Builds the set of ArtCraft app packages available for `pkgs.system`.
#
# Each app is a thin instantiation of ./mk-craft-app.nix with its pinned source
# (./sources.nix) and metadata (./metadata.nix). Only apps that publish an artifact
# for the current system are exposed.
{ pkgs }:

let
  inherit (pkgs) lib;
  inherit (pkgs.stdenv.hostPlatform) system;

  metadata = import ./metadata.nix;
  sources = import ./sources.nix;
  mkCraftApp = pkgs.callPackage ./mk-craft-app.nix { };

  hasArtifact = name: (sources ? ${name}) && (sources.${name}.srcs ? ${system});

  buildApp =
    name:
    let
      source = sources.${name};
      srcInfo = source.srcs.${system};
    in
    mkCraftApp {
      pname = name;
      inherit (source) version;
      description = metadata.${name}.description;
      src = pkgs.fetchurl { inherit (srcInfo) url hash; };
    };

  names = builtins.filter hasArtifact (builtins.attrNames metadata);
in
lib.genAttrs names buildApp
