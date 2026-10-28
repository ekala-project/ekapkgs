{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  pkg-config,
  qt6,
  dbus,
  kauth,
  kcmutils,
  kcodecs,
  kconfig,
  kconfigwidgets,
  kcoreaddons,
  kdbusaddons,
  ki18n,
  kimageformats,
  kirigami,
  kitemmodels,
  kpackage,
  kservice,
  ksvg,
  kwidgetsaddons,
  kwindowsystem,
  kxmlgui,
  layer-shell-qt,
  libkscreen ? null, # TODO: not yet in ekapkgs
  libplasma ? null, # TODO: not yet in ekapkgs
  plasma5support ? null, # TODO: not yet in ekapkgs
  wayland-protocols,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kscreen";
  version = "6.7.5";

  src = fetchurl {
    url = "mirror://kde/stable/plasma/${finalAttrs.version}/kscreen-${finalAttrs.version}.tar.xz";
    hash = "sha256-oXQiEKDPTqdpWfcIxVGAslc2SOnNNctOOPNJ/laUyd8=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsensors
    qt6.qtwayland
    kauth
    kcmutils
    kcodecs
    kconfig
    kconfigwidgets
    kcoreaddons
    kdbusaddons
    ki18n
    kimageformats
    kirigami
    kitemmodels
    kpackage
    kservice
    ksvg
    kwidgetsaddons
    kwindowsystem
    kxmlgui
    layer-shell-qt
    wayland-protocols
  ]
  ++ lib.optional (libkscreen != null) libkscreen
  ++ lib.optional (libplasma != null) libplasma
  ++ lib.optional (plasma5support != null) plasma5support;

  postFixup = ''
    substituteInPlace $out/share/kglobalaccel/org.kde.kscreen.desktop \
      --replace-fail dbus-send ${dbus}/bin/dbus-send
  '';

  meta = {
    description = "KDE screen management software";
    homepage = "https://invent.kde.org/plasma/kscreen";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "kscreen-console";
  };
})
