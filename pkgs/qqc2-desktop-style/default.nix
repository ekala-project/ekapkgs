{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kcolorscheme,
  kiconthemes,
  kirigami,
  sonnet,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qqc2-desktop-style";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/qqc2-desktop-style-${finalAttrs.version}.tar.xz";
    hash = "sha256-dMZAL6aXp2JU4caOvYYTa+SeA/rYZILoaiflR49mLEE=";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
  ];

  propagatedBuildInputs = [
    kcolorscheme
    kiconthemes
    kirigami
    sonnet
  ];

  dontWrapQtApps = true;

  cmakeEntries = {
    BUILD_TESTING = false;
  };

  meta = {
    description = "Qt Quick Controls 2 style for desktop integration";
    homepage = "https://invent.kde.org/frameworks/qqc2-desktop-style";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
