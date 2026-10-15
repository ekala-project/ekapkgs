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
  kdoctools,
  kglobalaccel,
  kguiaddons,
  ki18n,
  kio,
  kirigami,
  knotifications,
  kpipewire,
  kquickimageeditor,
  kstatusnotifieritem,
  kwidgetsaddons,
  kwindowsystem,
  kxmlgui,
  layer-shell-qt,
  prison,
  purpose,
  wayland,
  opencv4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "spectacle";
  version = "6.7.5";

  src = fetchurl {
    url = "mirror://kde/stable/plasma/6.7.5/spectacle-${finalAttrs.version}.tar.xz";
    hash = "sha256-KmOo2jMfkkng/wCRo48vqUbHuFx7cTO9i2DdUk6OAbg=";
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
    qt6.qtdeclarative
    qt6.qtwayland
    qt6.qtmultimedia
    kconfig
    kcoreaddons
    kcrash
    kdbusaddons
    kglobalaccel
    kguiaddons
    ki18n
    kio
    kirigami
    knotifications
    kpipewire
    kquickimageeditor
    kstatusnotifieritem
    kwidgetsaddons
    kwindowsystem
    kxmlgui
    layer-shell-qt
    prison
    purpose
    wayland
    (opencv4.override {
      enableCuda = false;
      enabledModules = [
        "core"
        "imgproc"
      ];
      runAccuracyTests = false;
    })
  ];

  meta = {
    description = "KDE screenshot capture utility";
    homepage = "https://apps.kde.org/spectacle/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "spectacle";
  };
})
