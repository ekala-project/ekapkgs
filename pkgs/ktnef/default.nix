{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kcalendarcore,
  kcalutils,
  kcontacts,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ktnef";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/ktnef-${finalAttrs.version}.tar.xz";
    hash = "sha256-B5UHEv7gtJZUBc4EmOZlBa35yFD9KnRjERw4pHSGatg=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    kcalendarcore
    kcalutils
    kcontacts
  ];

  meta = {
    description = "API for handling TNEF data";
    homepage = "https://invent.kde.org/pim/ktnef";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
