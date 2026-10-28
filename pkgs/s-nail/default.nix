{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
  ncurses,
  libidn2 ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "s-nail";
  version = "14.9.26";

  src = fetchFromGitHub {
    owner = "sdaoden";
    repo = "s-nail";
    tag = "v${finalAttrs.version}";
    hash = lib.fakeHash;
  };

  buildInputs = [
    openssl
    ncurses
    libidn2
  ];

  configurePhase = ''
    runHook preConfigure

    make VAL_PREFIX=$out \
         VAL_SYSCONFDIR=$out/etc \
         OPT_AUTOCC=no \
         config

    runHook postConfigure
  '';

  meta = {
    description = "S-nail mail user agent (BSD Mail / POSIX mailx)";
    homepage = "https://www.sdaoden.eu/code.html";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    mainProgram = "s-nail";
  };
})
