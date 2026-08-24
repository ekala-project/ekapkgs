{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  gettext,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nudoku";
  version = "8.0.1";

  src = fetchFromGitHub {
    owner = "jubalh";
    repo = "nudoku";
    rev = finalAttrs.version;
    hash = "sha256-8xSvW+oNMfPMIDTGLp6okGd1lzu/ZmZI4eYZBFhm45I=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    gettext
  ];
  buildInputs = [ ncurses ];

  meta = {
    description = "Ncurses based sudoku game";
    mainProgram = "nudoku";
    homepage = "https://jubalh.github.io/nudoku";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
})
