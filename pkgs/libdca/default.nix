{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libdca";
  version = "0.0.7";

  src = fetchurl {
    url = "https://download.videolan.org/pub/videolan/libdca/${finalAttrs.version}/libdca-${finalAttrs.version}.tar.bz2";
    hash = "sha256-OgsTgV9YLGYdI4j/yrwvHqgvRxeDxAD3ZfLsbIEGX2o=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  # The Makefile install-exec-hook creates a libdts.a -> libdca.a symlink,
  # but libdca.a is not built when --disable-static is in effect (the default).
  # Remove the dangling symlink to avoid noBrokenSymlinks check failure.
  postInstall = ''
    rm -f $out/lib/libdts.a
  '';

  meta = {
    description = "Free library for decoding DTS Coherent Acoustics streams";
    homepage = "https://code.videolan.org/videolan/libdca";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
