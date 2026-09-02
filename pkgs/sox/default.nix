{
  lib,
  stdenv,
  fetchgit,
  autoreconfHook,
  autoconf-archive,
  pkg-config,
  alsa-lib,
  libao,
  lame,
  libmad,
  libogg,
  libvorbis,
  opusfile,
  flac,
  libpng,
  libsndfile,
  wavpack,
  pulseaudio,
}:

stdenv.mkDerivation {
  pname = "sox";
  version = "unstable-2021-05-09";

  src = fetchgit {
    name = "source";
    url = "https://git.code.sf.net/p/sox/code";
    rev = "42b3557e13e0fe01a83465b672d89faddbe65f49";
    hash = "sha256-9cpOwio69GvzVeDq79BSmJgds9WU5kA/KUlAkHcpN5c=";
  };

  outputs = [
    "out"
    "dev"
    "lib"
  ];

  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
    pkg-config
  ];

  patches = [ ./0001-musl-rewind-pipe-workaround.patch ];

  buildInputs = [
    alsa-lib
    libao
    lame
    libmad
    libogg
    libvorbis
    opusfile
    flac
    libpng
    libsndfile
    wavpack
    pulseaudio
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Sample Rate Converter for audio";
    homepage = "https://sox.sourceforge.net/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
}
