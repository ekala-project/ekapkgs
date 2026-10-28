{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kconfig,
  ki18n,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kunitconversion";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/kunitconversion-${finalAttrs.version}.tar.xz";
    hash = "sha256-PcqkWHW6taLcrcNM9XzwZom42G/0DiD+4ByisYmHF18=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
  ];

  buildInputs = [
    qt6.qtbase
    kconfig
    ki18n
  ];

  dontWrapQtApps = true;

  cmakeEntries = {
    BUILD_TESTING = false;
  };

  meta = {
    description = "Support for unit conversion";
    homepage = "https://invent.kde.org/frameworks/kunitconversion";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
