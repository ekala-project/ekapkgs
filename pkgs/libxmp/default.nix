{
  lib,
  stdenv,
  docutils,
  fetchFromGitHub,
  cmake,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libxmp";
  version = "4.7.3";

  src = fetchFromGitHub {
    owner = "libxmp";
    repo = "libxmp";
    tag = "libxmp-${finalAttrs.version}";
    hash = "sha256-wc3+4J//GjkmzawcXuSwfQRIdRRScijrSwPmpaZggL8=";
  };

  outputs = [
    "out"
    "dev"
    "man"
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    ninja
    docutils
  ];

  cmakeEntries = {
    BUILD_SHARED = true;
    BUILD_STATIC = false;
  };

  meta = {
    description = "Extended module player library";
    homepage = "https://xmp.sourceforge.net/";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
})
