{
  stdenv,
  fetchFromGitLab,
  cmake,
  ninja,
  pkg-config,
  boost,
  glib,
  gsl,
  cairo,
  double-conversion,
  lib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lib2geom";
  version = "1.4";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitLab {
    owner = "inkscape";
    repo = "lib2geom";
    tag = finalAttrs.version;
    hash = "sha256-kbcnefzNhUj/ZKZaB9r19bpI68vxUKOLVAwUXSr/zz0=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    ninja
    pkg-config
  ];

  buildInputs = [
    boost
    glib
    gsl
    cairo
    double-conversion
  ];

  strictDeps = true;

  cmakeFlags = [
    "-D2GEOM_BUILD_SHARED=ON"
    "-D2GEOM_TESTING=OFF"
  ];

  doCheck = false;

  meta = {
    description = "Easy to use 2D geometry library in C++";
    homepage = "https://gitlab.com/inkscape/lib2geom";
    license = [
      lib.licenses.lgpl21Only
      lib.licenses.mpl11
    ];
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
