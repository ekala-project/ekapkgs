{
  lib,
  stdenv,
  fetchFromGitHub,
  alsa-lib,
  autoconf,
  automake,
  libtool,
  pkg-config,
  portaudio,
  which,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pcaudiolib";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "espeak-ng";
    repo = "pcaudiolib";
    rev = finalAttrs.version;
    hash = "sha256-bBiGvAySEwAv6Qj2iSawb9oZfMCGBDCDIP8AYdbtQQc=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    pkg-config
    which
  ];

  buildInputs = [
    portaudio
    alsa-lib
  ];

  preConfigure = ''
    ./autogen.sh
  '';

  meta = {
    homepage = "https://github.com/espeak-ng/pcaudiolib";
    description = "Provides a C API to different audio devices";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
  };
})
