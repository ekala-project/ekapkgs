{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  wrapGAppsHook3,
  pkg-config,
  which,
  gtk3,
  blas,
  lapack,
}:

assert (!blas.isILP64) && (!lapack.isILP64);

stdenv.mkDerivation (finalAttrs: {
  pname = "xnec2c";
  version = "4.4.18";

  src = fetchFromGitHub {
    owner = "KJ7LNW";
    repo = "xnec2c";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bmbSuk/bgjLVs6IOIYpOTdeDCYKTZbsCgMv57cLKsEw=";
  };

  nativeBuildInputs = [
    autoreconfHook
    wrapGAppsHook3
    pkg-config
    which
  ];
  buildInputs = [
    gtk3
    blas
    lapack
  ];
  meta = {
    homepage = "https://www.xnec2c.org/";
    description = "Graphical antenna simulation";
    mainProgram = "xnec2c";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;

    # Darwin support likely to be fixed upstream in the next release
    broken = stdenv.hostPlatform.isDarwin;
  };
})
