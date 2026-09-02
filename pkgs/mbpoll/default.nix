{
  lib,
  stdenv,
  cmake,
  pkg-config,
  fetchFromGitHub,
  libmodbus,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mbpoll";
  version = "1.5.4";

  src = fetchFromGitHub {
    owner = "epsilonrt";
    repo = "mbpoll";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Dzitr5zwkXztRDQ5l0Cb9JRf7sugYPBRKmibREWtfIc=";
  };

  buildInputs = [ libmodbus ];
  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
  ];

  meta = {
    description = "Command line utility to communicate with ModBus slave (RTU or TCP)";
    homepage = "https://epsilonrt.fr";
    license = lib.licenses.gpl3;
    mainProgram = "mbpoll";
    platforms = lib.platforms.linux;
  };
})
