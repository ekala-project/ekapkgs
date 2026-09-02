{
  lib,
  stdenv,
  fetchurl,
  lv2,
  meson,
  ninja,
  pkg-config,
  serd,
  sord,
}:

stdenv.mkDerivation rec {
  pname = "sratom";
  version = "0.6.22";

  src = fetchurl {
    url = "https://download.drobilla.net/${pname}-${version}.tar.xz";
    hash = "sha256-Agm30PIslqu0FnIu1zWwkzvkeTHs/0qksm3td2C08lI=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
  ];

  buildInputs = [
    lv2
    serd
    sord
  ];

  mesonFlags = [
    "-Ddocs=disabled"
    "-Dtests=disabled"
  ];

  meta = {
    homepage = "https://drobilla.net/software/sratom";
    description = "Library for serialising LV2 atoms to/from RDF";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
