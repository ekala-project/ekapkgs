{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xxhash";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "Cyan4973";
    repo = "xxHash";
    rev = "v${finalAttrs.version}";
    hash = "sha256-h6kohM+NxvQ89R9NEXZcYBG2wPOuB4mcyPfofKrx9wQ=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  cmakeDir = "../cmake_unofficial";

  meta = {
    description = "Extremely fast hash algorithm";
    homepage = "https://github.com/Cyan4973/xxHash";
    license = with lib.licenses; [
      bsd2
      gpl2Plus
    ];
    mainProgram = "xxhsum";
    platforms = lib.platforms.all;
  };
})
