{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kconfig,
  kcoreaddons,
  kdbusaddons,
  kdeclarative ? null, # TODO: not yet in ekapkgs
  kglobalaccel,
  ki18n,
  kiconthemes,
  kio,
  kitemmodels,
  knewstuff,
  kpackage,
  kquickcharts,
  kservice,
  kwindowsystem,
  libksysguard ? null, # TODO: not yet in ekapkgs
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "plasma-systemmonitor";
  version = "6.7.5";

  src = fetchurl {
    url = "mirror://kde/stable/plasma/${finalAttrs.version}/plasma-systemmonitor-${finalAttrs.version}.tar.xz";
    hash = "sha256-Vwjo8OGDPggpFEoUq6HxdyYmYcxXsgxKWjS/1pc9Hxs=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    kconfig
    kcoreaddons
    kdbusaddons
    kglobalaccel
    ki18n
    kiconthemes
    kio
    kitemmodels
    knewstuff
    kpackage
    kquickcharts
    kservice
    kwindowsystem
  ]
  ++ lib.optional (kdeclarative != null) kdeclarative
  ++ lib.optional (libksysguard != null) libksysguard;

  propagatedBuildInputs = [
    kquickcharts
  ];

  meta = {
    description = "An interface for monitoring system sensors, process information and other system resources";
    homepage = "https://invent.kde.org/plasma/plasma-systemmonitor";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "plasma-systemmonitor";
  };
})
