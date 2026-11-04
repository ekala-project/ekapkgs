{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  fetchpatch,
  elfutils,
  libpcap,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dynamips";
  version = "0.2.23";

  src = fetchFromGitHub {
    owner = "GNS3";
    repo = "dynamips";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+h+WsZ/QrDd+dNrR6CJb2uMG+vbUvK8GTxFJZOxknL0=";
  };

  patches = [
    (fetchpatch {
      name = "cmake4-compat.patch";
      url = "https://github.com/GNS3/dynamips/commit/fdbbb7d3887eaa5b024bbcbcc14215f420a7e989.patch";
      hash = "sha256-CbiPGrIqn9KGnZEPUw7LiH8dkqzjfu4UxW1f7Fzbwro=";
    })
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  buildInputs = [
    elfutils
    libpcap
  ];

  cmakeFlags = [
    (lib.cmakeFeature "DYNAMIPS_CODE" "stable")
  ];

  meta = {
    description = "Cisco router emulator";
    homepage = "https://github.com/GNS3/dynamips";
    changelog = "https://github.com/GNS3/dynamips/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl2Plus;
    mainProgram = "dynamips";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
