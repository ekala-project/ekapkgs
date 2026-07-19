{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  nasm,
  freetype,
  fribidi,
  harfbuzz,
  fontconfig,
}:

stdenv.mkDerivation rec {
  pname = "libass";
  version = "0.17.3";

  src = fetchurl {
    url = "https://github.com/libass/libass/releases/download/${version}/${pname}-${version}.tar.xz";
    hash = "sha256-6uQl2lDwAVwh97OpxyYqkQ8CGK9GniLikxRi/tPFCVk=";
  };

  outputs = [
    "out"
    "dev"
  ];

  configureFlags = [
    "--enable-fontconfig"
  ];

  nativeBuildInputs = [
    pkg-config
    nasm
  ];

  buildInputs = [
    freetype
    fribidi
    harfbuzz
    fontconfig
  ];

  meta = {
    description = "Portable ASS/SSA subtitle renderer";
    homepage = "https://github.com/libass/libass";
    license = lib.licenses.isc;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
}
