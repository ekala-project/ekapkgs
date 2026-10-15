{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kirigami";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/kirigami-${finalAttrs.version}.tar.xz";
    hash = "sha256-begR5VnCDcEIbAzyw0u5hxLb5NRflgxiw8P4hzMslfg=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    qt6.qtsvg
    qt6.qttools
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
  ];

  propagatedBuildInputs = [
    qt6.qt5compat
  ];

  dontWrapQtApps = true;

  cmakeEntries = {
    BUILD_TESTING = false;
  };

  meta = {
    description = "A QtQuick based components set";
    homepage = "https://invent.kde.org/frameworks/kirigami";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
