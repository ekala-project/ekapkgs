{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "serd";
  version = "0.32.8";

  src = fetchurl {
    url = "https://download.drobilla.net/serd-${finalAttrs.version}.tar.xz";
    hash = "sha256-9HJZvDi6VTsN64ttq2tbc9NjBGmnyUOczcqA4G18Hs4=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
  ];

  mesonFlags = [
    "-Ddocs=disabled"
    "-Dman_html=disabled"
    "-Dtests=disabled"
  ];

  meta = {
    description = "Lightweight C library for RDF syntax which supports reading and writing Turtle and NTriples";
    homepage = "https://drobilla.net/software/serd";
    license = lib.licenses.isc;
    mainProgram = "serdi";
    platforms = lib.platforms.unix;
  };
})
