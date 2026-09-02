{
  lib,
  cmake,
  fetchFromGitHub,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "md4c";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "mity";
    repo = "md4c";
    rev = "release-${finalAttrs.version}";
    hash = "sha256-2/wi7nJugR8X2J9FjXJF1UDnbsozGoO7iR295/KSJng=";
  };

  patches = [
    ./0001-fix-pkgconfig.patch
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
  ];

  strictDeps = true;

  meta = {
    homepage = "https://github.com/mity/md4c";
    description = "Markdown parser made in C";
    license = lib.licenses.mit;
    mainProgram = "md2html";
    platforms = lib.platforms.all;
  };
})
