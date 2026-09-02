{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  doxygen,
  autoreconfHook,
  buildPackages,
  curl,
  gettext,
  libiconv,
  readline,
  libxml2,
  mpfr,
  icu,
  gnuplot,
  gnuplotBinary ? lib.getExe gnuplot,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libqalculate";
  version = "5.12.0";

  src = fetchFromGitHub {
    owner = "qalculate";
    repo = "libqalculate";
    tag = "v${finalAttrs.version}";
    hash = "sha256-f9FzFcu2LtBM6B6apYo7uobeR5uZVb02FxX7Kng/rRI=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    doxygen
  ];
  depsBuildBuild = [
    buildPackages.stdenv.cc
  ];

  buildInputs = [
    curl
    gettext
    libiconv
    readline
  ];
  propagatedBuildInputs = [
    libxml2
    mpfr
    icu
  ];
  enableParallelBuilding = true;

  postPatch = lib.optionalString (gnuplotBinary != "") ''
    substituteInPlace libqalculate/Calculator-plot.cc \
      --replace-fail 'commandline = "gnuplot"' 'commandline = "${gnuplotBinary}"' \
      --replace-fail '"gnuplot - ' '"${gnuplotBinary} - '
  '';

  meta = {
    description = "Advanced calculator library";
    homepage = "http://qalculate.github.io";
    license = lib.licenses.gpl2Plus;
    mainProgram = "qalc";
    platforms = lib.platforms.all;
  };
})
