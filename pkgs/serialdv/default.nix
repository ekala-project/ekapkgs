{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "serialdv";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "f4exb";
    repo = "serialdv";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-uswddoIpTXqsvjM2/ygdud9jZHTemLn9Dlv9FBXXKow=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  meta = {
    description = "C++ Minimal interface to encode and decode audio with AMBE3000 based devices in packet mode over a serial link";
    mainProgram = "dvtest";
    homepage = "https://github.com/f4exb/serialdv";
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl3;
  };
})
