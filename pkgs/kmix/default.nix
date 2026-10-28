{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kconfig,
  kconfigwidgets,
  kcoreaddons,
  kcrash,
  kdbusaddons,
  kdoctools,
  kglobalaccel,
  ki18n,
  knotifications,
  kstatusnotifieritem,
  kwidgetsaddons,
  kwindowsystem,
  kxmlgui,
  solid,
  alsa-lib,
  libcanberra,
  libpulseaudio,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kmix";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kmix-${finalAttrs.version}.tar.xz";
    hash = "sha256-JeUqL1E6/ew7bHQr1aJ58ie8/hdFVdyyiLbGHgiAkaI=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    kdoctools
  ];

  buildInputs = [
    qt6.qtbase
    kconfig
    kconfigwidgets
    kcoreaddons
    kcrash
    kdbusaddons
    kglobalaccel
    ki18n
    knotifications
    kstatusnotifieritem
    kwidgetsaddons
    kwindowsystem
    kxmlgui
    solid
    alsa-lib
    libcanberra
    libpulseaudio
  ];

  meta = {
    description = "Volume control program";
    homepage = "https://invent.kde.org/multimedia/kmix";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
