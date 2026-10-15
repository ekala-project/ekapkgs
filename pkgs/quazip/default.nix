{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "quazip";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "stachenov";
    repo = "quazip";
    rev = "v${finalAttrs.version}";
    hash = "sha256-AOamvy2UgN8n7EZ8EidWkVzRICzEXMmvZsB18UwxIVo=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  buildInputs = [
    zlib
    qt6.qtbase
  ];

  propagatedBuildInputs = [
    qt6.qt5compat
  ];

  dontWrapQtApps = true;

  outputs = [
    "out"
    "dev"
  ];

  meta = {
    description = "Provides access to ZIP archives from Qt programs";
    homepage = "https://stachenov.github.io/quazip/";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
