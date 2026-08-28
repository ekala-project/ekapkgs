{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pagemon";
  version = "0.02.06";

  src = fetchFromGitHub {
    owner = "ColinIanKing";
    repo = "pagemon";
    tag = "V${finalAttrs.version}";
    hash = "sha256-nlgrPGctgP6F90LTkVXVZ1MVbkr8yDF/AI+yrvnU5Hs=";
  };

  buildInputs = [ ncurses ];

  makeFlags = [
    "BINDIR=$(out)/bin"
    "MANDIR=$(out)/share/man/man8"
    "BASHDIR=$(out)/share/bash-completion/completions"
  ];

  meta = {
    homepage = "https://github.com/ColinIanKing/pagemon";
    description = "Interactive memory/page monitor for Linux";
    mainProgram = "pagemon";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
