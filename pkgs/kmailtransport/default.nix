{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kconfigwidgets,
  ksmtp,
  libkgapi,
  qtkeychain,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kmailtransport";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kmailtransport-${finalAttrs.version}.tar.xz";
    hash = "sha256-ja5j4G4gFPA7fmACqNz5vFMjFzrA4SpmzmPLcar+yss=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    kconfigwidgets
    ksmtp
    libkgapi
    qtkeychain
  ];

  meta = {
    description = "KDE mail transport service";
    homepage = "https://invent.kde.org/pim/kmailtransport";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
