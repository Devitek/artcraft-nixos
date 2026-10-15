# Per-application metadata. The binary name and AppStream id follow the pattern
# `<name>` and `ai.storyteller.<name>`; `mainProgram` overrides the default binary.
#
# `extraLibs` is a function of nixpkgs returning additional runtime libraries the
# app links or dlopens on top of the common GUI/GPU set (see mk-craft-app.nix).
# The audio-capable apps link libasound.so.2 directly, hence alsa-lib.
{
  photocraft.description = "Raster image editor (ArtCraft suite)";
  vectorcraft.description = "Vector graphics editor (ArtCraft suite)";
  filmcraft.description = "Video editor (ArtCraft suite)";
  filmcraft.extraLibs = pkgs: [ pkgs.alsa-lib ];
  lightcraft.description = "Photo processing and lighting editor (ArtCraft suite)";
  pdfcraft.description = "PDF toolkit (ArtCraft suite)";
  effectcraft.description = "Visual effects editor (ArtCraft suite)";
  effectcraft.extraLibs = pkgs: [ pkgs.alsa-lib ];
  designcraft.description = "Design and layout editor (ArtCraft suite)";
  gridcraft.description = "Spreadsheet / grid editor (ArtCraft suite)";
  wordcraft.description = "Word processor (ArtCraft suite)";
  deckcraft.description = "Presentation editor (ArtCraft suite)";
  deckcraft.extraLibs = pkgs: [ pkgs.alsa-lib ];
  cadcraft.description = "CAD editor (ArtCraft suite)";
  soundcraft.description = "Audio editor (ArtCraft suite)";
  soundcraft.extraLibs = pkgs: [ pkgs.alsa-lib ];
  figcraft.description = "UI design and prototyping editor (ArtCraft suite)"
}
