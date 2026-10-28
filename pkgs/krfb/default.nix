{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  pkg-config,
  qt6,
  kconfig,
  kcoreaddons,
  kcrash,
  kdbusaddons,
  kdnssd,
  kdoctools,
  ki18n,
  knotifications,
  kpipewire,
  kstatusnotifieritem,
  kwallet,
  kwayland ? null, # TODO: not yet in ekapkgs
  kwidgetsaddons,
  kwindowsystem,
  kxmlgui,
  plasma-wayland-protocols,
  libvncserver,
  pipewire,
  libxdamage,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "krfb";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/krfb-${finalAttrs.version}.tar.xz";
    hash = "sha256-2WVfttiMG2yvVF3aejO39yK1v880N7Y8wOrxBAyFc+4=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    pkg-config
    kdoctools
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtwayland
    kconfig
    kcoreaddons
    kcrash
    kdbusaddons
    kdnssd
    ki18n
    knotifications
    kpipewire
    kstatusnotifieritem
    kwallet
    kwidgetsaddons
    kwindowsystem
    kxmlgui
    plasma-wayland-protocols
    libvncserver
    pipewire
    libxdamage
  ]
  ++ lib.optional (kwayland != null) kwayland;

  cmakeEntries = {
    QtWaylandScanner_EXECUTABLE = "${qt6.qtbase}/libexec/qtwaylandscanner";
  };

  meta = {
    description = "Desktop Sharing";
    homepage = "https://invent.kde.org/network/krfb";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
