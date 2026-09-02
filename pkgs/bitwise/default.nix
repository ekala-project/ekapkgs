{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
  readline,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bitwise";
  version = "0.60";

  src = fetchFromGitHub {
    owner = "mellowcandle";
    repo = "bitwise";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Ir5IwvB+oFFJmpHlmHrk470bg3gSmKAHPbfQ4df2iYM=";
  };

  buildInputs = [
    ncurses
    readline
  ];
  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    description = "Terminal based bitwise calculator in curses";
    homepage = "https://github.com/mellowcandle/bitwise";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    mainProgram = "bitwise";
  };
})
