{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  pkg-config,
  libogg,
  libvorbis,
  libao,
  curl,
  speex,
  flac,
}:

stdenv.mkDerivation rec {
  pname = "vorbis-tools";
  version = "1.4.3";

  src = fetchurl {
    url = "http://downloads.xiph.org/releases/vorbis/vorbis-tools-${version}.tar.gz";
    hash = "sha256-of493Gd3vc6/a3l+ft/gQ3lUskdW/8yMa4FrY+BGDd4=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libogg
    libvorbis
    libao
    curl
    speex
    flac
  ];

  meta = {
    description = "Extra tools for Ogg-Vorbis audio codec";
    homepage = "https://xiph.org/vorbis/";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.all;
  };
}
