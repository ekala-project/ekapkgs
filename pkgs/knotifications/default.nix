{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kconfig,
  libcanberra,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "knotifications";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/knotifications-${finalAttrs.version}.tar.xz";
    hash = "sha256-Ca1QVwsmqtoECLucz6q/YpxW7ImplyyLDhVat4D1d88=";
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
    kconfig
    libcanberra
  ];

  dontWrapQtApps = true;

  cmakeEntries = {
    BUILD_TESTING = false;
  };

  meta = {
    description = "Abstraction for system notifications";
    homepage = "https://invent.kde.org/frameworks/knotifications";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
