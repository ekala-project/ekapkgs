{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "systemc";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "accellera-official";
    repo = "systemc";
    tag = finalAttrs.version;
    hash = "sha256-v/PcQu0m/7zyx2TtpZrLFbHtknahgVCkzcRi3lgrRGw=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  cmakeEntries = {
    CMAKE_CXX_STANDARD = "17";
  };

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  meta = {
    description = "Language for System-level design, modeling and verification";
    homepage = "https://systemc.org/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
  };
})
