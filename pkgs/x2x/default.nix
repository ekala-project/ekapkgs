{
  lib,
  stdenv,
  libx11,
  libxtst,
  libxext,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libxi,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "x2x";
  version = "1.30-12";

  src = fetchFromGitHub {
    owner = "dottedmag";
    repo = "x2x";
    rev = "debian/${finalAttrs.version}";
    hash = "sha256-41pzalsiDVcWWtZRYtVky0O8d4v59o9LufKvPjiTzS4=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libx11
    libxtst
    libxext
    libxi
  ];

  meta = {
    description = "Allows the keyboard, mouse on one X display to be used to control another X display";
    homepage = "https://github.com/dottedmag/x2x";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    mainProgram = "x2x";
  };
})
