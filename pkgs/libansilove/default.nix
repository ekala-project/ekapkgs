{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libansilove";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "ansilove";
    repo = "libansilove";
    tag = finalAttrs.version;
    hash = "sha256-kbQ7tbQbJ8zYhdbfiVZY26woyR4NNzqjCJ/5nrunlWs=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  buildInputs = [ gd ];

  meta = {
    description = "Library for converting ANSI, ASCII, and other formats to PNG";
    homepage = "https://github.com/ansilove/libansilove";
    changelog = "https://github.com/ansilove/libansilove/blob/${finalAttrs.src.rev}/ChangeLog";
    license = lib.licenses.bsd2;
    mainProgram = "libansilove";
    platforms = lib.platforms.unix;
  };
})
