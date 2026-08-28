{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "primesieve";
  version = "12.15";

  src = fetchFromGitHub {
    owner = "kimwalisch";
    repo = "primesieve";
    rev = "v${finalAttrs.version}";
    hash = "sha256-jYKdak6A6nMGz3nu78+OpuGBMyJl1EIRdl8NOeOP59o=";
  };

  outputs = [
    "out"
    "dev"
    "lib"
    "man"
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  strictDeps = true;

  meta = {
    homepage = "https://primesieve.org/";
    description = "Fast C/C++ prime number generator";
    changelog = "https://github.com/kimwalisch/primesieve/blob/${finalAttrs.src.rev}/ChangeLog";
    license = lib.licenses.bsd2;
    mainProgram = "primesieve";
    platforms = lib.platforms.unix;
  };
})
