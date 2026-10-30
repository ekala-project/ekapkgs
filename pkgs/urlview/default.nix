{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "urlview";
  version = "0-unstable-2013-10-23";

  src = fetchFromGitHub {
    owner = "sigpipe";
    repo = "urlview";
    rev = "08767aa863cd27d1755ba0aff65b8cc1a0c1446a";
    hash = "sha256-gPnYH53AvQ/IHorZX5M4OT6Bdj7ti6SRXfkJ30aFYM4=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ ncurses ];

  preInstall = ''
    mkdir -p $out/share/man/man1
  '';

  meta = {
    description = "Extract and view URLs from text";
    homepage = "https://github.com/sigpipe/urlview";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
    mainProgram = "urlview";
  };
})
