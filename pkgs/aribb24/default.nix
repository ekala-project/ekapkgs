{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  pkg-config,
  libpng,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aribb24";
  version = "1.0.4";

  src = fetchFromGitLab {
    domain = "code.videolan.org";
    owner = "jeeb";
    repo = "aribb24";
    rev = "v${finalAttrs.version}";
    hash = "sha256-hq3LnLACZfV+E76ZDEHGlN51fS6AqFnNReE3JlWcv9M=";
  };

  buildInputs = [
    libpng
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  meta = {
    description = "Library for ARIB STD-B24, decoding JIS 8 bit characters and parsing MPEG-TS stream";
    homepage = "https://code.videolan.org/jeeb/aribb24/";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.unix;
  };
})
