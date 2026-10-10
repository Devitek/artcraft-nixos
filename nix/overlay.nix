# nixpkgs overlay exposing the ArtCraft apps under `pkgs.artcraft.<app>`.
#
#   nixpkgs.overlays = [ artcraft.overlays.default ];
#   environment.systemPackages = [ pkgs.artcraft.photocraft ];
final: _prev: {
  artcraft = import ../pkgs { pkgs = final; };
}
