{
  lib,
  stdenv,
  autoreconfHook,
  buildPackages,
  fetchurl,
  flex,
  lzip,
  readline,
  ed,
  texinfo,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bc";
  version = "1.08.2";
  src = fetchurl {
    url = "mirror://gnu/bc/bc-${finalAttrs.version}.tar.lz";
    hash = "sha256-eeMeAiqEsx3YCYFQY9S46lkLQJY3pSxQ7J9Cwr8zJxE=";
  };

  configureFlags = [ "--with-readline" ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [
    autoreconfHook
    ed
    flex
    lzip
    texinfo
    buildPackages.readline
    buildPackages.ncurses
  ];
  buildInputs = [
    readline
    flex
  ];

  strictDeps = true;

  meta = {
    description = "GNU software calculator";
    homepage = "https://www.gnu.org/software/bc/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    mainProgram = "bc";
  };
})
