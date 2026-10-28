{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  shared-mime-info,
  bluez-qt ? null, # TODO: not yet in ekapkgs
  kauth,
  kcmutils,
  kcodecs,
  kcompletion,
  kconfig,
  kconfigwidgets,
  kcoreaddons,
  kdbusaddons,
  kdoctools,
  ki18n,
  kio,
  kitemviews,
  kjobwidgets,
  knotifications,
  kservice,
  kwidgetsaddons,
  kwindowsystem,
  kxmlgui,
  libplasma ? null, # TODO: not yet in ekapkgs
  plasma-workspace ? null, # TODO: not yet in ekapkgs
  solid,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bluedevil";
  version = "6.7.5";

  src = fetchurl {
    url = "mirror://kde/stable/plasma/${finalAttrs.version}/bluedevil-${finalAttrs.version}.tar.xz";
    hash = "sha256-H2wLATJ7S14t3PEf2OSz5mukksnGbGGpXU3f0liFDV8=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    qt6.wrapQtAppsHook
    shared-mime-info
  ];

  buildInputs = [
    qt6.qtbase
    kauth
    kcmutils
    kcodecs
    kcompletion
    kconfig
    kconfigwidgets
    kcoreaddons
    kdbusaddons
    kdoctools
    ki18n
    kio
    kitemviews
    kjobwidgets
    knotifications
    kservice
    kwidgetsaddons
    kwindowsystem
    kxmlgui
    solid
  ]
  ++ lib.optional (bluez-qt != null) bluez-qt
  ++ lib.optional (libplasma != null) libplasma
  ++ lib.optional (plasma-workspace != null) plasma-workspace;

  meta = {
    description = "KDE Bluetooth stack";
    homepage = "https://invent.kde.org/plasma/bluedevil";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
