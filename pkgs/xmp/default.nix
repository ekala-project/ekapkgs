{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  alsa-lib,
  libxmp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xmp";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "libxmp";
    repo = "xmp-cli";
    rev = "xmp-${finalAttrs.version}";
    hash = "sha256-bHepVTkh7Gu8ea/WW5bY7zTiqYWpENlsPqsMV+4WVT4=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libxmp
    alsa-lib
  ];

  meta = {
    description = "Extended module player";
    homepage = "https://xmp.sourceforge.net/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    mainProgram = "xmp";
    maintainers = [ ];
  };
})
