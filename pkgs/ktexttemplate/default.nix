{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ktexttemplate";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/ktexttemplate-${finalAttrs.version}.tar.xz";
    hash = "sha256-w8IplE0lKUEC5OiltJ+gwPSB2p0z+L7DeC6KU6/UdJM=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
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
    description = "Library to allow application developers to separate the structure of documents from the data they contain";
    homepage = "https://invent.kde.org/frameworks/ktexttemplate";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
