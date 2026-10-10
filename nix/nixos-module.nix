# NixOS module: install and manage the ArtCraft apps system-wide.
#
#   imports = [ artcraft.nixosModules.default ];
#   programs.artcraft = { enable = true; apps = [ "photocraft" "vectorcraft" ]; };
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.artcraft;

  # App set built for this system (only apps with an artifact for pkgs.system).
  available = import ../pkgs { inherit pkgs; };
  appNames = builtins.attrNames available;
in
{
  options.programs.artcraft = {
    enable = lib.mkEnableOption "the ArtCraft creative suite";

    apps = lib.mkOption {
      type = lib.types.listOf (lib.types.enum appNames);
      default = appNames;
      example = [
        "photocraft"
        "vectorcraft"
      ];
      description = ''
        Which ArtCraft apps to install. Defaults to every app available for the
        current system. Desktop entries and icons are integrated automatically.
      '';
    };

    packages = lib.mkOption {
      type = lib.types.attrsOf lib.types.package;
      default = available;
      defaultText = lib.literalMD "the ArtCraft app set for the current system";
      description = ''
        The resolved ArtCraft package set to pick {option}`apps` from. Override to
        pin a different revision of this flake.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = map (name: cfg.packages.${name}) cfg.apps;

    # These are GPU apps (egui + wgpu); they need a working graphics stack.
    warnings = lib.optional (!config.hardware.graphics.enable) ''
      programs.artcraft is enabled but hardware.graphics.enable is false. The
      ArtCraft apps need Vulkan/OpenGL drivers at runtime; set
      `hardware.graphics.enable = true;` for GPU acceleration.
    '';
  };
}
