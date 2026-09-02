{
  lib,
  stdenv,
  fetchurl,
  libxcrypt,
  ncurses,
  buildPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tcsh";
  version = "6.24.16";

  src = fetchurl {
    url = "mirror://tcsh/tcsh-${finalAttrs.version}.tar.gz";
    hash = "sha256-QgjPRjD7ZNkdgZh/hU+VcKWg6KABqSgn3vN9Dtjzc2Q=";
  };

  strictDeps = true;

  depsBuildBuild = [
    buildPackages.stdenv.cc
  ];

  buildInputs = [
    libxcrypt
    ncurses
  ];

  passthru.shellPath = "/bin/tcsh";

  meta = {
    homepage = "https://www.tcsh.org/";
    description = "Enhanced version of the Berkeley UNIX C shell (csh)";
    mainProgram = "tcsh";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
  };
})
