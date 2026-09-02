{
  stdenv,
  fetchurl,
  lib,
  pkg-config,
  alsa-lib,
  libogg,
  speexdsp,
}:

stdenv.mkDerivation rec {
  pname = "alsa-plugins";
  version = "1.2.12";

  src = fetchurl {
    url = "mirror://alsa/plugins/alsa-plugins-${version}.tar.bz2";
    hash = "sha256-e9ioPTBOji2GoliV2Nyw7wJFqN8y4nGVnNvcavObZvI=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    alsa-lib
    libogg
    speexdsp
  ];

  configureFlags = [
    "--disable-jack"
    "--disable-pulseaudio"
    "--disable-libav"
  ];

  meta = {
    description = "Various plugins for ALSA";
    homepage = "http://alsa-project.org/";
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.linux;
  };
}
