{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  extra-cmake-modules,
  qt6,
  bison,
  flex,
  ki18n,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kseexpr";
  version = "6.0.0.0";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "graphics";
    repo = "kseexpr";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Z3CjQdKHeZ/6He43qVYQj8Fo0y88v/ldJJD8bPYOaEo=";
  };

  patches = [
    # see https://github.com/NixOS/nixpkgs/issues/144170
    ./cmake_libdir.patch
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
  ];

  dontWrapQtApps = true;

  buildInputs = [
    bison
    flex
    ki18n
    qt6.qtbase
    qt6.qttools
  ];

  meta = {
    homepage = "https://invent.kde.org/graphics/kseexpr";
    description = "Embeddable expression evaluation engine";
    license = lib.licenses.lgpl3Plus;
  };
})
