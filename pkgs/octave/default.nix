{
  lib,
  stdenv,
  fetchurl,
  gfortran,
  ncurses,
  perl,
  flex,
  texinfo,
  qhull,
  libsndfile,
  portaudio,
  libx11,
  graphicsmagick,
  pcre2,
  pkg-config,
  libGL,
  libGLU,
  fltk,
  fftw,
  fftwSinglePrec ? null,
  fast-float,
  zlib,
  curl,
  rapidjson,
  blas,
  lapack,
  qrupdate,
  arpack,
  suitesparse,
  use64BitIdx ? false,
  libwebp,
  gl2ps,
  ghostscript,
  hdf5,
  glpk,
  gnuplot,
  enableReadline ? true,
  readline,
  enableJava ? true,
  jdk ? null,
  python3,
  sundials,
  enableQt ? false,
  qt6Packages,
  libiconv,
}:

let
  blas' =
    if use64BitIdx then
      blas.override {
        isILP64 = true;
      }
    else
      blas;

  lapack' =
    if use64BitIdx then
      lapack.override {
        isILP64 = true;
      }
    else
      lapack;

  qrupdate' = qrupdate.override {
    blas = blas';
    lapack = lapack';
  };

  arpack' = arpack.override {
    blas = blas';
    lapack = lapack';
  };

  suitesparse' =
    if suitesparse != null then
      suitesparse.override {
        blas = blas';
        lapack = lapack';
      }
    else
      null;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "octave";
  version = "11.3.0";

  src = fetchurl {
    url = "mirror://gnu/octave/octave-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-y1if6zzvhNE0hUaDcYycE+C0ceqRbQdhvnqMTiYaMtE=";
  };

  postPatch = ''
    patchShebangs --build build-aux/*.pl
  '';

  nativeBuildInputs = [
    perl
    pkg-config
    gfortran
    texinfo
  ]
  ++ lib.optionals enableQt [
    qt6Packages.wrapQtAppsHook
    qt6Packages.qttools
  ];

  buildInputs = [
    readline
    ncurses
    flex
    qhull
    graphicsmagick
    pcre2
    fltk
    zlib
    curl
    rapidjson
    blas'
    lapack'
    libsndfile
    fftw
    fftwSinglePrec
    portaudio
    qrupdate'
    arpack'
    libwebp
    gl2ps
    ghostscript
    hdf5
    glpk
    suitesparse'
    sundials
    gnuplot
    python3
  ]
  ++ lib.optionals enableQt [
    qt6Packages.qtbase
    qt6Packages.qtsvg
    qt6Packages.qt5compat
    qt6Packages.qscintilla
  ]
  ++ lib.optionals enableJava [
    jdk
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    libGL
    libGLU
    libx11
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
    fast-float
  ];

  doCheck = !stdenv.hostPlatform.isDarwin;

  env =
    lib.optionalAttrs stdenv.hostPlatform.isDarwin {
      NIX_LDFLAGS = "-lobjc";
      NIX_CFLAGS_COMPILE = "-Wno-format-security";
    }
    // lib.optionalAttrs use64BitIdx {
      F77_INTEGER_8_FLAG = "-fdefault-integer-8";
    };

  preConfigure = ''
    export PATH="$PATH:${qt6Packages.qttools}/libexec"
  '';

  configureFlags = [
    (lib.withFeatureAs true "blas" "blas")
    (lib.withFeatureAs true "lapack" "lapack")
    (lib.enableFeature use64BitIdx "64")
    (lib.enableFeature enableReadline "readline")
    (lib.withFeatureAs enableQt "qt" (lib.versions.major qt6Packages.qtbase.version))
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ "--with-x=no" ];

  postInstall = ''
    cp test/fntests.log $out/share/octave/octave-${finalAttrs.version}-fntests.log || true
  '';

  passthru = {
    blas = blas';
    lapack = lapack';
    qrupdate = qrupdate';
    arpack = arpack';
    suitesparse = suitesparse';
    inherit fftw fftwSinglePrec;
    inherit portaudio;
    inherit jdk;
    python = python3;
    inherit enableQt enableReadline enableJava;
  };

  meta = {
    homepage = "https://www.gnu.org/software/octave/";
    license = lib.licenses.gpl3Plus;
    description = "Scientific Programming Language";
  };
})
