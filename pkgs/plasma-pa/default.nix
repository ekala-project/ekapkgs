{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  pkg-config,
  qt6,
  libcanberra,
  pulseaudio,
  kcmutils,
  kconfig,
  kcoreaddons,
  kdeclarative ? null, # TODO: not yet in ekapkgs
  kglobalaccel,
  ki18n,
  kitemmodels,
  kpackage,
  kstatusnotifieritem,
  ksvg,
  libplasma ? null, # TODO: not yet in ekapkgs
  plasma-workspace ? null, # TODO: not yet in ekapkgs
  pulseaudio-qt ? null, # TODO: not yet in ekapkgs
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "plasma-pa";
  version = "6.7.5";

  src = fetchurl {
    url = "mirror://kde/stable/plasma/${finalAttrs.version}/plasma-pa-${finalAttrs.version}.tar.xz";
    hash = "sha256-T+KFeWk4WM2vNNW34ltEHT5lMFj/GFechZbrilciGiU=";
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
    libcanberra
    pulseaudio
    kcmutils
    kconfig
    kcoreaddons
    kglobalaccel
    ki18n
    kitemmodels
    kpackage
    kstatusnotifieritem
    ksvg
  ]
  ++ lib.optional (kdeclarative != null) kdeclarative
  ++ lib.optional (libplasma != null) libplasma
  ++ lib.optional (plasma-workspace != null) plasma-workspace
  ++ lib.optional (pulseaudio-qt != null) pulseaudio-qt;

  meta = {
    description = "Plasma applet for audio volume management using PulseAudio";
    homepage = "https://invent.kde.org/plasma/plasma-pa";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
