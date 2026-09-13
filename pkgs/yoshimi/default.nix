{
  lib,
  stdenv,
  fetchFromGitHub,
  alsa-lib,
  boost,
  cairo,
  cmake,
  expat,
  fftwSinglePrec,
  fltk,
  fontconfig,
  libGLU,
  libjack2,
  libjpeg,
  libpng,
  libsndfile,
  libxcursor,
  libxdmcp,
  libxfixes,
  libxft,
  libxinerama,
  libxrender,
  lv2,
  minixml,
  pkg-config,
  readline,
  libpthread-stubs,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yoshimi";
  version = "2.3.6.5";

  src = fetchFromGitHub {
    owner = "Yoshimi";
    repo = "yoshimi";
    tag = finalAttrs.version;
    hash = "sha256-ZlabEfDt/94kXPI1DbkykdFGfqf0csH/Cad3OBtyUf0=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  postPatch = ''
    substituteInPlace Misc/Config.cpp --replace /usr $out
    substituteInPlace Misc/Bank.cpp --replace /usr $out
  '';

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    fltk
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    boost
    cairo
    expat
    fftwSinglePrec
    fltk
    fontconfig
    libGLU
    libjack2
    libjpeg
    libpng
    libsndfile
    libxdmcp
    libxrender
    lv2
    minixml
    readline
    libpthread-stubs
    zlib
  ];

  cmakeFlags = [ "-DFLTK_MATH_LIBRARY=${stdenv.cc.libc}/lib/libm.so" ];

  # fltk static libraries need their transitive deps linked explicitly
  env.NIX_LDFLAGS = "-lpng -ljpeg -lXrender -lfontconfig -lXft -lXfixes -lXcursor -lXinerama";

  meta = {
    description = "High quality software synthesizer based on ZynAddSubFX";
    longDescription = ''
      Yoshimi delivers the same synthesizer capabilities as
      ZynAddSubFX along with very good Jack and Alsa midi/audio
      functionality on Linux
    '';
    homepage = "https://yoshimi.github.io/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "yoshimi";
  };
})
