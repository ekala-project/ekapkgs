{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  pkg-config,
  gpgmepp,
  libgcrypt,
  libsecret,
  kdoctools,
  kcolorscheme,
  kconfig,
  kcoreaddons,
  kcrash,
  kdbusaddons,
  ki18n,
  kiconthemes,
  knotifications,
  kwidgetsaddons,
  kwindowsystem,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kwallet";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/kwallet-${finalAttrs.version}.tar.xz";
    hash = "sha256-k8ucHfJjCAfAS/jDAxLnWuO7Rmx33Zspuyx1LnHTSiY=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    pkg-config
  ];

  buildInputs = [
    qt6.qtbase
    gpgmepp
    libgcrypt
    libsecret
    kdoctools
    kcolorscheme
    kconfig
    kcoreaddons
    kcrash
    kdbusaddons
    ki18n
    kiconthemes
    knotifications
    kwidgetsaddons
    kwindowsystem
  ];

  dontWrapQtApps = true;

  cmakeEntries = {
    BUILD_TESTING = false;
  };

  meta = {
    description = "Secure and unified container for user passwords";
    homepage = "https://invent.kde.org/frameworks/kwallet";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
