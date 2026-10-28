{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kconfig,
  kcoreaddons,
  kpty,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kdesu";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/kdesu-${finalAttrs.version}.tar.xz";
    hash = "sha256-m/JEiEsJzjithNAOWHnnmLAuFhDsjz2e5sk+dQKzVuI=";
  };

  # Look for NixOS SUID wrapper first
  patches = [ ./kdesu-search-for-wrapped-daemon-first.patch ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
  ];

  buildInputs = [
    qt6.qtbase
    kconfig
    kcoreaddons
    kpty
  ];

  dontWrapQtApps = true;

  cmakeEntries = {
    BUILD_TESTING = false;
  };

  meta = {
    description = "KDE Su";
    homepage = "https://invent.kde.org/frameworks/kdesu";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
