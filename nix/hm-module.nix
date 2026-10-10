# Home Manager module: install the ArtCraft apps for a single user.
#
#   imports = [ artcraft.homeManagerModules.default ];
#   programs.artcraft = { enable = true; apps = [ "photocraft" "soundcraft" ]; };
#
# GPU acceleration still requires a working system graphics stack
# (`hardware.graphics.enable = true;` on NixOS).
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.artcraft;

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
        "soundcraft"
      ];
      description = ''
        Which ArtCraft apps to install into the user environment. Defaults to every
        app available for the current system.
      '';
    };

    packages = lib.mkOption {
      type = lib.types.attrsOf lib.types.package;
      default = available;
      defaultText = lib.literalMD "the ArtCraft app set for the current system";
      description = "The resolved ArtCraft package set to pick {option}`apps` from.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = map (name: cfg.packages.${name}) cfg.apps;
  };
}
