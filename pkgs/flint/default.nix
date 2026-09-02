{
  lib,
  stdenv,
  fetchurl,
  autoconf,
  automake,
  gettext,
  libtool,
  gmp,
  mpfr,
  ntl ? null,
  blas,
  lapack,
  boehmgc,
  openblas ? null,
  withBlas ? true,
  withNtl ? (ntl != null && !ntl.meta.broken or false),
  withGc ? false,
}:

assert
  withBlas
  -> openblas != null && blas.implementation == "openblas" && lapack.implementation == "openblas";

stdenv.mkDerivation (finalAttrs: {
  pname = "flint";
  version = "3.6.0";

  src = fetchurl {
    url = "https://flintlib.org/download/flint-${finalAttrs.version}.tar.gz";
    hash = "sha256-uV4sd5L17qShyNLULECYQ0dWgy5XoJSyletd/cm0w2s=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    autoconf
    automake
    gettext
    libtool
  ];

  propagatedBuildInputs = [
    mpfr
  ];

  buildInputs = [
    gmp
  ]
  ++ lib.optionals withBlas [
    openblas
  ]
  ++ lib.optionals withNtl [
    ntl
  ]
  ++ lib.optionals withGc [
    boehmgc
  ];

  # We're not using autoreconfHook because flint's bootstrap
  # script calls autoreconf, among other things.
  preConfigure = ''
    echo "Executing bootstrap.sh"
    ./bootstrap.sh
  '';

  configureFlags = [
    "--with-gmp=${gmp}"
    "--with-mpfr=${mpfr}"
  ]
  ++ lib.optionals withBlas [
    "--with-blas=${openblas}"
  ]
  ++ lib.optionals withNtl [
    "--with-ntl=${ntl}"
  ]
  ++ lib.optionals withGc [
    "--with-gc=${boehmgc}"
  ];

  enableParallelBuilding = true;
  enableParallelChecking = true;
  doCheck = true;

  meta = {
    description = "Fast Library for Number Theory";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.all;
    homepage = "https://www.flintlib.org/";
    downloadPage = "https://www.flintlib.org/downloads.html";
    broken =
      withBlas
      && stdenv.hostPlatform.isStatic
      && stdenv.hostPlatform.isLinux
      && stdenv.hostPlatform.isAarch64;
  };
})
