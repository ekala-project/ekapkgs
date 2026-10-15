{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  karchive,
  kcoreaddons,
  ki18n,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kpackage";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/kpackage-${finalAttrs.version}.tar.xz";
    hash = "sha256-WJOa8MVT8kljZS4Q0kji+PKyyiuH3CbTIgZ17QzzMBk=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
  ];

  buildInputs = [
    qt6.qtbase
  ];

  propagatedBuildInputs = [
    karchive
    kcoreaddons
    ki18n
  ];

  dontWrapQtApps = true;

  cmakeEntries = {
    BUILD_TESTING = false;
  };

  meta = {
    description = "Installation and loading of additional content (plugins, applets, etc.) as packages";
    homepage = "https://invent.kde.org/frameworks/kpackage";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
    mainProgram = "kpackagetool6";
  };
})
