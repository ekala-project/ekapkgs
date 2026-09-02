{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cmatrix";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "abishekvashok";
    repo = "cmatrix";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dWlVWSRIE1fPa6R2N3ONL9QJlDQEqxfdYIgWTSr5MsE=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ ncurses ];

  meta = {
    description = "Simulates the falling characters theme from The Matrix movie";
    homepage = "https://github.com/abishekvashok/cmatrix";
    changelog = "https://github.com/abishekvashok/cmatrix/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    mainProgram = "cmatrix";
  };
})
