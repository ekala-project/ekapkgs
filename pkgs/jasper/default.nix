{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  libglut,
  libGL,
  libjpeg,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jasper";
  version = "4.2.9";

  src = fetchFromGitHub {
    owner = "jasper-software";
    repo = "jasper";
    rev = "version-${finalAttrs.version}";
    hash = "sha256-Z3eg3xNGFpvzvDp9ldYwh0JnrqfoaZQ7jc58hcZo+Qo=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
    "lib"
    "man"
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
  ];

  buildInputs = [
    libjpeg
    libglut
    libGL
  ];

  cmakeBuildDir = "build-directory";
  cmakeEntries = {
    ALLOW_IN_SOURCE_BUILD = true;
    JAS_ENABLE_HEIC_CODEC = false;
    JAS_INCLUDE_HEIC_CODEC = false;
    JAS_ENABLE_JPG_CODEC = true;
    JAS_INCLUDE_JPG_CODEC = true;
    JAS_ENABLE_MIF_CODEC = false;
    JAS_ENABLE_OPENGL = true;
  };

  strictDeps = true;

  preConfigure = lib.optionalString (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    cmakeFlagsArray+=(-DJAS_STDC_VERSION="$(echo __STDC_VERSION__ | $CXX -E -P -)")
  '';

  meta = {
    homepage = "https://jasper-software.github.io/jasper/";
    description = "Image processing/coding toolkit";
    license = lib.licenses.mit;
    mainProgram = "jasper";
    platforms = lib.platforms.unix;
  };
})
