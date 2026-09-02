{
  fetchFromGitHub,
  lib,
  stdenv,
  boost,
  zlib,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "maeparser";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "schrodinger";
    repo = "maeparser";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-xRyf/n8ezmMPMhlQFapVpnT2LReLe7spXB9jFC+VPRA=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];
  buildInputs = [
    boost
    zlib
  ];

  meta = {
    homepage = "https://github.com/schrodinger/maeparser";
    description = "Maestro file parser";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
