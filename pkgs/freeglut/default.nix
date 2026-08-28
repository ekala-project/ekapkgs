{
  lib,
  stdenv,
  fetchurl,
  cmake,
  libGL,
  libGLU,
  libice,
  libxext,
  libxi,
  libxrandr,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "freeglut";
  version = "3.6.0";

  src = fetchurl {
    url = "mirror://sourceforge/freeglut/freeglut-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-nD1NZRb7+gKA7ck8d2mPtzA+RDwaqvN9Jp4yiKbD6lI=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  buildInputs = [
    libGL
    libGLU
    libice
    libxext
    libxi
    libxrandr
  ];

  meta = {
    description = "Create and manage windows containing OpenGL contexts";
    homepage = "https://freeglut.sourceforge.net/";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
})
