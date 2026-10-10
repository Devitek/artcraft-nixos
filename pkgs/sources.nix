# Pinned upstream release artifacts (version + per-arch tarball url & hash).
#
# This file is the single source of truth for what gets packaged. It is kept up to
# date automatically — see `nvfetcher.toml` and `.github/workflows/update.yml`.
{
  photocraft = {
    version = "0.6.0";
    srcs = {
      x86_64-linux = {
        url = "https://github.com/storytold/photocraft/releases/download/v0.6.0/photocraft-0.6.0-linux-x86_64.tar.gz";
        hash = "sha256-tl/XAbY2DTugsFkAR0v5LZkmx2gC/vp76ZZpD8vDlsY=";
      };
      aarch64-linux = {
        url = "https://github.com/storytold/photocraft/releases/download/v0.6.0/photocraft-0.6.0-linux-aarch64.tar.gz";
        hash = "sha256-6PQKVbOs7ibeuXRCXnwAwR1VBlrn/RhiaFiZUZel2s0=";
      };
    };
  };
}
