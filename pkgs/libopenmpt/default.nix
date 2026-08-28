{
  lib,
  stdenv,
  fetchurl,
  zlib,
  pkg-config,
  mpg123,
  libogg,
  libvorbis,
  portaudio,
  libsndfile,
  flac,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libopenmpt";
  version = "0.8.6";

  outputs = [
    "out"
    "dev"
    "bin"
  ];

  src = fetchurl {
    url = "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-${finalAttrs.version}+release.autotools.tar.gz";
    hash = "sha256-yqL6lZ44n0N02eLfOvXGM0UsEt2ARCy6LonLf/K5PFs=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    zlib
    mpg123
    libogg
    libvorbis
    portaudio
    libsndfile
    flac
  ];

  configureFlags = [
    "--without-pulseaudio"
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  postFixup = ''
    moveToOutput share/doc $dev
  '';

  meta = {
    description = "Cross-platform C++ and C library to decode tracked music files into a raw PCM audio stream";
    mainProgram = "openmpt123";
    homepage = "https://lib.openmpt.org/libopenmpt/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
  };
})
