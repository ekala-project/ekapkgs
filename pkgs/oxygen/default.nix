{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  frameworkintegration,
  kcmutils,
  kcompletion,
  kconfig,
  kconfigwidgets,
  kcoreaddons,
  kdecoration,
  kguiaddons,
  ki18n,
  kservice,
  kwidgetsaddons,
  kwindowsystem,
  libplasma ? null, # TODO: not yet in ekapkgs
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "oxygen";
  version = "6.7.5";

  src = fetchurl {
    url = "mirror://kde/stable/plasma/${finalAttrs.version}/oxygen-${finalAttrs.version}.tar.xz";
    hash = "sha256-/6S5aRl/bgmm7k9GiSXmciNmbXYe6YAajqYS4Jt1YDc=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    frameworkintegration
    kcmutils
    kcompletion
    kconfig
    kconfigwidgets
    kcoreaddons
    kdecoration
    kguiaddons
    ki18n
    kservice
    kwidgetsaddons
    kwindowsystem
  ]
  ++ lib.optional (libplasma != null) libplasma;

  cmakeEntries = {
    # Skip Qt5 support build
    BUILD_QT5 = false;
  };

  meta = {
    description = "The Oxygen Style for Qt/KDE Applications";
    homepage = "https://invent.kde.org/plasma/oxygen";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
