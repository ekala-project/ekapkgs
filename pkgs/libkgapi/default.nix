{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kcalendarcore,
  kcontacts,
  kwallet,
  cyrus_sasl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libkgapi";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/libkgapi-${finalAttrs.version}.tar.xz";
    hash = "sha256-CRs7bjf4zPX8vi3TVNsFlY9IiJ+HVo+tJIFauFNU/iU=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    qt6.qttools
  ];

  buildInputs = [
    qt6.qtbase
    kcalendarcore
    kcontacts
    kwallet
    cyrus_sasl
  ];

  dontWrapQtApps = true;

  cmakeEntries = {
    BUILD_TESTING = false;
  };

  meta = {
    description = "Library for accessing various Google services via their public API";
    homepage = "https://invent.kde.org/pim/libkgapi";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
