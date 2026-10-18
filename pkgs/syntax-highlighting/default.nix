{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "syntax-highlighting";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/syntax-highlighting-${finalAttrs.version}.tar.xz";
    hash = "sha256-/EKbCTBYvsSHgwbLv7OqBWD/Sj8WbGlQQDbFB/5yr8w=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    qt6.qttools
    perl
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
  ];

  dontWrapQtApps = true;

  cmakeEntries = {
    BUILD_TESTING = false;
  };

  meta = {
    description = "Syntax highlighting engine for structured text and code";
    homepage = "https://invent.kde.org/frameworks/syntax-highlighting";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
    mainProgram = "ksyntaxhighlighter6";
  };
})
