# Generic builder for a pre-built ArtCraft app (Linux release tarball).
#
# All Craft apps ship the same way: a `<name>-<ver>-linux-<arch>.tar.gz` holding a
# `bin/` + `share/` FHS tree. The binaries link only glibc + libgcc_s directly; the
# windowing stack (X11/Wayland, xkbcommon) and the GPU (Vulkan / EGL / GL) are loaded
# at runtime via dlopen, so they are invisible to autoPatchelf and must be provided
# on LD_LIBRARY_PATH through a wrapper. See docs/adr/0006-runtime-deps-wrapper.md.
{
  lib,
  stdenv,
  autoPatchelfHook,
  makeWrapper,
  libxkbcommon,
  wayland,
  xorg,
  vulkan-loader,
  libGL,
  addDriverRunpath,
}:

{
  pname,
  version,
  src,
  description ? "An ArtCraft creative-suite application",
  mainProgram ? pname,
  extraMeta ? { },
}:

let
  # Authoritative runtime set (from upstream packaging/linux/nfpm.yaml):
  # libxkbcommon(+x11), wayland-client, libX11(+xcb), libxcb, libXcursor, libXi,
  # and libvulkan OR libEGL. glibc/libgcc_s come from stdenv.cc.cc.lib (NEEDED).
  runtimeLibs = [
    stdenv.cc.cc.lib
    libxkbcommon
    wayland
    xorg.libX11
    xorg.libxcb
    xorg.libXcursor
    xorg.libXi
    vulkan-loader
    libGL
  ];
in
stdenv.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = runtimeLibs;

  # The tarball's single top-level directory is stripped by the unpack phase,
  # leaving bin/ and share/ in the cwd.
  installPhase = ''
    runHook preInstall
    mkdir -p "$out"
    cp -r bin share "$out"/
    runHook postInstall
  '';

  # Make the dlopen'd windowing/GPU libraries discoverable at runtime, plus the
  # NixOS driver path that provides the Vulkan ICD and the GL/EGL vendor libs.
  postFixup = ''
    for bin in "$out"/bin/*; do
      [ -f "$bin" ] && [ -x "$bin" ] || continue
      wrapProgram "$bin" \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}:${addDriverRunpath.driverLink}/lib"
    done
  '';

  meta = {
    inherit description mainProgram;
    homepage = "https://github.com/storytold/${pname}";
    downloadPage = "https://github.com/storytold/${pname}/releases";
    license = with lib.licenses; [
      mit
      asl20
    ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = [ ];
  }
  // extraMeta;
}
