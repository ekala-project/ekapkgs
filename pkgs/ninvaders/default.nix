{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ninvaders";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "sf-refugees";
    repo = "ninvaders";
    rev = "v${finalAttrs.version}";
    sha256 = "1wmwws1zsap4bfc2439p25vnja0hnsf57k293rdxw626gly06whi";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];
  buildInputs = [ ncurses ];

  meta = {
    description = "Space Invaders clone based on ncurses";
    mainProgram = "ninvaders";
    homepage = "https://ninvaders.sourceforge.net/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
  };
})
