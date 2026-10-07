{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pacparser";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "manugarg";
    repo = "pacparser";
    rev = "v${finalAttrs.version}";
    hash = "sha256-zAntXNjqkOsILsy7FdQVuBpOM9FCRFcDIVT20FhaVzo=";
  };

  makeFlags = [
    "NO_INTERNET=1"
    "PREFIX=${placeholder "out"}"
    "VERSION=v${finalAttrs.version}"
  ];


  preConfigure = ''
    patchShebangs tests/runtests.sh
    cd src
  '';

  hardeningDisable = [ "format" ];

  versionCheckProgramArg = "-v";
  meta = {
    description = "Library to parse proxy auto-config (PAC) files";
    homepage = "https://pacparser.manugarg.com/";
    license = lib.licenses.lgpl3;
    platforms = lib.platforms.all;
    mainProgram = "pactester";
  };
})
