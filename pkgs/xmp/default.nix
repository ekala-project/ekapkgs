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
  version = "4.3.1";

  src = fetchFromGitHub {
    owner = "libxmp";
    repo = "xmp-cli";
    rev = "xmp-${finalAttrs.version}";
    hash = "sha256-vy1e/d70c2sMOBEPfAdaPrUQ77BQDJkUNwE9BCFIXeg=";
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
