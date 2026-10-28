{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  libical,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kcalendarcore";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/kcalendarcore-${finalAttrs.version}.tar.xz";
    hash = "sha256-6L9g45ji+AmKTbfbRMVHXXBUCtj4lIoSPIvBCdxNt3Y=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    qt6.qttools
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    libical
  ];

  dontWrapQtApps = true;

  cmakeEntries = {
    BUILD_TESTING = false;
  };

  meta = {
    description = "Library for interfacing with calendars";
    homepage = "https://invent.kde.org/frameworks/kcalendarcore";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
